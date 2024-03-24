import 'package:flutter/material.dart';
// import 'package:glycon_app/Widgets/InsertBloodGlucose.dart';
import 'package:glycon_app/utils/sliding_up_functions.dart';
import 'package:go_router/go_router.dart';

class AddOptionsPanel extends StatefulWidget {
  final String userId;
  final void Function() onDataRegistered;
  String? newGlucoseValue;
  String? glucoseValue;
  String? newPillValue;
  String? pillValue;
  String? newFoodValue;
  String? foodValue;
  String? newInsulinValue;
  String? insulinValue;

  final void Function() onClose;
  AddOptionsPanel(
      {Key? key,
      required this.userId,
      required this.onDataRegistered,
      required this.glucoseValue,
      required this.newGlucoseValue,
      required this.onClose,
      this.newPillValue,
      this.pillValue,
      this.newFoodValue,
      this.foodValue,
      this.newInsulinValue,
      this.insulinValue})
      : super(key: key);

  @override
  State<AddOptionsPanel> createState() => _AddOptionsPanelState();
}

class _AddOptionsPanelState extends State<AddOptionsPanel> {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    // Defina a porcentagem do tamanho da tela que você quer para o padding
    final double verticalPaddingPercent = 0.05; // 5% do tamanho da tela
    final double horizontalPaddingPercent = 0.1; // 10% do tamanho da tela

    final double verticalPadding = screenHeight * verticalPaddingPercent;
    final double horizontalPadding = screenWidth * horizontalPaddingPercent;

    void _updateGlucoseValue() {
      // Atualiza o valor da glicose com o novo valor
      setState(() {
        widget.glucoseValue = widget.newGlucoseValue!;
      });
      // Chama a função onDataRegistered para notificar a página inicial
      widget.onDataRegistered();
    }

    void _updatePillValue() {
      // Atualiza o valor do medicamento com o novo valor
      setState(() {
        widget.pillValue = widget.newPillValue!;
      });
      // Chama a função onDataRegistered para notificar a página inicial
      widget.onDataRegistered();
    }

    void _updateFoodValue() {
      // Atualiza o valor do alimento com o novo valor
      setState(() {
        widget.foodValue = widget.newFoodValue!;
      });
      // Chama a função onDataRegistered para notificar a página inicial
      widget.onDataRegistered();
    }

    void _updateInsulinValue() {
      // Atualiza o valor da insulina com o novo valor
      setState(() {
        widget.insulinValue = widget.newInsulinValue!;
      });
      // Chama a função onDataRegistered para notificar a página inicial
      widget.onDataRegistered();
    }

    void _navigateToPage(int index) {
      final router = GoRouter.of(context);

      switch (index) {
        case 0:
          router.go('/homePage');
          break;
        case 1:
          router.go('/metas');
          break;
        case 2:
          showSlidingUpBloodGlucose(
              context, widget.userId, () => _updateGlucoseValue());
          break;
        case 3:
          router.go('/sharePage');
          break;
        case 4:
          router.go('/accountPage');
          break;
      }
    }

    void Function(int)? _onNavigationItemSelected(int index) {
      _navigateToPage(index);

      if (index == 0) {
        // Função intermediária sem argumentos
        void updateGlucoseValueWithoutArgument() {
          _updateGlucoseValue();
        }

        // Passa a função intermediária
        showSlidingUpBloodGlucose(
            context, widget.userId, updateGlucoseValueWithoutArgument);
      }
      return null;
    }

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
              'O que você deseja adicionar?',
              style: TextStyle(
                fontSize: 20,
                color: Color(0xFF4B0D07),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 15),
            ElevatedButton(
              onPressed: () {
                showSlidingUpBloodGlucose(context, widget.userId, () {
                  _updateGlucoseValue();
                });
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
              child: Text('Glicemia'),
            ),
            SizedBox(height: 15),
            ElevatedButton(
              onPressed: () {
                showSlidingUpInsulin(context, widget.userId, () {
                  _updateInsulinValue();
                });
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
              child: Text('Insulina'),
            ),
            SizedBox(height: 15),
            ElevatedButton(
              onPressed: () {
                showSlidingUpPill(context, widget.userId, () {
                  _updatePillValue();
                });
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
              child: Text('Medicamento'),
            ),
            SizedBox(height: 15),
            ElevatedButton(
              onPressed: () {
                showSlidingUpFood(context, widget.userId, () {
                  _updateFoodValue();
                });
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
              child: Text('Alimento'),
            ),
          ],
        ),
      ),
    );
  }
}
