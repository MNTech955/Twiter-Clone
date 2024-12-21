
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:twiter_clone/components/my_user_tile.dart';
import 'package:twiter_clone/services/database/database_provider.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _searchTextController=TextEditingController();
  @override
  Widget build(BuildContext context) {
    //provider
    final databaseProvider=Provider.of<DatabaseProvider>(context, listen: false);
    final listeningProvider=Provider.of<DatabaseProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchTextController,
          decoration: InputDecoration(
            hintText: "search user..",
            hintStyle: TextStyle(color: Theme.of(context).colorScheme.primary),
            border: InputBorder.none
          ),
          //search is begin after new charcahter as been types
          onChanged: (value){
            //search user
            if(value.isNotEmpty){
              databaseProvider.searchUser(value);
            }
            //clear result
            else{
              databaseProvider.searchUser("");


            }
          },
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: listeningProvider.searchResult.isEmpty
      ?
      //no iser found...
      Center(
        child: Text("No user found.."),
      )
      :
      //user found
      ListView.builder(
        itemCount: listeningProvider.searchResult.length,
        itemBuilder: (context, index){
          //get each user form search result
          final user=listeningProvider.searchResult[index];

          return MyUserTile(user: user);
        }
        )
      ,
    );
  }
}