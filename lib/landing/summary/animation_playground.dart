/// Flutter code sample for SlideTransition

// The following code implements the [SlideTransition] as seen in the video
// above:

import 'package:flutter/material.dart';

/// This is the stateful widget that the main application instantiates.
class AnimationSlideSample extends StatefulWidget {
  AnimationSlideSample({Key key}) : super(key: key);

  @override
  _AnimationSlideSampleState createState() => _AnimationSlideSampleState();
}

/// This is the private State class that goes with MyStatefulWidget.
class _AnimationSlideSampleState extends State<AnimationSlideSample>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    ); //..repeat(reverse: true);
    _offsetAnimation = Tween<Offset>(
      begin: const Offset(1.5, 1.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    ));
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FlatButton(
          onPressed: () async {
            _controller.reset();
            await _controller.forward().orCancel;
          },
          child: Text(
            "Start Animation",
          ),
        ),
        SlideTransition(
          position: _offsetAnimation,
          child: const Padding(
            padding: EdgeInsets.all(8.0),
            child: FlutterLogo(size: 150.0),
          ),
        )
      ],
    );
  }
}
