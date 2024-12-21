



import 'package:flutter/material.dart';
import 'package:twiter_clone/components/my_button.dart';
import 'package:twiter_clone/components/my_loading_circle.dart';
import 'package:twiter_clone/components/my_text_field.dart';
import 'package:twiter_clone/services/auth/auth_services.dart';
import 'package:twiter_clone/services/database/database_services.dart';


class RegisterPage extends StatefulWidget {
  final void Function()? onTap;
   RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
    final TextEditingController nameController=TextEditingController();

  final TextEditingController emailController=TextEditingController();

  final TextEditingController pwController=TextEditingController();

  final TextEditingController confirmPwController=TextEditingController();

  //access auth & db service
  final _auth=AuthServices();
  final _db=DataBaseServices();

  //register button tapped 
  void register()async{
    //password matched create user 
    if(pwController.text==confirmPwController.text){
      //show loading circle
      showLoadingCircle(context);

      //attempt to register new user
      try{
        await _auth.registerEmailPassword(emailController.text, pwController.text);

        //finish loading...
      

       //once registered, create and save user profile in database
       await _db.saveUserInfoInFirebase(name: nameController.text, email: emailController.text);
        if(mounted) hideLoadingCircle(context);

      }
      //catchh any error 
      catch(e){
       if(mounted) hideLoadingCircle(context);

       //let user know if the error
       if(mounted){
        showDialog(
          context: context, 
          builder: (context)=>AlertDialog(
             title: Text(e.toString()),
          ),
          );
       }

      }
    }

    //password donot matched show error
    else{
       showDialog(
          context: context, 
          builder: (context)=>AlertDialog(
             title: Text("Password donot matched"),
          ),
          );
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
                  Text("Let's create an account for you",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 16,
                  ),
                  ),
                  SizedBox(height: 25,),


                  //name textfield
                      MyTextField(
                    controller: nameController,
                    hintText: "Enter name...",
                     obsecureText: false,
                     ),
                     SizedBox(height: 10,),
              
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
                     //confirm password
                     MyTextField(
                    controller: confirmPwController,
                    hintText: "Confirm password...",
                     obsecureText: true,
                     ),
                     SizedBox(height: 10,),

              
               
                    SizedBox(height: 25,),
              
                  //sign up buttoon
                  MyButton(
                    text: "Register",
                     onTap: register
                     ),
                     SizedBox(height: 50,),
              
                  //Already a membor login here 
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Already a membor?", 
                      style: TextStyle(color: Theme.of(context).colorScheme.primary),
                      ),
                      SizedBox(width: 5,),
                      
              
                      //user can tap this to go to the register page 
                      GestureDetector(
                        onTap: widget.onTap,
                          
                        
                        child: Text("Login now",
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