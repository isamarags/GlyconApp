import 'package:flutter/material.dart';
import 'package:glycon_app/Widgets/HeightSelectionDialog.dart';
import 'package:glycon_app/Widgets/WeightPicker.dart';
import 'package:glycon_app/Widgets/forgotPassword.dart';
import 'package:glycon_app/pages/welcomePage.dart';
import 'package:go_router/go_router.dart';
// import 'package:glycon_app/assets/colors/colors.dart';
import 'package:glycon_app/pages/createAccount_page.dart';
import 'package:glycon_app/pages/login_page.dart';
import 'package:glycon_app/Widgets/About.dart';
import 'package:glycon_app/Widgets/Health.dart';
import 'package:glycon_app/pages/home_page.dart';
import 'package:glycon_app/pages/metasPage.dart';
import 'package:glycon_app/pages/accountPage.dart';
import 'Widgets/InsertBloodGlucose.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  runApp(
    MaterialApp(
      home: MyApp(),
    )
  );

  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );
}

final GoRouter _router = GoRouter(
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
        return LandingPage(glucoseValue: '', newGlucoseValue: '');
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
      path: '/accountPage',
      builder: (BuildContext context, GoRouterState state) {
        return AccountPage();
      },
    ),
    GoRoute(
      path: '/insertBloodGlucose',
      builder: (BuildContext context, GoRouterState state) {
        final userId = ModalRoute.of(context)!.settings.arguments as String;
        return InsertBloodGlucose(
          userId: userId,
          onDataRegistered: () {
            // Lógica para fechar o painel de opções
            Navigator.pop(context);
          }, 
          closeOptionsPanel: () {
            // Lógica para fechar o painel de opções
            Navigator.pop(context);
          },
        );
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
