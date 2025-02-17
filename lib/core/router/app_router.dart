import 'package:auto_route/auto_route.dart';

import '../../presentation/auth/guards/authenticated_guard.dart';
import '../../presentation/auth/guards/unauthenticated_guard.dart';
import 'app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends $AppRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(
      page: LoginRoute.page,
      guards: [UnAuthenticatedGuard()],
      initial: true,
    ),
    AutoRoute(
      page: DataListRoute.page,
      guards: [AuthenticatedGuard()],
    ),
    AutoRoute(
      page: ProfileRoute.page,
      guards: [AuthenticatedGuard()],
    ),
  ];
}
