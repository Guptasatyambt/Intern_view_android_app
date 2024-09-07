import 'dart:convert';
import 'package:flutter/material.dart';
import '../config.dart';
import '../services/api_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return userProfile();

  }

  Widget userProfile() {
    return FutureBuilder(
      future: APIService.getUserProfile(),
      builder: (
          BuildContext context,
          AsyncSnapshot<String> model,
          ) {
        if (model.connectionState == ConnectionState.waiting) {
          // Loading state
          return const Scaffold(
            backgroundColor: Colors.grey,
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        else if (model.hasError) {
          // Error state
          return const Scaffold(
            backgroundColor: Colors.grey,
            body: Center(
              child: Text('Error fetching user profile'),
            ),
          );
        }
        else if (model.hasData) {
          // Data available
          var userProfileData = jsonDecode(model.data!);

          String name = userProfileData['name'];
          String email = userProfileData['email'];
          String id = userProfileData['_id'];
          String profileimage = userProfileData['profileimage'];
          String college = userProfileData['college'];
          String branch = userProfileData['branch'];
          String specialization = userProfileData['specialization'];
          String year = userProfileData['year'];
          String resume = userProfileData['resume'];
          var coins = userProfileData['coins'];
          List<dynamic> interviewList=userProfileData['interview'];

          return Scaffold(
            body: Center(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.3,
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: <Widget>[
                          Positioned(
                            top: 50, // Adjust this value as needed
                            right: 20, // Adjust this value as needed
                            child: Row(
                              children: [
                                const Icon(Icons.monetization_on, size: 30),
                                Text(
                                  '$coins',
                                  style: const TextStyle(color: Colors.black, fontSize: 20),
                                ),
                              ],
                            ),
                          ),
                          ConvexContainer(
                            child: Container(
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.black54,
                                    Colors.black38
                                  ], // Adjust the colors as needed
                                  begin: Alignment.topRight,
                                  end: Alignment.bottomLeft,
                                  stops: [0.0, 1.5],
                                  tileMode: TileMode.clamp,
                                ),
                              ),
                            ),
                          ),
                          Center(
                            child: Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    name,
                                    style: const TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white),
                                  ),
                                  IconButton(
                                      onPressed: (){
                                        Navigator.pushNamed(context, '/editprofile').then((value) {
                                          setState(() {});
                                        });
                                      },
                                      icon: const Icon(Icons.edit,color: Colors.white,)
                                  )
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: -MediaQuery.of(context).size.height * 0.05,
                            left: MediaQuery.of(context).size.width * 0.32,
                            child: GestureDetector(
                              child: CircleAvatar(
                                backgroundColor: Colors.black38,
                                backgroundImage: NetworkImage("https://"+Config.apiURL+"/"+profileimage),
                                radius: 50,
                                // child: Image.network(
                                //     "https://"+Config.apiURL+"/"+profileimage,
                                //   width: MediaQuery.of(context).size.width,
                                //   height: 125,
                                // ),
                              ),
                              onTap: (){
                                setState(() {

                                });
                              },
                            ),
                          ),
                          Positioned(
                            top: 40, // Adjust this value as needed
                            left: 16, // Adjust this value as needed
                            child: IconButton(
                              icon: const Icon(Icons.arrow_back, color: Colors.black),
                              onPressed: () {
                                Navigator.of(context).pop(false);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    ListView(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      physics: NeverScrollableScrollPhysics(), // Prevent internal scrolling
                      children: <Widget>[
                        _buildListTile(context, Icons.email, 'Email', email),
                        const SizedBox(
                          height: 10,
                        ),
                        _buildListTile(context, Icons.home_repair_service_rounded, 'College', college),
                        const SizedBox(
                          height: 10,
                        ),
                        _buildListTile(context, Icons.contact_page_rounded, 'Branch', branch),
                        const SizedBox(
                          height: 10,
                        ),
                        _buildListTile(context, Icons.add, 'Specialization', specialization),
                        const SizedBox(
                          height: 10,
                        ),
                        _buildListTile(context, Icons.timelapse, 'Year', year),
                        const SizedBox(
                          height: 10,
                        ),
                        _buildListTile(context, Icons.edit_document, 'Resume', resume),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 9.0),
                      child: Container(
                        alignment: Alignment.centerLeft,
                          child: Text("Previous Interviews",style: TextStyle(color: Colors.black, fontSize: 20),)),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: EdgeInsets.all(10.0),
                      height: 120.0, // Adjust height as needed
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: interviewList.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            child: Container(
                              width: 120.0, // Adjust width as needed
                              margin: const EdgeInsets.symmetric(horizontal: 10.0),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Colors.black54,
                                    Colors.black38
                                  ], // Adjust the colors as needed
                                  begin: Alignment.topRight,
                                  end: Alignment.bottomLeft,
                                  stops: [0.0, 1.5],
                                  tileMode: TileMode.clamp,
                                ),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Center(
                                child: Column(
                                  children: [
                                    Text("Interview ${index+1}",style: TextStyle(color: Colors.white, fontSize: 20),),
                                    SizedBox(height: 5,),
                                    Text(
                                        "Result:",
                                      style: TextStyle(color: Colors.white, fontSize: 18),
                                    ),
                                    SizedBox(height: 5,),
                                    Text(
                                      interviewList[index]['result'].toString(),
                                      style: TextStyle(color: Colors.white, fontSize: 18),
                                    ),
                                  ],
                                ),
                                
                              ),
                            ),
                            onTap: (){
                              String interviewId=interviewList[index]['interview_id'].toString();
                              print(interviewId);
                              Navigator.pushNamed(
                                context,
                                '/interviewreport',
                                arguments:interviewId, // Optional, passing interviewId as arguments
                              );
                              // showDialog(
                              //     context: context,
                              //     builder: (BuildContext context) {
                              //       return AlertDialog(
                              //         content: Container(
                              //           height: 150,
                              //           child: Column(
                              //             children: [
                              //               Row(
                              //                 children: [
                              //                   SizedBox(
                              //                     width:MediaQuery.of(context).size.width  * 0.5,
                              //                   ),
                              //                   IconButton(
                              //                       onPressed: (){
                              //                         Navigator.of(context).pop(false);
                              //                       },
                              //                       icon: Icon(Icons.close))
                              //                 ],
                              //               ),
                              //                Column(
                              //                 children: [
                              //                   Text("Interview ${index+1}",style: TextStyle(color: Colors.black, fontSize: 20),),
                              //                   SizedBox(height: 5,),
                              //                   Text(
                              //                     "Result:Expert",
                              //                     style: TextStyle(color: Colors.black, fontSize: 18),
                              //                   ),
                              //                   SizedBox(height: 5,),
                              //                   Text(
                              //                     "Confidence: expert",
                              //                     style: TextStyle(color: Colors.black, fontSize: 18),
                              //                   ),
                              //                 ],
                              //               ),
                              //               const SizedBox(
                              //                 height: 5,
                              //               ),
                              //
                              //             ],
                              //           ),
                              //         ),
                              //       );
                              //     });
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );


        }
        else {
          return const SizedBox();
        }
      },
    );
  }
  Widget _buildListTile(BuildContext context, IconData icon, String title, String subtitle) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 1.0),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          ListTile(
            leading: Icon(icon),
            title: Text(subtitle,style: const TextStyle(
              fontSize: 15.0,
              fontWeight: FontWeight.w500,
            ),),
          ),

          Positioned(
            left: 10,
            top: -10,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              color: Colors.white, // Background color for the title to cover the border
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 13.0,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),

        ],
      ),
    );
  }


}

class ConvexContainer extends StatelessWidget {
  final Widget child;

  const ConvexContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: ConvexClipper(),
      child: child,
    );
  }
}

class ConvexClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height -30);
    path.quadraticBezierTo(
      size.width /2, size.height + 10,  // Control point for a subtler curve
      size.width, size.height - 30,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}