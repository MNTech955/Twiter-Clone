import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:twiter_clone/services/auth/auth_gate.dart';


import 'package:twiter_clone/services/database/database_provider.dart';

import 'package:twiter_clone/themes/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        //theme provider
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(),
        ),
         //database provide
         ChangeNotifierProvider(
          create: (_) => DatabaseProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {'/':(context)=>AuthGate()},
      
      theme: Provider.of<ThemeProvider>(context).themeData,
    );
  }
}
