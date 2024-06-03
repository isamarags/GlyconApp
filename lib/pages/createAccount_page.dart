import 'package:flutter/material.dart';
// import 'package:glycon_app/assets/colors/colors.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:logger/logger.dart';
import 'package:glycon_app/services/registerUser.dart'; // Importe o arquivo auth_service.dart

class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({Key? key}) : super(key: key);

  @override
  State<CreateAccountPage> createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _nameController = TextEditingController();
  // final _crmController = TextEditingController();

  void onPressedPassword() {
    setState(() {
      _passwordVisible = !_passwordVisible;
    });
  }

  void onPressedConfirmPassword() {
    setState(() {
      _confirmPasswordVisible = !_confirmPasswordVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          double screenWidth = constraints.maxWidth;
          double screenHeight = constraints.maxHeight;
          return SingleChildScrollView(
            child: Container(
              width: screenWidth,
              height: screenHeight,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(color: Color(0xFFEFDED8)),
              child: Column(
                children: [
                  Container(
                    height: screenHeight * 0.3,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
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
                          SizedBox(height: 10),
                          Text(
                            'Cuidando da sua diabetes',
                            style: GoogleFonts.montserrat(
                              color: Color(0xFF4B0D07),
                              fontSize: 19,
                              fontWeight: FontWeight.w400,
                              height: 0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: screenHeight * 0.7,
                    decoration: ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(height: 45),
                          Text(
                            'CADASTRO',
                            style: GoogleFonts.montserrat(
                              color: Color(0xFF4B0D07),
                              fontSize: 22,
                              fontWeight: FontWeight.w400,
                              height: 0,
                              letterSpacing: 0,
                            ),
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
                                  color: Color(0x7F4B0D07),
                                ),
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            child: TextFormField(
                              controller: _nameController,
                              style: GoogleFonts.montserrat(
                                color: Color(0xFF4B0D07),
                                fontSize: 18,
                                fontWeight: FontWeight.normal,
                                decorationColor: Color(0xFF4B0D07),
                                letterSpacing: 0,
                              ),
                              textAlign: TextAlign.start,
                              decoration: InputDecoration(
                                hintText: 'Nome completo',
                                border: InputBorder.none,
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 20),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.transparent,
                                  ),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.transparent,
                                  ),
                                ),
                              ),
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
                                  color: Color(0x7F4B0D07),
                                ),
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            child: TextFormField(
                              controller: _emailController,
                              style: GoogleFonts.montserrat(
                                decorationColor: Color(0xFF4B0D07),
                                fontSize: 18,
                                fontWeight: FontWeight.normal,
                                color: Color(0xFF4B0D07),
                              ),
                              textAlign: TextAlign.start,
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
                                  color: Color(0x7F4B0D07),
                                ),
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            child: TextFormField(
                              controller: _passwordController,
                              style: GoogleFonts.montserrat(
                                decorationColor: Color(0xFF4B0D07),
                                fontSize: 18,
                                fontWeight: FontWeight.normal,
                                color: Color(0xFF4B0D07),
                              ),
                              textAlign: TextAlign.start,
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
                                      horizontal: 20, vertical: 14)),
                              obscureText: !_passwordVisible,
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
                                  color: Color(0x7F4B0D07),
                                ),
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            child: TextFormField(
                              controller: _confirmPasswordController,
                              style: GoogleFonts.montserrat(
                                decorationColor: Color(0xFF4B0D07),
                                fontSize: 18,
                                fontWeight: FontWeight.normal,
                                color: Color(0xFF4B0D07),
                              ),
                              textAlign: TextAlign.start,
                              decoration: InputDecoration(
                                  hintText: 'Confirmar senha',
                                  suffixIcon: IconButton(
                                      icon: Icon(
                                        _confirmPasswordVisible
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                        color: Color(0xFF4B0D07),
                                      ),
                                      onPressed: () =>
                                          onPressedConfirmPassword()),
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 14)),
                              obscureText: !_confirmPasswordVisible,
                            ),
                          ),
                          SizedBox(height: 45),
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
                                await registerUser(
                                  context,
                                  _nameController,
                                  _emailController,
                                  _passwordController,
                                  _confirmPasswordController,
                                );
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
                              context.go('/login');
                            },
                            child: Text(
                              'Já possui uma conta? Faça login!',
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
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
