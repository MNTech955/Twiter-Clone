


import 'package:flutter/material.dart';

class MyInputAlertBox extends StatelessWidget {
  final TextEditingController textController;
  final String hintText;
  final void Function()? onPressed;
  final String onPressedText;
  const MyInputAlertBox({super.key, required this.textController,
  required this.hintText, required this.onPressed,
  required this.onPressedText
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      content: TextField(
        controller: textController,

        maxLength: 140,
        maxLines: 3,
        decoration: InputDecoration(
          //border when textfield is unselected
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.tertiary ,
            
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        //border when textfield is unselected
         focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.primary,
            
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        hintText: hintText,
        hintStyle: TextStyle(color: Theme.of(context).colorScheme.primary),
        fillColor: Theme.of(context).colorScheme.secondary,
        filled: true,
        counterStyle: TextStyle(color: Theme.of(context).colorScheme.primary)
        )
      ),
      //button
      actions: [
        //cancel buuton
        TextButton(
          onPressed: (){
            Navigator.pop(context);

            textController.clear();

            

          },
           child: Text("Cancel"),
           ),

        //yes button
        TextButton(
          onPressed: (){
            Navigator.pop(context);
            onPressed!();

            textController.clear();
          },
           child: Text(onPressedText),
           ),
      ],
    );
  }
}