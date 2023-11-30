import 'package:flutter/material.dart';

class LeftPageRoute extends PageRouteBuilder {
  final Widget child;

  LeftPageRoute({required this.child})
      : super(
            transitionDuration: const Duration(milliseconds: 251),
            reverseTransitionDuration: const Duration(milliseconds: 251),
            pageBuilder: (context, animation, secondaryAnimation) => child);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(-1, 0),
        end: Offset.zero,
      ).animate(animation),
      child: child,
    );
  }
}

class RightPageRoute extends PageRouteBuilder {
  final Widget child;

  RightPageRoute({required this.child})
      : super(
            transitionDuration: const Duration(milliseconds: 251),
            reverseTransitionDuration: const Duration(milliseconds: 251),
            pageBuilder: (context, animation, secondaryAnimation) => child);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(1, 0),
        end: Offset.zero,
      ).animate(animation),
      child: child,
    );
  }
}

class BottomPageRoute extends PageRouteBuilder {
  final Widget child;

  BottomPageRoute({required this.child})
      : super(
            transitionDuration: const Duration(milliseconds: 251),
            reverseTransitionDuration: const Duration(milliseconds: 251),
            pageBuilder: (context, animation, secondaryAnimation) => child);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, 1),
        end: Offset.zero,
      ).animate(animation),
      child: child,
    );
  }
}
