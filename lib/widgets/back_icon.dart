import 'package:flutter/material.dart';

class BackIcon extends StatelessWidget {
  final VoidCallback? onTap;
  final Color color;
  final double size;

  const BackIcon({
    Key? key,
    this.onTap,
    this.color = Colors.black,
    this.size = 28.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ?? () => Navigator.of(context).maybePop(),
      child: Icon(
        Icons.arrow_back_ios_new,
        color: color,
        size: size,
      ),
    );
  }
} 