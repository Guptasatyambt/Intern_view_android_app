import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:path/path.dart' as Path;
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:intern_view/services/api_service.dart';
import 'package:intern_view/services/shared_service.dart';
import 'package:path_provider/path_provider.dart';
import '../models/upload_video_request_model.dart';
import '../utils/utils.dart';
import '../widgets/customButton.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:permission_handler/permission_handler.dart';

class PracticePage extends StatefulWidget {
  final CameraDescription camera;
  const PracticePage({Key? key, required this.camera}) : super(key: key);

  @override
  State<PracticePage> createState() => _PracticePageState();
}

class _PracticePageState extends State<PracticePage> {
  late CameraController _controller;
  int i = 0;
  bool isRecording = false;
  late String _videoPath;
  OverlayEntry? entry;
  Offset offset = const Offset(5, 50);

  SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String _lastWords = '';
  bool _shouldContinueListening = false;// Added flag
  String speech="";

  List<String> question = [
    "introduce yourself",
    "can you tell me more about your skills",
    "tell me about your projects"
  ];
  String nextQuestion="introduce yourself";
  int questionNumber = 0;

  List<int> timeList=[0];

  static const maxSeconds = 180;
  int seconds = maxSeconds;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    _initSpeech();
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.high,
      enableAudio: false,
    );

    _controller.initialize().then((_) {
      if (!mounted) {
        return;
      }

      setState(() {});
    });
  }
  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize(
      onStatus: (status) => print('Status: $status'),
      onError: (error) => print('Error: ${error.errorMsg}, permanent: ${error.permanent}'),
    );
    setState(() {});
  }


  void _startListening() async {
    _shouldContinueListening = true;
    _lastWords = "";  // Clear previous speech result
    await _speechToText.listen(
      onResult: _onSpeechResult,
      listenFor: Duration(seconds: 300), // Long listening duration
      pauseFor: Duration(seconds: 2)  // Prevent pausing during speech recognition
    );
    setState(() {});
  }

  void _stopListening() async {
    _shouldContinueListening = false;  // Disable continuous listening
    await _speechToText.stop();
    print(speech);
    speech = "";
    setState(() {});
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _lastWords = result.recognizedWords;
      if (_lastWords.isNotEmpty) {
        speech += _lastWords; // Accumulate speech
        print("Recognized speech: $speech");
      } else {
        print("No recognizable speech detected.");
      }
    });
    // Restart listening only if the flag is set and it's not already listening
    if (_shouldContinueListening && !_speechToText.isListening) {
      _startListening();
    }
  }


  @override
  Widget build(BuildContext context) {
    if (!_controller.value.isInitialized) {
      return Container();
    }
    return WillPopScope(
      onWillPop: () async {
        if (isRecording) {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  content: Container(
                    height: 150,
                    child: Column(
                      children: [
                        const ListTile(
                          leading: Icon(Icons.add_alert),
                          title: Text(
                              "This will affect your coins. Deducted fee will not be refunded if you press back."),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            const SizedBox(
                              width: 25,
                            ),
                            CustomButton(
                              onPressed: () {
                                stopInterview();
                                Navigator.of(context).pop(false);
                              },
                              text: 'Ok',
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            CustomButton(
                              onPressed: () {
                                Navigator.of(context).pop(true);
                              },
                              text: 'Cancel',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              });

          return false;
        }
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0.2,
          backgroundColor: Colors.white,
          actions: [

          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    left: 5.0, right: 5, top: 2, bottom: 10),
                child: Container(
                  child: !isRecording
                      ? Image.asset('assets/images/logowobg.png')
                      : Image.asset('assets/images/interviewer(1).gif'),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              isRecording
                  ? SizedBox(
                      child: Text(
                        // "Q- ${question[questionNumber]}",
                        "Q-${nextQuestion}",
                        style: const TextStyle(fontSize: 20),
                      ),
                    )
                  : Container(),
              isRecording
                  ? Container()
                  : SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: 50,
                      child:
                      CustomButton(
                        onPressed:(){
                          _startListening();
                          interviewStrat();
                      },
                        text: 'Start Interview',
                      ),
                    ),
              const SizedBox(
                height: 30,
              ),
              isRecording
                  ?  SizedBox(
                child: Text(
                  _speechToText.isListening
                      ? _lastWords
                      : 'Tap the microphone to start listening...',
                  style: TextStyle(fontSize: 20),
                ),
              )
                  : Container(),
              // buildTimer() : Container(),
              SizedBox(
                height: MediaQuery.of(context).size.width * 0.3,
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 0.0),
                child: Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.05,
                    ),
                    isRecording
                        ? Padding(
                            padding: const EdgeInsets.only(left: 25.0, top: 30),
                            child: Container(
                              child: ElevatedButton(
                                onPressed: () {
                                  if (questionNumber >= 2) {
                                    questionNumber = 3;
                                    showSnackBar(context,
                                        "You are currenty beggener level so max questions you can attempt is 3 ");
                                  } else {
                                    setState(() {
                                      nextQuestion="tell me more about yourself";
                                      print(speech);
                                      print('ssssssssssssssssssssssssssssssssssssssssssssssssssss');
                                      print(_lastWords);
                                      speech="";
                                      _lastWords="";
                                      print(speech);
                                      print('ssssssssssssssssssssssssssssssssssssssssssssssssssss');
                                      print(_lastWords);
                                      //Call here AI API for next question every time
                                      questionNumber++;
                                      // timeList.add(seconds);
                                    });
                                  }
                                },
                                style: ButtonStyle(
                                  foregroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.white),
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.deepOrange),
                                ),
                                child: Text('Next'),
                              ),
                            ),
                          )
                        : Container(),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.1,
                    ),

                  ],
                ),
              ),
              isRecording
                  ?
              Row(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.3,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ElevatedButton(onPressed: (){
                      stopInterview();
                    },
                      child: Icon(Icons.call_end_outlined),
                      style: ButtonStyle(
                        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50.0),
                          ),
                        ),
                      ),
                    ),
                  ),
                  ElevatedButton(onPressed: (){
                    _speechToText.isNotListening ? _startListening() : _stopListening();
                  },
                    child: Icon(_speechToText.isNotListening ? Icons.mic_off : Icons.mic),
                    style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.grey),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                      ),
                    ),
                  ),
                ],
              )
                  : Container(),
            ],
          ),
        ),
        ),

    );
  }



  void interviewStrat() async {
    // APIService.startinterview().then((response) async {
    //   if (response) {

        // await starttimer();
        // _speechToText.isNotListening ? _startListening() : _stopListening();
        setState(() {
          // isInterview=!isInterview;
          isRecording = !isRecording;
          if (isRecording) {
            _controller.startVideoRecording();
          } else {
            _controller.stopVideoRecording().then((XFile file) {
              // Process the recorded video here
              // Apply ML algorithms, save locally, etc.
              setState(() {
                _videoPath = file.path;
              });
            });
          }
        });
        setState(() {});
        entry = OverlayEntry(
          builder: (context) => Positioned(
            right: offset.dx,
            bottom: offset.dy,
            child: GestureDetector(
              onPanUpdate: (details) {
                offset -= details.delta;
                entry!.markNeedsBuild();
              },
              child: Container(
                width: 120,
                height: 180,
                // color: Colors.blue.withOpacity(0.5),
                child: CameraPreview(_controller),
              ),
            ),
          ),
        );
        final overlay = Overlay.of(context)!;
        overlay.insert(entry!);
      // }
      // else {
      //   showSnackBar(context, "Enter Correct details");
      // }
    // });
  }

  Future<void> stopInterview() async {
    // stoptimer();
    _speechToText.isNotListening ? _startListening() : _stopListening();
     setState(() {
      isRecording = !isRecording;
      // isInterview=!isInterview;
      if (!isRecording) {
        _controller.stopVideoRecording().then((XFile file) async {
          // Process the recorded video here
          // Apply ML algorithms, save locally, etc.
          setState(() {
            _videoPath = file.path;
            print(_videoPath);
          });
          print(_videoPath);
          // var data = await APIService.uploadvideo(_videoPath);
          // print(data);
          // print('Video Path: $_videoPath');
        });
      }
      // seconds=maxSeconds;
    });
    entry?.remove();
    entry = null;
    setState(() {});
    Navigator.of(context).pop(false);
  }
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Future<void> starttimer() async {
  //   timer = Timer.periodic(Duration(seconds: 1), (_) {
  //     if (seconds > 0) {
  //       setState(() => seconds--);
  //     } else {
  //       stoptimer();
  //     }
  //   });
  // }
  //
  // void stoptimer({bool reset = true}) {
  //   if (reset) {
  //     resetTimer();
  //   }
  //   timer?.cancel();
  // }
  //
  // void resetTimer() => setState(() {
  //       seconds = maxSeconds;
  //       questionNumber = 0;
  //     });
  // Widget buildTime() {
  //   if (seconds == 0) {
  //     questionNumber = 0;
  //     stopInterview();
  //     return const Icon(
  //       Icons.done,
  //       color: Colors.greenAccent,
  //       size: 50,
  //     );
  //   } else if (seconds == 90 || seconds == 45) {
  //     if (questionNumber >= question.length - 1) {
  //       questionNumber = question.length - 1;
  //     } else {
  //       setState(() {
  //         questionNumber++;
  //         timeList.add(seconds);
  //       });
  //     }
  //   }
  //   return Text(
  //     '$seconds',
  //     style: const TextStyle(
  //         fontWeight: FontWeight.bold, color: Colors.black, fontSize: 50),
  //   );
  // }
  //
  // Widget buildTimer() => SizedBox(
  //       width: 100,
  //       height: 100,
  //       child: Stack(
  //         fit: StackFit.expand,
  //         children: [
  //           CircularProgressIndicator(
  //             value: 1 - seconds / maxSeconds,
  //             valueColor: const AlwaysStoppedAnimation(Colors.redAccent),
  //             strokeWidth: 8,
  //             backgroundColor: Colors.greenAccent,
  //           ),
  //           Center(
  //             child: buildTime(),
  //           ),
  //         ],
  //       ),
  //     );
}
