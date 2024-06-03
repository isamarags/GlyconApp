import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
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
              decoration:
                  BoxDecoration(color: Color.fromARGB(255, 255, 255, 255)),
              child: Column(
                children: [
                  Container(
                    height: screenHeight * 0.5,
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
                    )
                  ),
                  Container(
                    height: screenHeight * 0.5,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
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
                              onPressed: () {
                                context.go('/createAccount');
                                // context.go('/health');
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFFD8A9A9),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  side: BorderSide(color: Color(0xFFD8A9A9)),
                                ),
                              ),
                              child: Text(
                                'Cadastrar-se',
                                style: GoogleFonts.montserrat(
                                  color: Color(0xFF4B0D07),
                                  fontSize: 19,
                                  fontWeight: FontWeight.normal,
                                  height: 0,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 15),
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
                              onPressed: () {
                                context.go('/login');
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFFD8A9A9),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  side: BorderSide(color: Color(0xFFD8A9A9)),
                                ),
                              ),
                              child: Text(
                                'Login',
                                style: GoogleFonts.montserrat(
                                  color: Color(0xFF4B0D07),
                                  fontSize: 19,
                                  fontWeight: FontWeight.normal,
                                  height: 0,
                                ),
                              ),
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
