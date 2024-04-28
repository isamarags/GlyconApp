import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget buildRowItem({
  required IconData icon,
  required String title,
  required String subtitle,
  required Function onTap,
}) {
  return GestureDetector(
    onTap: () {
      onTap();
    },
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 34,
          height: 32,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: Color(0xFF4B0D07),
            size: 35,
          ),
        ),
        SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: GoogleFonts.montserrat(
                  color: Color(0xFF4B0D07),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5),
            ),
            Text(
              subtitle,
              style: GoogleFonts.montserrat(
                color: Color(0xFF808080),
                fontSize: 13,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        Spacer(),
        Icon(
          Icons.arrow_forward_ios,
          color: Color(0xFF4B0D07),
          size: 20,
        ),
      ],
    ),
  );
}