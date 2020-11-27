import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class BarChartSample4 extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => BarChartSample4State();
}

class BarChartSample4State extends State<BarChartSample4> {

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.8,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        color: Theme.of(context).colorScheme.background,
        child: Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.center,
              barTouchData: BarTouchData(
                enabled: false,
              ),
              titlesData: FlTitlesData(
                show: true,
                bottomTitles: SideTitles(
                  showTitles: true,
                  getTextStyles: (value) => Theme.of(context).textTheme.bodyText2,
                  margin: 10,
                  getTitles: (double value) {
                    switch (value.toInt()) {
                      case 0:
                        return 'Apr';
                      case 1:
                        return 'May';
                      case 2:
                        return 'Jun';
                      case 3:
                        return 'Jul';
                      case 4:
                        return 'Aug';
                      default:
                        return '';
                    }
                  },
                ),
                leftTitles: SideTitles(
                  showTitles: true,
                  interval: 4,
                  getTextStyles: (value) => Theme.of(context).textTheme.caption,
                  margin: 2,
                ),
              ),
              borderData: FlBorderData(
                show: false,
              ),
              groupsSpace: 4,
              barGroups: getData(context),
            ),
          ),
        ),
      ),
    );
  }

  List<BarChartGroupData> getData(BuildContext context) {

    final Color dark = Theme.of(context).colorScheme.primary;
    final Color light = Theme.of(context).colorScheme.secondary;
    return [
      BarChartGroupData(
        x: 0,
        barsSpace: 4,
        barRods: [
          BarChartRodData(
              y: 15,
              rodStackItems: [
                BarChartRodStackItem(0, 12, dark),
                BarChartRodStackItem(12, 15, light),
              ],
              borderRadius: const BorderRadius.all(Radius.zero)),
          BarChartRodData(
              y: 16,
              rodStackItems: [
                BarChartRodStackItem(0, 14, dark),
                BarChartRodStackItem(14, 16, light),
              ],
              borderRadius: const BorderRadius.all(Radius.zero)),
          BarChartRodData(
              y: 13.5,
              rodStackItems: [
                BarChartRodStackItem(0, 8, dark),
                BarChartRodStackItem(8, 13.5, light),
              ],
              borderRadius: const BorderRadius.all(Radius.zero)),
          BarChartRodData(
              y: 19,
              rodStackItems: [
                BarChartRodStackItem(0, 15, dark),
                BarChartRodStackItem(15, 19, light),
              ],
              borderRadius: const BorderRadius.all(Radius.zero)),
          BarChartRodData(
              y: 12,
              rodStackItems: [
                BarChartRodStackItem(0, 7.5, dark),
                BarChartRodStackItem(7.5, 12, light),
              ],
              borderRadius: const BorderRadius.all(Radius.zero)),
        ],
      ),
      BarChartGroupData(
        x: 1,
        barsSpace: 4,
        barRods: [
          BarChartRodData(
              y: 12.3,
              rodStackItems: [
                BarChartRodStackItem(0, 8, dark),
                BarChartRodStackItem(8, 12.3, light),
              ],
              borderRadius: const BorderRadius.all(Radius.zero)),
          BarChartRodData(
              y: 10.5,
              rodStackItems: [
                BarChartRodStackItem(0, 7, dark),
                BarChartRodStackItem(7, 10.5, light),
              ],
              borderRadius: const BorderRadius.all(Radius.zero)),
          BarChartRodData(
              y: 7,
              rodStackItems: [
                BarChartRodStackItem(0, 4, dark),
                BarChartRodStackItem(4, 7, light),
              ],
              borderRadius: const BorderRadius.all(Radius.zero)),
          BarChartRodData(
              y: 15,
              rodStackItems: [
                BarChartRodStackItem(0, 12, dark),
                BarChartRodStackItem(12, 15, light),
              ],
              borderRadius: const BorderRadius.all(Radius.zero)),
          BarChartRodData(
              y: 7,
              rodStackItems: [
                BarChartRodStackItem(0, 5, dark),
                BarChartRodStackItem(5, 7, light),
              ],
              borderRadius: const BorderRadius.all(Radius.zero)),
        ],
      ),
      BarChartGroupData(
        x: 2,
        barsSpace: 4,
        barRods: [
          BarChartRodData(
              y: 4,
              rodStackItems: [
                BarChartRodStackItem(0, 3, dark),
                BarChartRodStackItem(3, 4, light),
              ],
              borderRadius: const BorderRadius.all(Radius.zero)),
          BarChartRodData(
              y: 9,
              rodStackItems: [
                BarChartRodStackItem(0, 7, dark),
                BarChartRodStackItem(7, 9, light),
              ],
              borderRadius: const BorderRadius.all(Radius.zero)),
          BarChartRodData(
              y: 4.5,
              rodStackItems: [
                BarChartRodStackItem(0, 2, dark),
                BarChartRodStackItem(2, 4.5, light),
              ],
              borderRadius: const BorderRadius.all(Radius.zero)),
          BarChartRodData(
              y: 11,
              rodStackItems: [
                BarChartRodStackItem(0, 9, dark),
                BarChartRodStackItem(9, 11, light),
              ],
              borderRadius: const BorderRadius.all(Radius.zero)),
          BarChartRodData(
              y: 12,
              rodStackItems: [
                BarChartRodStackItem(0, 5, dark),
                BarChartRodStackItem(5, 12, light),
              ],
              borderRadius: const BorderRadius.all(Radius.zero)),
        ],
      ),
      BarChartGroupData(
        x: 3,
        barsSpace: 4,
        barRods: [
          BarChartRodData(
              y: 10,
              rodStackItems: [
                BarChartRodStackItem(0, 7, dark),
                BarChartRodStackItem(7, 10, light),
              ],
              borderRadius: const BorderRadius.all(Radius.zero)),
          BarChartRodData(
              y: 7,
              rodStackItems: [
                BarChartRodStackItem(0, 5, dark),
                BarChartRodStackItem(5, 7, light),
              ],
              borderRadius: const BorderRadius.all(Radius.zero)),
          BarChartRodData(
              y: 9,
              rodStackItems: [
                BarChartRodStackItem(0, 8, dark),
                BarChartRodStackItem(8, 9, light),
              ],
              borderRadius: const BorderRadius.all(Radius.zero)),
          BarChartRodData(
              y: 7.5,
              rodStackItems: [
                BarChartRodStackItem(0, 5, dark),
                BarChartRodStackItem(5, 7.5, light),
              ],
              borderRadius: const BorderRadius.all(Radius.zero)),
          BarChartRodData(
              y: 6,
              rodStackItems: [
                BarChartRodStackItem(0, 5, dark),
                BarChartRodStackItem(5, 6, light),
              ],
              borderRadius: const BorderRadius.all(Radius.zero)),
        ],
      ),
    ];
  }
}
