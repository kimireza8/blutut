// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i7;
import 'package:blutut_clasic/domain/entities/shipment_entity.dart' as _i9;
import 'package:blutut_clasic/presentation/auth/pages/login_page.dart' as _i4;
import 'package:blutut_clasic/presentation/data_list/pages/data_list_page.dart'
    as _i1;
import 'package:blutut_clasic/presentation/data_list/pages/print_page.dart'
    as _i5;
import 'package:blutut_clasic/presentation/detail_data_list/pages/detail_data_list_page.dart'
    as _i2;
import 'package:blutut_clasic/presentation/profile/pages/profile_page.dart'
    as _i6;
import 'package:blutut_clasic/presentation/receipt/pages/input_page.dart'
    as _i3;
import 'package:flutter/material.dart' as _i8;

abstract class $AppRouter extends _i7.RootStackRouter {
  $AppRouter({super.navigatorKey});

  @override
  final Map<String, _i7.PageFactory> pagesMap = {
    DataListRoute.name: (routeData) {
      return _i7.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i1.DataListPage(),
      );
    },
    DetailDataListRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<DetailDataListRouteArgs>(
          orElse: () => DetailDataListRouteArgs(
              shipmentId: pathParams.getString('shipmentId')));
      return _i7.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i2.DetailDataListPage(
          shipmentId: args.shipmentId,
          key: args.key,
        ),
      );
    },
    InputRoute.name: (routeData) {
      return _i7.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i3.InputPage(),
      );
    },
    LoginRoute.name: (routeData) {
      return _i7.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i4.LoginPage(),
      );
    },
    Print.name: (routeData) {
      final args = routeData.argsAs<PrintArgs>();
      return _i7.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i5.Print(
          shipment: args.shipment,
          key: args.key,
        ),
      );
    },
    ProfileRoute.name: (routeData) {
      return _i7.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i6.ProfilePage(),
      );
    },
  };
}

/// generated route for
/// [_i1.DataListPage]
class DataListRoute extends _i7.PageRouteInfo<void> {
  const DataListRoute({List<_i7.PageRouteInfo>? children})
      : super(
          DataListRoute.name,
          initialChildren: children,
        );

  static const String name = 'DataListRoute';

  static const _i7.PageInfo<void> page = _i7.PageInfo<void>(name);
}

/// generated route for
/// [_i2.DetailDataListPage]
class DetailDataListRoute extends _i7.PageRouteInfo<DetailDataListRouteArgs> {
  DetailDataListRoute({
    required String shipmentId,
    _i8.Key? key,
    List<_i7.PageRouteInfo>? children,
  }) : super(
          DetailDataListRoute.name,
          args: DetailDataListRouteArgs(
            shipmentId: shipmentId,
            key: key,
          ),
          rawPathParams: {'shipmentId': shipmentId},
          initialChildren: children,
        );

  static const String name = 'DetailDataListRoute';

  static const _i7.PageInfo<DetailDataListRouteArgs> page =
      _i7.PageInfo<DetailDataListRouteArgs>(name);
}

class DetailDataListRouteArgs {
  const DetailDataListRouteArgs({
    required this.shipmentId,
    this.key,
  });

  final String shipmentId;

  final _i8.Key? key;

  @override
  String toString() {
    return 'DetailDataListRouteArgs{shipmentId: $shipmentId, key: $key}';
  }
}

/// generated route for
/// [_i3.InputPage]
class InputRoute extends _i7.PageRouteInfo<void> {
  const InputRoute({List<_i7.PageRouteInfo>? children})
      : super(
          InputRoute.name,
          initialChildren: children,
        );

  static const String name = 'InputRoute';

  static const _i7.PageInfo<void> page = _i7.PageInfo<void>(name);
}

/// generated route for
/// [_i4.LoginPage]
class LoginRoute extends _i7.PageRouteInfo<void> {
  const LoginRoute({List<_i7.PageRouteInfo>? children})
      : super(
          LoginRoute.name,
          initialChildren: children,
        );

  static const String name = 'LoginRoute';

  static const _i7.PageInfo<void> page = _i7.PageInfo<void>(name);
}

/// generated route for
/// [_i5.Print]
class Print extends _i7.PageRouteInfo<PrintArgs> {
  Print({
    required _i9.ShipmentEntity shipment,
    _i8.Key? key,
    List<_i7.PageRouteInfo>? children,
  }) : super(
          Print.name,
          args: PrintArgs(
            shipment: shipment,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'Print';

  static const _i7.PageInfo<PrintArgs> page = _i7.PageInfo<PrintArgs>(name);
}

class PrintArgs {
  const PrintArgs({
    required this.shipment,
    this.key,
  });

  final _i9.ShipmentEntity shipment;

  final _i8.Key? key;

  @override
  String toString() {
    return 'PrintArgs{shipment: $shipment, key: $key}';
  }
}

/// generated route for
/// [_i6.ProfilePage]
class ProfileRoute extends _i7.PageRouteInfo<void> {
  const ProfileRoute({List<_i7.PageRouteInfo>? children})
      : super(
          ProfileRoute.name,
          initialChildren: children,
        );

  static const String name = 'ProfileRoute';

  static const _i7.PageInfo<void> page = _i7.PageInfo<void>(name);
}
