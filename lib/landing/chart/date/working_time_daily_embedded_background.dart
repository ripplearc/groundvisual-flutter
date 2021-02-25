import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WorkingTimeDailyEmbeddedBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.0, 0.4],
            colors: [
              Colors.transparent,
              Theme.of(context).colorScheme.background
            ],
          ),
        ),
      );
}
