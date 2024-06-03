import 'package:flutter/material.dart';

class BuildHealthItemGlucose extends StatelessWidget {
  final String title;
  final String description;
  final Color backgroundColor;
  final String dateTime;

  const BuildHealthItemGlucose({
    required this.title,
    required this.description,
    required this.backgroundColor,
    required this.dateTime,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      width: 200,
      height: 120,
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Color.fromARGB(255, 240, 242, 244),
            blurRadius: 8.0,
            spreadRadius: 10.0,
            // offset: Offset(5, 10),
          ),
        ],
      ),
      child: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(width: 10),
              Flexible(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      softWrap: false,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 20,
                          color: Color(0xFF4B0D07),
                          fontWeight: FontWeight.w500),
                    ),
                    SizedBox(height: 5),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 18,
                        color: backgroundColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )),
    );
  }
}
