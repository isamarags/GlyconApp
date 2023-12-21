import 'package:flutter/material.dart';

class InsertBloodGlucose extends StatefulWidget {
  const InsertBloodGlucose({Key? key}) : super(key: key);

  @override
  _InsertBloodGlucoseState createState() => _InsertBloodGlucoseState();
}

class _InsertBloodGlucoseState extends State<InsertBloodGlucose> {
  late DateTime selectedDate;
  late TimeOfDay selectedTime;
  bool beforeMealSelected = false;
  bool afterMealSelected = false;
  TextEditingController glucoseLevelController = TextEditingController();

  @override
  void initState() {
    super.initState();
    selectedDate = DateTime.now();
    selectedTime = TimeOfDay.now();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null && picked != selectedTime)
      setState(() {
        selectedTime = picked;
      });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    final double verticalPaddingPercent = 0.05;
    final double horizontalPaddingPercent = 0.1;

    final double verticalPadding = screenHeight * verticalPaddingPercent;
    final double horizontalPadding = screenWidth * horizontalPaddingPercent;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.0),
          topRight: Radius.circular(24.0),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: verticalPadding,
          horizontal: horizontalPadding,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Glicemia',
              style: TextStyle(
                fontSize: 20,
                color: Color(0xFF4B0D07),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 15),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime(2100),
                      );
                      if (date != null) {
                        final time = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.fromDateTime(DateTime.now()),
                        );
                        if (time != null) {}
                      }
                    },
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        TextFormField(
                          readOnly: true,
                          onTap: () {},
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Color(0xFFD8A9A9),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 90, vertical: 10),
                            border: InputBorder.none,
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          controller: TextEditingController(),
                        ),
                        Positioned(
                          child: Text(
                            'Data e horário',
                            style: TextStyle(
                                color: Color(0xFF4B0D07),
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                letterSpacing: 0.5),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 25),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Nível de glicose no sangue',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF4B0D07),
                    fontWeight: FontWeight.normal,
                  ),
                  textAlign: TextAlign.start,
                ),
              ],
            ),
            SizedBox(height: 15),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                color: Color(0xFFD8A9A9),
              ),
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: TextField(
                controller: glucoseLevelController,
                keyboardType: TextInputType.number,
                style: TextStyle(
                  color: Color(0xFF4B0D07),
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  letterSpacing: 0.5,
                ),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 130, vertical: 0),
                  labelText: 'mg/dl',
                  labelStyle: TextStyle(
                    color: Color(0xFF4B0D07),
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      beforeMealSelected = !beforeMealSelected;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: beforeMealSelected ?
                      Color(0xFF4B0D07) : Color(0xFFD8A9A9),
                  ),
                  child: Text('Antes da refeição',
                      style: TextStyle(
                          color: beforeMealSelected ?
                            Color(0xFFD8A9A9) : Color(0xFF4B0D07))),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      afterMealSelected = !afterMealSelected;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: afterMealSelected ? 
                        Color(0xFF4B0D07) : Color(0xFFD8A9A9),
                  ),
                  child: Text('Depois da refeição',
                      style: TextStyle(
                          color: afterMealSelected ?
                            Color(0xFFD8A9A9) : Color(0xFF4B0D07))),
                ),
              ],
            ),
            SizedBox(height: 15),
            ElevatedButton(
              onPressed: () {
                // Lógica para salvar os dados
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFD8A9A9),
                foregroundColor: Color(0xFF4B0D07),
                textStyle: TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
                fixedSize: Size(350, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text('Salvar'),
            ),
          ],
        ),
      ),
    );
  }
}
