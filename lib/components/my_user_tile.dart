

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:twiter_clone/model/user_model.dart';
import 'package:twiter_clone/pages/profile_page.dart';

class MyUserTile extends StatelessWidget {
  final UserProfile user;
  const MyUserTile({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      //padding outside
      margin: EdgeInsets.symmetric(horizontal: 25,vertical: 5),
      //padding inside the contaier
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(12)
      ),
      child: ListTile(
        title: Text(user.name),
        titleTextStyle: TextStyle(color:  Theme.of(context).colorScheme.inversePrimary,),
        subtitle: Text("@${user.username}"),
        subtitleTextStyle: TextStyle(color: Theme.of(context).colorScheme.primary),
        leading: Icon(
          Icons.person,
          color: Theme.of(context).colorScheme.primary,
        ),
        onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>ProfilePage(uid: user.uid))),
        trailing: Icon(Icons.arrow_forward, color: Theme.of(context).colorScheme.primary,),
      ),
    );
  }
}