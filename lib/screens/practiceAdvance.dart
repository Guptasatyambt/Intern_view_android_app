import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import '../widgets/customButton.dart';

class AdvancePracticePage extends StatefulWidget {
  final CameraDescription camera;
  const AdvancePracticePage({Key? key, required this.camera}) : super(key: key);

  @override
  State<AdvancePracticePage> createState() => _PracticePageState();
}

class _PracticePageState extends State<AdvancePracticePage> {
  late CameraController _controller;
  bool isRecording = false;
  String? _videoPath;
  OverlayEntry? entry;
  Offset offset = Offset(5, 50);
  static const valueOfCoins=0;



  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.high,
    );
    _controller.initialize().then((_) {
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
      onWillPop: () async{
        if(isRecording){
          showDialog(context: context, builder: (BuildContext context){
            return AlertDialog(
              content: Container(
                height: 150,
                child:  Column(
                  children: [
                    ListTile(
                      leading: Icon(Icons.add_alert),
                      title: Text("This will affect your coins. Deducted fee will not be refunded if you press back."),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        SizedBox(width: 25,),
                        CustomButton(
                          onPressed: (){

                            stopInterview();
                            Navigator.of(context).pop(false);
                          },
                          text: 'Ok',
                        ),
                        SizedBox(width: 5,),
                        CustomButton(
                          onPressed: () {
                            // Close the dialog and allow back button behavior
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
          actions: const [
            Padding(
              padding: EdgeInsets.only(right: 10.0),
              child: Row(
                children: [
                  Icon(Icons.attach_money,color: Colors.blueGrey,),
                  Text('$valueOfCoins',style: TextStyle(color: Colors.blueGrey),)
                ],
              ),
            ),

          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 5.0,right: 5,top: 2,bottom: 10),
                child: Container(
                  child: Image.asset('assets/images/logo.jpg'),
                ),
              ),
              const SizedBox(height: 20,),
              isRecording
                  ? SizedBox(
                width: MediaQuery.of(context).size.width*0.8,
                height: 50,
                child: CustomButton(
                  onPressed: () => stopInterview(),
                  text: 'Stop Interview',
                ),
              )
                  : SizedBox(
                width: MediaQuery.of(context).size.width*0.8,
                height: 50,
                child: CustomButton(
                  onPressed: () => interviewStrat(),
                  text: 'Start Interview',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void interviewStrat() {
    setState(() {
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
          print('Video Path: $_videoPath');
        });
      }
    });
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
  }

  void stopInterview() {
    setState(() {
      isRecording = !isRecording;
      if (!isRecording) {
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
    entry?.remove();
    entry = null;
  }
}
