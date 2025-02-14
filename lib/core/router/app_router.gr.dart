// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i3;
import 'package:blutut_clasic/presentation/auth/pages/login_page.dart' as _i2;
import 'package:blutut_clasic/presentation/home/pages/home_page.dart' as _i1;
import 'package:flutter/material.dart' as _i4;

/// generated route for
/// [_i1.HomePage]
class HomeRoute extends _i3.PageRouteInfo<HomeRouteArgs> {
  HomeRoute({_i4.Key? key, List<_i3.PageRouteInfo>? children})
    : super(
        HomeRoute.name,
        args: HomeRouteArgs(key: key),
        initialChildren: children,
      );

  static const String name = 'HomeRoute';

  // static _i3.PageInfo page = _i3.PageInfo(
  //   name,
  //   builder: (data) {
  //     final args = data.argsAs<HomeRouteArgs>(
  //       orElse: () => const HomeRouteArgs(),
  //     );
  //     return _i1.HomePage(key: args.key);
  //   },
  // );
}

class HomeRouteArgs {
  const HomeRouteArgs({this.key});

  final _i4.Key? key;

  @override
  String toString() {
    return 'HomeRouteArgs{key: $key}';
  }
}

/// generated route for
/// [_i2.LoginPage]
class LoginRoute extends _i3.PageRouteInfo<void> {
  const LoginRoute({List<_i3.PageRouteInfo>? children})
    : super(LoginRoute.name, initialChildren: children);

  static const String name = 'LoginRoute';

  static _i3.PageInfo page = _i3.PageInfo(
    name,
    builder: (data) {
      return const _i2.LoginPage();
    },
  );
}
