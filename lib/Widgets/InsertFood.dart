import 'package:flutter/material.dart';
import 'package:glycon_app/services/FirebaseFunctions.dart';
import 'package:glycon_app/services/datePickerService.dart';
import 'package:glycon_app/Widgets/CustomCounter.dart' as Counter;

class InsertFood extends StatefulWidget {
  final String userId;
  final VoidCallback closeOptionsPanel;
  final void Function() onDataRegistered;

  const InsertFood(
      {Key? key,
      required this.closeOptionsPanel,
      required this.userId,
      required this.onDataRegistered})
      : super(key: key);

  @override
  _InsertFoodState createState() => _InsertFoodState();
}

class _InsertFoodState extends State<InsertFood> {
  int quantityFood = 1;
  String userId = '';
  late DateTime selectedDate;
  late TimeOfDay selectedTime;
  TextEditingController foodController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController dateTimeController = TextEditingController();
  bool showQuantityField = true;

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

    // double quantity = 1;

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
              'Alimento',
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
                  'Alimento',
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
                    controller: foodController,
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
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      showQuantityField = true;
                    });
                  },
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor:
                            showQuantityField ? Colors.green : Colors.grey,
                        radius: 10,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        'Quantidade',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF4B0D07),
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.start,
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 20),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      showQuantityField = false;
                    });
                  },
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor:
                            !showQuantityField ? Colors.green : Colors.grey,
                        radius: 10,
                      ),
                      SizedBox(width: 5),
                      Text(
                        'Grama',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF4B0D07),
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.start,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 15),
            if (!showQuantityField)
              SizedBox(
                width: screenWidth,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 120.0),
                  child: TextField(
                    controller: quantityController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: "Gramas",
                      hintStyle: TextStyle(
                        color: Color(0xFF4B0D07).withOpacity(0.5),
                        fontWeight: FontWeight.normal,
                        fontSize: 16,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
              ),
            if (showQuantityField)
              SizedBox(
                width: 150, // Defina a largura que você deseja
                height: 50, // Defina a altura que você deseja
                child: Counter.CustomCounter(
                  quantity: quantityFood, // Passando a quantidade atual
                  onIncrement: () {
                    setState(() {
                      quantityFood++;
                    });
                  },
                  onDecrement: () {
                    setState(() {
                      if (quantityFood > 1) {
                        quantityFood--;
                      }
                    });
                  },
                ),
              ),
            SizedBox(height: 15),
            ElevatedButton(
              onPressed: () {
                if (foodController.text.isEmpty ||
                    (showQuantityField &&
                        quantityFood == num &&
                        quantityController.text.isEmpty) ||
                    (!showQuantityField && quantityController.text.isEmpty) ||
                    dateTimeController.text.isEmpty) {
                  // Mostra um pop-up informando que é obrigatório preencher pelo menos um dos campos
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text(
                          'Dados incorretos',
                          style: TextStyle(color: Color(0xFF4B0D07)),
                        ),
                        content: Text(
                          'Por favor, preencha pelo menos um dos campos obrigatórios!',
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
                } else {
                  int quantity = showQuantityField
                    ? quantityFood
                    : int.parse(quantityController.text.toString());

                  FirebaseFunctions.saveFoodDataToFirestore(
                    selectedDate: selectedDate,
                    nameFood: foodController.text,
                    quantityFood: quantity,
                    typeFood: showQuantityField ? 'unidade' : 'grama',
                    userId: userId,
                    // Adicione outros parâmetros conforme necessário
                  );
                  // Lógica para salvar os dados
                  // Navigator.pop(context);
                  // widget.onDataRegistered();
                  widget.closeOptionsPanel();
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
