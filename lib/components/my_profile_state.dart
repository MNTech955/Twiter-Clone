


import 'package:flutter/material.dart';

class MyProfileStats extends StatelessWidget {
  final int postCount;
  final int followerCount;
  final int followingCount;
  final void Function()? onTap;
  const MyProfileStats({super.key, required this.postCount, required this.followerCount, required this.followingCount,
  required this.onTap
  });

  @override
  Widget build(BuildContext context) {
    //textsstyle for cout 
    var textStyleCount=TextStyle(
      fontSize: 20, color: Theme.of(context).colorScheme.inversePrimary
    );
    //text style for text
    var textStyleForText=TextStyle(
      color: Theme.of(context).colorScheme.primary
    );
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 100,
            child: Column(
              children: [
                Text(postCount.toString(), style: textStyleCount,),
                Text("Posts", style: textStyleForText,),
              ],
            ),
          ),
          SizedBox(
            width: 100,
            child: Column(
              children: [
                Text(followerCount.toString(), style: textStyleCount,),
                Text("Follower",style: textStyleForText,),
              ],
            ),
          ),
          SizedBox(
            width: 100,
            child: Column(
              children: [
                Text(followingCount.toString(), style: textStyleCount,),
                Text("Following", style: textStyleForText,),
              ],
            ),
          ),
      
        ],
      ),
    );
  }
}