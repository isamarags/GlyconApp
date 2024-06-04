import 'package:flutter/material.dart';
import 'package:glycon_app/Widgets/HeightSelectionDialog.dart';
import 'package:glycon_app/pages/HomePageChart.dart';
import 'package:glycon_app/Widgets/WeightPicker.dart';
import 'package:glycon_app/Widgets/ChangeProfile.dart';
import 'package:glycon_app/Widgets/ChangeHealth.dart';
import 'package:glycon_app/Widgets/forgotPassword.dart';
import 'package:glycon_app/pages/welcomePage.dart';
import 'package:go_router/go_router.dart';
// import 'package:glycon_app/assets/colors/colors.dart';
import 'package:glycon_app/pages/createAccount_page.dart';
import 'package:glycon_app/pages/login_page.dart';
import 'package:glycon_app/Widgets/About.dart';
import 'package:glycon_app/Widgets/Health.dart';
import 'package:glycon_app/Widgets/ViewHistory.dart';
import 'package:glycon_app/pages/home_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:glycon_app/pages/profile_page.dart';
// import 'package:glycon_app/Widgets/GlicemicIndexChart.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MaterialApp(
    home: MyApp(),
  ));

  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );
}

final GoRouter _router = GoRouter(routes: <RouteBase>[
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
      return LandingPage();
    },
  ),
  GoRoute(
    path: '/weight',
    builder: (BuildContext context, GoRouterState state) {
      double selectedWeight = 60.0;

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
    path: '/changeProfile',
    builder: (BuildContext context, GoRouterState state) {
      return ChangeProfile();
    },
  ),
  GoRoute(
    path: '/changeHealth',
    builder: (BuildContext context, GoRouterState state) {
      return ChangeHealth();
    },
  ),
  GoRoute(
    path: '/teste',
    builder: (BuildContext context, GoRouterState state) {
      return ViewHistory();
    },
  ),
]);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
    );
  }
}
