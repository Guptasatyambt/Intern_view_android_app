import 'dart:convert';

import 'package:flutter/material.dart';

import '../services/api_service.dart';
import 'editProfile.dart';

class InterviewReport extends StatefulWidget {

  const InterviewReport({Key? key}) : super(key: key);

  @override
  State<InterviewReport> createState() => _InterviewReportState();
}

class _InterviewReportState extends State<InterviewReport> {
  String _id="";
  @override
  void initState(){
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final String? interviewId = ModalRoute.of(context)?.settings.arguments as String?;
      print(interviewId);
      setState(() {
        _id = interviewId!;
      });
      print(_id);
    });
  }
  @override
  Widget build(BuildContext context) {
    return interviewReport();

  }

  Widget interviewReport() {
    return FutureBuilder(
      future: APIService.getInterview(_id),
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
          var interviewData = jsonDecode(model.data!);

          String level = interviewData['level'];
          String email = interviewData['email'];
          String video = interviewData['video'];
          String result = interviewData['result'];
          String confidence = interviewData['confidence'];
          String accuracy = interviewData['accuracy'];
          String eye = interviewData['eye'];
          String neck = interviewData['neck'];



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
                                  Text(
                                    _id,
                                    style: const TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white),
                                  ),

                                ],
                              ),
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
                        ListTile(title: Text("Result:"),subtitle: Text(result),),
                        const SizedBox(
                          height: 10,
                        ),
                        ListTile(title: Text("Result:"),subtitle: Text(result),),
                        const SizedBox(
                          height: 10,
                        ),
                        ListTile(title: Text("Result:"),subtitle: Text(result),),
                        const SizedBox(
                          height: 10,
                        ),
                        ListTile(title: Text("Result:"),subtitle: Text(result),),
                        const SizedBox(
                          height: 10,
                        ),
                        ListTile(title: Text("Result:"),subtitle: Text(result),),

                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 9.0),
                      child: Container(
                          alignment: Alignment.centerLeft,
                          child: Text("Video",style: TextStyle(color: Colors.black, fontSize: 20),)),
                    ),
                    const SizedBox(
                      height: 10,
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
}
