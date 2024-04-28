import 'package:flutter/material.dart';
import 'package:glycon_app/pages/HomePageChart.dart';
import 'package:glycon_app/Widgets/forgotPassword.dart';
import 'package:glycon_app/pages/welcomePage.dart';
import 'package:go_router/go_router.dart';
// import 'package:glycon_app/assets/colors/colors.dart';
import 'package:glycon_app/pages/createAccount_page.dart';
import 'package:glycon_app/pages/login_page.dart';
import 'package:glycon_app/pages/metasPage.dart';
import 'package:glycon_app/Widgets/insertBloodGlucose.dart';
import 'package:glycon_app/pages/profile_page.dart';
import 'package:glycon_app/Widgets/WeightPicker.dart';
import 'package:glycon_app/Widgets/HeightSelectionDialog.dart';
import 'package:glycon_app/Widgets/About.dart';
import 'package:glycon_app/Widgets/Health.dart';
import 'package:glycon_app/pages/home_page.dart';

class AppRoutes {
  static final GoRouter _router = GoRouter(
    routes: <RouteBase>[
      GoRoute(
        path: '/',
        builder: (BuildContext context, GoRouterState state) {
          return WelcomePage();
        },
      ),
      GoRoute(
        path: '/login',
        builder: (BuildContext context, GoRouterState state) {
          return LoginPage();
        },
      ),
      GoRoute(
        path: '/forgotPassword',
        builder: (BuildContext context, GoRouterState state) {
          return ForgotPassword();
        },
      ),
      GoRoute(
        path: '/createAccount',
        builder: (BuildContext context, GoRouterState state) {
          return const CreateAccountPage();
        },
      ),
      GoRoute(
        path: '/about',
        builder: (BuildContext context, GoRouterState state) {
          return const About();
        },
      ),
      GoRoute(
        path: '/health',
        builder: (BuildContext context, GoRouterState state) {
          return const Health();
        },
      ),
      GoRoute(
        path: '/homePage',
        builder: (BuildContext context, GoRouterState state) {
          return LandingPage(
            glucoseValue: '',
            newGlucoseValue: '',
            pillValue: '',
            newPillValue: '',
            foodValue: '',
            newFoodValue: '',
            insulinValue: '',
            newInsulinValue: '',
          );
        },
      ),
      GoRoute(
        path: '/weight',
        builder: (BuildContext context, GoRouterState state) {
          String selectedWeight = '';

          return WeightPicker(
            selectedWeight: selectedWeight,
            weightController: null,
            onWeightChanged: (newWeight) {
              return newWeight;
            },
          );
        },
      ),
      GoRoute(
        path: '/height',
        builder: (BuildContext context, GoRouterState state) {
          double? selectedHeight;

          return HeightSelectionDialog(
            onHeightChanged: (newHeight) {
              selectedHeight = newHeight;
            },
          );
        },
      ),

      GoRoute(
        path: '/metas',
        builder: (BuildContext context, GoRouterState state) {
          return MetasPage();
        },
      ),
      // GoRoute(
      //   path: '/relatorios',
      //   builder: (BuildContext context, GoRouterState state) {
      //     return GlicemicIndexChart();
      //   },
      // ),
      GoRoute(
        path: '/profilePage',
        builder: (BuildContext context, GoRouterState state) {
          return ProfilePage();
        },
      ),
      GoRoute(
        path: '/charts',
        builder: (BuildContext context, GoRouterState state) {
          return HomePageChart();
        },
      ),
      GoRoute(
        path: '/insertBloodGlucose',
        builder: (BuildContext context, GoRouterState state) {
          final userId = ModalRoute.of(context)!.settings.arguments as String;
          return InsertBloodGlucose(
            userId: userId,
            onDataRegistered: () {
              Navigator.pop(context);
            },
            closeOptionsPanel: () {
              Navigator.pop(context);
            },
          );
        },
      ),
    ],
  );

  static GoRouter get router => _router;
}