import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

class PointsLineChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  PointsLineChart(this.seriesList, {this.animate});

  @override
  Widget build(BuildContext context) {
    return new charts.LineChart(seriesList,
        animate: animate,
        behaviors: [new charts.ChartTitle('Student Count',
              behaviorPosition: charts.BehaviorPosition.bottom,
              titleStyleSpec: charts.TextStyleSpec(fontSize: 11),
              titleOutsideJustification:
              charts.OutsideJustification.middleDrawArea),
              new charts.ChartTitle('Days',
              behaviorPosition: charts.BehaviorPosition.start,
              titleStyleSpec: charts.TextStyleSpec(fontSize: 11),
              titleOutsideJustification:
              charts.OutsideJustification.middleDrawArea),],
        defaultRenderer: new charts.LineRendererConfig(includePoints: true));
  }

  /// Create one series with sample hard coded data.
  
}