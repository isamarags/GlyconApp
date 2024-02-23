import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:glycon_app/services/sendpasswordreset.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}


class _ForgotPasswordState extends State<ForgotPassword> {
  final _emailController = TextEditingController();
  final _sendPasswordReset = SendPasswordReset();

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
                        'Recuperação de senha',
                        style: GoogleFonts.montserrat(
                            color: Color(0xFF4B0D07),
                            fontSize: 22,
                            fontWeight: FontWeight.w500,
                            height: 0,
                            letterSpacing: 0),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 60),
                      Text(
                        'Informe o seu e-mail de cadastro',
                        style: GoogleFonts.montserrat(
                            color: Color(0xFF4B0D07),
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                            height: 0,
                            letterSpacing: 0),
                        textAlign: TextAlign.center,
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
                          onPressed: (){
                            String email = _emailController.text.trim();
                            if (email.isNotEmpty) {
                              _sendPasswordReset.resetPassword(email);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor: Color(0xFFD8A9A9),
                                  content: Text(
                                    'Reset de senha enviado ao e-mail cadastrado.', 
                                    style: TextStyle(
                                      color:  Color(0xFF4B0D07)
                                    )
                                  ),
                                  action: SnackBarAction(
                                    label: 'OK',
                                    textColor: Color(0xFF4B0D07),
                                    onPressed: () {
                                      context.go('/login');
                                    },
                                  ),
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Por favor, preencha o campo de e-mail.'),
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
                            'REDEFINIR SENHA',
                            style: GoogleFonts.montserrat(
                              color: Color(0xFF4B0D07),
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              height: 0,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 30),
                      InkWell(
                        onTap: () {
                          context.go('/login');
                        },
                        child: Text(
                          'Voltar ao Login',
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
