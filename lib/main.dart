import 'package:flutter/material.dart';
import 'package:glycon_app/Widgets/HeightSelectionDialog.dart';
import 'package:glycon_app/Widgets/WeightPicker.dart';
import 'package:go_router/go_router.dart';
// import 'package:glycon_app/assets/colors/colors.dart';
import 'package:glycon_app/pages/createAccount_page.dart';
import 'package:glycon_app/pages/login_page.dart';
import 'package:glycon_app/pages/createAccount_pageOne.dart';
import 'package:glycon_app/pages/createAccount_pageTwo.dart';
import 'package:glycon_app/pages/home_page.dart';
import 'package:glycon_app/pages/registerItem.dart';
import 'package:glycon_app/pages/metasPage.dart';
import 'package:glycon_app/pages/sharePage.dart';
import 'package:glycon_app/pages/accountPage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  runApp(const MyApp());

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

final GoRouter _router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/login',
      builder: (BuildContext context, GoRouterState state) {
        return const LoginPage();
      },
    ),
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const CreateAccountPage();
      },
    ),
    GoRoute(
      path: '/createAccount_One',
      builder: (BuildContext context, GoRouterState state) {
        return const CreateAccountPageOne();
      },
    ),
    GoRoute(
      path: '/createAccount_Two',
      builder: (BuildContext context, GoRouterState state) {
        return const CreateAccountPageTwo();
      },
    ),
    GoRoute(
      path: '/homePage',
      builder: (BuildContext context, GoRouterState state) {
        return const LandingPage();
      },
    ),
    GoRoute(
      path: '/weight',
      builder: (BuildContext context, GoRouterState state) {
        String selectedWeight = ''; // Crie uma variável para armazenar o peso selecionado

        return WeightPicker(
          selectedWeight:
            selectedWeight, // Passe o valor selecionado como inicial
          weightController: null, // Preencha com o controlador adequado
          onWeightChanged: (newWeight) {
            return newWeight;
          },
        );
      },
    ),
    GoRoute(
      path: '/height',
      builder: (BuildContext context, GoRouterState state) {
        return const HeightSelectionDialog();
      },
    ),

    GoRoute(
    path: '/homePage',
    builder: (BuildContext context, GoRouterState state) {
      return LandingPage();
      },
    ),
    GoRoute(
      path: '/metas',
      builder: (BuildContext context, GoRouterState state) {
        return MetasPage();
      },
    ),
    GoRoute(
      path: '/registerItem',
      builder: (BuildContext context, GoRouterState state) {
        return RegisterItemPage();
      },
    ),
    GoRoute(
      path: '/sharePage',
      builder: (BuildContext context, GoRouterState state) {
        return SharePage();
      },
    ),
    GoRoute(
      path: '/accountPage',
      builder: (BuildContext context, GoRouterState state) {
        return AccountPage();
      },
    ),
  ]
);

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
