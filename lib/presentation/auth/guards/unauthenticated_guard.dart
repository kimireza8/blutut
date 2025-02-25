import 'package:auto_route/auto_route.dart';

import '../../../core/router/app_router.gr.dart';
import '../../../core/services/shared_preferences_service.dart';
import '../../../dependency_injections.dart';

class UnAuthenticatedGuard extends AutoRouteGuard {
  @override
  Future<void> onNavigation(
    NavigationResolver resolver,
    StackRouter router,
  ) async {
    SharedPreferencesService sharedPreferencesService =
        serviceLocator<SharedPreferencesService>();
    String? cookie = sharedPreferencesService.getCookie();
    if (cookie != null) {
      await router.replace(const ReceiptRoute());
    } else {
      resolver.next();
    }
  }
}
