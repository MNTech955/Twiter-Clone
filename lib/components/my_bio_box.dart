

import 'package:flutter/material.dart';

/**
 USER BIOBOX

 this is a simple box with text inside, we will used this for the user bio
 on their propile page


 to use this widget we just need 

 -text

 */

class MyBioBox extends StatelessWidget {
  final String text;
  const MyBioBox({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(8),
      ),
      //padding inside
      padding: EdgeInsets.all(25),

      //padding outside
       margin: EdgeInsets.symmetric(horizontal: 25),
      child: Text(text.isNotEmpty?text:"Empty Bio...",
      style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary),
      ),
    )
    ;
  }
}