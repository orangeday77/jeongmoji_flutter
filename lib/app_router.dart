import 'package:auto_route/annotations.dart';
import 'package:jeong_moji/auth_guard.dart';
import 'package:jeong_moji/elastic_page/login_page.dart';
// import 'package:jeong_moji/elastic_page/paged_table_stateful.dart';
import 'package:jeong_moji/elastic_page/paged_table_stateful_advanced.dart';

@MaterialAutoRouter(
  replaceInRouteName: 'Page,Route',
  routes: <AutoRoute>[
    AutoRoute(page: LoginPage, initial: true),
    AutoRoute(page: DataTableAdvancedStateful, guards: [AuthGuard]),
  ],
)
class $AppRouter {}
