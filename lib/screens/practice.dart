import 'dart:async';
import 'dart:io';
import 'package:path/path.dart' as Path;
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:intern_view/services/api_service.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import '../models/upload_video_request_model.dart';
import '../utils/utils.dart';
import '../widgets/customButton.dart';

class PracticePage extends StatefulWidget {
  final CameraDescription camera;
  const PracticePage({Key? key, required this.camera}) : super(key: key);

  @override
  State<PracticePage> createState() => _PracticePageState();
}

class _PracticePageState extends State<PracticePage> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  late List<CameraImage> imgfrm;
  int i=0;
  bool isRecording = false;
  late String _videoPath;
  OverlayEntry? entry;
  Offset offset = const Offset(5, 50);
  static const valueOfCoins = 120;
  late final record;
  late String _audioPath;

  static const maxSeconds = 180;
  int seconds = maxSeconds;
  Timer? timer;



  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.high,
    );
    record = AudioRecorder();
    imgfrm=[];
    _initializeControllerFuture = _controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
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
            Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: Row(
                children: [
                  Image.asset(
                    'assets/images/coin.png',
                    width: 30,
                    height: 30,
                  ),
                  Text(
                    '$valueOfCoins',
                    style: TextStyle(color: Colors.blueGrey),
                  )
                ],
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    left: 5.0, right: 5, top: 2, bottom: 10),
                child: Container(

                  child: !isRecording?Image.asset('assets/images/logowobg.png'):Image.asset('assets/images/interviewer(1).gif'),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              isRecording
                  ? SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: 50,
                      child: CustomButton(
                        onPressed: () => stopInterview(),
                        text: 'Stop Interview',
                      ),
                    )
                  : SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: 50,
                      child: CustomButton(
                        onPressed: () => interviewStrat(),
                        text: 'Start Interview',
                      ),
                    ),
              const SizedBox(
                height: 30,
              ),
              isRecording?
              buildTimer():
                  Container(),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    record.dispose();
    super.dispose();
  }

  void interviewStrat() async {

    // APIService.startinterview().then(
    //     (response)async{
    //       if (response) {
            await starttimer();
            setState(() {

              isRecording = !isRecording;
              if (isRecording) {
                _controller.startVideoRecording();
                _controller.startImageStream((image) {

                  setState(() {
                    print(image.width);
                    imgfrm.insert(i, image);
                    i++;
                  });
                });
              } else {
                _controller.stopVideoRecording().then((XFile file) {
                  // Process the recorded video here
                  // Apply ML algorithms, save locally, etc.
                  setState(() {
                    _videoPath = file.path;
                  });
                  print('Video Path: $_videoPath');
                });
              }
            });
            if (!(await record.hasPermission())) {
          print('Permission denied for audio recording');
          return;
          }
          if (isRecording) {
          // Start audio recording
          Directory tempDir = await getTemporaryDirectory();
          String tempPath = tempDir.path;
          await record.start(const RecordConfig(),
          path: '$tempPath/myAudioRecording.m4a');
          }
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
        //   }
        //   else {
        //     showSnackBar(context, "Enter Correct details");
        //   }
        // });

  }

  Future<void> stopInterview() async {
    stoptimer();
    setState(() {
      isRecording = !isRecording;
      if (!isRecording) {
        _controller.stopVideoRecording().then((XFile file) async {

           // Process the recorded video here
          // Apply ML algorithms, save locally, etc.
          setState(() {
            _videoPath = file.path;
          });
          var data=await APIService.uploadvideo(_videoPath);
          print(data);

          print('Video Path: $_videoPath');
        });
      }
    });
    entry?.remove();
    entry = null;
    if (!isRecording) {
      moveRecordingToAssets();
    }
    setState(() {});
  }

  Future<void> moveRecordingToAssets() async {
    // Get the temporary directory
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;

    // Get the assets directory
    Directory appDir = await getApplicationDocumentsDirectory();
    String assetsPath = '${appDir.path}/assets';
    // Create the assets directory if it doesn't exist
    if (!await Directory(assetsPath).exists()) {
      await Directory(assetsPath).create(recursive: true);
    }

    // Move the recorded audio file to the assets folder
    String recordedFilePath = '$tempPath/myAudioRecording.m4a';
    String destinationFilePath = '$assetsPath/myAudioRecording.m4a';

    await File(recordedFilePath).copy(destinationFilePath);
    _audioPath = destinationFilePath;
    print(_audioPath);
  }

  Future<void> starttimer() async {
    timer = Timer.periodic(Duration(seconds: 1), (_) {
      if (seconds > 0) {
        setState(() => seconds--);
      } else {
        stoptimer();
      }
    });
  }

  void stoptimer({bool reset = true}) {
    if (reset) {
      resetTimer();
    }
    timer?.cancel();
  }

  void resetTimer() => setState(() {
        seconds = maxSeconds;
      });
  Widget buildTime() {
    if(seconds==0){
      stopInterview();
      return const Icon(Icons.done,color: Colors.greenAccent,size: 50,);
    }
    return Text(
      '$seconds',
      style: const TextStyle(
          fontWeight: FontWeight.bold, color: Colors.black, fontSize: 50),
    );
  }

  Widget buildTimer() => SizedBox(
    width: 100,
    height: 100,
    child: Stack(
      fit: StackFit.expand,
          children: [
            CircularProgressIndicator(
              value: 1-seconds/maxSeconds,
              valueColor: const AlwaysStoppedAnimation(Colors.redAccent),
              strokeWidth: 8,
              backgroundColor: Colors.greenAccent,
             ),
            Center(
              child: buildTime(),
            ),
          ],

        ),
  );
}
