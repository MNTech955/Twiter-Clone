/*

DATABASE SERVICES

this class handle all the data from and to database
----------------------------------------------------
-userprofile
-postmessage
-likes
-comment
-account
-account stuff(report/block/delete account)
-follow/unfollow
-Search users
* */

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:twiter_clone/model/comment.dart';
import 'package:twiter_clone/model/post.dart';
import 'package:twiter_clone/model/user_model.dart';
import 'package:twiter_clone/services/auth/auth_services.dart';

class DataBaseServices {
  //get instance of firestore data base and auth
  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

/*
  //user profile 
  //when a new user registers, we can create an account for them , but we can also store theire detail
  //in the database to display on their profilepage 
  */
  //save user info
  Future<void> saveUserInfoInFirebase(
      {required String name, required String email}) async {
    //get Current user
    String uid = _auth.currentUser!.uid;

    //extract username form email
    //This line of code is written in Dart (commonly used in Flutter development) and extracts the username from an email address.
    //For example, if email is "nouman@example.com", the result of email.split('@') will be:["nouman", "example.com"]
    //The [0] accesses the first element of the list returned by split. This corresponds to the part of the email before the @ symbol.

    //e.g.mitch@gmail.com->username:mitch
    String username = email.split('@')[0];

    //create user profile
    UserProfile user = UserProfile(
      uid: uid,
      name: name,
      email: email,
      username: username,
      bio: '',
    );

    //convert a user into a map, so that we can store in firebase
    final userMap = user.toMap();

    //save user info in firebase
    await _db.collection("Users").doc(uid).set(userMap);
  }

  //Get user info
  Future<UserProfile?> getUserFromFirebase(String uid) async {
    try {
      //retrieve user info from firebase
      DocumentSnapshot userDoc = await _db.collection("Users").doc(uid).get();

      //convert doc to user profile
      return UserProfile.fromDocument(userDoc);
    } catch (e) {
      print(e);
      return null;
    }
  }

  //update user bio

  Future<void> updateUserBioInFirebase(String bio) async {
    //get current user uid

    String uid = AuthServices().getCurrentUid();

    //atempt to updatein firebase
    try {
      await _db.collection("Users").doc(uid).update({"bio": bio});
    } catch (e) {
      print(e);
    }
  }

  //delete user info from firebase with the given user uid
  Future<void> deleteUserInfoFromFirebase(String uid)async{
    WriteBatch batch=_db.batch();
    //delete userdoc
    DocumentReference userDoc=await _db.collection("Users").doc(uid);
    batch.delete(userDoc);
    

    //delete user posts
    QuerySnapshot userPosts=
    await _db.collection("Posts").where("uid", isEqualTo: uid).get();
    for(var post in userPosts.docs){
      batch.delete(post.reference);

    }

    //delete user comment
    QuerySnapshot userComments=
    await _db.collection("Comments").where("uid", isEqualTo: uid).get();
    for(var comment in userComments.docs){
      batch.delete(comment.reference);
    }

    //delete like done by this user
    QuerySnapshot allPosts=await _db.collection("Posts").get();
    for(QueryDocumentSnapshot post in allPosts.docs){
      Map<String, dynamic> postData=post.data() as Map<String, dynamic>;
      var likedBy=postData["likedBy"] as List<dynamic>? ??[];

      if(likedBy.contains(uid)){
        batch.update(post.reference, {
          "likedBy":FieldValue.arrayRemove([uid]),
          "likes":FieldValue.increment(-1),


        });
      }
    }

    //update follower and following ecord accordingly..later

    //commit batch
    await  batch.commit();

  }

  /*
  POST MESSAGE

   */
  //post a message
  Future<void> postMessageInFirebase(String message) async {
    try {
      //get current user
      String uid = _auth.currentUser!.uid;
      //use this uid to get user profile
      UserProfile? user = await getUserFromFirebase(uid);

      //create a post
      Post newPost = Post(
          id: '', //firebase will auto generate this id
          uid: uid,
          name: user!.name,
          username: user.username,
          message: message,
          timestamp: Timestamp.now(),
          likeCount: 0,
          likedBy: []);

      //convert a post object to map
      Map<String, dynamic> newPostMap = newPost.toMap();

      //add to firebase
      await _db.collection("Posts").add(newPostMap);
    } catch (e) {
      print(e);
    }
  }

  //delete  a post
  Future<void> deletePostFromFirebase(String postId) async {
    try {
      await _db.collection("Posts").doc(postId).delete();
    } catch (e) {
      print(e);
    }
  }

  //get all post from firebase
  Future<List<Post>> getAllPostsFromFirebase() async {
    try {
      //go to collection ->post
      QuerySnapshot snapshot = await _db
          .collection("Posts")
          //chronological order
          .orderBy("timestamp", descending: true)
          //get this post
          .get();
      //return as list of post
      return snapshot.docs.map((doc) => Post.fromDocument(doc)).toList();
    } catch (e) {
      return [];
    }
  }

  //Get individual post

  /*
  LIKES

   */
  //likes a post

  Future<void> toggleLikeInFirebase(String postId) async {
    try {
      //get cureent uid
      final uid = _auth.currentUser!.uid;
      //go to doc for this post
      //DocumentReference:->Represents a reference (or pointer) to a document in a Firestore collection.It does not contain the data of the document.
      //It is used to perform operations like read, update, delete, or listen to the document.
      DocumentReference postDoc = _db.collection("Posts").doc(postId);
      // Starts a transaction, which is a mechanism to ensure safe and consistent read and write operations. Firestore guarantees that all operations
      // inside the transaction either succeed together or fail completely
      //Ensures that the "like" status isn't overwritten in case multiple users like/unlike the post simultaneously

      //execute like
      await _db.runTransaction((transaction) async {
        //get post data
        //DocumentSnapshot:->Represents the actual data and metadata of a document at a specific point in time.
        //To obtain a DocumentSnapshot, you need to call .get() or use a stream to fetch the document's data.
        DocumentSnapshot postSnapshot = await transaction.get(postDoc);

        //get like of user who like this post
        List<String> likedBy = List<String>.from(postSnapshot["likedBy"] ?? []);

        //get like count
        int currentLikeCount = postSnapshot['likes'];

        //if user has not liked this post then like
        if (!likedBy.contains(uid)) {
          //add user to like list
          likedBy.add(uid);
          //incriment like count
          currentLikeCount++;
        }

        //if user alreay like this post then un like this post
        else {
          likedBy.remove(uid);
          currentLikeCount--;
        }

        //update in firebase

        transaction
            .update(postDoc, {"likes": currentLikeCount, "likedBy": likedBy});
      });
    } catch (e) {
      print(e);
    }
  }

  /*

  COMMENT

  


  //delete comment from the psot 
   */

  //add a comment to a post
  Future<void> addCommentInFirebase(String postId, message) async {
    try {
      //get current user
      String uid = _auth.currentUser!.uid;
      UserProfile? user = await getUserFromFirebase(uid);

      //create a new comment
      Comment newComment = Comment(
          id: '', //auto generated by firestore
          postId: postId,
          uid: uid,
          name: user!.name,
          username: user.username,
          message: message,
          timestamp: Timestamp.now(),
          );

          //convert comment into a map
          Map<String, dynamic> newCommentMap=newComment.toMap();

          //to store in firestore
          await _db.collection("Comments").add(newCommentMap);
    } catch (e) {
      print(e);
    }
  }

  //delete comment from the post

  Future<void> deleteCommentInFirebase(String commentId)async{
    try{
      await _db.collection("Comments").doc(commentId).delete();

    }catch(e){
      print(e);


    }
  }



  //Fetch comment from a post

  Future<List<Comment>> getCommentsFromFirebase(String postId)async{
    try{
      //get comment from firebase
      QuerySnapshot snapshot=await _db.collection("Comments")
      .where("postId", isEqualTo: postId)
      .get();

      //return a list of comment
      return snapshot.docs.map((doc) => Comment.fromDocument(doc)).toList();

    }catch(e){
      print(e);
      return [];

    }

  }

  /*
  ACCOUNT STUFF
  this is requirement if you wish to published this to the app store 

   */
  //report post 
  Future<void> reportUserInFirebase(String postId, userId)async{
    //get current user
    final currentUserId=_auth.currentUser!.uid;

    //create a report map
    final report={
      "reportedBy":currentUserId,
      "messageId":postId,
      "messageOwnerId":userId,
      "timestamp":FieldValue.serverTimestamp()

    };
    //update in firestore
    await _db.collection("Reports").add(report);


  }
  //block user 
  Future<void> blockUserInFirebase(String userId)async{
    //get current user id
    final currentuserId=_auth.currentUser!.uid;

    //add this user to blocked list 
    await _db
    .collection("Users")
    .doc(currentuserId)
    .collection("BlockedUsers")
    .doc(userId)
    .set({});
  }
  //unblock user
  Future<void> unblockUserInFirebase(String blockedUserId)async{
     //get current user id
    final currentuserId=_auth.currentUser!.uid;

    //add this user to blocked list 
    await _db
    .collection("Users")
    .doc(currentuserId)
    .collection("BlockedUsers")
    .doc(blockedUserId)
    .delete();
  }
  //get list of all blocked user ids
  Future<List<String>> getBlockedUidsFromFirebase()async{
    //get current user id
    final currentUserId=_auth.currentUser!.uid;

    //get data of blcoked user 
    final snapshot= await _db
    .collection("Users")
    .doc(currentUserId)
    .collection("BlockedUsers")
    .get();
    //return as list of uids
    return snapshot.docs.map((doc) => doc.id).toList();

  }

  //FOllOW

  //follow user
  Future<void> followUserInFirebase(String uid)async{
    //get currrent logged in user
    final currentUserId=_auth.currentUser!.uid;
    //add target user to the current user's following
    await _db.collection("Users")
    .doc(currentUserId)
    .collection("Following")
    .doc(uid)
    .set({});

    //add current user to the target user's follower
     await _db.collection("Users")
    .doc(uid)
    .collection("Followers")
    .doc(currentUserId)
    .set({});

  }
  


  //Unfoloow user
  Future<void> UnFollowUserInFirebase(String uid)async{
    //get current logged in user
    final currentUserId=_auth.currentUser!.uid;
    //remove target user from the current user Following
     await _db.collection("Users")
    .doc(currentUserId)
    .collection("Following")
    .doc(uid)
    .delete();


    //reomove currrent user from the target user's follower
         await _db.collection("Users")
    .doc(uid)
    .collection("Followers")
    .doc(currentUserId)
    .delete();
  }

  //Get user follower list:List of uid
  Future<List<String>> getFollowerUidsFromFirebase(String uid)async{
    //get the followers from firebase
    final snapshot=await _db.collection("Users").doc(uid).collection("Followers").get();
    //retutn as simple list of uids
    return snapshot.docs.map((doc) => doc.id).toList();

  }

  //Get user following List of Uids
   Future<List<String>> getFollowingUidsFromFirebase(String uid)async{
    //get the following from firebase
    final snapshot=await _db.collection("Users").doc(uid).collection("Following").get();
    //retutn as simple list of uids
    return snapshot.docs.map((doc) => doc.id).toList();

  }

  //search 
  //search user by name 

   Future<List<UserProfile>> searchUserInFirebase(String searchTerm)async{
    try{
      QuerySnapshot snapshot=await _db
      .collection("Users")
      .where("username",isGreaterThanOrEqualTo: searchTerm)
      .where("username", isLessThanOrEqualTo: '$searchTerm\uf8ff')
      .get();
      return snapshot.docs.map((doc) => UserProfile.fromDocument(doc)).toList();

    }catch(e){
      return [];

    }
   }
  



  }
  




