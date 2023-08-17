import 'package:flutter/material.dart';
import 'package:jack_social_app_v2/chat_page.dart';
import 'package:jack_social_app_v2/form_widget.dart';
import 'package:jack_social_app_v2/image_picker_example.dart';
import 'package:jack_social_app_v2/location_page.dart';
import 'package:jack_social_app_v2/profile.dart';
import 'package:jack_social_app_v2/realtimedatabase.dart';

class BottomNavigationBarControl extends StatefulWidget {
  const BottomNavigationBarControl({super.key});

  @override
  State<BottomNavigationBarControl> createState() =>
      _BottomNavigationBarControlState();
}

class _BottomNavigationBarControlState
    extends State<BottomNavigationBarControl> {
  int _selectedIndex = 0;
  //String character;
  static final List<Widget> _widgetOptions = <Widget>[
    const ChatPage(character: "You are a teenager in a high school and you are also participate in multiple school clubs and sport teams. You are also focusing on grades and academics. "),
    ImageSuperPicker(),
    const RealTimeFirebase(),
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
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Activities',
          ),
            BottomNavigationBarItem(
            icon: Icon(Icons.image),
            label: 'Images',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_business_outlined),
            label: 'Your Journey',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
