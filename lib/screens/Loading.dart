import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intern_view/screens/entryPage.dart';

import '../models/login_responce_model.dart';
import '../services/shared_service.dart';

class Loading extends StatefulWidget {
  const Loading({Key? key}) : super(key: key);
  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  Future<void> startApp(BuildContext context) async {
    try {
      await Future.delayed(const Duration(seconds: 2));
      bool result=await SharedService.isLoggedIn();
      var loginDetails = await SharedService.loginDetails();
      var name="";
      if (loginDetails != null) {
        name = loginDetails.data.name;
      }
      if (result ) {
          if(name!=""){
            bool signup=false;
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/home',
                  (route) => false,
              arguments: signup,
            );
          }
        else{
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/userinformation',
                (route) => false,
          );
        }

      }
      else{
        Navigator.pushReplacement(context,  MaterialPageRoute(
          builder: (context) => const EntryPage(),
        ),);
      }

    } catch (error) {
      // Handle errors, log them, or show an error message
      print('Error during app initialization: $error');
      // For example, navigate to a login screen on error
    }
  }


  @override
  Widget build(BuildContext context) {
    startApp(context);

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset("assets/images/logo.jpg", width: 240, height: 240),
              const Text(
                "Intern-View",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
              const SpinKitCircle(
                color: Colors.white,
                size: 50.0,
              ),
              const SizedBox(height: 100),
              const Text(
                "Co-Founder - ",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 15),
              const Text(
                "Satyam Gupta",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                "Upendra Yadav",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.black38,
    );
  }
}
