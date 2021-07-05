import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:groundvisual_flutter/landing/timeline/search/components/search_filter_button.dart';

/// [TimelineVisualSearchBar] displays the current search query of [siteName] and [dateTimeString].
/// It transitions to the edit mode after tapping [onTapSearchBar], or transitions
/// to the filter mode after tapping [onTapFilter].
/// See also [TimelineEditSearchBar].
class TimelineVisualSearchBar extends StatelessWidget {
  final double? width;
  final GestureTapCallback? onTapSearchBar;
  final GestureTapCallback? onTapFilter;
  final String dateTimeString;
  final String siteName;
  final String? filterIndicator;

  const TimelineVisualSearchBar(
      {Key? key,
      this.width,
      this.onTapSearchBar,
      this.onTapFilter,
      required this.dateTimeString,
      required this.siteName,
      this.filterIndicator})
      : super(key: key);

  @override
  Widget build(BuildContext context) => _buildSearchBar(context);

  Container _buildSearchBar(BuildContext context) => Container(
      padding: EdgeInsets.only(left: 20.0, right: 10),
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
            onTap: onTapSearchBar,
            behavior: HitTestBehavior.translucent,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                    flex: 6,
                    child: Text(siteName,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.subtitle1)),
                Flexible(
                    flex: 6,
                    child: Padding(
                        padding: EdgeInsets.only(right: 5),
                        child: Text(dateTimeString,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodyText2))),
              ],
            ),
          )),
          Row(
            children: [
              VerticalDivider(thickness: 2),
              SearchFilterButton(
                  filterIndicator: filterIndicator, onTapFilter: onTapFilter)
            ],
          )
        ],
      )));
}
