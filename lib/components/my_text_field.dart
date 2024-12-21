


import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
   bool obsecureText;
   MyTextField({super.key, required this.controller, required this.hintText, required this.obsecureText});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obsecureText,
      decoration: InputDecoration(
        //border when unselected
        enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: Theme.of(context).colorScheme.tertiary
        )
        ),
        //border when selected
         focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: Theme.of(context).colorScheme.primary
        )
        ),
        fillColor: Theme.of(context).colorScheme.secondary,
        filled: true,
        hintText: hintText,
        hintStyle: TextStyle(color: Theme.of(context).colorScheme.primary)
      ),

    );
  }
}