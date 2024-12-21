

/*

drawer contain 5 menu option:

--------------------------------------------------------
--home
--profile
--setting 
--serach
--logout


*/

import 'package:flutter/material.dart';
import 'package:twiter_clone/components/my_drawer_tile.dart';
import 'package:twiter_clone/pages/profile_page.dart';
import 'package:twiter_clone/pages/search_page.dart';
import 'package:twiter_clone/pages/setting_page.dart';
import 'package:twiter_clone/services/auth/auth_services.dart';

class MyDrawer extends StatelessWidget {
   MyDrawer({super.key});

  //access auth services
  final _auth=AuthServices();

  //logOut

  void logOut(){
    _auth.logOut();
  }


  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            children: [
              //app logo
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 50),
                child: Icon(Icons.person,
                size: 72,
                color: Theme.of(context).colorScheme.primary,
                ),
                
              ),
              //drawer line
              Divider(
                indent: 25,
                endIndent: 25,
                color:  Theme.of(context).colorScheme.secondary,
              ),
              //home List tile 
              MyDrawerTile(icon: Icons.home, title: 'H O M E', onTap: (){
                //pop because we are are already on the honme page 
                Navigator.pop(context);
              }),
              //Profile list tile
             MyDrawerTile(icon: Icons.person, title: "P R O F I L E", onTap: (){
              Navigator.pop(context);
              //go to the profile page
              Navigator.push(context, MaterialPageRoute(builder: (context)=>ProfilePage(uid: _auth.getCurrentUid())));


             }),
              //search list tile 
              MyDrawerTile(icon: Icons.search, title: "S E A R C H", onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>SearchPage()));
              }),
              //setting list tile
              MyDrawerTile(icon: Icons.settings, title: "S E T T I N G S", onTap: (){
                //pop
                Navigator.pop(context);
          
                //go to the setting page
                Navigator.push(context, MaterialPageRoute(builder: (context)=>SettingPage()));
              }),
              Spacer(),
              //Logout tile
              
             MyDrawerTile(icon: Icons.logout, title: "L O G O U T", onTap: logOut,

          
             )
          
            ],
          ),
        ),
      ),
    );
  }
}