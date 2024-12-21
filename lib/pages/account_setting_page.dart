
import 'package:flutter/material.dart';

import 'package:twiter_clone/services/auth/auth_services.dart';

class AccountSetting extends StatefulWidget {
  const AccountSetting({super.key});

  @override
  State<AccountSetting> createState() => _AccountSettingState();
}

class _AccountSettingState extends State<AccountSetting> {
  //ask for confirmation form the user before deletion 
  void confirmDeletion(BuildContext context){
       showDialog(
      context: context,
       builder: (context)=>AlertDialog(
        title: Text("Delete Account?"),
        content: Text("Are you sure you want to delete this account?"),
        actions: [
          //cancel button
          TextButton(
            onPressed: (){
              Navigator.pop(context);
            },
             child: Text("Cancel")
             ),
             //delete button button
              TextButton(
            onPressed: ()async{
            
              //report user
              await AuthServices().deleteAccount();

              //then navigate to the initial routes (Auth gate->login/register page)
              Navigator.pushNamedAndRemoveUntil(
                context,
                 '/',
                 (route) => false
                 );
            },
             child: Text("Delete")
             ),
        ],
       )
       );

  }
  //build ui
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        centerTitle: true,
        title: Text("Account Settings",
        
        ),
        foregroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Column(
        children: [
          //delete tile
          GestureDetector(
            onTap: ()=>confirmDeletion(context),
            child: Container(
              padding: EdgeInsets.all(25),
              margin: EdgeInsets.all(25),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text("Delete Account",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white
                ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}