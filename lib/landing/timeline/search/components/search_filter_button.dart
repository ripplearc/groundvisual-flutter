import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

/// [SearchFilterButton] invokes [onTapFilter] upon touch. It superimposes indicator
/// on top of the button if the [filterIndicator] is not null.
class SearchFilterButton extends StatelessWidget {
  const SearchFilterButton({
    Key? key,
    required this.filterIndicator,
    required this.onTapFilter,
  }) : super(key: key);

  final String? filterIndicator;
  final GestureTapCallback? onTapFilter;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 40,
        child: Stack(children: [
          IconButton(
              icon: Icon(Icons.filter_list),
              color: Theme.of(context).colorScheme.onBackground,
              iconSize: 24,
              onPressed: onTapFilter),
          if (filterIndicator != null)
            Positioned.fill(
                top: 4,
                right: 4,
                child: Align(
                    alignment: Alignment.topRight,
                    child: ClipOval(
                        child: Container(
                            height: 16,
                            width: 16,
                            alignment: Alignment.center,
                            color: Theme.of(context).colorScheme.secondary,
                            child: Text(filterIndicator ?? "",
                                textAlign: TextAlign.center,
                                style: Theme.of(context)
                                    .textTheme
                                    .button
                                    ?.apply(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .background)))))),
        ]));
  }
}
