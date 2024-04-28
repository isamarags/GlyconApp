import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NavigationService {
  static void navigateToPage(BuildContext context, int index) {
    final router = GoRouter.of(context);
    switch (index) {
      case 0:
        router.go('/homePage');
        break;
      case 1:
        router.go('/homePage');
        break;
      case 2:
        router.go('/historico');
        break;
      case 3:
        router.go('/charts');
        break;
      case 4:
        router.go('/profilePage');
        break;
    }
  }
}
