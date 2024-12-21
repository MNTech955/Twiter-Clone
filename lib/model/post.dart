/*
POST MODEL

this is what every post should have 

 */

import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String id; //id of the post
  final String uid; //uid of the poster
  final String name; //name off the poster
  final String username; //username of the poster
  final String message; //mesage of the post
  final Timestamp timestamp; //timestamp of the post
  final int likeCount; //like count of the post
  final List<String> likedBy; //list of the user id who like this post

  Post(
      {required this.id,
      required this.uid,
      required this.name,
      required this.username,
      required this.message,
      required this.timestamp,
      required this.likeCount,
      required this.likedBy});
  //convert firestore documents to a post object so that we can use in our app

  factory Post.fromDocument(DocumentSnapshot doc) {
    return Post(
        id: doc.id,
        uid: doc['uid'],
        name: doc['name'],
        username: doc['username'],
        message: doc['message'],
        timestamp: doc['timestamp'],
        likeCount: doc['likes'],
        likedBy: List<String>.from(doc['likedBy']?? []),
        );
  }

  //convert a post object to a map so that we can store app data  in firebase
  Map<String, dynamic> toMap(){
    return {
      "uid":uid,
      'name':name,
      "username":username,
      "message":message,
      "timestamp":timestamp,
      "likes":likeCount,
      "likedBy":likedBy

    };
  }
}
