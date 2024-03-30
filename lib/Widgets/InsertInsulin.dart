import 'package:flutter/material.dart';
import 'package:glycon_app/services/datePickerService.dart';
import 'package:glycon_app/services/FirebaseFunctions.dart';
// import 'package:glycon_app/Widgets/CustomCounter.dart' as Counter;
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:glycon_app/services/FirebaseFunctions.dart';

class InsertInsulin extends StatefulWidget {
  final VoidCallback closeOptionsPanel;
  final String userId;
  final void Function() onDataRegistered;

  const InsertInsulin({
    Key? key,
    required this.closeOptionsPanel,
    required this.userId,
    required this.onDataRegistered,
  }) : super(key: key);

  @override
  _InsertInsulinState createState() => _InsertInsulinState();
}

class _InsertInsulinState extends State<InsertInsulin> {
  late DateTime selectedDate;
  late TimeOfDay selectedTime;
  bool beforeMealSelected = false;
  bool afterMealSelected = false;
  TextEditingController insulinLevelController = TextEditingController();
  TextEditingController dateTimeController = TextEditingController();
  String userId = '';
  late String selectedInsulinType = '';
  late String selectedInsulin = '';
  late List<String> insulinOptions = [];

  @override
  void initState() {
    super.initState();
    selectedDate = DateTime.now();
    selectedTime = TimeOfDay.now();
    userId = widget.userId;
    selectedInsulinType = 'Basal';
    selectedInsulin = 'Selecionar'; // Definindo como vazio inicialmente
    FirebaseFunctions.fetchInsulinOptions().then((options) {
      setState(() {
        insulinOptions = options.toSet().toList(); // Remover duplicatas
        if (insulinOptions.isNotEmpty) {
          selectedInsulin =
              insulinOptions[0]; // Definir o primeiro valor como selecionado
        }
      });
    }).catchError((error) {
      print('Erro ao buscar as opções de insulina: $error');
      // Lidar com o erro conforme necessário
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
              'Insulina',
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
                          alignLabelWithHint:
                              true, // Adicione esta linha para centralizar o conteúdo
                        ),
                        style: TextStyle(
                          // Adicione esta parte para definir o estilo
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
                // Text(
                //   'Tipo de Insulina',
                //   style: TextStyle(
                //     fontSize: 16,
                //     color: Color(0xFF4B0D07),
                //     fontWeight: FontWeight.w500,
                //   ),
                //   textAlign: TextAlign.start,
                // ),
                // SizedBox(height: 25),

                Text(
                  'Insulina',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF4B0D07),
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.start,
                ),
                SizedBox(height: 5),
                DropdownButtonFormField<String>(
                  value: selectedInsulin.isNotEmpty
                      ? selectedInsulin
                      : insulinOptions.isNotEmpty
                          ? insulinOptions[0]
                          : null,
                  onChanged: (newValue) {
                    setState(() {
                      selectedInsulin = newValue!;

                      selectedInsulinType = newValue; 
                    });
                  },
                  items:
                      insulinOptions.map<DropdownMenuItem<String>>((insulin) {
                    return DropdownMenuItem<String>(
                      value: insulin,
                      child: Text(
                        insulin,
                        style: TextStyle(
                          color: Color(0xFF4B0D07),
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          letterSpacing: 0.5,
                        ),
                      ),
                    );
                  }).toList(),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Color(0xFFD8A9A9),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide.none,
                    ),
                    hintText: 'Selecionar insulina',
                  ),
                ),
              ],
            ),
            SizedBox(height: 25),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Dosagem de Insulina (UI)',
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
                    controller: insulinLevelController,
                    // controller: ,
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
                      suffixText: '',
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
            SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: screenWidth * 0.38,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        beforeMealSelected = !beforeMealSelected;

                        if (beforeMealSelected) {
                          afterMealSelected = false;
                        }
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      backgroundColor: beforeMealSelected
                          ? Color(0xFF4B0D07)
                          : Color(0xFFD8A9A9),
                    ),
                    child: Text(
                      'Antes da refeição',
                      style: TextStyle(
                        fontSize: 14,
                        color: beforeMealSelected
                            ? Color(0xFFD8A9A9)
                            : Color(0xFF4B0D07),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                SizedBox(
                  width: screenWidth * 0.38,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        afterMealSelected = !afterMealSelected;

                        if (afterMealSelected) {
                          beforeMealSelected = false;
                        }
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      backgroundColor: afterMealSelected
                          ? Color(0xFF4B0D07)
                          : Color(0xFFD8A9A9),
                    ),
                    child: Text(
                      'Depois da refeição',
                      style: TextStyle(
                        fontSize: 14,
                        color: afterMealSelected
                            ? Color(0xFFD8A9A9)
                            : Color(0xFF4B0D07),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 15),
            ElevatedButton(
              onPressed: () {
                if (insulinLevelController.text.isNotEmpty &&
                    beforeMealSelected != afterMealSelected &&
                    selectedInsulin.isNotEmpty) {
                  FirebaseFunctions.saveInsulinDataToFirestore(
                    selectedDate: selectedDate,
                    insulinValue: insulinLevelController.text,
                    beforeMealSelected: beforeMealSelected,
                    afterMealSelected: afterMealSelected,
                    insulinType: selectedInsulinType,
                    userId: userId,
                  );
                  widget.closeOptionsPanel();
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
                          'Para salvar a sua insulina, por favor preencha todos os campos!',
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
