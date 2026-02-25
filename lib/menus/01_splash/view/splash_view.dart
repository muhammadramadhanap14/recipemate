import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:recipemate/utils/color_var.dart';

import '../../../utils/recipemate_app_util.dart';
import '../../../utils/view_utils/recipemate_circle_painter.dart';
import '../view_model/splash_view_model.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView>
    with TickerProviderStateMixin {

  late SplashViewModel viewModel;
  late AnimationController rotationController;
  late AnimationController iconController;
  late AnimationController textController;
  late Animation<double> iconFade;
  late Animation<Offset> iconSlide;
  late Animation<double> textFade;
  late Animation<Offset> textSlide;

  @override
  void initState() {
    super.initState();

    viewModel = Get.put(
      SplashViewModel(context: context),
    );

    RecipeMateAppUtil.lockToPortrait();

    _initAnimation();
    _listenAnimationTriggers();
  }

  void _initAnimation() {

    rotationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    )..repeat();

    iconController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    iconFade = Tween<double>(begin: 0, end: 1).animate(iconController);

    iconSlide = Tween<Offset>(
      begin: const Offset(0, -1.5),
      end: Offset.zero,
    ).animate(iconController);

    textFade = Tween<double>(begin: 0, end: 1).animate(textController);

    textSlide = Tween<Offset>(
      begin: const Offset(0, 1.5),
      end: Offset.zero,
    ).animate(textController);
  }

  void _listenAnimationTriggers() {
    ever(viewModel.startIconAnimation, (bool start) {
      if (start) iconController.forward();
    });
    ever(viewModel.startTextAnimation, (bool start) {
      if (start) textController.forward();
    });
  }

  @override
  void dispose() {
    rotationController.dispose();
    iconController.dispose();
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final circleSize = MediaQuery.of(context).size.width * 0.45;
    return Scaffold(
      backgroundColor: HexColor(ColorVar.bgAppColor),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: circleSize,
                height: circleSize,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    AnimatedBuilder(
                      animation: rotationController,
                      builder: (_, child) {
                        return Transform.rotate(
                          angle: rotationController.value * 2 * math.pi,
                          child: child,
                        );
                      },
                      child: CustomPaint(
                        size: Size(circleSize, circleSize),
                        painter: RecipeMateCirclePainter(),
                      ),
                    ),
                    // Image.asset(
                    //   "assets/images/ic_logo_recipemate.png",
                    //   width: circleSize * 0.45,
                    //   height: circleSize * 0.45,
                    // )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}