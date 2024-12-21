

/*
BLOCKED USER PAGE 
-this page display all the user that as been blocked 
-you can unblocked the user from here 
 */

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:twiter_clone/services/database/database_provider.dart';

class BlockedUserPage extends StatefulWidget {
  const BlockedUserPage({super.key});

  @override
  State<BlockedUserPage> createState() => _BlockedUserPageState();
}

class _BlockedUserPageState extends State<BlockedUserPage> {
  late final listeningProvider=Provider.of<DatabaseProvider>(context);
  late final databaseProvider=Provider.of<DatabaseProvider>(context, listen: false);

  //on startuf
  @override
  void initState() {
    
    super.initState();
    //load all blocked user
    loadBlockedUsers();
  }
  Future<void> loadBlockedUsers()async{
    await databaseProvider.loadBlockedUsers();
  }
  //show confirm unblock box 
     void _showUnblockConfimationBox(String userId){
    showDialog(
      context: context,
       builder: (context)=>AlertDialog(
        title: Text("Unblock User"),
        content: Text("Are you sure you want to Unblock this user"),
        actions: [
          //cancel button
          TextButton(
            onPressed: (){
              Navigator.pop(context);
            },
             child: Text("Cancel")
             ),
             //unblock button
              TextButton(
            onPressed: ()async{
            
              //Unblock user
              await databaseProvider.unblockUser(userId);
              
              

              //let user know it was successfuly reported 
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("User Unblocked!"))
              );
                //close box
              Navigator.pop(context);
            },
             child: Text("Unblock")
             ),
        ],
       )
       );
  }

  //build ui
  @override
  Widget build(BuildContext context) {
    final blockedUsers=listeningProvider.blockedUsers;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,

      //appbar
      appBar: AppBar(
        centerTitle: true,
        title: Text("Blocked Users"),
        foregroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: blockedUsers.isEmpty?
      Center(
        child: Text("No Blocked users..."),
      )
      :ListView.builder(
        itemCount: blockedUsers.length,
        itemBuilder: (context, index){
          final user=blockedUsers[index];
          return ListTile(
            title: Text(user.name),
            subtitle: Text("@"+user.username),
            trailing: IconButton(
              onPressed: ()=>_showUnblockConfimationBox(user.uid), 
               icon: Icon(Icons.block)
               ),
          );
        }
        )

    );
  }
}