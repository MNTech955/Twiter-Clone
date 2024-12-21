

//show laoding circle 
import 'package:flutter/material.dart';

void showLoadingCircle(BuildContext context){
  showDialog(
    context: context,
     builder: (context)=>AlertDialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      content: Center(
        child: CircularProgressIndicator(),
      ),
     )
     );
}

//hide loading circle
void hideLoadingCircle(BuildContext context){
  Navigator.pop(context); 
}