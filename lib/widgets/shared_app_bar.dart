import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

import '../utils/constants.dart';

class SharedAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool animationCompleted;
  final VoidCallback onAnimationFinished;
  final List<Widget>? actions;

  const SharedAppBar({
    super.key,
    required this.animationCompleted,
    required this.onAnimationFinished,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.brown[50],
      title: animationCompleted
          ? Text(
              Constants.appName,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.normal,
                color: Colors.brown[700],
              ),
            )
          : AnimatedTextKit(
              animatedTexts: [
                TyperAnimatedText(
                  Constants.appName,
                  textStyle: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.normal,
                    color: Colors.brown[700],
                  ),
                ),
              ],
              isRepeatingAnimation: false,
              onFinished: onAnimationFinished,
            ),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
