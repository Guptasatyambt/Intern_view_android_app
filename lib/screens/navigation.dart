import 'package:camera_platform_interface/src/types/camera_description.dart';
import 'package:flutter/material.dart';
import 'package:intern_view/screens/practice.dart';
import 'package:intern_view/screens/profile.dart';

import 'home.dart';

class NavigatorPage extends StatefulWidget {
  final CameraDescription camera;
  const NavigatorPage({Key? key, required this.camera}) : super(key: key);

  @override
  State<NavigatorPage> createState() => _NavigatorPageState();
}

class _NavigatorPageState extends State<NavigatorPage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      const Home(),
      PracticePage(camera: widget.camera),
      const ProfilePage(),
    ];
    return Scaffold(

      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(

        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        items:   [
          const BottomNavigationBarItem(icon: Icon(Icons.home),label:"Home"),
          BottomNavigationBarItem(icon: Image.asset('assets/images/logo.jpg',width: 18,height: 18,),label:"Inter-View"),
          const BottomNavigationBarItem(icon: Icon(Icons.person),label:"Profile"),
        ],
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
