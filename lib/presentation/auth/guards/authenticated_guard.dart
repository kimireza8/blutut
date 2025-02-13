// import 'package:auto_route/auto_route.dart';
// import 'package:blutut_clasic/core/router/app_router.gr.dart';
// import 'package:flutter/material.dart';

// @RoutePage()
// class AuthenticatedGuard extends ConsumerWidget {
//   const AuthenticatedGuard({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final token = ref.watch(userStateProvider.select((user) => user.token));

//     if (token == null) {
//       context.replaceRoute(LoginRoute());
//       return const Material(child: SizedBox());
//     }

//     return const AutoRouter();
//   }
// }