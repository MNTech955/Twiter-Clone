

/*
POST PAGE 

--individual post
--comment on the post 

*/


import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:twiter_clone/components/my_comment_tile.dart';
import 'package:twiter_clone/components/my_post_tile.dart';
import 'package:twiter_clone/helper/navigate_page.dart';
import 'package:twiter_clone/model/post.dart';
import 'package:twiter_clone/services/database/database_provider.dart';

class PostPage extends StatefulWidget {
  final Post post;
  const PostPage({super.key, required this.post});

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
   late final listeningProvider=Provider.of<DatabaseProvider>(context);
  late final databaseProvider=Provider.of<DatabaseProvider>(context, listen: false);
  @override
  Widget build(BuildContext context) {
    //listen to all comment for this post
    final allComments=listeningProvider.getComments(widget.post.id);
    return Scaffold(
      backgroundColor:  Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        foregroundColor: Theme.of(context).colorScheme.primary,
        centerTitle: true,
        title: Text(widget.post.message),
      ),
      body: ListView(
        children: [
          //post
          MyPostTie(
            post: widget.post,
             onUserTap: ()=>goUserPage(context, widget.post.uid),
              onPostTap: (){},
              ),

              //comment on this post 
              allComments.isEmpty
              ?
              //no comment yet...
              Center(
                child: Text("No Comment yet..."),
              )

              //comments exit
              :
              ListView.builder(
                itemCount: allComments.length,
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index){
                  //get each comment
                  final comment=allComments[index];

                  //return as comment tile ui
                  return MyCommentTile(comment: comment, onUserTap: ()=>goUserPage(context, comment.uid));

                }
                )
        ],
      ),
    );
  }
}