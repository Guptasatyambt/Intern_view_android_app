import 'package:flutter/material.dart';
import 'package:intern_view/services/api_service.dart';
import 'package:snippet_coder_utils/ProgressHUD.dart';

import '../models/feedback_request_model.dart';
import '../utils/utils.dart';
import '../widgets/customButton.dart';

class FeedbackForm extends StatefulWidget {
  const FeedbackForm({super.key});

  @override
  _FeedbackFormState createState() => _FeedbackFormState();
}

class _FeedbackFormState extends State<FeedbackForm> {
  final TextEditingController _feedbackController = TextEditingController();
  bool isApiCallProcess = false;
  GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();



  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.2,
          backgroundColor: Colors.white,
          iconTheme: const IconThemeData(color: Colors.blueGrey),

        ),
        body: ProgressHUD(
          inAsyncCall: isApiCallProcess,
          opacity: 0.3,
          key: UniqueKey(),
          child: Form(
            key: globalFormKey,
            child: _feedback(context),
          ),
        ),
      ),
    );
  }

  Widget _feedback(BuildContext context){
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Your Feedback:',
              style: TextStyle(fontSize: 20.0),
            ),
            SizedBox(height: 10.0),
            TextField(
              controller: _feedbackController,
              maxLines: 5,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter your feedback here...',
              ),
            ),
            SizedBox(height: 20.0),
            Row(
              children: [
                SizedBox(width: MediaQuery.of(context).size.width * 0.3,),
                CustomButton(
                  text:'Submit' ,
                  onPressed: _submitFeedback,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  void _submitFeedback() {
    String feedback = _feedbackController.text;
    if(feedback==""){
      showSnackBar(context, "Please Give Us Feedback");
    }
    else {
      setState(() {
        isApiCallProcess = true;
      });
      FeedbackRequestModel model =FeedbackRequestModel(
        userFeedback: feedback,
      );
      APIService.givefeedback(model).then(
            (response) {
          setState(() {
            isApiCallProcess = false;
          });
          if (response) {
            showSnackBar(context, "Thanks For Giving Us Feedback We'll definitely work on it");
          } else {
            showSnackBar(context, "Enter Correct details");
          }
        },
      );

    }
    }
}