import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:glycon_app/services/signInUser.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _passwordVisible = false;
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  void onPressedPassword() {
    setState(() {
      _passwordVisible = !_passwordVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: screenWidth,
          height: screenHeight,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(color: Color(0xFFEFDED8)),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  'Glycon',
                  style: GoogleFonts.philosopher(
                    color: Color(0xFF4B0D07),
                    fontSize: 68,
                    fontWeight: FontWeight.w400,
                    height: 0,
                  ),
                ),
                Text(
                  'Cuidando da sua diabetes',
                  style: GoogleFonts.montserrat(
                    color: Color(0xFF4B0D07),
                    fontSize: 19,
                    fontWeight: FontWeight.w400,
                    height: 0,
                  ),
                ),
                Container(
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: 65),
                      Text(
                        'LOGIN',
                        style: GoogleFonts.montserrat(
                            color: Color(0xFF4B0D07),
                            fontSize: 22,
                            fontWeight: FontWeight.w400,
                            height: 0,
                            letterSpacing: 0),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 35),
                      Container(
                        width: 350,
                        height: 50,
                        margin: EdgeInsets.symmetric(horizontal: 40),
                        decoration: ShapeDecoration(
                          color: Color(0x4CEFDED8),
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              width: 1,
                              // strokeAlign: StrokeAlign.center,
                              color: Color(0x7F4B0D07),
                            ),
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: TextFormField(
                          controller: _emailController,
                          style: GoogleFonts.montserrat(
                              fontSize: 18,
                              fontWeight: FontWeight.normal,
                              decorationColor: Color(0xFF4B0D07),
                              letterSpacing: 0),
                          decoration: InputDecoration(
                              hintText: 'E-mail',
                              border: InputBorder.none,
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 20)),
                          keyboardType: TextInputType.emailAddress,
                        ),
                      ),
                      SizedBox(height: 20),
                      Container(
                        width: 350,
                        height: 50,
                        margin: EdgeInsets.symmetric(horizontal: 40),
                        decoration: ShapeDecoration(
                          color: Color(0x4CEFDED8),
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              width: 1,
                              // strokeAlign: StrokeAlign.center,
                              color: Color(0x7F4B0D07),
                            ),
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: TextFormField(
                          controller: _passwordController,
                          style: GoogleFonts.montserrat(
                              fontSize: 18,
                              fontWeight: FontWeight.normal,
                              decorationColor: Color(0xFF4B0D07),
                              letterSpacing: 0),
                          decoration: InputDecoration(
                            hintText: 'Senha',
                            suffixIcon: IconButton(
                                icon: Icon(
                                  _passwordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Color(0xFF4B0D07),
                                ),
                                onPressed: () => onPressedPassword()),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical:
                                    14), // Ajuste para alinhar verticalmente
                          ),
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: !_passwordVisible,
                        ),
                      ),
                      SizedBox(height: 18),
                      Padding(
                        padding: const EdgeInsets.only(right: 45),
                        child: GestureDetector(
                          onTap: () {
                            context.go('/forgotPassword');
                          },
                          child: Text(
                            'Esqueci minha senha',
                            style: GoogleFonts.montserrat(
                              color: Color(0xFFB98282),
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              height: 0,
                            ),
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ),
                      SizedBox(height: 40),
                      Container(
                        width: 30,
                        height: 53,
                        margin: EdgeInsets.symmetric(horizontal: 36),
                        decoration: ShapeDecoration(
                          color: Color(0xFFD8A9A9),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: ElevatedButton(
                          onPressed: () async {
                            String email = _emailController.text;
                            String password = _passwordController.text;

                            if (email.isNotEmpty && password.isNotEmpty) {
                              User? user = await AuthService.signInUser(
                                  email: email, password: password);

                              if (user != null) {
                                context.go('/homePage');
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        'Falha no login. Verifique suas credenciais.'),
                                  ),
                                );
                              }
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      'Por favor, preencha todos os campos.'),
                                ),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFFD8A9A9),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: BorderSide(color: Color(0xFFD8A9A9)),
                            ),
                          ),
                          child: Text(
                            'CONTINUAR',
                            style: GoogleFonts.montserrat(
                              color: Color(0xFF4B0D07),
                              fontSize: 19,
                              fontWeight: FontWeight.w500,
                              height: 0,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 46),
                      InkWell(
                        onTap: () {
                          context.go('/createAccount');
                        },
                        child: Text(
                          'Não possui uma conta? Cadastre-se!',
                          style: GoogleFonts.montserrat(
                            color: Color(0xFF4B0D07),
                            fontSize: 17,
                            fontWeight: FontWeight.w400,
                            height: 0,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
