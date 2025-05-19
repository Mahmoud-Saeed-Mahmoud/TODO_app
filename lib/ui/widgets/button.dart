import 'package:flutter/material.dart';
import 'package:todo/ui/theme.dart';

class MyButton extends StatelessWidget {
  final String label;

  final Function() onTap;
  const MyButton({super.key, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        width: 100,
        height: 45,
        decoration: BoxDecoration(
          color: primaryClr,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          label,
          style: const TextStyle(color: Colors.white),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
