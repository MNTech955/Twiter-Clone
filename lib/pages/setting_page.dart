import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:twiter_clone/components/my_setting_tile.dart';
import 'package:twiter_clone/helper/navigate_page.dart';
import 'package:twiter_clone/themes/theme_provider.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        centerTitle: true,
        title: Text("S E T T I N G S"),
        foregroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Column(
        children: [
          //dark mode tile
          MySettingTile(
              action: CupertinoSwitch(
                onChanged: (value) {
                  Provider.of<ThemeProvider>(context, listen: false)
                      .toggleTheme();
                },
                value: Provider.of<ThemeProvider>(context, listen: false)
                    .isDarkMode,
              ),
              title: "Dark Mode"),

          //Block user tile
          MySettingTile(
            action: GestureDetector(
              onTap:()=> goToBlockedUserPage(context),
              child: Icon(
                Icons.arrow_forward,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
             title: "Blocked user"
             ),

          //account setting tile
          MySettingTile(
            action: IconButton(
              onPressed: ()=>goToAccountSettingsPage(context),
               icon: Icon(Icons.arrow_forward, color: Theme.of(context).colorScheme.primary,),
               ),
             title: "Account Settings"
             ),
        ],
      ),
    );
  }
}
