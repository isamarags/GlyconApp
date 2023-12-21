import 'package:flutter/material.dart';
// import 'package:glycon_app/assets/colors/colors.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';

class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({Key? key}) : super(key: key);

  @override
  State<CreateAccountPage> createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  // final _formKey = GlobalKey<FormState>();
  // final _emailController = TextEditingController();
  // final _passwordController = TextEditingController();
  // final _confirmPasswordController = TextEditingController();
  // final _nameController = TextEditingController();
  // final _crmController = TextEditingController();

  bool loading = false;

  static Future<User?> registerUser({
    required String name,
    required String email,
    required String password,
  }) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;
    final logger = Logger();

    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      user = userCredential.user;

      await user!.updateDisplayName(name);
      await user.reload();
      final updatedUser = auth.currentUser;

      if (updatedUser != null) {
        logger.i(
            'User registered: ${updatedUser.uid}, Name: ${updatedUser.displayName}');
      } else {
        logger.i('Failed to update user profile.');
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        logger.e('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        logger.e('The account already exists for that email.');
      } else {
        logger.e(e);
      }

      return user;
    }

    return null;
  }

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
                top: 235,
                right: 0,
                child: Container(
                  width: MediaQuery.of(context).size.height,
                  height: 673,
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
                      SizedBox(height: 45),
                      Text(
                        'CADASTRO',
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
                            color: Color(0xFF4B0D07),
                            fontSize: 19,
                            fontWeight: FontWeight.normal,
                            decorationColor: Color(0xFF4B0D07),
                            letterSpacing: 0
                          ),
                          decoration: InputDecoration(
                            hintText: 'Nome completo',
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(horizontal: 20),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.transparent, // Define a cor como transparente
                              ),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.transparent, // Define a cor como transparente
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
                              // strokeAlign: StrokeAlign.center,
                              color: Color(0x7F4B0D07),
                            ),
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: TextFormField(
                          // controller: emailController,
                          style: GoogleFonts.montserrat(
                              decorationColor: Color(0xFF4B0D07),
                              fontSize: 19,
                              fontWeight: FontWeight.normal,
                              color: Color(0xFF4B0D07)),
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
                          // controller: senhaController,
                          style: GoogleFonts.montserrat(
                              decorationColor: Color(0xFF4B0D07),
                              fontSize: 20,
                              fontWeight: FontWeight.normal,
                              color: Color(0xFF4B0D07)),
                          decoration: InputDecoration(
                              hintText: 'Senha',
                              border: InputBorder.none,
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 20)),
                          obscureText: true,
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
                          // controller: confirmarsenhaController,
                          style: GoogleFonts.montserrat(
                              decorationColor: Color(0xFF4B0D07),
                              fontSize: 19,
                              fontWeight: FontWeight.normal,
                              color: Color(0xFF4B0D07)),
                          decoration: InputDecoration(
                              hintText: 'Confirmar senha',
                              border: InputBorder.none,
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 20)),
                          obscureText: true,
                        ),
                      ),
                      SizedBox(height: 23),
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
                      SizedBox(height: 23),
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
                          onPressed: () => context.go('/about'),
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
              Positioned(
                left: 104,
                top: 85,
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
                top: 173,
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

  // void _submitForm() {
  //   if (_formKey.currentState!.validate()) {
  //     // Form is valid, proceed with your logic
  //     // For example, you can extract the data from controllers like:
  //     // String name = _nameController.text;
  //     // String email = _emailController.text;
  //     // String password = _passwordController.text;
  //     // String confirmPassword = _confirmPasswordController.text;
  //     // String crm = _crmController.text;
  //   }
  // }
}
