





import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:twiter_clone/model/comment.dart';
import 'package:twiter_clone/services/auth/auth_services.dart';
import 'package:twiter_clone/services/database/database_provider.dart';

class MyCommentTile extends StatelessWidget {
  final Comment comment;
  final void Function()? onUserTap;
  const MyCommentTile({super.key, required this.comment, required this.onUserTap});

  
  void _showOption(BuildContext context){
    //check if the post is own by user or not 
    String currentUid=AuthServices().getCurrentUid();
    final bool isOwnComment=comment.uid==currentUid;
    showModalBottomSheet(
      context: context,
       builder: (context){
        return SafeArea(
          child: Wrap(
            children: [

              //this comment belong to the current user
              if(isOwnComment)
              //delete message button
              ListTile(
                leading: Icon(Icons.delete),
                title: Text("Delete"),
                onTap: ()async{
                  //pop ption box
                  Navigator.pop(context);

                  //handle delete action
                  await Provider.of<DatabaseProvider>(context, listen: false).deleteComment(comment.id, comment.postId);


                },
              )
              //this Comment  does not belon to the user 
             else ...[
              //report comment button
               ListTile(
                leading: Icon(Icons.flag),
                title: Text("Report"),
                onTap: (){
                        //pop option box
                  Navigator.pop(context);
                },
              ),
              //block user button
                ListTile(
                leading: Icon(Icons.block),
                title: Text("Block User"),
                onTap: (){
                        //pop option box
                  Navigator.pop(context);
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

  @override
  Widget build(BuildContext context) {
    return Container(
        //padding outside
        margin: EdgeInsets.symmetric(horizontal: 25, vertical: 5),
      
        //padding inside
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.tertiary,
      
          //curve curnor
          borderRadius: BorderRadius.circular(8)
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
               onTap: onUserTap,
              child: Row(
                children: [
                  //profile pic
                  Icon(Icons.person,
                  color: Theme.of(context).colorScheme.primary,
                  ),
                  SizedBox(width: 10,),
                  //name
                  Text(comment.name,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold
                  ),
                  ),
                  SizedBox(width: 5,),
                  //username handle
                  Text("@${comment.username}",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary
                  ),
                  ),
                  Spacer(),

                  //button->more option:delete
                  GestureDetector(
                    onTap: ()=>_showOption(context),
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
              comment.message,
              style: TextStyle(
                color: Theme.of(context).colorScheme.inversePrimary
              ),
            ),
            SizedBox(height: 20,),
     
          ],
        ),
      );
  }
}