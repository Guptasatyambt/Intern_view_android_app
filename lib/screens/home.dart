import 'dart:async';
import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../services/shared_service.dart';
import '../widgets/customButton.dart';
import 'nav_bar.dart';



class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  String name="";
   bool signup = false ;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Accessing ModalRoute arguments after the build method is completed.
      final args = ModalRoute.of(context)!.settings.arguments as bool?;
      if (args != null) {
        setState(() {
          signup = args;
        });
      }
      loadName().then((_) {
        if(signup) {
          _showWelcomeDialog();
        }
      });
    });

  }
  Future<void> loadName() async {
    var loginDetails = await SharedService.loginDetails();
    if (loginDetails != null) {
      setState(() {
        name = loginDetails.data.name;
      });
    }
  }


  void _showWelcomeDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          icon:Image.asset(
            'assets/images/celebration.gif',
            width: 50,
            height: 50,
          ),
          title: Text("Welcome"),
          content: Text("Congratulation! You got 100 Coins of welcome bonus"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {

  loadName();

    return Scaffold(
      backgroundColor: Colors.white,
      drawer: const Navbar(),
      appBar: AppBar(
        elevation: 0.2,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.blueGrey),
        actions:  [
          Padding(
            padding: EdgeInsets.only(right: 10.0),
            child: Row(
              children: [

                GestureDetector(
                  onTap:(){
                    Navigator.pushNamed(context, '/profile');
                  },
                  child: const CircleAvatar(
                    backgroundColor: Colors.black38,
                    backgroundImage: AssetImage('assets/images/user.png'),
                    radius: 20,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),

      body:  SingleChildScrollView(
          child: Column(children: [
            SizedBox(
              height: 250,
              child: GestureDetector(
                onTap: () {
                  // Handle the onTap action here
                  print('Crousel tapped!');
                  // You can navigate to a new screen, show a dialog, etc.
                },
                child: CarouselSlider(
                  items: [
                    // Add your carousel items here
                    Image.asset("assets/images/logo.jpg"),
                    Image.network(
                        'https://happay.com/blog/wp-content/uploads/sites/12/2022/09/Business-Travel-Management-_1_-scaled-1.webp'),
                    Image.network(
                        'https://happay.com/blog/wp-content/uploads/sites/12/2022/09/Business-Travel-Management-_1_-scaled-1.webp'),
                  ],
                  options: CarouselOptions(
                    height: 250.0, // Adjust the height of the carousel
                    aspectRatio:
                        16 / 9, // Adjust the aspect ratio of the carousel items
                    viewportFraction:
                        0.75, // Adjust the width of the carousel items
                    initialPage: 0, // Set the initial page
                    enableInfiniteScroll: true, // Allow infinite scrolling
                    reverse: false, // Reverse the order of items
                    autoPlay: true, // Enable auto-play
                    autoPlayInterval:
                        const Duration(seconds: 3), // Set auto-play interval
                    autoPlayAnimationDuration: const Duration(
                        milliseconds: 800), // Set auto-play animation duration
                    autoPlayCurve:
                        Curves.fastOutSlowIn, // Set auto-play animation curve
                    enlargeCenterPage: true, // Enlarge the center item
                    onPageChanged: (index, reason) {
                      // Callback when the page changes
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.1,
                ),
                Text(
                  "Hello! $name , Good to see you",
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Colors.blueGrey),
                )
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.circular(10), // Adjust the value as needed
                  gradient: const LinearGradient(
                    colors: [
                      Colors.black45,
                      Colors.black26
                    ], // Adjust the colors as needed
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    stops: [0.0, 1.0],
                    tileMode: TileMode.clamp,
                  ),
                ),
                  child: Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: ListTile(
                      leading: Image.asset('assets/images/level-1.png',width: 65,height: 55,),
                      title: const Text('Beginner',style: TextStyle(fontSize: 20,fontWeight: FontWeight.w400),),
                      trailing: Image.asset('assets/images/beginner.png'),
                      tileColor: Colors.transparent,
                      minVerticalPadding: 29,
                      onTap:() {
                        Navigator.pushNamed(context, '/practice');
                      },
                    ),
                  ),

              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.circular(10), // Adjust the value as needed
                  gradient: const LinearGradient(
                    colors: [
                      Colors.black45,
                      Colors.black26
                    ], // Adjust the colors as needed
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    stops: [0.0, 1.0],
                    tileMode: TileMode.clamp,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(0),
                  child: ListTile(
                    leading: Image.asset('assets/images/level-2.png',width: 60,height: 50,),
                    title: const Text('Intermidiate',style: TextStyle(fontSize: 20,fontWeight: FontWeight.w400),),
                    trailing: Image.asset('assets/images/intermidiate.png'),
                    tileColor: Colors.transparent,
                    minVerticalPadding: 29,
                    onTap:() {
                      Navigator.pushNamed(context, '/practiceintermidiate');
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.circular(10), // Adjust the value as needed
                  gradient: const LinearGradient(
                    colors: [
                      Colors.black45,
                      Colors.black26
                    ], // Adjust the colors as needed
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    stops: [0.0, 1.0],
                    tileMode: TileMode.clamp,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(0),
                  child: ListTile(
                    leading: Image.asset('assets/images/level-3.png',width: 60,height: 50,),
                    title: const Text('Advance',style: TextStyle(fontSize: 20,fontWeight: FontWeight.w400),),
                    trailing: Image.asset('assets/images/advance.png'),
                    tileColor: Colors.transparent,
                    minVerticalPadding: 29,
                    onTap:() {
                      Navigator.pushNamed(context, '/practiceadvance');
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),

          ]),
        ),


      // Center(
      //   child: FutureBuilder<Album>(
      //     future: futureAlbum,
      //     builder: (context, snapshot) {
      //       if (snapshot.hasData) {
      //         return Text(snapshot.data!.title);
      //       } else if (snapshot.hasError) {
      //         return Text('${snapshot.error}');
      //       }
      //
      //       // By default, show a loading spinner.
      //       return const CircularProgressIndicator();
      //     },
      //   ),
      // ),
    );
  }
}
