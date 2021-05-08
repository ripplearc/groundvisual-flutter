/// Id and attributes of the highlighted bar.
class HighlightedBar {
  final int groupId;
  final int rodId;
  final String siteName;
  final DateTime time;

  HighlightedBar(
      {required this.groupId,
      required this.rodId,
      required this.siteName,
      required this.time});
}
