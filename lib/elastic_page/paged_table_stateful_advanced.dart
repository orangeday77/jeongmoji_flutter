import 'package:advanced_datatable/advanced_datatable_source.dart';
import 'package:advanced_datatable/datatable.dart';
import 'package:elastic_client/elastic_client.dart';
import 'package:flutter/material.dart';
import 'package:jeong_moji/elastic_page/elastic_service.dart';
import 'dart:html' as html;
import 'dart:js' as js;

const pdfUrl =
    'http://ec2-43-200-192-22.ap-northeast-2.compute.amazonaws.com/static/_pdf';

class DataTableAdvancedStateful extends StatefulWidget {
  const DataTableAdvancedStateful({Key? key, this.title}) : super(key: key);
  final String? title;
  @override
  DataTableAdvancedState createState() => DataTableAdvancedState();
}

class DataTableAdvancedState extends State<DataTableAdvancedStateful> {
  var _rowsPerPage = 50;
  final _source = ExampleSource();
  var _sortIndex = 0;
  var _sortAsc = false;
  final _searchController = TextEditingController();
  var _customFooter = false;

  @override
  void initState() {
    super.initState();
    _searchController.text = '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('정주행의 모든 지식들'),
        actions: [
          IconButton(
            icon: const Icon(Icons.table_chart_outlined),
            tooltip: 'Change footer',
            onPressed: () {
              setState(() {
                _customFooter = !_customFooter;
              });
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: TextField(
                      controller: _searchController,
                      decoration: const InputDecoration(
                        labelText: 'Search by keyword(e.g. 분산원장;블록체인;비교)',
                      ),
                      onSubmitted: (vlaue) {
                        _source.filterServerSide(_searchController.text,
                            ordered: _sortAsc ? 'asc' : 'desc');
                      },
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      _searchController.text = '';
                    });
                    _source.filterServerSide(_searchController.text);
                  },
                  icon: const Icon(Icons.clear),
                ),
                IconButton(
                  onPressed: () => _source.filterServerSide(
                      _searchController.text,
                      ordered: _sortAsc ? 'asc' : 'desc'),
                  icon: const Icon(Icons.search),
                ),
              ],
            ),
            AdvancedPaginatedDataTable(
              showCheckboxColumn: false,
              addEmptyRows: false,
              source: _source,
              showHorizontalScrollbarAlways: true,
              sortAscending: _sortAsc,
              sortColumnIndex: _sortIndex,
              showFirstLastButtons: true,
              rowsPerPage: _rowsPerPage,
              // availableRowsPerPage: const [25, 50, 100],
              availableRowsPerPage: const [50],
              onRowsPerPageChanged: (newRowsPerPage) {
                if (newRowsPerPage != null) {
                  setState(() {
                    _rowsPerPage = newRowsPerPage;
                  });
                }
              },
              columns: [
                DataColumn(label: const Text('Name'), onSort: setSort),
                const DataColumn(label: Text('Path')),
                const DataColumn(label: Text('Size')),
                const DataColumn(label: Text('Registration Date')),
              ],
              //Optianl override to support custom data row text / translation
              getFooterRowText:
                  (startRow, pageSize, totalFilter, totalRowsWithoutFilter) {
                final localizations = MaterialLocalizations.of(context);
                var amountText = localizations.pageRowsInfoTitle(
                  startRow,
                  pageSize,
                  totalFilter ?? totalRowsWithoutFilter,
                  false,
                );

                if (totalFilter != null) {
                  //Filtered data source show addtional information
                  amountText += ' filtered from ($totalRowsWithoutFilter)';
                }

                return amountText;
              },
              customTableFooter: _customFooter
                  ? (source, offset) {
                      const maxPagesToShow = 6;
                      const maxPagesBeforeCurrent = 3;
                      final lastRequestDetails = source.lastDetails!;
                      final rowsForPager = lastRequestDetails.filteredRows ??
                          lastRequestDetails.totalRows;
                      final totalPages = rowsForPager ~/ _rowsPerPage;
                      final currentPage = (offset ~/ _rowsPerPage) + 1;
                      final List<int> pageList = [];
                      if (currentPage > 1) {
                        pageList.addAll(
                          List.generate(currentPage - 1, (index) => index + 1),
                        );
                        //Keep up to 3 pages before current in the list
                        pageList.removeWhere(
                          (element) =>
                              element < currentPage - maxPagesBeforeCurrent,
                        );
                      }
                      pageList.add(currentPage);
                      //Add reminding pages after current to the list
                      pageList.addAll(
                        List.generate(
                          maxPagesToShow - (pageList.length - 1),
                          (index) => (currentPage + 1) + index,
                        ),
                      );
                      pageList.removeWhere((element) => element > totalPages);

                      return Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: pageList
                            .map(
                              (e) => TextButton(
                                onPressed: e != currentPage
                                    ? () {
                                        //Start index is zero based
                                        source.setNextView(
                                          startIndex: (e - 1) * _rowsPerPage,
                                        );
                                      }
                                    : null,
                                child: Text(
                                  e.toString(),
                                ),
                              ),
                            )
                            .toList(),
                      );
                    }
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  // ignore: avoid_positional_boolean_parameters
  void setSort(int i, bool asc) => setState(() {
        _sortIndex = i;
        _sortAsc = asc;
      });
}

typedef SelectedCallBack = Function(int index, bool newSelectState);

class ExampleSource extends AdvancedDataTableSource<ElasticModel> {
  List<String> selectedIds = [];
  String lastSearchTerm = '';
  String _ordered = 'asc';

  @override
  DataRow? getRow(int index) =>
      lastDetails!.rows[index].getRow(index, selectedRow, selectedIds);

  @override
  int get selectedRowCount => selectedIds.length;

  // void selectedRow(String id, bool newSelectState) {
  void selectedRow(int index, bool newSelectState) {
    // method 1:
    // String url = 'http://localhost:8080/static/test.pdf';
    // html.AnchorElement anchorElement = new html.AnchorElement(href: url);
    // anchorElement.download = url;
    // anchorElement.click();

    // method 2:
    // fileDisplayPath + fileName
    var fileDisplayPath = lastDetails!.rows[index].fileDisplayPath;
    var fileName = lastDetails!.rows[index].fileName;
    js.context.callMethod('open', ['$pdfUrl/$fileDisplayPath/$fileName']);

    if (selectedIds.contains(index.toString())) {
      selectedIds.remove(index.toString());
    } else {
      selectedIds = [];
      selectedIds.add(index.toString());
    }
    notifyListeners();
  }

  void filterServerSide(String filterQuery, {String ordered = 'asc'}) {
    lastSearchTerm = filterQuery.toLowerCase().trim();
    _ordered = ordered;
    setNextView();
  }

  @override
  Future<RemoteDataSourceDetails<ElasticModel>> getNextPage(
    NextPageRequest pageRequest,
  ) async {
    selectedIds = [];
    var response = await _fetchData(
        offset: pageRequest.offset, searchText: lastSearchTerm, ordered: pageRequest.sortAscending == true ? 'asc': 'desc');
    return RemoteDataSourceDetails(
      response.totalCount,
      (response.hits)
          .map(
            (json) => ElasticModel.fromJson(json.doc),
          )
          .toList(),
      // filteredRows: lastSearchTerm.isNotEmpty
      //     ? response.totalCount
      //     : null,
    );
  }

  Future<SearchResult> _fetchData(
      {int offset = 0, String searchText = '', String ordered = 'asc'}) async {
    return ElasticService.search(
        offset: offset, searchText: searchText, ordered: ordered);
  }
}

class ElasticModel {
  final String id;
  final String fileName;
  final String filePath;
  final String fileDisplayPath;
  final String fileSize;
  final String registerDt;
  bool selected = false;

  ElasticModel({
    required this.id,
    required this.fileName,
    required this.filePath,
    required this.fileDisplayPath,
    required this.fileSize,
    required this.registerDt,
  });

  DataRow getRow(
    int index,
    SelectedCallBack callback,
    List<String> selectedIds,
  ) {
    return DataRow(
      cells: [
        // DataCell(Text(id.toString())),
        DataCell(Text(fileName)),
        // DataCell(Text(filePath)),
        DataCell(Text(fileDisplayPath)),
        DataCell(Text(fileSize)),
        DataCell(Text(registerDt)),
      ],
      onSelectChanged: (newState) {
        callback(index, newState ?? false);
      },
      selected: selectedIds.contains(index.toString()),
    );
  }

  factory ElasticModel.fromJson(Map<dynamic, dynamic> json) {
    return ElasticModel(
      id: json['id'],
      fileName: json['fileName'],
      filePath: json['filePath'],
      fileDisplayPath: json['fileDisplayPath'],
      fileSize: json['fileSize'],
      registerDt: json['registerDt'],
    );
  }
}
