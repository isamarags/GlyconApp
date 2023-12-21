import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:glycon_app/Widgets/CustomBottomNavigationBarItem.dart';
import 'package:glycon_app/Widgets/AddOptionsPanel.dart';
import 'package:glycon_app/Widgets/BuildHealthItem.dart';
import 'package:go_router/go_router.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  int _selectedIndex = 0;

  void _showSlidingUpPanel() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return AddOptionsPanel(); // Chama o widget personalizado
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
        _showSlidingUpPanel();
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
  }

  BottomNavigationBarItem _buildIcon(int index, IconData icon, String label) {
    final customItem = CustomBottomNavigationBarItem(
      index: index,
      icon: icon,
      label: label,
      selectedIndex: _selectedIndex,
      onTap: () => _onNavigationItemSelected(index),
    );

    return BottomNavigationBarItem(
      icon: Icon(customItem.icon),
      label: customItem.label,
    );
  }

  List<Color> backgroundColors = [
    Color(0xFFE7F1FF),
    Color(0xFFDCFFD7),
    Color(0xFFFAD5CD),
  ];



  @override
  Widget build(BuildContext context) {
    String formattedDateTime =
        DateFormat('dd MMMM - HH:mm').format(DateTime.now());

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 50, horizontal: 25),
          padding: EdgeInsets.only(top: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundImage:
                              AssetImage('lib/assets/images/avatar.png'),
                          radius: 30,
                        ),
                        SizedBox(width: 15),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Isamara,',
                              style: TextStyle(
                                color: Color(0xFFB98282),
                                fontFamily: 'Montserrat',
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              'Bom dia!',
                              style: TextStyle(
                                  color: Color(0xFF4B0D07),
                                  fontFamily: 'Montserrat',
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Spacer(),
                        Container(
                          padding: EdgeInsets.only(right: 20),
                          child: IconButton(
                            icon: Icon(Icons.menu),
                            iconSize: 40,
                            color: Color(0xFF4B0D07),
                            onPressed: () {},
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                color: Colors.white,
                padding: EdgeInsets.all(20),
                margin: EdgeInsets.all(10),
                child: Column(
                  children: [
                    Container(
                      width: 217,
                      height: 120,
                      margin: EdgeInsets.only(bottom: 15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Color(0xFFD8A9A9),
                      ),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Glicose',
                            style: TextStyle(
                                color: Color(0xFF4B0D07),
                                fontFamily: 'Montserrat',
                                fontSize: 25,
                                letterSpacing: 1),
                          ),
                          Text(
                            '👍 100 mg/dl',
                            style: TextStyle(
                              color: Color(0xFF3F7332),
                              fontFamily: 'Montserrat',
                              fontSize: 22,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: EdgeInsets.only(
                        left: 10,
                      ),
                      child: Row(
                        children: [
                          Text(
                            'Saúde 💊',
                            style: TextStyle(
                                color: Color(0xFF4B0D07),
                                fontFamily: 'Montserrat',
                                fontSize: 16,
                                fontWeight: FontWeight.w500),
                          ),
                          Spacer(),
                          IconButton(
                            icon: Icon(Icons.more_vert),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    BuildHealthItem(
                      imagePath: 'lib/assets/images/medication.png',
                      title: 'Medicamentos',
                      description: '2 remédios tomados',
                      backgroundColor: backgroundColors[0],
                      dateTime: formattedDateTime,
                    ),
                    SizedBox(height: 10),
                    BuildHealthItem(
                      imagePath: 'lib/assets/images/insulin.png',
                      title: 'Insulina',
                      description: 'NPH',
                      backgroundColor: backgroundColors[1],
                      dateTime: formattedDateTime,
                    ),
                    SizedBox(height: 10),
                    BuildHealthItem(
                      imagePath: 'lib/assets/images/food.png',
                      title: 'Alimentação',
                      description: 'Lanche da tarde',
                      backgroundColor: backgroundColors[2],
                      dateTime: formattedDateTime,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: null,
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _navigateToPage,
          type: BottomNavigationBarType.fixed,
          items: [
            _buildIcon(0, Icons.home, 'Home'),
            _buildIcon(1, Icons.star, 'Metas'),
            _buildIcon(2, Icons.equalizer, 'Índice Glicêmico'),
            _buildIcon(3, Icons.share, 'Compartilhar'),
            _buildIcon(4, Icons.person, 'Conta'),
          ],
        ),
      ),
    );
  }
}
