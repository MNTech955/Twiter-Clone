import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:twiter_clone/themes/theme_provider.dart';

class MySettingTile extends StatelessWidget {
  String title;
  Widget action;
   MySettingTile({super.key, required this.action, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        //curve corner 
        borderRadius: BorderRadius.circular(20),
      ),
      //padding outside
      margin: EdgeInsets.only(left: 25, right: 25, top: 10),
      //padding inside
      padding: EdgeInsets.all(25),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          //title
          Text(title, style: TextStyle(fontWeight: FontWeight.bold),) ,

          //action
          action
        ],
      )
    );
  }
}
