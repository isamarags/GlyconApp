import 'package:flutter/material.dart';

class BuildHealthItem extends StatelessWidget {
  final String? imagePath;
  final String title;
  final String description;
  final Color? backgroundColor;
  final String dateTime;

  const BuildHealthItem({
    this.imagePath,
    required this.title,
    required this.description,
    this.backgroundColor,
    required this.dateTime,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Color.fromARGB(255, 246, 249, 255),
            blurRadius: 8.0,
            spreadRadius: 5.0,
            offset: Offset(2, 4),
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
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: imagePath != null
                  ? Image.asset(imagePath!)
                  : null,
            ),
            SizedBox(width: 10),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    softWrap: false,
                    style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF4B0D07),
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                      height:
                          5), 
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF4B0D07),
                    ),
                  ),
                  SizedBox(height: 15),
                  Text(
                    dateTime,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  )
                ],
              ),
            ),
            // IconButton(
            //   icon: Icon(Icons.more_vert),
            //   onPressed: () {},
            // ),
          ],
        ),
      ),
    );
  }
}
