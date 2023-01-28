import 'dart:convert';
import 'package:elastic_client/elastic_client.dart';
import 'package:jeong_moji/elastic_page/paged_table_stateful_advanced.dart';

const String elasticUrl = 'http://localhost:9200';

class ElasticService {
  // TODO factory
  static Future<SearchResult> search(
      {int offset = 0, String searchText = '', String ordered = 'asc'}) async {
    final transport = HttpTransport(
      url: elasticUrl,
      authorization: getBasicAuth(),
    );
    final client = Client(transport);

    List<String> searchTextList = searchText.split(';');
    var mustList = [
      for (var val in searchTextList)
        if (val == '기출')
          {
            "wildcard": {"fileDisplayPath": '10.gichul*'}
          }
        else if (val == '모의')
          {
            "wildcard": {"fileDisplayPath": '20.moui*'}
          }
        else if (val == '모범')
          {
            "wildcard": {"fileDisplayPath": '30.mobeom*'}
          }
        else
          {
            "match_phrase": {"fileName": val}
          }
    ];

    final response = await client.search(
      index: 'itpe_jeongmoji',
      query: Query.bool(must: mustList),
      sort: [
        {'fileName.raw': ordered},
      ],
      offset: offset,
      size: 50,
      source: true,
    );
    return response;
  }

  static List<ElasticModel> responseToDataSource(SearchResult searchResult) {
    List<ElasticModel> list = [];
    for (var i = 0; i < searchResult.hits.length; i++) {
      final hit = searchResult.hits[i];
      final json = hit.doc;
      ElasticModel model = ElasticModel.fromJson(json);
      list.add(model);
    }

    setTotalCount(searchResult.totalCount);

    return list;
  }

  static int _totalCount = 0;
  static void setTotalCount(int totalCount) {
    _totalCount = totalCount;
  }

  static int get getTotalCount => _totalCount;

  static getBasicAuth() {
    String username = 'your_username';
    String password = 'your_password';
    String base64EncodedData =
        base64.encode(utf8.encode('$username:$password'));
    String basicAuth = 'Basic $base64EncodedData';
    return basicAuth;
  }
}
