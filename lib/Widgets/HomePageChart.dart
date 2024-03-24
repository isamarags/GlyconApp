import 'package:flutter/material.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:glycon_app/services/FirebaseFunctions.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';
import 'package:csv/csv.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class _GlicemiaData {
  final DateTime time;
  final double glucoseLevel;
  final Color color;

  _GlicemiaData(this.time, this.glucoseLevel, this.color);
}

enum ChartType {
  line,
  bar,
  spline,
  area,
}

class HomePageChart extends StatefulWidget {
  @override
  _HomePageChartState createState() => _HomePageChartState();
}

class _HomePageChartState extends State<HomePageChart> {
  List<_GlicemiaData> glucoseData = [];
  DateTime selectedDate = DateTime.now();
  ChartType _selectedChartType = ChartType.line;
  final GlobalKey _chartKey = GlobalKey();
  String userId = '';
  String fullName = '';

  @override
  void initState() {
    super.initState();
    _fetchUserInfo();
    _fetchGlucoseData();
    _fetchGlucoseDataLast14Days();
  }

  Future<void> _fetchUserInfo() async {
    fullName = await FirebaseFunctions.getUserNameFromFirestore();
    userId = await FirebaseFunctions.getUserIdFromFirestore();
  }

  Future<void> _fetchGlucoseData() async {
    List<Map<String, dynamic>> glucoseDataList =
        await FirebaseFunctions.getGlucoseDataFromFirestore(
            userId, selectedDate);

    setState(() {
      glucoseData.clear();
      for (Map<String, dynamic> data in glucoseDataList) {
        DateTime myDateTime = DateTime.fromMillisecondsSinceEpoch(
            data['selectedDate'].seconds * 1000);

        glucoseData.add(_GlicemiaData(
            myDateTime,
            double.parse(data['glucoseLevel']),
            _getBarColor(double.parse(data['glucoseLevel']), glucoseData)));
        glucoseData.sort((a, b) => a.time.compareTo(b.time));
      }
    });
  }

  Future<List<Map<String, dynamic>>> _fetchGlucoseDataLast14Days() async {
    DateTime fourteenDaysAgo = DateTime.now().subtract(Duration(days: 14));

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('glicoseData')
        .doc(userId)
        .collection('data')
        .where('selectedDate', isGreaterThanOrEqualTo: fourteenDaysAgo)
        .orderBy('selectedDate', descending: true)
        .get();

    List<Map<String, dynamic>> glucoseDataList = [];
    querySnapshot.docs.forEach((doc) {
      glucoseDataList.add(doc.data() as Map<String, dynamic>);
    });

    return glucoseDataList;
  }

  Color _getBarColor(
      double glucoseLevel, List<_GlicemiaData> dataWithinFourteenDays) {
    final averageGlucose = dataWithinFourteenDays.isEmpty
        ? 0
        : dataWithinFourteenDays
                .map((data) => data.glucoseLevel)
                .reduce((a, b) => a + b) /
            dataWithinFourteenDays.length;

    if (averageGlucose >= 240) {
      return Colors.orange;
    } else if (averageGlucose >= 181 && averageGlucose <= 240) {
      return Colors.yellow;
    } else if (averageGlucose >= 70 && averageGlucose <= 180) {
      return Colors.green;
    } else {
      return Colors.red;
    }
  }

  Widget _buildChart() {
    switch (_selectedChartType) {
      case ChartType.line:
        return SfCartesianChart(
          key: _chartKey,
          primaryXAxis: DateTimeAxis(
            dateFormat: DateFormat.Hm(),
            intervalType: DateTimeIntervalType.hours,
          ),
          primaryYAxis: NumericAxis(
            maximum: 350,
          ),
          title: ChartTitle(text: 'Glicemia - Gráfico de Linha'),
          legend: Legend(isVisible: true),
          tooltipBehavior: TooltipBehavior(enable: true),
          series: <CartesianSeries>[
            LineSeries<_GlicemiaData, DateTime>(
              dataSource: glucoseData,
              xValueMapper: (_GlicemiaData glicemia, _) => glicemia.time,
              yValueMapper: (_GlicemiaData glicemia, _) =>
                  glicemia.glucoseLevel,
              name: 'Nível de Glicose',
              dataLabelSettings: DataLabelSettings(isVisible: true),
              markerSettings: MarkerSettings(isVisible: true),
            ),
          ],
        );
      case ChartType.bar:
        List<double> averages = [0, 0, 0, 0];
        List<int> counts = [0, 0, 0, 0];

        for (int i = 0; i < 14; i++) {
          DateTime currentDate = DateTime.now().subtract(Duration(days: i));
          List<_GlicemiaData> dataWithinDay = glucoseData
              .where((data) =>
                  data.time.year == currentDate.year &&
                  data.time.month == currentDate.month &&
                  data.time.day == currentDate.day)
              .toList();

          if (dataWithinDay.isNotEmpty) {
            for (int j = 0; j < dataWithinDay.length; j++) {
              double glucoseLevel = dataWithinDay[j].glucoseLevel;
              if (glucoseLevel > 240) {
                averages[0] += glucoseLevel;
                counts[0]++;
              } else if (glucoseLevel >= 181 && glucoseLevel <= 240) {
                averages[1] += glucoseLevel;
                counts[1]++;
              } else if (glucoseLevel >= 70 && glucoseLevel <= 180) {
                averages[2] += glucoseLevel;
                counts[2]++;
              } else {
                averages[3] += glucoseLevel;
                counts[3]++;
              }
            }
          }
        }

        for (int i = 0; i < averages.length; i++) {
          if (counts[i] > 0) {
            averages[i] /= counts[i];
          }
        }

        List<_BarData> barData = [
          _BarData('> 240', averages[0], Colors.orange, counts[0]),
          _BarData('181 - 240', averages[1], Colors.yellow, counts[1]),
          _BarData('70 - 180', averages[2], Colors.green, counts[2]),
          _BarData('< 70', averages[3], Colors.red, counts[3]),
        ];

        return SfCartesianChart(
          key: _chartKey,
          primaryXAxis: CategoryAxis(),
          primaryYAxis: NumericAxis(
            maximum: 350,
            labelFormat: '{value}',
          ),
          title: ChartTitle(text: 'Glicemia - Gráfico de Barra'),
          legend: Legend(isVisible: true),
          tooltipBehavior: TooltipBehavior(enable: true),
          series: <CartesianSeries>[
            BarSeries<_BarData, String>(
              dataSource: barData,
              xValueMapper: (_BarData data, _) => data.range,
              yValueMapper: (_BarData data, _) => data.average,
              name: 'Nível de Glicose',
              dataLabelSettings: DataLabelSettings(isVisible: true),
              pointColorMapper: (_BarData data, _) => data.color,
              dataLabelMapper: (_BarData data, _) =>
                  '${data.average.toStringAsFixed(2)} (${data.count})',
            ),
          ],
        );

      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    String dateRangeText = _selectedChartType == ChartType.line
        ? _formatDate(selectedDate)
        : _calculateDateRangeText(selectedDate);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          padding: EdgeInsets.only(left: 35),
          onPressed: () => context.go('/homePage'),
          color: Color(0xFF4B0D07),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.calendar_today),
            onPressed: () async {
              final DateTime? picked = await showDatePicker(
                context: context,
                initialDate: selectedDate,
                firstDate: DateTime(2015, 8),
                lastDate: DateTime(2101),
              );
              if (picked != null && picked != selectedDate)
                setState(() {
                  selectedDate = picked;
                  _fetchGlucoseData();
                });
            },
          ),
          PopupMenuButton<ChartType>(
            onSelected: (ChartType result) {
              setState(() {
                _selectedChartType = result;
              });
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<ChartType>>[
              const PopupMenuItem<ChartType>(
                value: ChartType.line,
                child: Text('Gráfico de Linha'),
              ),
              const PopupMenuItem<ChartType>(
                value: ChartType.bar,
                child: Text('Gráfico de Barra'),
              ),
            ],
          ),
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () {
              _generateAndShareCSV();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.5,
            child: _buildChart(),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text(
                  dateRangeText,
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 5),
                if (_selectedChartType == ChartType.bar)
                  Text(
                    'Média de 14 dias',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _calculateDateRangeText(DateTime selectedDate) {
    if (selectedDate == null) return '';

    if (_selectedChartType == ChartType.line) {
      return _formatDate(selectedDate);
    } else {
      DateTime endDate = selectedDate;
      DateTime startDate = endDate.subtract(Duration(days: 13));

      return '${_formatDate(startDate)} - ${_formatDate(endDate)}';
    }
  }

  String _formatDate(DateTime date) {
    final daysOfWeek = [
      'Domingo',
      'Segunda-feira',
      'Terça-feira',
      'Quarta-feira',
      'Quinta-feira',
      'Sexta-feira',
      'Sábado'
    ];
    final months = [
      'Janeiro',
      'Fevereiro',
      'Março',
      'Abril',
      'Maio',
      'Junho',
      'Julho',
      'Agosto',
      'Setembro',
      'Outubro',
      'Novembro',
      'Dezembro'
    ];
    return '${daysOfWeek[date.weekday - 1]}, ${date.day} de ${months[date.month - 1]}';
  }

  void _generateAndShareCSV() async {
    try {
      String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);

      List<List<dynamic>> rows = [];

      rows.add(['Relatório Glicêmico - $formattedDate']);
      rows.add([]);
      rows.add(['Nome do Paciente: $fullName']);
      rows.add([]);

      rows.add(['Data', 'Hora', 'Valor Glicemia', 'Comparação com a Meta']);

      for (var data in glucoseData) {
        String comparison = _compareWithTargets(data.glucoseLevel);
        rows.add([
          formattedDate,
          DateFormat('HH:mm').format(data.time),
          data.glucoseLevel,
          comparison
        ]);
      }

      String csv = const ListToCsvConverter().convert(rows);

      final directory = await getApplicationDocumentsDirectory();

      final file = File('${directory.path}/$formattedDate.csv');
      await file.writeAsString(csv);

      await FlutterShare.shareFile(
        title: 'Relatório Glicêmico - $formattedDate',
        text:
            'Relatório CSV dos dados glicêmicos de $fullName em $formattedDate.',
        filePath: file.path,
      );
    } catch (e) {
      print('Erro ao gerar e compartilhar CSV: $e');
    }
  }

  String _compareWithTargets(double glucoseLevel) {
    if (glucoseLevel < 70) {
      return 'Abaixo da meta';
    } else if (glucoseLevel >= 70 && glucoseLevel <= 130) {
      return 'Dentro da meta';
    } else if (glucoseLevel > 130 && glucoseLevel <= 160) {
      return 'Dentro da meta';
    } else if (glucoseLevel > 160 && glucoseLevel <= 180) {
      return 'Dentro da meta';
    } else if (glucoseLevel > 180) {
      return 'Acima da meta';
    } else {
      return '';
    }
  }
}

class _BarData {
  final String range;
  final double average;
  final Color color;
  final int count;

  _BarData(this.range, this.average, this.color, this.count);
}
