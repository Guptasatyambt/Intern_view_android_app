import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../widgets/customButton.dart';


class ContactUsPage extends StatefulWidget {
  const ContactUsPage({super.key});

  @override
  _ContactUsPageState createState() => _ContactUsPageState();
}

class _ContactUsPageState extends State<ContactUsPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  final TextEditingController _subjectController = TextEditingController();

  final String defaultEmail = 'guptasatyamml@gmail.com'; // Change this to your default email

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      elevation: 0.2,
      backgroundColor: Colors.white,
      iconTheme: const IconThemeData(color: Colors.blueGrey),
      title: const Text('Contact-Us',style: TextStyle(color: Colors.blueGrey),),
    ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextFormField(
                  controller: _nameController,
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Your Name',
                  ),
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _emailController,
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Please enter your email address';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Email Address',
                  ),
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _subjectController,
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Please enter subject';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Subject',
                  ),
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _messageController,
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Please enter your message';
                    }
                    return null;
                  },
                  maxLines: 5,
                  decoration: const InputDecoration(
                    labelText: 'Message',
                  ),
                ),
                const SizedBox(height: 32.0),
                Center(
                  child: CustomButton(
                    text:'Submit' ,
                    onPressed: (){
                      if (_formKey.currentState?.validate()??true) {
                      _submitForm();
                      }
          },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _submitForm() async {
    String name = _nameController.text;
    String email = _emailController.text;
    String message = _messageController.text;

    String subject = 'Contact Us Form Submission';

    String body = 'Name: $name\n'
        'Email: $email\n'
        'Message: $message';

    String url = 'mailto:$defaultEmail?subject=${Uri.encodeFull(subject)}&body=${Uri.encodeFull(body)}';

    try {
      await launch(url); // Clear the text fields after submission
      _nameController.clear();
      _emailController.clear();
      _messageController.clear();

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Submission Successful'),
            content: Text('Thank you for contacting us! We will get back to you as soon as possible.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Failed to open email client.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }
}