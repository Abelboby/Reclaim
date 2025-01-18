import 'package:flutter/material.dart';

class AppAnimations {
  static const Duration defaultDuration = Duration(milliseconds: 300);
  static const Duration longDuration = Duration(milliseconds: 500);

  static PageRouteBuilder<T> fadeScale<T>({
    required Widget child,
    Duration duration = defaultDuration,
  }) {
    return PageRouteBuilder<T>(
      transitionDuration: duration,
      pageBuilder: (context, animation, secondaryAnimation) => child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final scaleAnimation = Tween<double>(begin: 0.95, end: 1.0).animate(
          CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
        );
        final fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(parent: animation, curve: Curves.easeInOut),
        );
        return FadeTransition(
          opacity: fadeAnimation,
          child: ScaleTransition(
            scale: scaleAnimation,
            child: child,
          ),
        );
      },
    );
  }

  static Widget slideUp({
    required Widget child,
    required Animation<double> animation,
  }) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - animation.value)),
          child: Opacity(
            opacity: animation.value,
            child: child,
          ),
        );
      },
      child: child,
    );
  }

  static Widget fadeIn({
    required Widget child,
    required Animation<double> animation,
  }) {
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }

  static Widget scale({
    required Widget child,
    required Animation<double> animation,
  }) {
    return ScaleTransition(
      scale: animation,
      child: child,
    );
  }

  static Widget shimmer({required Widget child}) {
    return ShaderMask(
      shaderCallback: (bounds) {
        return LinearGradient(
          colors: [
            Colors.white.withOpacity(0.5),
            Colors.white,
            Colors.white.withOpacity(0.5),
          ],
          stops: const [0.0, 0.5, 1.0],
          begin: const Alignment(-1.0, -0.5),
          end: const Alignment(1.0, 0.5),
          tileMode: TileMode.clamp,
        ).createShader(bounds);
      },
      child: child,
    );
  }

  static Widget staggeredList({
    required List<Widget> children,
    Duration initialDelay = const Duration(milliseconds: 100),
    Duration itemDelay = const Duration(milliseconds: 50),
  }) {
    return ListView.builder(
      itemCount: children.length,
      itemBuilder: (context, index) {
        return TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: Duration(milliseconds: 300), // Using explicit duration since defaultDuration isn't defined
          curve: Curves.easeOutCubic,
          onEnd: () {
            Future.delayed(initialDelay + (itemDelay * index));
          },
          builder: (context, value, child) {
            return Transform.translate(
              offset: Offset(0, 20 * (1 - value)),
              child: Opacity(
                opacity: value,
                child: child,
              ),
            );
          },
          child: children[index],
        );
      },
    );
  }
} 