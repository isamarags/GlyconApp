import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:glycon_app/pages/registerItem.dart';
import 'package:glycon_app/pages/metasPage.dart';
import 'package:glycon_app/pages/sharePage.dart';
import 'package:glycon_app/pages/accountPage.dart';
import 'package:go_router/go_router.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    LandingPage(),
    MetasPage(),
    RegisterItemPage(), 
    SharePage(),
    AccountPage()
  ];

  

  void _onItemTapped(int index) {
  setState(() {
    _selectedIndex = index;
  });

}

  BottomNavigationBarItem _buildIcon(int index, IconData icon, String label) {
    final isSelected = index == _selectedIndex;
    final color = isSelected ? Color(0xFFBA8383) : Color(0xFFEFDFD8);

    return BottomNavigationBarItem(
      icon: Icon(icon, color: color),
      label: label,
    );
  }

  List<Color> backgroundColors = [
    Color(0xFFE7F1FF),
    Color(0xFFDCFFD7),
    Color(0xFFFAD5CD),
  ];

  Widget _buildHealthItem(String imagePath, String title, String description,
      Color backgroundColor, String dateTime) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Color(0xFFE7F1FF), // Cor da sombra
            blurRadius: 8.0, // soften the shadow
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
              child: Image.asset(
                imagePath, // Caminho da imagem que você deseja exibir
              ),
            ),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF4B0D07),
                      fontWeight: FontWeight.w500),
                ),
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
            Spacer(),
            IconButton(
              icon: Icon(Icons.more_vert),
              onPressed: () {
                // Adicione ação para o ícone de reticências aqui
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String formattedDateTime =
        DateFormat('dd MMMM - HH:mm').format(DateTime.now());

    return Scaffold(
      backgroundColor: Colors.white, // Cor de fundo do Scaffold
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(
              vertical: 50,
              horizontal: 25), // Espaçamento antes e depois da AppBar
          padding: EdgeInsets.only(top: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(
                    left: 15), // Adiciona espaçamento à esquerda
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
                          padding: EdgeInsets.only(
                              right:
                                  20), // Espaçamento à direita para os ícones
                          child: IconButton(
                            icon: Icon(Icons.menu),
                            iconSize: 40,
                            color: Color(0xFF4B0D07),
                            onPressed: () {
                              // Adicione ação para o ícone do menu aqui
                            },
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
                          Spacer(), // Espaçamento flexível para empurrar o ícone para a direita
                          IconButton(
                            icon: Icon(Icons.more_vert),
                            onPressed: () {
                              // Adicione ação para o ícone de reticências aqui
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    _buildHealthItem(
                      'lib/assets/images/medication.png',
                      'Medicamentos',
                      '2 remédios tomados',
                      backgroundColors[0],
                      formattedDateTime,
                    ),
                    SizedBox(height: 10),
                    _buildHealthItem(
                      'lib/assets/images/insulin.png',
                      'Insulina',
                      'NPH',
                      backgroundColors[1],
                      formattedDateTime,
                    ),
                    SizedBox(height: 10),
                    _buildHealthItem(
                      'lib/assets/images/food.png',
                      'Alimentação',
                      'Lanche da tarde',
                      backgroundColors[2],
                      formattedDateTime,
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
          canvasColor: null, // Define a cor de fundo como transparente
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (int index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          type: BottomNavigationBarType
              .fixed, // Define o tipo de barra inferior como fixo para evitar realces de cor
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
