import 'package:flutter/material.dart';
import 'package:snippet_coder_utils/ProgressHUD.dart';

import '../services/api_service.dart';
import '../utils/utils.dart';
import '../widgets/customButton.dart';
import 'loginPage.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final TextEditingController emailController = TextEditingController();
  bool isApiCallProcess = false;
  bool _obscureText = true;
  GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black38,
        body:ProgressHUD(
          child: Form(
            key: globalFormKey,
            child: _loginUi(context),
          ),
          inAsyncCall: isApiCallProcess,
          opacity: 0.3,
          key: UniqueKey(),
        ),
      ),
    );
  }

  Widget _loginUi (BuildContext context){
    return SingleChildScrollView(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 35),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: GestureDetector(
                  onTap: () => Navigator.pushReplacementNamed(
                      context, '/login'),
                  child: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                ),
              ),
              Container(
                width: 250,
                height: 250,
                padding: const EdgeInsets.all(20.0),

                child: Image.asset(
                  "assets/images/logo.jpg",width: 190,height: 190,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Forgot Password",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white70,
                ),
              ),

              const SizedBox(height: 20),
              TextFormField(
                cursorColor: Colors.white,
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white70,
                ),
                decoration: InputDecoration(
                  hintText: "Enter Email Address",
                  hintStyle: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                    color: Colors.white60,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.white54),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.white60),
                  ),
                  prefixIcon: Container(
                    padding: const EdgeInsets.only(top: 13.0,right: 8,left:8),
                    child: const InkWell(
                        child:Icon(Icons.email,color: Colors.white38,)
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: CustomButton(
                  onPressed: () =>verify(),
                  text:'Send OTP',
                ),

              ),


            ],
          ),
        ),
      ),
    );

  }
  void verify(){
    if(emailController.text==""){
      showSnackBar(context, "Enter Email");
    }
    else{
      setState(() {
        isApiCallProcess = true;
      });


      APIService.forgotPassword(emailController.text).then(
            (response) {
          setState(() {
            isApiCallProcess = false;
          });

          if (response) {
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/otp',
                  (route) => false,
            );
          } else {
            showSnackBar(context, "Something Went Wrong");
          }
        },
      );
    }
  }
}

