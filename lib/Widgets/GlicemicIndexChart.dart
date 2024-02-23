import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class GlicemicIndexChart extends StatelessWidget {
  final List<GlicemicIndexData> data;

  GlicemicIndexChart({required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gráfico de Índice Glicêmico'),
      ),
      body: Center(
        child: Container(
          height: 300,
          child: SfCartesianChart(
            primaryXAxis: CategoryAxis(),
            series: <CartesianSeries>[
              LineSeries<GlicemicIndexData, String>(
                dataSource: data,
                xValueMapper: (GlicemicIndexData index, _) => index.food,
                yValueMapper: (GlicemicIndexData index, _) => index.index,
                dataLabelSettings: DataLabelSettings(isVisible: true),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GlicemicIndexData {
  final String food;
  final double index;

  GlicemicIndexData({required this.food, required this.index});
}

void main() {
  runApp(MaterialApp(
    home: GlicemicIndexChart(
      data: <GlicemicIndexData>[
        GlicemicIndexData(food: 'Maçã', index: 40),
        GlicemicIndexData(food: 'Banana', index: 60),
        GlicemicIndexData(food: 'Pão Branco', index: 70),
        GlicemicIndexData(food: 'Batata Cozida', index: 85),
        GlicemicIndexData(food: 'Arroz Integral', index: 50),
      ],
    ),
  ));
}
