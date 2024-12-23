

/*

USER PROFILE

this is what every user should  have for their profile 
-------------------------------------------------------------

-uid
-name
-email
-username
-bio
-profile photo


*/


import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfile{
  final String uid;
  final String name;
  final String email;
  final String username;
  final String bio;

  UserProfile({
    required this.uid, 
    required this.name,
    required this.email, 
    required this.username,
    required this.bio

  });
  //firebase->to app
  //convert firestore document to a user profile , so that we can used in our app

  factory UserProfile.fromDocument(DocumentSnapshot doc){
    return UserProfile(
      uid: doc['uid'],
       name: doc['name'],
        email: doc['email'],
         username: doc['username'],
          bio: doc['bio']
          );
  }
  //app->to firebase
  //convert user profile to map(so that we can store in firestore )

  Map<String, dynamic> toMap(){
    return{
      "uid":uid,
      'name':name,
      'email':email,
      'username':username,
      'bio':bio,

    }; 
  }

}