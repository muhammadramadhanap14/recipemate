import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/routes/custom_transition.dart';


CustomTransition liquidGlassTransition() {
  return _LiquidGlassPageTransition();
}

class _LiquidGlassPageTransition extends CustomTransition {
  @override
  Widget buildTransition(
      BuildContext context,
      Curve? curve,
      Alignment? alignment,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child,
      ) {
    final curved = CurvedAnimation(
      parent: animation,
      curve: curve ?? Curves.easeOutCubic,
    );

    return FadeTransition(
      opacity: curved,
      child: ScaleTransition(
        scale: Tween<double>(begin: 0.96, end: 1.0).animate(curved),
        child: child,
      ),
    );
  }
}