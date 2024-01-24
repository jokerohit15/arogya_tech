import 'dart:async';

import 'package:arogya_tech/utils/constants/colors_value.dart';
import 'package:flutter/material.dart';

class AnimatedToolTip extends StatefulWidget {
  const AnimatedToolTip({super.key, required this.text, required this.icon});
final String text;
final IconData icon;
  @override
  State<AnimatedToolTip> createState() => _AnimatedToolTipState();
}

class _AnimatedToolTipState extends State<AnimatedToolTip> {
  bool isTooltipVisible = false;

  @override
  void initState() {
    super.initState();
    // Show the tooltip-like message after a delay
    Timer(const Duration(seconds: 2), () {
      setState(() {
        isTooltipVisible = true;
      });
      // Hide the tooltip-like message after 5 seconds
      Timer(const Duration(seconds: 5), () {
        setState(() {
          isTooltipVisible = false;
        });
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: isTooltipVisible ? 1.0 : 0.0, // Control opacity
      duration: const Duration(seconds: 1), // Duration of fading animation
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 5),
        decoration: BoxDecoration(
          color: ColorsValue.secondaryColor,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2), // Shadow color
              spreadRadius: 1, // Spread radius
              blurRadius: 2, // Blur radius
              offset: const Offset(0, 2), // Offset in the x, y direction
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(widget.text,
              style: const TextStyle(
                color: ColorsValue.whiteColor,
                fontSize: 9.0,
              ),
            ),
            Icon(widget.icon),
          ],
        ),
      ),
    );
  }
}
