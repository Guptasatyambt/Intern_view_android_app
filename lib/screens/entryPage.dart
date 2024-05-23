import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
class EntryPage extends StatefulWidget {
  const EntryPage({super.key});

  @override
  State<EntryPage> createState() => _EntryPageState();
}

class _EntryPageState extends State<EntryPage> {
  @override
  Widget build(BuildContext context) {
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

              const SizedBox(height: 100),
              Column(
                children: [
                  button(
                      text: "Login",
                      onPressed: () {
                        Navigator.pushReplacementNamed(
                            context, '/login');
                      }

                    ),
                  button(
                      text: "Sign-Up",
                      onPressed: () {
                        Navigator.pushReplacementNamed(
                            context, '/signup');
                      }),
                ],
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.black38,
    );
  }
  Widget button({
    required String text,
    required Function() onPressed,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        style: ButtonStyle(
          fixedSize: MaterialStateProperty.all<Size>(
            Size(MediaQuery.of(context).size.width * 0.8,
                50), // Set width and height
          ),
          foregroundColor: MaterialStateProperty.all<Color>(Colors.black38),
          backgroundColor:
          MaterialStateProperty.all<Color>(Colors.yellow.shade700),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25.0),
            ),
          ),
        ),
        onPressed: onPressed,
        child: Text(text, style: const TextStyle(fontSize: 16)),
      ),
    );
  }

}
