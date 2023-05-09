import 'package:flutter/material.dart';

/// A transient background from transparent to solid used together
/// with the embedded content.
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
