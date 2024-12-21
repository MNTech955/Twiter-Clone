

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:twiter_clone/components/my_drawer.dart';
import 'package:twiter_clone/components/my_input_alert_box.dart';
import 'package:twiter_clone/components/my_post_tile.dart';
import 'package:twiter_clone/helper/navigate_page.dart';
import 'package:twiter_clone/model/post.dart';
import 'package:twiter_clone/services/database/database_provider.dart';

/*

HOME PAGE

this is the home page of the app it display all the post

*/

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //access provider
   late final listeningProvider=Provider.of<DatabaseProvider>(context);
  late final databaseProvider=Provider.of<DatabaseProvider>(context, listen: false);
 
  //text controller
  final _messageController=TextEditingController();

  @override
  void initState() {
    
    super.initState();
    loadAllPosts();
  }

  //load all post
  Future<void> loadAllPosts()async{
    await databaseProvider.loadAllPosts();
  }
  //show a post message dialog box
  void _openPostMessageBox(){
    showDialog(
      context: context,
       builder: (context)=>MyInputAlertBox(
        textController: _messageController,
         hintText: "What's on your mind?",
          onPressed: ()async{
            //post in database
            await postMessage(_messageController.text);
            
            
          },
           onPressedText: "Post",
           )
       
       );
  }
  //user want to post a message 
  Future<void> postMessage(String message)async{
    await databaseProvider.postMessage(message);

  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      //TAB CONTROLLR:2 option->for you/following
      length: 2,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        drawer: MyDrawer(),
        appBar: AppBar(
          centerTitle: true,
          title: Text("H O M E",
          
          ),
          foregroundColor: Theme.of(context).colorScheme.primary,
              bottom: TabBar(
            dividerColor: Colors.transparent,
            labelColor: Theme.of(context).colorScheme.inversePrimary,
            unselectedLabelColor: Theme.of(context).colorScheme.primary,
            indicatorColor: Theme.of(context).colorScheme.secondary,
            tabs: [
              Tab(
                text: "For you",
              ),
              Tab(
                text: "Following",
              )
            ]
            ),
       
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _openPostMessageBox,
          child: Icon(Icons.add),
          ),
          //list of all post
          body: TabBarView(
            children: [
              _buildPostList(listeningProvider.allPost),
              _buildPostList(listeningProvider.followingPosts),
            ]
            )
      ),
    );
  }
  Widget _buildPostList(List<Post> posts){
    return posts.isEmpty?

    //post is empty
    Center(
      child: Text("Nothing here..."),

    )
    //post list is not empty
    :
    ListView.builder(
      itemCount: posts.length,
      itemBuilder: (context, index){
        //get each individual post
        final post=posts[index];

        //return  post tile ui
        return MyPostTie(
          post: post,
           onUserTap: ()=>goUserPage(context, post.uid),
           onPostTap: ()=>goPostPage(context, post),
        

        );
      },
    );

    
  }
}