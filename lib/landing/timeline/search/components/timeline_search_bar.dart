import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class TimelineSearchBar extends StatelessWidget {
  final double? width;
  final GestureTapCallback? onTap;
  final String dateString;

  const TimelineSearchBar(
      {Key? key, this.width, this.onTap, required this.dateString})
      : super(key: key);

  @override
  Widget build(BuildContext context) => _buildSearchBar(context);

  Container _buildSearchBar(BuildContext context) => Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      width: width ?? double.infinity,
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 3,
              blurRadius: 3,
              offset: Offset(1, 1), // changes position of shadow
            ),
          ],
          borderRadius: BorderRadius.all(Radius.circular(30))),
      child: IntrinsicHeight(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          IconButton(
              color: Theme.of(context).colorScheme.onBackground,
              icon: Icon(Icons.arrow_back_outlined),
              onPressed: () => Navigator.pop(context)),
          Expanded(
              child: GestureDetector(
            onTap: onTap,
            behavior: HitTestBehavior.translucent,
            child: Row(
              children: [
                Text("Penton Rise Ct.",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.subtitle1),
                Spacer(),
                Text(dateString,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyText2),
                VerticalDivider(
                  thickness: 2,
                ),
                Icon(Icons.filter_list)
              ],
            ),
          ))
        ],
      )));
}
