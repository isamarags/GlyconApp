import 'package:flutter/material.dart';
import 'package:glycon_app/services/datePickerService.dart';
import 'package:glycon_app/Widgets/CustomCounter.dart' as Counter;
// import 'package:customizable_counter/customizable_counter.dart';
import 'package:glycon_app/services/FirebaseFunctions.dart';

class InsertPill extends StatefulWidget {
  final String userId;
  final void Function() onDataRegistered;
  final VoidCallback closeOptionsPanel;

  const InsertPill(
      {Key? key,
      required this.userId,
      required this.closeOptionsPanel,
      required this.onDataRegistered})
      : super(key: key);

  @override
  _InsertPillState createState() => _InsertPillState();
}

class _InsertPillState extends State<InsertPill> {
  late DateTime selectedDate;
  late TimeOfDay selectedTime;
  bool beforeMealSelected = false;
  bool afterMealSelected = false;
  TextEditingController namePillController = TextEditingController();
  TextEditingController dateTimeController = TextEditingController();
  String namePill = ''; // Adicionado
  int quantityPill = 1; // Adicionado
  String userId = '';

  @override
  void initState() {
    super.initState();
    selectedDate = DateTime.now();
    selectedTime = TimeOfDay.now();
    userId = widget.userId;
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
              'Medicamento',
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
                Text(
                  'Nome do medicamento',
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
                    onChanged: (value) {
                      setState(() {
                        namePill = value;
                      });
                    },
                    controller: namePillController,
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
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Quantidade',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF4B0D07),
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.start,
                ),
                SizedBox(width: 20),
                Counter.CustomCounter(
                  quantity: quantityPill, // Passando a quantidade atual
                  onIncrement: () {
                    setState(() {
                      quantityPill++;
                    });
                  },
                  onDecrement: () {
                    setState(() {
                      if (quantityPill > 1) {
                        quantityPill--;
                      }
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 15),
            ElevatedButton(
              onPressed: () {
                // Verifica se todos os campos obrigatórios foram preenchidos
                if (namePillController.text.isNotEmpty) {
                  FirebaseFunctions.savePillDataToFirestore(
                    selectedDate: selectedDate,
                    namePill: namePill,
                    quantityPill: quantityPill,
                    userId: userId,
                  );

                  // Navigator.pop(context);
                  // widget.onDataRegistered();
                  widget.closeOptionsPanel();
                } else {
                  // Mostra um pop-up informando que é obrigatório preencher todos os campos
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text(
                          'Dados incorretos',
                          style: TextStyle(color: Color(0xFF4B0D07)),
                        ),
                        content: Text(
                          'Para salvar o medicamento, por favor preencha todos os campos!',
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
