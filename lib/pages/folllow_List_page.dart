import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:twiter_clone/components/my_user_tile.dart';
import 'package:twiter_clone/model/user_model.dart';
import 'package:twiter_clone/services/database/database_provider.dart';

class FollowListPage extends StatefulWidget {
  final String uid;
  const FollowListPage({super.key, required this.uid});

  @override
  State<FollowListPage> createState() => _FollowListPageState();
}

class _FollowListPageState extends State<FollowListPage> {
  //provider
  late final listeningProvider=Provider.of<DatabaseProvider>(context);
  late final databaseProvider=Provider.of<DatabaseProvider>(context, listen: false);

   @override
   void  initState(){
    super.initState();

    //load user follower list
    loadFollowerList();


    //load user foloowing list
    loadFollowingList();
   }

   //load  user followers
   Future<void> loadFollowerList()async{
    await databaseProvider.loadUserFollowerProfiles(widget.uid);
   }
   //load user following
   Future<void> loadFollowingList()async{
    await databaseProvider.loadUserFollowingProfiles(widget.uid);
   }
  @override
  Widget build(BuildContext context) {
    //listen to the follower and following
    final followers= listeningProvider.getListOfFollowersProfile(widget.uid);
    final following=listeningProvider.getListOfFollowingProfile(widget.uid);

    



    return DefaultTabController(
      length: 2,
       child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppBar(
          foregroundColor: Theme.of(context).colorScheme.primary,
          bottom: TabBar(
            dividerColor: Colors.transparent,
            labelColor: Theme.of(context).colorScheme.inversePrimary,
            unselectedLabelColor: Theme.of(context).colorScheme.primary,
            indicatorColor: Theme.of(context).colorScheme.secondary,
            tabs: [
              Tab(
                text: "Followers",
              ),
              Tab(
                text: "Following",
              )
            ]
            ),
        ),
        body: TabBarView(
          children: [
            _buildUserList(followers, "No followers.."),

            _buildUserList(following, "No following..")
          ]
          ),
       )
       );
  }
  //build user list, given a list of user profile 
  Widget _buildUserList(List<UserProfile> userList, String emptyMessage){
    return userList.isEmpty
    ?
    //return empty message if there are no user
    Center(
      child: Text(emptyMessage),
      
    )
    :ListView.builder(
      itemCount: userList.length,
      itemBuilder: (context, index){
        //get each user
        final user=userList[index];
        print(user.name);

        //return as user list tile
        return MyUserTile(user: user);
      }
      );
  }
}