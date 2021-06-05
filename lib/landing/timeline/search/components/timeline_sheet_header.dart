import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:groundvisual_flutter/landing/timeline/search/bloc/timeline_search_bloc.dart';

/// The header section of the timeline search result sheet.
class TimelineSheetHeader extends StatelessWidget {
  final double width;

  const TimelineSheetHeader({Key? key, required this.width})
      : super(key: key);

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<TimelineSearchBloc, TimelineSearchState>(
          builder: (blocContext, state) => Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Divider(
                    thickness: 4,
                    indent: width * 0.43,
                    endIndent: width * 0.43,
                  ),
                  Text(
                    "45 results",
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  Divider(
                    thickness: 1,
                    indent: width * 0.05,
                    endIndent: width * 0.05,
                  )
                ],
              ));
}
