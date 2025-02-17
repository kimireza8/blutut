// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i6;
import 'package:blutut_clasic/domain/entities/shippment_entity.dart' as _i7;
import 'package:blutut_clasic/presentation/auth/pages/login_page.dart' as _i3;
import 'package:blutut_clasic/presentation/home/pages/data_list_page.dart'
    as _i1;
import 'package:blutut_clasic/presentation/home/pages/print_page.dart' as _i4;
import 'package:blutut_clasic/presentation/profile/pages/profile_page.dart'
    as _i5;
import 'package:blutut_clasic/presentation/receipt/pages/input_page.dart'
    as _i2;
import 'package:flutter/material.dart' as _i8;

abstract class $AppRouter extends _i6.RootStackRouter {
  $AppRouter({super.navigatorKey});

  @override
  final Map<String, _i6.PageFactory> pagesMap = {
    DataListRoute.name: (routeData) {
      return _i6.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i1.DataListPage(),
      );
    },
    InputRoute.name: (routeData) {
      return _i6.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i2.InputPage(),
      );
    },
    LoginRoute.name: (routeData) {
      return _i6.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i3.LoginPage(),
      );
    },
    Print.name: (routeData) {
      final args = routeData.argsAs<PrintArgs>();
      return _i6.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i4.Print(
          shipment: args.shipment,
          key: args.key,
        ),
      );
    },
    ProfileRoute.name: (routeData) {
      return _i6.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i5.ProfilePage(),
      );
    },
  };
}

/// generated route for
/// [_i1.DataListPage]
class DataListRoute extends _i6.PageRouteInfo<void> {
  const DataListRoute({List<_i6.PageRouteInfo>? children})
      : super(
          DataListRoute.name,
          initialChildren: children,
        );

  static const String name = 'DataListRoute';

  static const _i6.PageInfo<void> page = _i6.PageInfo<void>(name);
}

/// generated route for
/// [_i2.InputPage]
class InputRoute extends _i6.PageRouteInfo<void> {
  const InputRoute({List<_i6.PageRouteInfo>? children})
      : super(
          InputRoute.name,
          initialChildren: children,
        );

  static const String name = 'InputRoute';

  static const _i6.PageInfo<void> page = _i6.PageInfo<void>(name);
}

/// generated route for
/// [_i3.LoginPage]
class LoginRoute extends _i6.PageRouteInfo<void> {
  const LoginRoute({List<_i6.PageRouteInfo>? children})
      : super(
          LoginRoute.name,
          initialChildren: children,
        );

  static const String name = 'LoginRoute';

  static const _i6.PageInfo<void> page = _i6.PageInfo<void>(name);
}

/// generated route for
/// [_i4.Print]
class Print extends _i6.PageRouteInfo<PrintArgs> {
  Print({
    required _i7.ShipmentEntity shipment,
    _i8.Key? key,
    List<_i6.PageRouteInfo>? children,
  }) : super(
          Print.name,
          args: PrintArgs(
            shipment: shipment,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'Print';

  static const _i6.PageInfo<PrintArgs> page = _i6.PageInfo<PrintArgs>(name);
}

class PrintArgs {
  const PrintArgs({
    required this.shipment,
    this.key,
  });

  final _i7.ShipmentEntity shipment;

  final _i8.Key? key;

  @override
  String toString() {
    return 'PrintArgs{shipment: $shipment, key: $key}';
  }
}

/// generated route for
/// [_i5.ProfilePage]
class ProfileRoute extends _i6.PageRouteInfo<void> {
  const ProfileRoute({List<_i6.PageRouteInfo>? children})
      : super(
          ProfileRoute.name,
          initialChildren: children,
        );

  static const String name = 'ProfileRoute';

  static const _i6.PageInfo<void> page = _i6.PageInfo<void>(name);
}
