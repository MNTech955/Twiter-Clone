

import 'package:flutter/material.dart';

class MyDrawerTile extends StatelessWidget {
  String title;
  IconData icon;
  void Function() onTap;
  

   MyDrawerTile({super.key, required this.icon, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title,
      style: TextStyle(
        color: Theme.of(context).colorScheme.inversePrimary
      ),
      ),
      leading: Icon(icon,
      color: Theme.of(context).colorScheme.primary,
      
      ),
      onTap: onTap
    );
  }
}