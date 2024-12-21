//go to user page

import 'package:flutter/material.dart';
import 'package:twiter_clone/model/post.dart';
import 'package:twiter_clone/pages/home_page.dart';
import 'package:twiter_clone/pages/post_page.dart';
import 'package:twiter_clone/pages/profile_page.dart';

import '../pages/account_setting_page.dart';
import '../pages/blocked_user_page.dart';

void goUserPage(BuildContext context, String uid){
  //navigate to page
  Navigator.push(context, MaterialPageRoute(builder: (context)=>ProfilePage(uid: uid)));
}


//go to the post page
void goPostPage(BuildContext context, Post post){
  //navigate to post page 
  Navigator.push(context, MaterialPageRoute(builder: (context)=>PostPage(post: post)));
}
//go to blocked user page 
void goToBlockedUserPage(BuildContext context){
    Navigator.push(context, MaterialPageRoute(builder: (context)=>BlockedUserPage()));

}

//go to the account page 
void goToAccountSettingsPage(BuildContext context){
  Navigator.push(context, MaterialPageRoute(builder: (context)=>AccountSetting()));
}

//go home page (but remove all the previos routes, this is goood for reload)
void goHomePage(BuildContext context){
  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>HomePage()),
  //keep the first route auth gate 
   (route) => false);
}