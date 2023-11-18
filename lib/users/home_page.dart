import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jack_social_app_v2/users/activity_near_me.dart';
import 'package:jack_social_app_v2/auth/auth.dart';
import 'package:jack_social_app_v2/chat_page.dart';
import 'package:jack_social_app_v2/form_widget.dart';
import 'package:jack_social_app_v2/little_get_to_know_screen.dart';
import 'package:jack_social_app_v2/main.dart';
import 'package:jack_social_app_v2/profile.dart';
import 'package:jack_social_app_v2/users/gpt_summary.dart';
import 'package:jack_social_app_v2/your_journals.dart';

class BottomNavigationBarControl extends StatefulWidget {
  const BottomNavigationBarControl({super.key});

  @override
  State<BottomNavigationBarControl> createState() =>
      _BottomNavigationBarControlState();
}

class _BottomNavigationBarControlState extends State<BottomNavigationBarControl> {
  int _selectedIndex = 0;
  late User user;
  late TextEditingController controller;
  final phoneController = TextEditingController();
  String? photoURL;
  bool showSaveButton = false;
  bool isLoading = false;


  static final List<Widget> _widgetOptions = <Widget>[
    const YourJournals(),
    const GPTSummaryScreen(),
    const ChatPage(character: "You are a teenager in a high school and you are also participate in multiple school clubs and sport teams. You are also focusing on grades and academics. "),
    const ActivityNearMePage(),
    const ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.yellow,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.add_business_outlined),
            label: 'Your Journey',
            //backgroundColor: Colors.blue
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.summarize),
            label: 'Little Advise',
            //backgroundColor: Colors.blue
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble),
            label: 'Chat Bot',
            //backgroundColor: Colors.grey
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.accessibility_outlined),
            label: 'Get To know',
            //backgroundColor: Colors.greenAccent
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Profile',
            //backgroundColor: Colors.deepOrangeAccent
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}

