import 'package:flutter/material.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:glycon_app/services/FirebaseFunctions.dart';
import 'package:path_provider/path_provider.dart';
// import 'package:flutter_share/flutter_share.dart';
import 'package:share_plus/share_plus.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:glycon_app/Widgets/NavigationBar.dart' as Navigation;
import 'package:glycon_app/services/getUserName.dart';

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
  final String? newGlucoseValue;
  String? glucoseValue;
  final String? newPillValue;
  String? pillValue;
  final String? newFoodValue;
  String? foodValue;
  final String? newInsulinValue;
  String? insulinValue;

  HomePageChart({
    Key? key,
    this.glucoseValue,
    this.newGlucoseValue,
    this.pillValue,
    this.newPillValue,
    this.foodValue,
    this.newFoodValue,
    this.insulinValue,
    this.newInsulinValue,
  }) : super(key: key);

  @override
  _HomePageChartState createState() => _HomePageChartState();
}

class _HomePageChartState extends State<HomePageChart> {
  List<_GlicemiaData> glucoseDataForLine = [];
  List<_GlicemiaData> glucoseDataForBar = [];
  DateTime selectedDate = DateTime.now();
  DateTime selectedStartDate = DateTime.now();
  DateTime selectedEndDate = DateTime.now();
  ChartType _selectedChartType = ChartType.line;
  final GlobalKey _chartKey = GlobalKey();
  String userId = '';
  String fullName = '';
  int _selectedIndex = 2;

  @override
  void initState() {
    super.initState();
    _fetchUserInfo();
    _fetchGlucoseData(selectedDate);
    _fetchGlucoseDataWithRange();
  }

  Future<void> _fetchUserInfo() async {
    print('Fetching user info...');
    fullName = await GetUserName.getFullNameFromFirestore();
    userId = await FirebaseFunctions.getUserIdFromFirestore();
  }

  Future<void> _fetchGlucoseData(DateTime selectedDate) async {
    await _fetchUserInfo();

    List<Map<String, dynamic>> glucoseDataList =
        await FirebaseFunctions.getGlucoseDataFromFirestore(
            userId, selectedDate);

    setState(() {
      glucoseDataForLine.clear();
      for (Map<String, dynamic> data in glucoseDataList) {
        DateTime myDateTime = DateTime.fromMillisecondsSinceEpoch(
            data['selectedDate'].seconds * 1000);
        glucoseDataForLine.add(_GlicemiaData(
            myDateTime,
            double.parse(data['glucoseLevel']),
            _getBarColor(
                double.parse(data['glucoseLevel']), glucoseDataForLine)));
      }
      glucoseDataForLine.sort((a, b) => a.time.compareTo(b.time));
    });
  }

  Future<void> _fetchGlucoseDataWithRange() async {
    if (_selectedChartType == ChartType.line) {
      List<Map<String, dynamic>> glucoseDataList =
          await FirebaseFunctions.getGlucoseDataFromFirestore(
              userId, selectedStartDate);

      setState(() {
        glucoseDataForBar.clear();
        for (Map<String, dynamic> data in glucoseDataList) {
          DateTime myDateTime = DateTime.fromMillisecondsSinceEpoch(
              data['selectedDate'].seconds * 1000);

          glucoseDataForBar.add(_GlicemiaData(
              myDateTime,
              double.parse(data['glucoseLevel']),
              _getBarColor(
                  double.parse(data['glucoseLevel']), glucoseDataForBar)));
        }
      });
    } else if (_selectedChartType == ChartType.bar) {
      List<Map<String, dynamic>> glucoseDataList =
          await FirebaseFunctions.getGlucoseDataWithinRange(
              userId, selectedStartDate, selectedEndDate);

      setState(() {
        glucoseDataForBar.clear();
        for (Map<String, dynamic> data in glucoseDataList) {
          DateTime myDateTime = DateTime.fromMillisecondsSinceEpoch(
              data['selectedDate'].seconds * 1000);

          glucoseDataForBar.add(_GlicemiaData(
              myDateTime,
              double.parse(data['glucoseLevel']),
              _getBarColor(
                  double.parse(data['glucoseLevel']), glucoseDataForBar)));
        }
      });
    }
  }

  double _countGlucoseInRange(
      List<_GlicemiaData> dataWithinRange, double lowerBound,
      [double upperBound = double.infinity]) {
    List<_GlicemiaData> filteredData = dataWithinRange
        .where((data) =>
            data.glucoseLevel >= lowerBound && data.glucoseLevel <= upperBound)
        .toList();

    return filteredData.length.toDouble();
  }

  Color _getBarColor(double glucoseLevel, List<_GlicemiaData> dataWithinRange) {
    final averageGlucose = dataWithinRange.isEmpty
        ? 0
        : dataWithinRange
                .map((data) => data.glucoseLevel)
                .reduce((a, b) => a + b) /
            dataWithinRange.length;

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
              dataSource: glucoseDataForLine,
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
        List<_GlicemiaData> dataWithinRange = glucoseDataForBar.where((data) {
          return data.time.isAfter(selectedStartDate) &&
              data.time.isBefore(selectedEndDate.add(Duration(days: 1)));
        }).toList();

        List<_BarData> barData = [
          _BarData('> 240', _countGlucoseInRange(dataWithinRange, 240),
              Colors.orange),
          _BarData('181 - 240', _countGlucoseInRange(dataWithinRange, 181, 240),
              Colors.yellow),
          _BarData('70 - 180', _countGlucoseInRange(dataWithinRange, 70, 180),
              Colors.green),
          _BarData(
              '< 70', _countGlucoseInRange(dataWithinRange, 0, 69), Colors.red),
        ];

        barData = barData.reversed.toList();

        return SfCartesianChart(
          key: _chartKey,
          primaryXAxis: CategoryAxis(),
          primaryYAxis: NumericAxis(
            maximum: 120,
            labelFormat: '{value}',
          ),
          title: ChartTitle(text: 'Glicemia - Gráfico de Barra'),
          legend: Legend(isVisible: true),
          tooltipBehavior: TooltipBehavior(enable: true),
          series: <CartesianSeries>[
            BarSeries<_BarData, String>(
              dataSource: barData,
              xValueMapper: (_BarData data, _) => data.range,
              yValueMapper: (_BarData data, _) => data.count,
              name: 'Quantidade de Registros',
              dataLabelSettings: DataLabelSettings(isVisible: true),
              pointColorMapper: (_BarData data, _) => data.color,
              dataLabelMapper: (_BarData data, _) => '${data.count}',
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
        ? _calculateDateRangeText(selectedDate, selectedDate)
        : _calculateDateRangeText(selectedStartDate, selectedEndDate);

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          // leading: IconButton(
          //   icon: Icon(Icons.arrow_back),
          //   padding: EdgeInsets.only(left: 35),
          //   onPressed: () => context.go('/homePage'),
          //   color: Color(0xFF4B0D07),
          // ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.calendar_today),
              onPressed: _selectedChartType == ChartType.line
                  ? () async {
                      final DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: selectedDate,
                          firstDate: DateTime(2015, 8),
                          lastDate: DateTime(2101),
                          builder: (BuildContext context, Widget? child) {
                            return Theme(
                              data: ThemeData.light().copyWith(
                                colorScheme: ColorScheme.light().copyWith(
                                  background:
                                      const Color.fromARGB(255, 243, 33, 173),
                                ),
                              ),
                              child: child!,
                            );
                          });

                      if (picked != null && picked != selectedDate)
                        setState(() {
                          selectedDate = picked;
                          _fetchGlucoseData(selectedDate);
                        });
                    }
                  : _selectedChartType == ChartType.bar
                      ? () async {
                          final DateTimeRange? picked =
                              await showDateRangePicker(
                                  context: context,
                                  firstDate: DateTime(2015),
                                  lastDate: DateTime(2101),
                                  initialDateRange: DateTimeRange(
                                      start: selectedStartDate,
                                      end: selectedEndDate),
                                  builder:
                                      (BuildContext context, Widget? child) {
                                    return Theme(
                                      data: ThemeData.light().copyWith(
                                        colorScheme:
                                            ColorScheme.light().copyWith(
                                          background: const Color.fromARGB(
                                              255, 243, 33, 173),
                                        ),
                                      ),
                                      child: child!,
                                    );
                                  });

                          if (picked != null) {
                            setState(() {
                              selectedStartDate = picked.start;
                              selectedEndDate = picked.end;
                              _fetchGlucoseDataWithRange();
                            });
                          }
                        }
                      : null,
            ),
            PopupMenuButton<ChartType>(
              onSelected: (ChartType result) {
                setState(() {
                  _selectedChartType = result;
                });
              },
              itemBuilder: (BuildContext context) =>
                  <PopupMenuEntry<ChartType>>[
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
              icon: Icon(Icons.download_rounded),
              onPressed: () {
                generateAndSharePDF(userId, fullName, selectedStartDate,
                    selectedEndDate.add(Duration(days: 30)));
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
                      'Tempo dentro do intervalo selecionado',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: Navigation.NavigationBar(
          currentIndex: 2,
        ));
  }

  String _calculateDateRangeText(
      DateTime selectedStartDate, DateTime selectedEndDate) {
    if (_selectedChartType == ChartType.line) {
      return _formatDate(selectedStartDate);
    }

    return '${_formatDate(selectedStartDate)} - ${_formatDate(selectedEndDate)}';
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

  Future<void> generateAndSharePDF(String userId, String fullName,
      DateTime selectedStartDate, DateTime selectedEndDate) async {
    try {
      String formattedStartDate =
          DateFormat('dd-MM-yyyy').format(selectedStartDate);
      String formattedEndDate =
          DateFormat('dd-MM-yyyy').format(selectedEndDate);

      List<Map<String, dynamic>> glucoseDataList =
          await FirebaseFunctions.getGlucoseDataForLast30Days(userId);

      final pdf = pw.Document();

      pdf.addPage(pw.MultiPage(
        build: (context) => [
          pw.Text(
            'Relatório Glicêmico',
            style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
          ),
          pw.Text(
            '$formattedStartDate a $formattedEndDate',
            style: pw.TextStyle(fontSize: 18),
          ),
          pw.Text('\n'),
          pw.Paragraph(
              text: 'Nome do paciente: $fullName',
              style:
                  pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 20),
          pw.TableHelper.fromTextArray(
            context: context,
            data: _generateTableData(glucoseDataList),
            headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            cellStyle: pw.TextStyle(fontSize: 10),
            border: pw.TableBorder.all(),
            cellAlignment: pw.Alignment.center,
            columnWidths: {
              0: pw.FixedColumnWidth(105),
              1: pw.FixedColumnWidth(75),
              2: pw.FixedColumnWidth(110),
              3: pw.FixedColumnWidth(110),
              4: pw.FixedColumnWidth(110),
              5: pw.FixedColumnWidth(110),
              6: pw.FixedColumnWidth(110),
              7: pw.FixedColumnWidth(110),
              8: pw.FixedColumnWidth(110),
            },
          ),
        ],
      ));

      final directory = await getApplicationDocumentsDirectory();
      final filePath =
          '${directory.path}/Relatorio_Glicemico_$formattedStartDate-$formattedEndDate.pdf';

      final file = File(filePath);
      await file.writeAsBytes(await pdf.save());

      // await FlutterShare.shareFile(
      //   title: 'Relatório Glicêmico - $formattedStartDate a $formattedEndDate',
      //   text:
      //       'Relatório PDF dos dados glicêmicos de $fullName de $formattedStartDate a $formattedEndDate.',
      //   filePath: file.path,
      // );

      await Share.shareXFiles(
        [XFile('${file.path}')],
        subject:
            'Relatório Glicêmico de $fullName de $formattedStartDate a $formattedEndDate.',
      );
    } catch (e) {
      print('Erro ao gerar e compartilhar PDF: $e');
    }
  }

  List<List<dynamic>> _generateTableData(
      List<Map<String, dynamic>> glucoseDataList) {
    List<List<dynamic>> tableData = [
      [
        'Data',
        'Antes do café',
        '2h após o café',
        'Antes do almoço',
        '2h após o almoço',
        'Antes do jantar',
        '2h após o jantar',
      ].map((str) => str).toList()
    ];

    for (Map<String, dynamic> data in glucoseDataList) {
      DateTime myDateTime = DateTime.fromMillisecondsSinceEpoch(
          data['selectedDate'].seconds * 1000);
      String formattedDate = DateFormat('dd/MM/yyyy').format(myDateTime);
      String formattedTime = DateFormat('HH:mm').format(myDateTime);

      // Inicializar as colunas de refeição com um valor padrão vazio
      List<String> mealColumns = List.filled(6, '');

      // Mapear os valores de refeição para as colunas correspondentes
      switch (data['mealTime']) {
        case 'Antes do café da manhã':
          mealColumns[0] = data['glucoseLevel'].toString();
          break;
        case '2 horas após o café da manhã':
          mealColumns[1] = data['glucoseLevel'].toString();
          break;
        case 'Antes do almoço':
          mealColumns[2] = data['glucoseLevel'].toString();
          break;
        case '2 horas após o almoço':
          mealColumns[3] = data['glucoseLevel'].toString();
          break;
        case 'Antes do jantar':
          mealColumns[4] = data['glucoseLevel'].toString();
          break;
        case '2 horas após o jantar':
          mealColumns[5] = data['glucoseLevel'].toString();
          break;
        default:
          break;
      }

      tableData.add([
        formattedDate,
        ...mealColumns,
      ]);
    }

    return tableData;
  }
}

class _BarData {
  final String range;
  final double count;
  final Color color;

  _BarData(this.range, this.count, this.color);
}
