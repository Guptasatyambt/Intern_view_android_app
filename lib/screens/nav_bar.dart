import 'package:flutter/material.dart';

import '../services/shared_service.dart';

class Navbar extends StatelessWidget {
  const Navbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(

      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.transparent,
            ),
            margin: const EdgeInsets.only(bottom: 8),
            child: Column(
              children: [
                Image.asset('assets/images/logowobg.png',width:  MediaQuery.of(context).size.width,height: 100,),
                const Text("InternView",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600,color: Colors.blueGrey),),

              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              Navigator.pushNamed(context, '/home');
            },
          ),
          ListTileWithDropdown(),
          ListTile(
            leading: const Icon(Icons.feedback_sharp),
            title: const Text('Feedback'),
            onTap: () {
              Navigator.pushNamed(context, '/feedback');
            },
          ),
          ListTile(
            leading: const Icon(Icons.info_rounded),
            title: const Text('About Us'),
            onTap: () {
              Navigator.pushNamed(context, '/about');
            },
          ),

          ListTile(
            leading: const Icon(Icons.contact_page_rounded),
            title: const Text('Contact Us'),
            onTap: () {
              Navigator.pushNamed(context, '/contact');
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Log Out'),
            onTap: () {
              SharedService.logout(context);
            },
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height*0.32,
          ),
          const Divider(height: 2,thickness: 1,color: Colors.black,),
            Row(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width*0.3,
              ),
              Text('App version 1.0.1'),


            ],
          ),
        ],
      ),
    );
  }
}


class ListTileWithDropdown extends StatefulWidget {
  const ListTileWithDropdown({super.key});

  @override
  _ListTileWithDropdownState createState() => _ListTileWithDropdownState();
}

class _ListTileWithDropdownState extends State<ListTileWithDropdown> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      leading: Image.asset('assets/images/logo.jpg',width: 18,height: 18,),
      title: Text(
        'Prepare Ready',
        style: TextStyle(color: _isExpanded ? Colors.black : Colors.black),
      ),
      trailing: const Icon(
        Icons.keyboard_arrow_down_rounded,
        color:  Colors.grey,
      ),
      onExpansionChanged: (bool expanded) {
        setState(() {
          _isExpanded = expanded;
        });
      },
      children: <Widget>[

        ListTile(
          title: const Text('Beginner'),
          onTap: () {
            Navigator.pushNamed(context, '/practice');
          },

        ),
        ListTile(
          title: const Text('Intermidiate'),
          onTap: () {
            Navigator.pushNamed(context, '/practiceintermidiate');
          },

        ),
        ListTile(
          title: const Text('Advance'),
          onTap: () {
            Navigator.pushNamed(context, '/practiceadvance');
          },

        ),
      ],
    );
  }
}