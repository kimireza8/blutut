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
          page: ReceiptRoute.page,
          guards: [AuthenticatedGuard()],
        ),
        AutoRoute(
          page: ReceiptDetailRoute.page,
          guards: [AuthenticatedGuard()],
          path: '/detail/:receipt',
        ),
        AutoRoute(
          page: InputRoute.page,
          guards: [AuthenticatedGuard()],
        ),
        AutoRoute(
          page: ReceiptEditRoute.page,
          guards: [AuthenticatedGuard()],
          path: '/edit/:receipt',
        ),
        AutoRoute(
          page: PrintRoute.page,
          guards: [AuthenticatedGuard()],
        ),
      ];
}
