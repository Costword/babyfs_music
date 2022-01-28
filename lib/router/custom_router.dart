import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomPageRouter extends PageRouteBuilder{
  final Widget widget;
  CustomPageRouter(this.widget):super(
    transitionDuration: Duration(seconds: 1),
    pageBuilder: (context, animation, secondaryAnimation) {
      return widget;
    },
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
    
    return SlideTransition(position: Tween<Offset>(
      begin: Offset(0.0, 1.0),
      end: Offset(0.0,0.0)
      ).animate(CurvedAnimation(parent: animation, curve: Curves.fastOutSlowIn)),
      child: child,
      );
    // return FadeTransition(
    //   opacity: Tween(begin: 0.0,end: 1.0).animate(CurvedAnimation(parent: animation, curve: Curves.fastOutSlowIn)),
    //   child: child,
    //   );
    },
  );

}