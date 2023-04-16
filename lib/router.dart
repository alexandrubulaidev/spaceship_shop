// GoRouter configuration
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'ui/screens/component/component_page.dart';
import 'ui/screens/shop/shop_page.dart';
import 'ui/screens/spaceship/spaceship_page.dart';
import 'ui/screens/stations/stations_page.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (final context, final state) => const SpaceshipPage(),
      routes: <RouteBase>[
        GoRoute(
          path: 'component/:id',
          builder: (final context, final state) {
            return ComponentPage(
              id: state.params['id'],
            );
          },
        ),
        GoRoute(
          path: 'shop',
          builder: (final context, final state) {
            return const ShopPage();
          },
        ),
        GoRoute(
          path: 'stations',
          builder: (final context, final state) {
            return const StationsPage();
          },
        ),
      ],
    ),
  ],
);

// extension ContextRouting on BuildContext {
//   void popToRoot() {
//     // Get the current navigation state
//     final state = Navigator.of(this).restorablePopAndPushNamed('/');

//     // Pop all routes until the root
//     Navigator.of(this).pushAndRemoveUntil(
//       router.,
//     );
//   }
// }
