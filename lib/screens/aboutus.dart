import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutUsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.2,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.blueGrey),
        title: const Text(
          'About-Us',
          style: TextStyle(color: Colors.blueGrey),
        ),
      ),
      body:   SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Center(
              child: CircleAvatar(
                radius:140,
                backgroundImage: AssetImage(
                    'assets/images/logowobg.png'), // Replace with your company logo
              ),
            ),
            const SizedBox(height: 20),
            const Center(
              child: Text(
                'InternView',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Company Aims:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            const Text(
              'At InternView, we are dedicated to preparing you for your upcoming interviews through our comprehensive levels of interview preparation. Our goal is to instill confidence in you and equip you with the skills and knowledge needed to excel in your interviews, ultimately making you job-ready. With our tailored approach and real time analysis of your interview, we ensure that you are fully prepared to tackle any interview scenario with confidence and success.',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 20),

            const SizedBox(height: 20),
            const Center(
              child: CircleAvatar(
                radius: 140,
                backgroundImage: AssetImage(
                    'assets/images/satyam.jpg'), // Replace with your company logo
              ),

            ),
            const SizedBox(height: 5),
            const Center(
              child: Text(
                'Satyam Gupta\nCEO & Co-Founder:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 5),
            Padding(
              padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.3),
              child: Row(
                children: [
                  // SizedBox(width:MediaQuery.of(context).size.width*0.3,),
                  IconButton(
                    icon: Image.asset('assets/images/Linkedin.png'),
                    onPressed: () {
                      launch('https://www.linkedin.com/in/satyam-gupta-2b4792229?utm_source=share&utm_campaign=share_via&utm_content=profile&utm_medium=android_app'); // Replace with your company website URL
                    },
                    tooltip: 'Visit our website',
                  ),

                  IconButton(
                    icon: Image.asset('assets/images/Instagram.png'),
                    onPressed: () {
                      launch('https://www.instagram.com/gupta_satyam.12?igsh=bDl0Zm95NmE1MnM3'); // Replace with your company website URL
                    },
                    tooltip: 'Visit our website',
                  ),

                ],
              ),
            ),
            const SizedBox(height: 20),
            const Center(
              child: CircleAvatar(
                radius: 140,
                backgroundImage: AssetImage(
                    'assets/images/upendra.jpg'), // Replace with your company logo
              ),

            ),

            const SizedBox(height: 5),
            const Center(
              child: Text(
                'Upendra Yadav\nCTO & Co-Founder',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 5),
            Padding(
              padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.3),
              child: Row(
                children: [
                  // SizedBox(width:MediaQuery.of(context).size.width*0.3,),
                   IconButton(
                      icon: Image.asset('assets/images/Linkedin.png'),
                      onPressed: () {
                        launch('https://www.linkedin.com/in/upendra-yadav-157338241/'); // Replace with your company website URL
                      },
                      tooltip: 'Visit our website',
                    ),

                  IconButton(
                      icon: Image.asset('assets/images/Instagram.png'),
                      onPressed: () {
                        launch('https://www.instagram.com/yaduvansh_upendra?igsh=MThvNThrNTdiNW5mNQ=='); // Replace with your company website URL
                      },
                      tooltip: 'Visit our website',
                    ),

                ],
              ),
            ),
            const SizedBox(height: 20),


            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
