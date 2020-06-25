/// Line chart example
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:urawai_pos/core/Models/transaction.dart';

class SalesChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  SalesChart(this.seriesList, {this.animate});

  factory SalesChart.lineChartSales(
      List<TransactionOrder> transactions, List<DateTime> selectedDate) {
    return new SalesChart(
      _createData(transactions, selectedDate),

      // Disable animations for image tests.
      animate: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new charts.TimeSeriesChart(seriesList,
        animate: animate,
        defaultRenderer: new charts.LineRendererConfig(includePoints: true));
  }

  static List<charts.Series<LinearSales, DateTime>> _createData(
      List<TransactionOrder> transactions, List<DateTime> selectedDate) {
    double currentMonthTransaction = 0;
    double prevMonthTransaction = 0;
    double twoMonthAgoTransaction = 0;
    List<LinearSales> linearSales = [];

    for (var transaction in transactions) {
      if (transaction.date.month == DateTime.now().month) {
        currentMonthTransaction =
            currentMonthTransaction + transaction.grandTotal;
      } else if (transaction.date.month == DateTime.now().month - 1) {
        prevMonthTransaction = prevMonthTransaction + transaction.grandTotal;
      } else if (transaction.date.month == DateTime.now().month - 2) {
        twoMonthAgoTransaction =
            twoMonthAgoTransaction + transaction.grandTotal;
      }
    }

    //* Should be load Data from early month to newest
    linearSales.add(LinearSales(DateTime.now().subtract(Duration(days: 62)),
        twoMonthAgoTransaction.toInt()));
    linearSales.add(LinearSales(DateTime.now().subtract(Duration(days: 31)),
        prevMonthTransaction.toInt()));
    linearSales
        .add(LinearSales(DateTime.now(), currentMonthTransaction.toInt()));

    final data = linearSales;

    return [
      new charts.Series<LinearSales, DateTime>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (LinearSales sales, _) => sales.year,
        measureFn: (LinearSales sales, _) => sales.sales,
        data: data,
        displayName: 'Trend Penjualan',
      )
    ];
  }
}

class LinearSales {
  final DateTime year;
  final int sales;

  LinearSales(this.year, this.sales);
}
