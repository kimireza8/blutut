import 'package:auto_route/auto_route.dart';

import '../../presentation/auth/guards/authenticated_guard.dart';
import '../../presentation/auth/guards/unauthenticated_guard.dart';
import 'app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends $AppRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(
          page: SplashRoute.page,
          initial: true,
        ),
        AutoRoute(
          page: LoginRoute.page,
          guards: [UnAuthenticatedGuard()],
        ),
        AutoRoute(
          page: DataListRoute.page,
          guards: [AuthenticatedGuard()],
        ),
        AutoRoute(
          page: PrintRoute.page,
          guards: [AuthenticatedGuard()],
        ),
        AutoRoute(
          page: InputRoute.page,
          guards: [AuthenticatedGuard()],
        ),
        AutoRoute(
          page: DetailDataListRoute.page,
          guards: [AuthenticatedGuard()],
          path: '/detail/:shipment',
        ),
      ];
}
