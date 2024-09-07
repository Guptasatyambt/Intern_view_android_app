import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intern_view/config.dart';
import 'package:intern_view/screens/profile_controller.dart';
import 'package:intern_view/utils/utils.dart';
import '../services/api_service.dart';

class editProfile extends StatefulWidget {
  const editProfile({super.key});

  @override
  State<editProfile> createState() => _editProfileState();
}

class _editProfileState extends State<editProfile> {
  late String year;
  bool isloading=false;
  File? fileToDisplay;
  String? filePath;
  bool status = false;
  bool yearstatus = false;
  bool imagestatus = false;
  File? image;
  String? imagePath;
  final yearController = TextEditingController();
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    yearController.dispose();
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
        if (model.connectionState == ConnectionState.waiting||isloading==true) {
          // Loading state
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (model.hasError) {
          // Error state
          return const Center(
            child: Text('Error fetching user profile'),
          );
        } else if (model.hasData) {
          // Data available
          var userProfileData = jsonDecode(model.data!);

          String name = userProfileData['name'];
          String email = userProfileData['email'];
          String id = userProfileData['_id'];
          String profileimage = userProfileData['profileimage'];
          String college = userProfileData['college'];
          String branch = userProfileData['branch'];
          String specialization = userProfileData['specialization'];
           year = userProfileData['year'];
          String resume = userProfileData['resume'];
          var coins = userProfileData['coins'];
          List<dynamic> interviewList = userProfileData['interview'];
          print(interviewList);
          print(coins);

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
                                  imagePath == null
                                      ? CircleAvatar(
                                          backgroundColor: Colors.black38,
                                          backgroundImage: NetworkImage("https://" + Config.apiURL + "/" + profileimage),
                                          radius: 50,
                                          child: Align(
                                            alignment: Alignment.bottomRight,
                                            child: Container(
                                              padding: const EdgeInsets.all(0),
                                              decoration: const BoxDecoration(
                                                color: Colors.transparent,
                                                shape: BoxShape.circle,
                                              ),
                                              child: IconButton(
                                                onPressed: () async {
                                                  imagePath = await pickImageEdit(context);
                                                  setState(() {
                                                    isloading=true;
                                                  });
                                                  if (imagePath != null) {
                                                    bool st=await APIService.updateImage(imagePath!);
                                                    setState(() {
                                                      isloading=false;
                                                    });
                                                  }
                                                },
                                                icon: const Icon(
                                                  Icons.add_a_photo,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                      : CircleAvatar(
                                          backgroundColor: Colors.black38,
                                          backgroundImage:
                                              FileImage(File(imagePath!)),
                                          radius: 50,
                                          child: Align(
                                            alignment: Alignment.bottomRight,
                                            child: Container(
                                              padding: const EdgeInsets.all(0),
                                              decoration: const BoxDecoration(
                                                color: Colors.transparent,
                                                shape: BoxShape.circle,
                                              ),
                                              child: IconButton(
                                                onPressed: () async {
                                                  imagePath =await pickImageEdit(context);
                                                  setState(() {
                                                    isloading=true;
                                                  });
                                                  if (imagePath != null) {
                                                    bool st=await APIService.updateImage(imagePath!);
                                                    setState(() {
                                                      isloading=false ;
                                                    });
                                                    }
                                                },
                                                icon: const Icon(
                                                  Icons.add_a_photo,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            top: 40, // Adjust this value as needed
                            left: 16, // Adjust this value as needed
                            child: IconButton(
                              icon: const Icon(Icons.arrow_back,
                                  color: Colors.black),
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
                      physics:
                          NeverScrollableScrollPhysics(), // Prevent internal scrolling
                      children: <Widget>[
                        _buildListTile(context, Icons.email, 'Email', email),
                        const SizedBox(
                          height: 10,
                        ),
                        _buildListTile(
                            context,
                            Icons.home_repair_service_rounded,
                            'College',
                            college),
                        const SizedBox(
                          height: 10,
                        ),
                        _buildListTile(context, Icons.contact_page_rounded,
                            'Branch', branch),
                        const SizedBox(
                          height: 10,
                        ),
                        _buildListTile(context, Icons.add, 'Specialization',
                            specialization),
                        const SizedBox(
                          height: 10,
                        ),
                        yearstatus == true
                            ?textwidger(context, Icons.timelapse, 'Year', yearController)
                            : GestureDetector(
                                child: _buildListTile(context, Icons.timelapse, 'Year', year),
                                onTap: () {
                                  setState(() {
                                    yearstatus = true;
                                  });
                                  // print('''''''''''''''''''''''''''''''''''''object''''''''''''''''''''''''''''''''''''');
                                  // print(yearController);
                                  // // updateyear(yearController);
                                },
                              ),
                        const SizedBox(
                          height: 10,
                        ),
                        filePath != null
                            ? GestureDetector(
                                child: _buildListTile(context, Icons.edit_document, 'Resume', filePath!),
                                onTap: () async{
                                  filePath=await pickFile();
                                  setState(() {
                                    isloading=true;
                                  });

                                  bool st=await APIService.updateResume(filePath!);
                                  setState(() {
                                    isloading=false;
                                  });
                                },
                              )
                            : GestureDetector(
                                child: _buildListTile(context,
                                    Icons.edit_document, 'Resume', resume),
                                onTap: ()async {
                                  filePath=await pickFile();
                                  setState(() {
                                    isloading=true;
                                  });

                                  bool st=await APIService.updateResume(filePath!);
                                  setState(() {
                                    isloading=false;
                                  });
                                },
                              ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            ),
          );
        } else {
          return const SizedBox();
        }
      },
    );


  }
  Widget textwidger(BuildContext context, IconData icon, String title,
      TextEditingController controller) {
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
            title: TextFormField(
              controller: controller,
              cursorColor: Colors.black,
              decoration: InputDecoration(
                border: InputBorder.none,
                // Removes the border
              ),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w400,
                color: Colors.black,
              ),
            ),
            trailing: IconButton(
              onPressed: () async{
                String _year=controller.text;
                if(controller==null){
                  showSnackBar(context, "Please Fill Your Year");
                }
                else{
                  setState(() {
                    isloading=true;
                  });
                  print(_year);
                  bool st=await APIService.updateyear(_year);
                  if(st==false){
                    showSnackBar(context, "some error accurd");
                  }
                  setState(() {
                    isloading=false;
                    // yearstatus=false;
                    year=_year;
                  });
                }
              },
              icon: const Icon(Icons.done),
            ),
          ),
          Positioned(
            left: 10,
            top: -10,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              color: Colors
                  .white, // Background color for the title to cover the border
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


  Widget _buildListTile(
      BuildContext context, IconData icon, String title, String subtitle) {
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
            title: Text(
              subtitle,
              style: const TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Positioned(
            left: 10,
            top: -10,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              color: Colors
                  .white, // Background color for the title to cover the border
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

  Future<String?> pickFile() async {
    try {
      FilePickerResult? result;
      String? _fileName;
      PlatformFile? pickedFile;
      bool isLoading = false;

      result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowMultiple: false,
        allowedExtensions: ['pdf', 'doc'],
      );
      if (result != null) {
        // _fileName = result!.files.first.name;
        pickedFile = result!.files.first;
        _fileName=pickedFile.path;

        // setState(() {
        //   fileToDisplay = File(pickedFile!.path.toString());
        //   filePath=pickedFile.path;
        // });
        // print("file name:$fileToDisplay");
      } else {
        // User canceled the picker
        print('User canceled file picker');
      }
      return _fileName;
    } catch (e) {
      showSnackBar(context, e.toString());
    }
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
    path.lineTo(0, size.height - 30);
    path.quadraticBezierTo(
      size.width / 2, size.height + 10, // Control point for a subtler curve
      size.width, size.height - 30,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
