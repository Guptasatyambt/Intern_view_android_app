import 'package:flutter/material.dart';
import 'package:snippet_coder_utils/ProgressHUD.dart';

import '../models/register_request_model.dart';
import '../services/api_service.dart';
import '../utils/utils.dart';
import '../widgets/customButton.dart';
import 'entryPage.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isApiCallProcess = false;
  GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();
  bool _obscureText = true;

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
            child: _signinUI(context),
          ),
          inAsyncCall: isApiCallProcess,
          opacity: 0.3,
          key: UniqueKey(),
        ),
      ),
    );
  }

  Widget _signinUI(BuildContext context){
    return SingleChildScrollView(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 35),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
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
                "Sign UP",
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
              TextFormField(
                cursorColor: Colors.white,
                controller: passwordController,
                keyboardType: TextInputType.visiblePassword,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white70,
                ),
                obscureText: _obscureText,
                decoration: InputDecoration(
                  hintText: "Enter Password",
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
                        child:Icon(Icons.password,color: Colors.white38,)
                    ),
                  ),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText; // Toggle password visibility
                      });
                    },
                    icon: Icon(
                      _obscureText ? Icons.visibility_off : Icons.visibility,
                      color: Colors.white38,
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
                  text:'Sign-UP',
                ),

              ),
            ],
          ),
        ),
      ),
    );
  }
  void verify(){
    if(emailController.text==""||passwordController.text==""){
      showSnackBar(context, "Enter all details");
    }
    else{
      setState(() {
        isApiCallProcess = true;
      });

      RegisterRequestModel model = RegisterRequestModel(
        email: emailController.text,
        password: passwordController.text,
      );
      APIService.register(model).then(
            (response) {
          setState(() {
            isApiCallProcess = false;
          });

          if (response=='true') {
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/userinformation',
                  (route) => false,
            );
          } else {
            showSnackBar(context, response);
          }
        },
      );
    }
    // Navigator.pushReplacementNamed(context, '/userinformation');
  }
}
