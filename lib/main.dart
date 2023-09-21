import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
// import 'package:glycon_app/assets/colors/colors.dart';
import 'package:glycon_app/pages/createAccount_page.dart';
import 'package:glycon_app/pages/login_page.dart';
import 'package:glycon_app/pages/createAccount_partTwo.dart';
import 'package:glycon_app/pages/createAccount_partThree.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  runApp(const MyApp());

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

final GoRouter _router = GoRouter(routes: <RouteBase>[
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
      return const CreateAccountOne_Page();
    },
  ),
  GoRoute(
    path: '/createAccount_Two',
    builder: (BuildContext context, GoRouterState state) {
      return const CreateAccountTwo_Page();
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
