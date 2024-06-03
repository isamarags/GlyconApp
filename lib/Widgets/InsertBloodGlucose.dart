import 'package:flutter/material.dart';
import 'package:glycon_app/services/datePickerService.dart';
import 'package:glycon_app/services/FirebaseFunctions.dart';

class InsertBloodGlucose extends StatefulWidget {
  final VoidCallback closeOptionsPanel;
  final String userId;
  final void Function() onDataRegistered;

  const InsertBloodGlucose({
    Key? key,
    required this.closeOptionsPanel,
    required this.userId,
    required this.onDataRegistered,
  }) : super(key: key);

  @override
  _InsertBloodGlucoseState createState() => _InsertBloodGlucoseState();
}

class _InsertBloodGlucoseState extends State<InsertBloodGlucose> {
  late DateTime selectedDate;
  late TimeOfDay selectedTime;
  bool beforeMealSelected = false;
  bool afterMealSelected = false;
  TextEditingController glucoseLevelController = TextEditingController();
  TextEditingController dateTimeController = TextEditingController();
  String? selectedMealTime;

  @override
  void initState() {
    super.initState();
    selectedDate = DateTime.now();
    selectedTime = TimeOfDay.now();
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
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      TextFormField(
                        readOnly: true,
                        onTap: () async {
                          final dateTime =
                              await DatePickerService.selectDateTime(
                                  context, DateTime.now());

                          if (dateTime != null) {
                            setState(() {
                              selectedDate = dateTime;
                              selectedTime = TimeOfDay.fromDateTime(dateTime);
                              dateTimeController.text =
                                  "${selectedDate.day}/${selectedDate.month}/${selectedDate.year} ${selectedTime.hour}:${selectedTime.minute.toString().padLeft(2, '0')}";
                            });
                          }
                        },
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Color(0xFFD8A9A9),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 40, vertical: 10),
                          border: InputBorder.none,
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          hintText: dateTimeController.text.isNotEmpty
                              ? ''
                              : 'Data e horário',
                          hintStyle: TextStyle(
                            color: Color(0xFF4B0D07),
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            letterSpacing: 0.5,
                          ),
                          alignLabelWithHint: true,
                        ),
                        style: TextStyle(
                          color: Color(0xFF4B0D07),
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          letterSpacing: 0.5,
                        ),
                        controller: dateTimeController,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 25),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Glicemia capilar',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF4B0D07),
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.start,
                ),
                SizedBox(height: 5),
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
                      contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                      suffixText: 'mg/dl',
                      suffixStyle: TextStyle(
                        color: Color(0xFF4B0D07),
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        letterSpacing: 0.5,
                      ),
                      hintStyle: TextStyle(
                        color: Color(0xFF4B0D07).withOpacity(0.5),
                        fontWeight: FontWeight.normal,
                        fontSize: 16,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Selecione a refeição do dia',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF4B0D07),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          color: Color(0xFFD8A9A9),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.0),
                                  color: Color(0xFFD8A9A9),
                                ),
                                padding: EdgeInsets.symmetric(horizontal: 16.0),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: selectedMealTime,
                                    icon: null,
                                    elevation: 16,
                                    style: TextStyle(
                                      color: Color(0xFF4B0D07),
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                      letterSpacing: 0.5,
                                    ),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        selectedMealTime = newValue;
                                        beforeMealSelected = false;
                                        afterMealSelected = false;
                                      });
                                    },
                                    dropdownColor:
                                        Color.fromARGB(255, 255, 255, 255),
                                    underline: SizedBox(),
                                    items: <String>[
                                      'Antes do café da manhã',
                                      '2 horas após o café da manhã',
                                      'Antes do almoço',
                                      '2 horas após o almoço',
                                      'Antes do jantar',
                                      '2 horas após o jantar',
                                    ].map<DropdownMenuItem<String>>(
                                        (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Center(
                                          child: Text(
                                            value,
                                            style: TextStyle(
                                              color: Color(0xFF4B0D07),
                                              fontWeight: FontWeight.w500,
                                              fontSize: 16,
                                              letterSpacing: 0.5,
                                            ),
                                          ),
                                        ),
                                      );
                                    }).toList(),
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
              ],
            ),
            SizedBox(height: 15),
            ElevatedButton(
              onPressed: () {
                if (glucoseLevelController.text.isNotEmpty &&
                    selectedMealTime != null) {
                  print('Selected dateaa: $selectedDate');

                  FirebaseFunctions.saveGlucoseToFirestore(
                    selectedDate: selectedDate,
                    glucoseLevel: glucoseLevelController.text,
                    // beforeMealSelected: beforeMealSelected,
                    // afterMealSelected: afterMealSelected,
                    mealTime: selectedMealTime!,
                    userId: widget.userId,
                  );

                  //print('Data registeredaaaa');
                  widget.closeOptionsPanel();
                  widget.onDataRegistered();

                  //widget.onDataRegistered();
                  // print('Data registered');
                } else {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text(
                          'Dados incorretos',
                          style: TextStyle(color: Color(0xFF4B0D07)),
                        ),
                        content: Text(
                          'Por favor, preencha todos os campos corretamente!',
                          style: TextStyle(color: Color(0xFF4B0D07)),
                        ),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              'OK',
                              style: TextStyle(color: Color(0xFF4B0D07)),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                }
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
