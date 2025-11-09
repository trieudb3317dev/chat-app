import 'package:chat_app/providers/friend_provider.dart';
import 'package:chat_app/providers/profile_provider.dart';
import 'package:chat_app/screens/onboarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chat_app/providers/theme_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => ThemeProvider()),
        ChangeNotifierProvider(create: (ctx) => ProfileProvider()),
        ChangeNotifierProvider(create: (ctx) => FriendProvider()), // Add FriendProvider
      ],
      child: Consumer<ThemeProvider>(
        builder: (ctx, themeObject, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Chat App',
          themeMode: themeObject.mode,
          theme: ThemeData(
            primarySwatch: Colors.blue,
            primaryColor: Colors.blue[600],
            brightness: Brightness.light,
            scaffoldBackgroundColor: Colors.grey[100],
            fontFamily: 'Karla',
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          darkTheme: ThemeData(
            primarySwatch: Colors.blue,
            primaryColor: Colors.blue[300],
            brightness: Brightness.dark,
            scaffoldBackgroundColor: Colors.grey[900],
            fontFamily: 'Karla',
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: OnboardingScreen(),
        ),
      ),
    );
  }
}
