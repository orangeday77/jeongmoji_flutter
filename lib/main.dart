import 'package:flutter/material.dart';

import 'package:jeong_moji/app_router.gr.dart';
import 'package:jeong_moji/dark_theme_styles.dart';
import 'package:url_strategy/url_strategy.dart';
// import 'package:jeong_moji/elastic_page/paged_table.dart';
// import 'package:jeong_moji/elastic_page/elastic_page.dart';
// import 'package:jeong_moji/elastic_page/paged_table.dart';
// import 'package:jeong_moji/elastic_page/paged_table_stateful.dart';
// import 'package:jeong_moji/elastic_page/paged_table_stateful_advanced.dart';

void main() {
  setPathUrlStrategy();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  final _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: '정주행의 모든 지식들',
      routerDelegate: _appRouter.delegate(),
      routeInformationParser: _appRouter.defaultRouteParser(),
      theme: Styles.themeData(true, context),
    );
  }
}
