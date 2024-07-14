import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intern_view/screens/Loading.dart';
import 'package:intern_view/screens/aboutus.dart';
import 'package:intern_view/screens/contact.dart';
import 'package:intern_view/screens/feedback.dart';
import 'package:intern_view/screens/home.dart';
import 'package:intern_view/screens/loginPage.dart';
import 'package:intern_view/screens/navigation.dart';
import 'package:intern_view/screens/practice.dart';
import 'package:intern_view/screens/profile.dart';
import 'package:intern_view/screens/signupUp.dart';
import 'package:intern_view/screens/userInformation.dart';
import 'package:camera/camera.dart';
import 'package:intern_view/services/shared_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();
  final frontCamera = cameras.firstWhere((camera) => camera.lensDirection == CameraLensDirection.front);

  // await Firebase.initializeApp();
  runApp(MyApp(camera: frontCamera));
}

class MyApp extends StatelessWidget {
  final CameraDescription camera;

  const MyApp({Key? key, required this.camera}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
     debugShowCheckedModeBanner: false,
      home: const Loading(),
      routes: {
        "/login":(context)=> const LoginPage(),
        "/signup":(context)=> const SignUpPage(),
        '/userinformation':(context)=>const UserInformationPage(),
        '/navigation':(context)=>NavigatorPage(camera:camera),
        '/practice' :(context)=> PracticePage(camera:camera),
        '/practiceintermidiate' :(context)=> PracticePage(camera:camera),
        '/practiceadvance' :(context)=> PracticePage(camera:camera),
        '/home' :(context)=>const Home(),
        '/feedback' :(context)=>const FeedbackForm(),
        '/profile' :(context)=>const ProfilePage(),
        '/contact' :(context)=> ContactUsPage(),
        '/about' :(context)=> AboutUsPage(),

      },
    );
  }
}

