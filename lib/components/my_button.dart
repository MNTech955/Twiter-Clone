

import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final String text;
  final  void Function()? onTap;
 MyButton({super.key, required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        //padding indside 
        padding: EdgeInsets.all(25),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          //curved curner 
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(text,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
          )
          ),
      ),

    );
  }
}