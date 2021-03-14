import 'package:fl_chart/fl_chart.dart';

typedef BarChartRodData BarRodTransform(BarChartRodData data);
typedef BarChartGroupData BarGroupTransform(BarChartGroupData data);

/// Extension of List<BarChartGroupData> to iterate through group and rod, and
/// then apply the transformation to each or selected rod.
extension Transformer on List<BarChartGroupData> {
  List<BarChartGroupData> mapBarGroup(BarGroupTransform transform) =>
      asMap().entries.map((entry) => transform(entry.value)).toList();

  List<BarChartGroupData> mapBarRod(BarRodTransform transform) =>
      asMap().entries.map((entry) {
        BarChartGroupData groupData = entry.value;
        return groupData.copyWith(
            barRods: _transformBarRod(groupData, transform));
      }).toList();

  List<BarChartGroupData> mapSelectedBarRod(
          int groupId, int rodId, BarRodTransform transform) =>
      asMap().entries.map((entry) {
        if (entry.key == groupId) {
          BarChartGroupData groupData = entry.value;
          return groupData.copyWith(
              barRods: _transformSelectedBarRod(groupData, rodId, transform));
        } else {
          return entry.value;
        }
      }).toList();

  List<BarChartRodData> _transformBarRod(
          BarChartGroupData groupData, BarRodTransform transform) =>
      groupData.barRods
          .asMap()
          .entries
          .map((entry) => transform(entry.value))
          .toList();

  List<BarChartRodData> _transformSelectedBarRod(
          BarChartGroupData groupData, int rodId, BarRodTransform transform) =>
      groupData.barRods.asMap().entries.map((entry) {
        if (entry.key == rodId) {
          return transform(entry.value);
        } else {
          return entry.value;
        }
      }).toList();
}
