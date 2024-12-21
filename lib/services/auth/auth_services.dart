

/*
AUTHENTICATION SERVICES

this do everything to do  with authentication in firebase

-login
-register
-logout
-delete account

*/


import 'package:firebase_auth/firebase_auth.dart';
import 'package:twiter_clone/services/database/database_services.dart';

class AuthServices{
  //get instance of the auth

  final _auth=FirebaseAuth.instance;

  //get current user and uid
  User? getCurrentUser()=>_auth.currentUser;
  String getCurrentUid()=>_auth.currentUser!.uid;

  //login->email and password
  Future<UserCredential> loginEmailPassword(String email,  password)async{
    //attempt login
    try{
      final userCredential=await _auth.signInWithEmailAndPassword(email: email, password: password);
      return userCredential;

    }
    //catch any error
    on FirebaseAuthException catch(e){
      throw Exception(e.toString());
    }

  }


  //register email and password

  Future<UserCredential> registerEmailPassword(String email, password)async{

    //atempt to register new user 
    try{

      UserCredential userCredential=await _auth.createUserWithEmailAndPassword(
        email: email,
         password: password
         );
         return userCredential;

    }on FirebaseAuthException catch(e){
      throw Exception(e.toString());
    }
  }

  //logout
  Future<void> logOut()async{
    await _auth.signOut();
  }

  //delete account
  Future<void> deleteAccount()async{
    //get current user uid
    User? user=getCurrentUser();
    if(user!=null){
      //delete user data frm firestore 
      await DataBaseServices().deleteUserInfoFromFirebase(user.uid);

      //delete the user auth record
      await user.delete();

    }
  }

}