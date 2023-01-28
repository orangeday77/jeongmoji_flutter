// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************
//
// ignore_for_file: type=lint

import 'package:auto_route/auto_route.dart' as _i3;
import 'package:flutter/material.dart' as _i4;

import 'elastic_page/login_page.dart' as _i1;
import 'elastic_page/paged_table_stateful_advanced.dart' as _i2;

class AppRouter extends _i3.RootStackRouter {
  AppRouter([_i4.GlobalKey<_i4.NavigatorState>? navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i3.PageFactory> pagesMap = {
    LoginRoute.name: (routeData) {
      return _i3.MaterialPageX<dynamic>(
          routeData: routeData, child: _i1.LoginPage());
    },
    DataTableAdvancedStateful.name: (routeData) {
      final args = routeData.argsAs<DataTableAdvancedStatefulArgs>(
          orElse: () => const DataTableAdvancedStatefulArgs());
      return _i3.MaterialPageX<dynamic>(
          routeData: routeData,
          child:
              _i2.DataTableAdvancedStateful(key: args.key, title: args.title));
    }
  };

  @override
  List<_i3.RouteConfig> get routes => [
        _i3.RouteConfig(LoginRoute.name, path: '/'),
        _i3.RouteConfig(DataTableAdvancedStateful.name,
            path: '/data-table-advanced-stateful')
      ];
}

/// generated route for
/// [_i1.LoginPage]
class LoginRoute extends _i3.PageRouteInfo<void> {
  const LoginRoute() : super(LoginRoute.name, path: '/');

  static const String name = 'LoginRoute';
}

/// generated route for
/// [_i2.DataTableAdvancedStateful]
class DataTableAdvancedStateful
    extends _i3.PageRouteInfo<DataTableAdvancedStatefulArgs> {
  DataTableAdvancedStateful({_i4.Key? key, String? title})
      : super(DataTableAdvancedStateful.name,
            path: '/data-table-advanced-stateful',
            args: DataTableAdvancedStatefulArgs(key: key, title: title));

  static const String name = 'DataTableAdvancedStateful';
}

class DataTableAdvancedStatefulArgs {
  const DataTableAdvancedStatefulArgs({this.key, this.title});

  final _i4.Key? key;

  final String? title;

  @override
  String toString() {
    return 'DataTableAdvancedStatefulArgs{key: $key, title: $title}';
  }
}
