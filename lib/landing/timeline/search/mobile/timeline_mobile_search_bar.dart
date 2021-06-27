import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:groundvisual_flutter/extensions/scoped.dart';
import 'package:groundvisual_flutter/landing/timeline/search/bloc/query/timeline_search_query_bloc.dart';
import 'package:groundvisual_flutter/landing/timeline/search/components/timeline_edit_search_bar.dart';
import 'package:groundvisual_flutter/landing/timeline/search/components/timeline_search_filter.dart';
import 'package:groundvisual_flutter/landing/timeline/search/components/timeline_visual_search_bar.dart';
import 'package:groundvisual_flutter/models/machine_detail.dart';

/// [TimelineMobileSearchBar] specifies the date, time range of the
/// search query. It transitions between visual and search edit mode.
/// The visual mode display the current search query while the search
/// edit mode allows edit of the query.
class TimelineMobileSearchBar extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => TimelineMobileSearchBarState();
}

class TimelineMobileSearchBarState extends State<TimelineMobileSearchBar> {
  Widget? _animatedAppBar;

  @override
  Widget build(BuildContext context) => AnimatedSwitcher(
        duration: Duration(milliseconds: 500),
        transitionBuilder: (Widget child, Animation<double> animation) {
          final offsetAnimation =
              Tween<Offset>(begin: Offset(0.0, -1.0), end: Offset(0.0, -0.0))
                  .animate(animation);
          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        },
        child: _animatedAppBar ?? _buildAppBarInVisualMode(),
      );

  AppBar _buildAppBarInVisualMode() => AppBar(
        key: ValueKey(1),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: BlocBuilder<TimelineSearchQueryBloc, TimelineSearchQueryState>(
            builder: (blocContext, state) => TimelineVisualSearchBar(
                dateTimeString: state.dateTimeString,
                siteName: state.siteName,
                onTapFilter: () async {
                  await _updateFilteredResults(state);
                },
                onTapSearchBar: () => setState(() {
                      _animatedAppBar = _buildAppBarInSearchMode();
                    }),
              filterIndicator: state.filterIndicator,
            )),
      );

  AppBar _buildAppBarInSearchMode() => AppBar(
      key: ValueKey(2),
      backgroundColor: Theme.of(context).colorScheme.background,
      automaticallyImplyLeading: false,
      flexibleSpace: Padding(
          padding: EdgeInsets.only(top: 30),
          child: BlocBuilder<TimelineSearchQueryBloc, TimelineSearchQueryState>(
              builder: (blocContext, state) => TimelineEditSearchBar(
                    onExitEditMode: () => setState(() {
                      _animatedAppBar = _buildAppBarInVisualMode();
                    }),
                    onTapFilter: () async {
                      await _updateFilteredResults(state);
                    },
                    filterIndicator: state.filterIndicator,
                  ))));

  Future<void> _updateFilteredResults(TimelineSearchQueryState state) async {
    final filteredMachines =
        await showModalBottomSheet<Map<MachineDetail, bool>>(
            context: context,
            isScrollControlled: true,
            backgroundColor: Theme.of(context).cardTheme.color,
            builder: (_) => TimelineSearchFilter(
                  title: state.siteName,
                  subtitle: state.dateTimeString,
                  filteredMachines: Map.from(state.filteredMachines),
                ));
    filteredMachines?.let((machines) =>
        BlocProvider.of<TimelineSearchQueryBloc>(context)
            .add(UpdateTimelineSearchQueryOfSelectedMachines(machines)));
  }
}
