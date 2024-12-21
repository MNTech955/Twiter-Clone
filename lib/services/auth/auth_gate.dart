

/*


AUTH GATE


this chch if the user is login or not
--------------------------------------------------------------------------
if user is logged in =>go to the home page
if user is not logged in => go the login or register page 
 */



import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:twiter_clone/pages/home_page.dart';
import 'package:twiter_clone/services/auth/login_or_register.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //stream just check if the current user is logged in or not 

      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
         builder: (context, snapshot){
          //user is loggin
          if(snapshot.hasData){
            return HomePage();

          }
          //user is not logged in 
          else{
            return LoginOrRegister();
          }


         }
         ),
    );
  }
}