
/*

PROFILE PAGE

this is profile page for given uid



*/

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:twiter_clone/components/my_bio_box.dart';
import 'package:twiter_clone/components/my_follower_button.dart';
import 'package:twiter_clone/components/my_input_alert_box.dart';
import 'package:twiter_clone/components/my_post_tile.dart';
import 'package:twiter_clone/components/my_profile_state.dart';
import 'package:twiter_clone/helper/navigate_page.dart';
import 'package:twiter_clone/model/user_model.dart';
import 'package:twiter_clone/pages/folllow_List_page.dart';
import 'package:twiter_clone/services/auth/auth_services.dart';
import 'package:twiter_clone/services/database/database_provider.dart';

class ProfilePage extends StatefulWidget {

  final String uid;
  const ProfilePage({super.key, required this.uid});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  //provider
  late final listeningProvider=Provider.of<DatabaseProvider>(context);
  late final databaseProvider=Provider.of<DatabaseProvider>(context, listen: false);

  //user info
  UserProfile? user;
  String currentUserId=AuthServices().getCurrentUid();
  //textController for bio
  final bioTextController=TextEditingController();

  //loading....
  bool _isLoading=true;

  //isFollowing state 
  bool _isFollowing=false;

  @override
  void initState() {
    // TODO: implement initState
    
    //let load user info
    loadUser();
  }

  Future<void> loadUser()async{
    //get the user profile info
    user=await databaseProvider.userProfile(widget.uid);

    //load follower and following for this user 
    await databaseProvider.loadUserFollowers(widget.uid);
    await databaseProvider.loadUserFollowing(widget.uid);

    //update the following state 
    _isFollowing=databaseProvider.isFollowing(widget.uid);

    //finish loading 
    setState(() {
      _isLoading=false;
    });
  }
  void _showEditBioBox(){
    showDialog(
      context: context,
       builder: (context)=>MyInputAlertBox(
        textController: bioTextController,
         hintText: "Edit Bio...",
          onPressed: saveBio,
           onPressedText: "Save",
           )
       );
  }

  //save updated bio
  Future<void> saveBio()async{
    //start loading...
    setState(() {
      _isLoading=true;
    });

    //update bio

    await databaseProvider.updateBio(bioTextController.text);

    //realod user
    await loadUser();


    //done loading
    setState(() {
      _isLoading=false;
    });


  }
  //toggle follow -->follow/unFollow
  Future<void> toggleFollow()async{
    //unfollow
    if(_isFollowing){
      showDialog(
        context: context,
         builder: (context)=>AlertDialog(
          title: Text("UnFollow"),
          content: Text("Are you sure you want to unfollow?"),
          actions: [
            //cancel
            TextButton(
              onPressed: (){
                Navigator.pop(context);
              },
               child: Text("Cancel")
               ),
               TextButton(
                onPressed: ()async{
                  Navigator.pop(context);
                  await databaseProvider.unFollowUser(widget.uid);


                },
                 child: Text("Yes")
                 )

          ],
         )
         );
    }
    //follow
    else{
      await databaseProvider.followUser(widget.uid);
    }
    //update isFolowing state
    setState(() {
      _isFollowing=!_isFollowing;
    });
  }



 //build ui
  @override
  Widget build(BuildContext context) {
    //get user post
    final allUserPost=listeningProvider.filterUserPosts(widget.uid);

    //listen to the following

    _isFollowing=listeningProvider.isFollowing(widget.uid);

    //listen to the follower and following count 
    final followerCount=listeningProvider.getFollowerCount(widget.uid);
    final followingCount=listeningProvider.getFollowingCount(widget.uid);
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        centerTitle: true,
        title: Text(_isLoading? '': user!.name),
        leading: IconButton(
          onPressed: ()=>goHomePage(context),
           icon: Icon(Icons.arrow_back)
           ),
        foregroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: ListView(
        children: [
          //user name handle
          Center(
            child: Text(_isLoading? '':'@${user!.username}',
            style: TextStyle(color: Theme.of(context).colorScheme.primary),
            ),
          ),
          SizedBox(height: 25,),
      
      
      
          //profile  picture
          Center(
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                borderRadius: BorderRadius.circular(25),
              ),
              padding: EdgeInsets.all(25),
              child: Icon(
                Icons.person,
                size: 72,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          SizedBox(height: 25,),
      
      
          //profile status->nomber of post/follower/following
          MyProfileStats(
            postCount: allUserPost.length,
             followerCount: followerCount,
              followingCount: followingCount,
              onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>FollowListPage(uid: widget.uid,)))
              ),

      
          //follow/unfollow
         //only show if user is viewing someone else profile 
         if(user!=null && user!.uid!=currentUserId)
          MyFollowButton(
            onPressed: toggleFollow,
            isFollowing: _isFollowing
            ),
      
          //edit bio
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Bio",
                style: TextStyle(color: Theme.of(context).colorScheme.primary),
                ),
                //only show edit button if it is curent user page 
                if(user !=null&& user!.uid==currentUserId)
                GestureDetector(
                  onTap: _showEditBioBox,
                  child: Icon(Icons.settings)
                  )
                  
                  
              ],
            ),
          ),
          SizedBox(height: 10,),
      
          //bio box
          MyBioBox(text: _isLoading? '....':user!.bio),

          Padding(
            padding: EdgeInsets.only(left: 25, top: 20),
            child: Text(
              "Posts",
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary
              ),
            ),
          ),
      
          //list of postfrom user
          allUserPost.isEmpty?
      
          //user post is empty
          Center(
            child: Text("No Posts yet..."),
          )
          //user post is not empty
          :ListView.builder(
            itemCount: allUserPost.length,
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index){
              //get indivdual post
              final post=allUserPost[index];
      
              //post tile ui
              return MyPostTie(
                post: post,
                onUserTap: (){},
                onPostTap: ()=>goPostPage(context, post),

                
                );
      
      
            }
            )
      
        ],
      )
    );
  }
}