import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TimelineSearchBar extends StatelessWidget {

  final double? width;

  const TimelineSearchBar({Key? key, this.width}) : super(key: key);

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
            children: [
              IconButton(
                  color: Theme.of(context).colorScheme.onBackground,
                  icon: Icon(Icons.arrow_back_outlined),
                  onPressed: () => Navigator.pop(context)),
              Text("Penton Rise Ct.", style: Theme.of(context).textTheme.subtitle1),
              Spacer(),
              Text("Aug 1 - 2", style: Theme.of(context).textTheme.bodyText2),
              VerticalDivider(
                thickness: 2,
              ),
              Icon(Icons.filter_list)
            ],
          )));

}
