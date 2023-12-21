import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:glycon_app/Widgets/InsertBloodGlucose.dart';

class AddOptionsPanel extends StatefulWidget {
  const AddOptionsPanel({super.key});

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

    void showSlidingUpBloodGlucose() {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return InsertBloodGlucose(); // Chama o widget personalizado
        },
      );
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
          showSlidingUpBloodGlucose();
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

        if (index == 2) {
          showSlidingUpBloodGlucose();
        }
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
              onPressed: () => showSlidingUpBloodGlucose(),
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
                // Lógica quando o botão 'Medicamento' é pressionado
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
                // Lógica quando o botão 'Alimento' é pressionado
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
