import 'package:flutter/material.dart';
import 'package:pie_chart_sz/ValueSettings.dart';
import 'package:pie_chart_sz/pie_chart_sz.dart';

class TodayChartWidget extends StatelessWidget {
  const TodayChartWidget({super.key});

  @override
  Widget build(BuildContext context) {
    List<Color>? colors = [
      Colors.purple,
      Colors.blue,
      Colors.orange,
      Colors.red,
      Colors.teal,
    ];

    List<double>? values = [50, 20, 20, 5, 5];
    return PieChartSz(
      colors: colors,
      values: values,
      gapSize: 0.2,
      centerText: "center text",
      centerTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
      valueSettings: Valuesettings(
        showValues: false,
        ValueTextStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }
}
