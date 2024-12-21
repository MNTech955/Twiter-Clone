



import 'package:flutter/material.dart';
import 'package:twiter_clone/model/comment.dart';

import 'package:twiter_clone/model/post.dart';
import 'package:twiter_clone/model/user_model.dart';
import 'package:twiter_clone/services/auth/auth_services.dart';
import 'package:twiter_clone/services/database/database_services.dart';

/**
 DATABASE PROVIDER
 

 this provider is to seperate the firestore data  handling and the ui of our app
 ----------------------------------------------------------------------------------------

 -the database services class handles data to and from firebase 
 -the database class processing the data to display in our app
 -this is to make our code much more modular , cleaner , and easily to read and test
 particulary as the nomber of pages grow , we need this provider to properly manage 
 different state of the app 
 */



class DatabaseProvider extends ChangeNotifier{
  /*
  SERVICES 
  */

  //get db and auth services
  final _auth=AuthServices();
  final _db=DataBaseServices();

  /*
  PROFILES

   */

  //get user profile given uid
  Future<UserProfile?> userProfile(String uid)=>_db.getUserFromFirebase(uid);

  //update user bio
  Future<void> updateBio(String bio)=>_db.updateUserBioInFirebase(bio);

  /*
  POSTS

   */

  //local list of post
  List<Post> _allPosts=[];
  List<Post> _followingPosts=[];

  //get post
  List<Post> get allPost=>_allPosts;
  List<Post> get followingPosts=>_followingPosts;

  //post message
  Future<void> postMessage(String message)async{
    //post message in firebase
    await _db.postMessageInFirebase(message);
    //reload data from firebase
    await loadAllPosts();
  }

  //fetch all post
  Future<void> loadAllPosts()async{
    //get all post form firebase
    final allPosts=await _db.getAllPostsFromFirebase();
    //get blocked user ids
    final blockedUserIds=await _db.getBlockedUidsFromFirebase();
    //filter out blocked user posts  and update locally
    _allPosts=allPosts.where((post)=>!blockedUserIds.contains(post.uid)).toList();

    //filter out the following posts
    loadFollowingPosts();


    //update local data
  
    //initalize local local like data
    initializeLikeMap();

    //update ui
    notifyListeners();
  }

  //filter and return post given uid
  List<Post> filterUserPosts(String uid){
    return _allPosts.where((post) => post.uid==uid).toList();
  }

  //load following posts->posts from users that the current user follows
  Future<void> loadFollowingPosts()async{
     //get current user uid
     String currentId=_auth.getCurrentUid();

     //get list of uid that current logged in user follows(from firebase)
     final followingUserId=await _db.getFollowingUidsFromFirebase(currentId);

     //filter all poststo be the one from the following tab
     _followingPosts=
     _allPosts.where((post) => followingUserId.contains(post.uid)).toList();


     //update the ui
     notifyListeners();
  }

  //delete a post

  Future<void> deletePost(String postId)async{
    //delete from firebase
    await _db.deletePostFromFirebase(postId);


    //reload data  from firebase
    await loadAllPosts();


  }

  //section for the likes


  /*
  Likes
  */

  //local map to track like counts for post
  Map<String ,int> _likeCounts={
    //for each post id like count 
  };

  //local list to track posts  likes by current user 
  List<String> _likedPosts=[];

  //does the current user like this post?
  bool isPostLikedByCurrentuser(String postId)=>_likedPosts.contains(postId);

  //get like count for a post
  int getLikeCount(String postId)=>_likeCounts[postId]!;

  //initalize like post locally
  void initializeLikeMap(){
    //get current user uid
    final currentUserID=_auth.getCurrentUid();

    //for each post get like data 
    for(var  post in _allPosts){
      //update like count map
      //This line updates the _likeCounts Map to store the current likeCount of the post under its unique id.
      _likeCounts[post.id]=post.likeCount;//post.likeCount refers to the current number of likes for the post.

      //if the current user already like this post 
      if(post.likedBy.contains(currentUserID)){

        //add this id to the local list of like post 
        _likedPosts.add(post.id);
      }
    }

 


  }
     //toggle like 
    Future<void> toggleLike(String postId)async{
      /*
      this first part will update the local value first , so that the ui feels immediately and reposniveness,
      will update the ui optimistically , and revert back if anything goes wrong while writing to the data base 

      optimistically updating the local value likes this is important because :
      reading and writing from the database take some time (1-2, depending on the internet conncetion ), so we donot wan
      want to give  the user  a slow lagged experince 
      */

      //store orignal value in case it is fail 
      final likedPostsOriginal=_likedPosts;
      final likedCountOriginal=_likeCounts;

      //perform like and unlike locally
      if(_likedPosts.contains(postId)){
        _likedPosts.remove(postId);
        _likeCounts[postId]=(_likeCounts[postId]??0)-1;
      }else{ 
         _likedPosts.add(postId);
        _likeCounts[postId]=(_likeCounts[postId]??0)+1;

      }

      //update ui locally
      notifyListeners();

      //atempt like in database

      
      try{
        await _db.toggleLikeInFirebase(postId);


      }
      //revert back to the initial state if updae fails
      catch(e){
        _likedPosts=likedPostsOriginal;
        _likeCounts=likedCountOriginal;

        //update ui agian
        notifyListeners();



      }


    }

    /**
     COMMENTS

     {
     postId1:[comment1, comment2,....]
     postId2:[comment1, comment2, .....]
     postId3: [comment1, comment2,.....]



     
     }
     */

    //local Map of comment
    final Map<String, List<Comment>> _comments={};

    //get comment locally
    List<Comment> getComments(String postId)=>_comments[postId]??[];

    //fetch comment from database for  a post
    Future<void> loadComment(String postId)async{
      //get all comment for this post 
      final allComments=await _db.getCommentsFromFirebase(postId);

      //update local data
      _comments[postId]=allComments;

      //update ui
      notifyListeners();

    }

    //add a comment
    Future<void> addComment(String postId, message)async{

      //add comment in firebase
      await _db.addCommentInFirebase(postId, message);

      //reload comment
      await loadComment(postId);

    }



    //delete a comment
    Future<void> deleteComment(String commentId, postId)async{

      //delete comment in firebase
      await _db.deleteCommentInFirebase(commentId);

      //reload Comments
       await loadComment(postId);

    }

    /*
    ACCOUNT STUFF
     */

    //local List of blocked user
    List<UserProfile> _blockedUsers=[];

    //get List of blcoked users
    List<UserProfile> get blockedUsers=>_blockedUsers;

    //fetch blocked user
    Future<void> loadBlockedUsers()async{
      //get list of blocked user ids
      final blockedUserId=await _db.getBlockedUidsFromFirebase();

      //get full user details using uids
      //Future.wait(...): Runs all these futures (calls to _db.getUserFromFirebase) concurrently and waits for all of them to complete.
      //await: Ensures the program waits until all the futures are completed before moving to the next line.
 
      final blocedUsersData=await Future.wait(
        blockedUserId.map((id) => _db.getUserFromFirebase(id))
      );

      //return as a list
      //Filters blocedUsersData to keep only objects of type UserProfile
      //whereType<UserProfile>(): Filters out invalid or null values.
      //Converts the filtered data into a list using .toList().
      _blockedUsers=blocedUsersData.whereType<UserProfile>().toList();

      //update the ui
      //Calls notifyListeners() to notify all listeners (e.g., widgets using ChangeNotifier) that _blockedUsers has been updated.
      notifyListeners();
    }
    //block user 
    Future<void> blockUser(String userId)async{
      //perform block in firebase
      await _db.blockUserInFirebase(userId);
      //reload blocked user
      await loadBlockedUsers();
      //reload data
     await loadAllPosts();

      //update the ui
      notifyListeners();
    }
    //unblock user
    Future<void> unblockUser(String blockedUserId)async{
      //perform unblock in firbase 
      await _db.unblockUserInFirebase(blockedUserId);

      //reload blocke user
      await loadBlockedUsers();

      //reload data 
      await loadAllPosts();

      //update the ui
      notifyListeners();
    }
    //report user and post 
    Future<void> reportUser(String postId, userId)async{
      await _db.reportUserInFirebase(postId, userId);
    }

    /*

    FOLLOW

    EVERYTHING HERE IS DONE WITH UIDs
    -----------------------------------------------------------------

    Each user id is list of:
    -followers uid
    -following uid

    e.g

    {
    "uid1":[List of uid here are following and follower]
    "uid2":[List of uid here are following and follower]
    "uid3":[List of uid here are following and follower]
    "uid4":[List of uid here are following and follower]
    "uid5":[List of uid here are following and follower]
    "uid6":[List of uid here are following and follower]
    
    }
     */


    //local map

    final Map<String, List<String>> _followers={};
    final Map<String, List<String>> _following={};
    final Map<String, int> _followerCount={};
    final Map<String, int> _followingCount={};

    //get count for the follower and following locally:given uid
    int getFollowerCount(String uid)=>_followerCount[uid]??0;
    int getFollowingCount(String uid)=>_followingCount[uid]??0;

    //load follower
    Future<void> loadUserFollowers(String uid)async{
      //get list of follower uids from firebase
      final listOfFollowerUids=await _db.getFollowerUidsFromFirebase(uid);

      //update local data
      _followers[uid]=listOfFollowerUids;
      _followerCount[uid]=listOfFollowerUids.length;

      //update ui
      notifyListeners();

    }
    //load following
     Future<void> loadUserFollowing(String uid)async{
      //get list of follower uids from firebase
      final listOfFollowingUids=await _db.getFollowingUidsFromFirebase(uid);

      //update local data
      _following[uid]=listOfFollowingUids;
      _followingCount[uid]=listOfFollowingUids.length;

      //update ui
      notifyListeners();

    }

    //follow user 
    Future<void> followUser(String targetUserId)async{
      /*
      
      Currently logged in user want to follow target user 
       */
      //get current uid
      final currentUserId=_auth.getCurrentUid();
      //initialize with empty list if null
      _following.putIfAbsent(currentUserId, () => []);
      _followers.putIfAbsent(targetUserId, () => []); 

      
     // Optimistic Ui Change:Update the local data and revert back if the data request fails

     //follow if current user is not one of the target users follower 
     if(!_followers[targetUserId]!.contains(currentUserId)){
      //add current user to the the target user's following list 
      _followers[targetUserId]?.add(currentUserId);

      //update the follower count 
      _followerCount[targetUserId]=(_followerCount[targetUserId]??0)+1;

      //then add the target user to the current user following list 
      _following[currentUserId]?.add(targetUserId);

      //update the following count
      _followerCount[currentUserId]=(_followingCount[currentUserId]??0)+1;
     }

     //update the ui
     notifyListeners();

     //UI as beeen optimisticaly update above woth local data 
     //Now let try to make this request to our database 
     try{
      //follow user in fiebase
      await _db.followUserInFirebase(targetUserId);
      //reload current user followers
     await loadUserFollowers(currentUserId);

      //reload current user following 
      await loadUserFollowing(currentUserId);

     }
     //if there is an error revert back to the original value
     catch(e){
      //remove current user from target user follower
      _followers[targetUserId]?.remove(currentUserId);

      //update follower count
      _followerCount[targetUserId]=(_followerCount[targetUserId]??0)-1;

      //remove from the current user following 
      _following[currentUserId]?.remove(targetUserId);

      //update the following count
      _followingCount[currentUserId]=(_followingCount[currentUserId]??0)-1;

      //update the ui
      notifyListeners();

     }
       
    }

    //unfollow user
    Future<void> unFollowUser(String targetUserId)async{

      /**
       currentlt logged in user want ot unfollow the target user

       */
      //get current user
        final currentUserId=_auth.getCurrentUid();
      


      //initilaize the list if they donot exits
      _following.putIfAbsent(currentUserId, () => []);
      _followers.putIfAbsent(targetUserId, () => []); 

      //Optimistic ui change:update the local data first & revert back if the database request fails 

      //unfollow if the current user is one of the traget user following 
      if(_followers[targetUserId]!.contains(currentUserId)){
        //remove current user from the target user's following list
        _followers[targetUserId]?.remove(currentUserId);

        //update the follower count 
        _followerCount[targetUserId]=(_followerCount[targetUserId]??1)-1;
        //remove target user from the current user following list 
        _following[currentUserId]?.remove(targetUserId);

        //update the following count
        _followingCount[currentUserId]=(_followingCount[currentUserId]??1)-1;
      }

      //update the ui
     notifyListeners();

      //UI has been optimistically update with local data above
      //now let try to make this request to our database 

      try{
        //unfollow target user in firbase
        await _db.UnFollowUserInFirebase(targetUserId);

        //reload user followers
        await loadUserFollowers(currentUserId);

        //reload user following 
        await loadUserFollowing(currentUserId);

      }
      //if there is an error revert back to the original value 
      catch(e){
        //add current user back to the target user followers
         _followers[targetUserId]?.add(currentUserId);


        //update the follower count 
         _followerCount[targetUserId]=(_followerCount[targetUserId]??1)+1;

        //add target user back to the current users following list 
         _following[currentUserId]?.remove(targetUserId);

        //uppate the folllowing count 
         _followingCount[currentUserId]=(_followingCount[currentUserId]??1)+1;


         //update the ui
         notifyListeners();
  

      }

    }

    //is current user following the target user 
    bool isFollowing(String uid){
      final currentUserId=_auth.getCurrentUid();
      return _followers[uid]?.contains(currentUserId)??false;
    }

    /*
    MAP OF PROFILE

    for a given uid:

    -list of follower profiles
    -list of following profile
    
     */
    final Map<String, List<UserProfile>> _followersProfile={};
    final Map<String, List<UserProfile>> _followingProfile={};
    

    //get list of follower profiles for a given user 

    List<UserProfile> getListOfFollowersProfile(String uid)=>
    _followersProfile[uid]??[];

    //get list of following profiles for a given user 
    List<UserProfile> getListOfFollowingProfile(String uid)=>
    _followingProfile[uid]??[];

    //load a follower profile for a given uid 
    Future<void> loadUserFollowerProfiles(String uid)async{
      try{
        //get list of folower uid from firebase 
        final  followerIds=await _db.getFollowerUidsFromFirebase(uid);

        //create list of userprofile
        List<UserProfile> followerProfiles=[];


        //go to each follower id
        for(String followerId in followerIds){
          //get user profile from firebase with this uid
          UserProfile? followerProfile=await _db.getUserFromFirebase(followerId);

          //add to the follower profile 
          if(followerProfile!=null){
            followerProfiles.add(followerProfile);
          }

        }

        //update local data
        _followersProfile[uid]=followerProfiles;

        //update ui
        notifyListeners();

      }
      //if there are error
      catch(e){
        print(e);

      }

    }

    //load a following profile for a given uid 
    
    Future<void> loadUserFollowingProfiles(String uid)async{
      try{
        //get list of folowing uid from firebase 
        final  followingIds=await _db.getFollowingUidsFromFirebase(uid);

        //create list of userprofile
        List<UserProfile> followingProfiles=[];


        //go to each follower id
        for(String followingId in followingIds){
          //get user profile from firebase with this uid
          UserProfile? followingProfile=await _db.getUserFromFirebase(followingId);

          //add to the follower profile 
          if(followingProfile!=null){
            followingProfiles.add(followingProfile);
          }

        }

        //update local data
        _followingProfile[uid]=followingProfiles;

        //update ui
        notifyListeners();

      }
      //if there are error
      catch(e){
        print(e);

      }

    }

    /**
     SEARCH USER
     */

    List<UserProfile> _searchResult=[];

    //get list of search result
    List<UserProfile> get searchResult=>_searchResult;


    //method to search for user

    Future<void> searchUser(String searchTerm)async{
      try{
        //search user in firebase
        final result=await _db.searchUserInFirebase(searchTerm);

        //update local data
        _searchResult=result;

        //update the ui
        notifyListeners();


      }catch(e){
        print(e);

      }

    }
    








}