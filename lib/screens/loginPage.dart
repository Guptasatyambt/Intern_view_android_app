import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:intern_view/screens/entryPage.dart';
import 'package:http/http.dart' as http;
import 'package:snippet_coder_utils/ProgressHUD.dart';
import 'package:intern_view/utils/utils.dart';
import '../models/login_request_model.dart';
import '../services/api_service.dart';
import '../services/shared_service.dart';
import '../widgets/customButton.dart';
import 'forgot_password.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
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
                        context, '/entry'),
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
                  "LogIn",
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
                Row(
                  children: [
                    SizedBox(width: MediaQuery.of(context).size.width  * 0.4,),
                    GestureDetector(
                      onTap: (){
                        Navigator.pushReplacementNamed(
                            context, '/forgot');
                      },
                      child: Text("Forgot Password?",style: TextStyle(color: Colors.white),),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: CustomButton(
                    onPressed: () =>verify(),
                    text:'Log-In',
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

      LoginRequestModel model = LoginRequestModel(
        email: emailController.text,
        password: passwordController.text,
      );
      APIService.login(model).then(
            (response) {
          setState(() {
            isApiCallProcess = false;
          });

          if (response) {
            bool signup=false;
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/home',
                  (route) => false,
              arguments: signup,
            );
          } else {
            showSnackBar(context, "Enter Correct details");
          }
        },
      );
    }
    }
  }

