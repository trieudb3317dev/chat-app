import 'package:chat_app/screens/chats/chats_screen.dart';
import 'package:chat_app/screens/groups/groups_screen.dart';
import 'package:chat_app/screens/more/more_screen.dart';
import 'package:chat_app/screens/profile/profile_screen.dart';
import 'package:flutter/material.dart';

import '../main_tab_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = const [
    ChatsScreen(),
    GroupsScreen(),
    ProfileScreen(),
    MoreScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: MainTabBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
