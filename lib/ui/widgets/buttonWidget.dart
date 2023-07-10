import 'package:flutter/material.dart';


import '../theme.dart';

class MyButton extends StatelessWidget {
  final Function()? onTap;
  final String label;
  final double height;
  final double width;

  MyButton({
    this.onTap,
    required this.height,
    required this.width,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          gradient:  RadialGradient(
            colors: [Colors.pinkAccent.shade100
            , Colors.deepPurple],
            radius:2,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}