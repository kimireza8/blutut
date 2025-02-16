import 'package:auto_route/auto_route.dart';
import 'app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends $AppRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(
          page: LoginRoute.page,
          initial: true,
        ),
        AutoRoute(page: ProfileRoute.page),
        AutoRoute(page: DataListRoute.page),
        AutoRoute(page: InputRoute.page),
      ];
}
