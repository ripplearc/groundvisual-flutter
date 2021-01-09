import 'dart:math';

/// Flutter code sample for SlideTransition

// The following code implements the [SlideTransition] as seen in the video
// above:

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:groundvisual_flutter/extensions/stream_logger.dart';

class StreamAnimationSlide extends StatelessWidget {
  final Random random = Random();

  @override
  Widget build(BuildContext context) => StreamBuilder(
      stream: Stream<String>.periodic(Duration(seconds: 6))
          .scan((accumulated, value, index) => accumulated + 1, 0)
          .take(10)
          .map((index) => 'images/digest/summary_$index.jpg')
          .log('🤘'),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if (snapshot.hasData) {
          final beginPoint = [
            Offset(1.5, 0),
            Offset(-1.5, 0),
            Offset(0, 1.5),
            Offset(0, -1.5)
          ].elementAt(random.nextInt(4));

          print("👀 $beginPoint");
          return StreamAnimationSlideSample(
              key: Key(snapshot.data),
              image: snapshot.data,
              animationTime: 3,
              beginPoint: beginPoint);
        } else {
          return Container();
        }
      });
}

/// This is the stateful widget that the main application instantiates.
class StreamAnimationSlideSample extends StatefulWidget {
  final String image;
  final int animationTime;
  final Offset beginPoint;

  StreamAnimationSlideSample(
      {Key key, this.image, this.animationTime, this.beginPoint})
      : super(key: key);

  @override
  _StreamAnimationSlideSampleState createState() =>
      _StreamAnimationSlideSampleState(image, animationTime, beginPoint);
}

/// This is the private State class that goes with MyStatefulWidget.
class _StreamAnimationSlideSampleState extends State<StreamAnimationSlideSample>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<Offset> _offsetAnimation;
  final String image;
  final int animationTime;
  final Offset beginPoint;

  _StreamAnimationSlideSampleState(
      this.image, this.animationTime, this.beginPoint);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: animationTime),
      vsync: this,
    )..forward(); //..repeat(reverse: true);
    _offsetAnimation = Tween<Offset>(
      begin: beginPoint,
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
        // FlatButton(
        //   onPressed: () async {
        //     _controller.reset();
        //     await _controller.forward().orCancel;
        //   },
        //   child: Text(
        //     "Start Animation",
        //   ),
        // ),
        SlideTransition(
          position: _offsetAnimation,
          child: Image.asset(
            image,
            width: 336,
            height: 190,
            fit: BoxFit.cover,
          ),
        )
      ],
    );
  }
}
