import 'package:flutter/material.dart';

/// Expand or collapse the app bar content when swipe down or up.
class SliverAppBarContainer extends StatefulWidget {
  final Widget child;
  final bool shouldStayWhenCollapse;

  const SliverAppBarContainer(
      {Key? key, required this.child, this.shouldStayWhenCollapse = false})
      : super(key: key);

  @override
  _SliverAppBarContainerState createState() {
    return new _SliverAppBarContainerState();
  }
}

class _SliverAppBarContainerState extends State<SliverAppBarContainer> {
  ScrollPosition? _position;
  bool? _visible;

  @override
  void dispose() {
    _removeListener();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _removeListener();
    _addListener();
  }

  void _addListener() {
    _position = Scrollable.of(context).position;
    _position?.addListener(_positionListener);
    _positionListener();
  }

  void _removeListener() {
    _position?.removeListener(_positionListener);
  }

  void _positionListener() {
    final FlexibleSpaceBarSettings? settings =
        context.dependOnInheritedWidgetOfExactType();
    print(settings?.minExtent);
    bool visible = false;
    if (widget.shouldStayWhenCollapse) {
      visible =
          settings == null || settings.currentExtent <= settings.minExtent + 10;
    } else {
      visible =
          settings == null || settings.currentExtent > settings.minExtent + 10;
    }
    if (_visible != visible) {
      setState(() {
        _visible = visible;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: Duration(milliseconds: 300),
      opacity: _visible ?? false ? 1 : 0,
      child: widget.child,
    );
  }
}
