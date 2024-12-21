
/*
Login Page

in this logiPage and existing user can login
==email
--password

 */




import 'package:flutter/material.dart';

import 'package:twiter_clone/components/my_button.dart';
import 'package:twiter_clone/components/my_loading_circle.dart';
import 'package:twiter_clone/components/my_text_field.dart';
import 'package:twiter_clone/services/auth/auth_services.dart';


class LoginPage extends StatefulWidget {
  final void Function()? onTap;

  
   LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController=TextEditingController();
  final TextEditingController pwController=TextEditingController();

  //acess auth services
  final _auth=AuthServices();

  //login method 
  void login()async{

    //show loading circle
    showLoadingCircle(context);
    //attempt login
    try{
      await _auth.loginEmailPassword(emailController.text, pwController.text);

      //finish loading
     if(mounted) hideLoadingCircle(context);


    }
    //catch any error
    catch(e){
       if(mounted) hideLoadingCircle(context);
      print(e.toString());

    }
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 50,),
                  //Logo
                  Icon(
                    Icons.lock_open_rounded,
                    size: 72,
                    color: Theme.of(context).colorScheme.primary,
                    ),
                    SizedBox(height: 50,),
              
              
                  //welcome back screen
                  Text("Welcome back you\'ve been missed",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 16,
                  ),
                  ),
                  SizedBox(height: 25,),
              
                  //email textfield 
                  MyTextField(
                    controller: emailController, 
                    hintText: "Enter Email...",
                     obsecureText: false,
                     ),
                    SizedBox(height: 10,),
              
                  //password texfiled
                    MyTextField(
                    controller: pwController,
                    hintText: "Enter password...",
                     obsecureText: true,
                     ),
                     SizedBox(height: 10,),
              
                  //forget password
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text("Forgot password?",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold
                    ),
                    )
                    ) ,
                    SizedBox(height: 25,),
              
                  //sign in buttoon
                  MyButton(
                    text: "Login",
                     onTap: login
                     ),
                     SizedBox(height: 50,),
              
                  //not a membor? register now 
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Not a membor?", 
                      style: TextStyle(color: Theme.of(context).colorScheme.primary),
                      ),
                      SizedBox(width: 5,),
                      
              
                      //user can tap this to go to the register page 
                      GestureDetector(
                        onTap: widget.onTap,
                       
                        
                        child: Text("Register now",
                        style: TextStyle(
                          color:  Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold
                        ),
                        )
                        ),
                    ],
                  )
              
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}