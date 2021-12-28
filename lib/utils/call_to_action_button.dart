import 'package:flutter/material.dart';

import 'constants.dart';

class CallToActionButton extends StatelessWidget {
  final bool disabled;
  final String heroTag;
  final bool extended;
  final String label;
  final Icon icon;
  final void Function() onPressed;
  const CallToActionButton({
    Key? key,
    required this.disabled,
    required this.heroTag,
    required this.extended,
    required this.label,
    required this.icon,
    required this.onPressed
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var foregroundColor;
    var backgroundColor;
    var splashColor;
    double elevation;

    if (disabled) {
      foregroundColor = COLOR_BLACK;
      backgroundColor = COLOR_GRAY;
      splashColor = COLOR_GRAY_SPLASH;
      elevation = 0;
    } else {
      elevation = 5;
      if (heroTag == 'delete') {
        foregroundColor = Colors.white;
        backgroundColor = COLOR_RED;
        splashColor = COLOR_RED_SPLASH;
      } else {
        foregroundColor = COLOR_BLACK;
        backgroundColor = COLOR_YELLOW;
        splashColor = COLOR_YELLOW_SPLASH;
      }
    }

    if (extended) {
      return FloatingActionButton.extended(
        onPressed: onPressed,
        heroTag: heroTag,
        label: Text(
          label,
          style: TextStyle(fontSize: 16),
        ),
        icon: icon,
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
        splashColor: splashColor,
        elevation: elevation,
        highlightElevation: 0,
      );
    } else {
      return FloatingActionButton(
        onPressed: onPressed,
        heroTag: heroTag,
        child: icon,
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
        splashColor: splashColor,
        elevation: elevation,
        highlightElevation: 0,
      );
    }
  }
}
