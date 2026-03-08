import 'package:flutter/material.dart';

enum SlideDirection { left, right }

class SlidePageRoute extends PageRouteBuilder {
  final Widget page;
  final SlideDirection direction;

  SlidePageRoute({required this.page, this.direction = SlideDirection.right})
      : super(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              page,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) {
            Offset beginOffset;
            switch (direction) {
              case SlideDirection.left:
                beginOffset = const Offset(-1, 0); // Slide from left
                break;
              case SlideDirection.right:
                beginOffset = const Offset(1, 0); // Slide from right
                break;
            }
            return SlideTransition(
              position: Tween<Offset>(
                begin: beginOffset,
                end: Offset.zero,
              ).animate(animation),
              child: child,
            );
          },
        );
}