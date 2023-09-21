import 'package:flutter/material.dart';
// import 'package:glycon_app/assets/colors/colors.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:logger/logger.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPage();
}

class _LoginPage extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: 430,
          height: MediaQuery.of(context).size.height,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(color: Color(0xFFEFDED8)),
          child: Stack(
            children: [
              Positioned(
                left: 0,
                top: 342,
                right: 0,
                child: Container(
                  width: MediaQuery.of(context).size.height,
                  height: 500,
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
                          // controller: nomecompletoController,
                          style: GoogleFonts.montserrat(
                              fontSize: 19,
                              fontWeight: FontWeight.normal,
                              decorationColor: Color(0xFF4B0D07),
                              letterSpacing: 0),
                          decoration: InputDecoration(
                              hintText: 'E-mail',
                              border: InputBorder.none,
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 20)),
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
                          // controller: emailController,
                          style: GoogleFonts.montserrat(
                              fontSize: 19,
                              fontWeight: FontWeight.normal,
                              color: Color(0xFF4B0D07)),
                          decoration: InputDecoration(
                              hintText: 'Senha',
                              border: InputBorder.none,
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 20)),
                          keyboardType: TextInputType.emailAddress,
                        ),
                      ),
                      SizedBox(height: 18),
                      Padding(
                        padding: const EdgeInsets.only(right: 45),
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
                          onPressed: () {},
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
                          context.go('/');
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
              ),
              Positioned(
                left: 104,
                top: 155,
                child: Text(
                  'Glycon',
                  style: GoogleFonts.philosopher(
                    color: Color(0xFF4B0D07),
                    fontSize: 68,
                    fontWeight: FontWeight.w400,
                    height: 0,
                  ),
                ),
              ),
              Positioned(
                top: 240,
                left: 82,
                child: Text(
                  'Cuidando da sua diabetes',
                  style: GoogleFonts.montserrat(
                    color: Color(0xFF4B0D07),
                    fontSize: 19,
                    fontWeight: FontWeight.w400,
                    height: 0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
