

/*
POST  TILE
all post will be displayed using this postile widget
-------------------------------------------------------

to use this widget we need
-post

-a function for onPostTap(go to the individual post to see it comment)
-A function for onUserTap(go to the user profile page )
 */

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:twiter_clone/components/my_input_alert_box.dart';
import 'package:twiter_clone/helper/time_formater.dart';
import 'package:twiter_clone/model/post.dart';
import 'package:twiter_clone/services/auth/auth_services.dart';
import 'package:twiter_clone/services/database/database_provider.dart';

class MyPostTie extends StatefulWidget {
  final Post post;
  final void Function()? onUserTap;
  final void Function()? onPostTap;

  const MyPostTie({super.key, required this.post, required this.onUserTap, required this.onPostTap});

  @override
  State<MyPostTie> createState() => _MyPostTieState();
}

class _MyPostTieState extends State<MyPostTie> {

  //Provider
  late final listeningProvider=Provider.of<DatabaseProvider>(context);
  late final databaseProvider=Provider.of<DatabaseProvider>(context, listen: false);

  final _commentCotroller=TextEditingController();

  @override
  void initState() {
   
    super.initState();
    //load comment for this post 
    _loadComments();
  }

  //likes
  //user tapped like or unlike
  void _toggleLikePost()async{
    try{
      await databaseProvider.toggleLike(widget.post.id);


    }catch(e){
      print(e);
    }
  }

  //Comments

  //open a comment box user want to types new comment 
  void _openNewCommentBox(){
    showDialog(
      context: context,
       builder: (context)=>MyInputAlertBox(
        textController: _commentCotroller,
         hintText: "Types a comment..",
          onPressed: ()async{
            //ad post in data vase
            await _addComment();

          },
           onPressedText: ('Post')
           ),
       );
  }
  //user tapped post to add comment

  Future<void> _addComment()async{
    //does nothing if there is nothing the text field 
    if(_commentCotroller.text.trim().isEmpty) return;

    //atempt to post comment
    try{
      await databaseProvider.addComment(widget.post.id, _commentCotroller.text.trim());

    }catch(e){
      print(e);

    }

  }

  //load comment
  Future<void>  _loadComments()async{
    await databaseProvider.loadComment(widget.post.id);

    
  }
  /*
  SHOW OPTIONS
  Case 1: this post belong to the current user
  -Delete
  -cancel

  Case 2: this post doesnot belong to the current user 
  -Report
  -Block
  -Cancel

  
   */


//show option for post 
  void _showOption(){
    //check if the post is own by user or not 
    String currentUid=AuthServices().getCurrentUid();
    final bool isOwnPost=widget.post.uid==currentUid;
    showModalBottomSheet(
      context: context,
       builder: (context){
        return SafeArea(
          child: Wrap(
            children: [

              //this post belong to the current user
              if(isOwnPost)
              //delete message button
              ListTile(
                leading: Icon(Icons.delete),
                title: Text("Delete"),
                onTap: ()async{
                  //pop ption box
                  Navigator.pop(context);

                  //handle delete action
                  await databaseProvider.deletePost(widget.post.id);


                },
              )
              //this post does not belon to the user 
             else ...[
              //report post button
               ListTile(
                leading: Icon(Icons.flag),
                title: Text("Report"),
                onTap: (){
                        //pop option box
                  Navigator.pop(context);
                  //handle report action
                  _reportPostConfirmationBox();
                },
              ),
              //block user button
                ListTile(
                leading: Icon(Icons.block),
                title: Text("Block User"),
                onTap: (){
                        //pop option box
                  Navigator.pop(context);
                  //handle block action
                  _blockPostConfirmationBox();
                },
              ),

              
             ],
              //cancel button
              ListTile(
                leading: Icon(Icons.cancel),
                title: Text("Cancel"),
                onTap: (){},
              )
            ],
          
          ),
        );
       }
       );

  }
  //report psot confirmation
  void _reportPostConfirmationBox(){
    showDialog(
      context: context,
       builder: (context)=>AlertDialog(
        title: Text("Report Message"),
        content: Text("Are you sure you want to report this user"),
        actions: [
          //cancel button
          TextButton(
            onPressed: (){
              Navigator.pop(context);
            },
             child: Text("Cancel")
             ),
             //report button
              TextButton(
            onPressed: ()async{
            
              //report user
              await databaseProvider.reportUser(widget.post.id, widget.post.uid);
              
              

              //let user know it was successfuly reported 
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Message Reported Successfuly"))
              );
                //close box
              Navigator.pop(context);
            },
             child: Text("Report")
             ),
        ],
       )
       );
  }
  //block user confirmation
    void _blockPostConfirmationBox(){
    showDialog(
      context: context,
       builder: (context)=>AlertDialog(
        title: Text("Block User"),
        content: Text("Are you sure you want to block this user"),
        actions: [
          //cancel button
          TextButton(
            onPressed: (){
              Navigator.pop(context);
            },
             child: Text("Cancel")
             ),
             //block button
              TextButton(
            onPressed: ()async{
            
              //report user
              await databaseProvider.blockUser(widget.post.uid);
              
              

              //let user know it was successfuly reported 
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("User Blocked!"))
              );
                //close box
              Navigator.pop(context);
            },
             child: Text("Block")
             ),
        ],
       )
       );
  }
  //build ui
  @override
  Widget build(BuildContext context) {

    //does the current user like this post
    bool likedByCurrentuser=listeningProvider.isPostLikedByCurrentuser(widget.post.id);

    //litsen to like count
    int likeCount=listeningProvider.getLikeCount(widget.post.id);

    //listen to the comment count
    int commentCount=listeningProvider.getComments(widget.post.id).length;

    return GestureDetector(
      onTap: widget.onPostTap,
      child: Container(
        //padding outside
        margin: EdgeInsets.symmetric(horizontal: 25, vertical: 5),
      
        //padding inside
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
      
          //curve curnor
          borderRadius: BorderRadius.circular(8)
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
               onTap: widget.onUserTap,
              child: Row(
                children: [
                  //profile pic
                  Icon(Icons.person,
                  color: Theme.of(context).colorScheme.primary,
                  ),
                  SizedBox(width: 10,),
                  //name
                  Text(widget.post.name,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold
                  ),
                  ),
                  SizedBox(width: 5,),
                  //username handle
                  Text("@${widget.post.username}",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary
                  ),
                  ),
                  Spacer(),

                  //button->more option:delete
                  GestureDetector(
                    onTap: _showOption,
                    child: Icon(Icons.more_horiz,
                    color: Theme.of(context).colorScheme.primary,
                    )
                    ),
                ],
              ),
            ),
            SizedBox(height: 10,),
            //message
            Text(
              widget.post.message,
              style: TextStyle(
                color: Theme.of(context).colorScheme.inversePrimary
              ),
            ),
            SizedBox(height: 20,),
            //button --> like +comment
            Row(
              children: [
                SizedBox(
                  width: 50,
                  child: Row(
                    children: [
                           //like button
                  GestureDetector(
                    onTap: _toggleLikePost,
                    child: likedByCurrentuser
                    ?Icon(
                      Icons.favorite,
                      color: Colors.red,
                    )
                    :Icon(Icons.favorite_border, color: Theme.of(context).primaryColor,)
                  ),
                  SizedBox(width: 5,),
                  //like count
                  Text(likeCount!=0?likeCount.toString():'',
                  style: TextStyle(color: Theme.of(context).colorScheme.primary),
                  ),
                    ],
                  ),
                ),

                //comment section
                Row(
                  children: [
                    //comment button
                    GestureDetector(
                      onTap: _openNewCommentBox,
                      child: Icon(
                        Icons.comment,
                         color: Theme.of(context).colorScheme.primary,)
                        ),

                    //comment count
                    Text(commentCount!=0?commentCount.toString():'',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary
                    ),
                    )

                  ],
                ),
                Spacer(),
                //time stamp
                Text(formatTimestamp(widget.post.timestamp), style: TextStyle(color: Theme.of(context).colorScheme.primary),)
           
              ],
            ),
          ],
        ),
      ),
    );
  }
}
