import 'package:flutter/material.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:snippet_coder_utils/ProgressHUD.dart';
import '../models/updateuser_request_model.dart';
import '../services/api_service.dart';
import '../utils/utils.dart';
import '../widgets/customButton.dart';
// import 'package:permission_handler/permission_handler.dart';

class UserInformationPage extends StatefulWidget {
  const UserInformationPage({super.key});

  @override
  State<UserInformationPage> createState() => _UserInformationPageState();
}

class _UserInformationPageState extends State<UserInformationPage> {
  File? image;
  final nameController = TextEditingController();
  final branchController = TextEditingController();
  final collegeController = TextEditingController();
  final specializationController = TextEditingController();
  final yearController = TextEditingController();

  bool isApiCallProcess = false;
  GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();
  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    branchController.dispose();
    collegeController.dispose();
    specializationController.dispose();
    yearController.dispose();
  }

  // for selecting image
  void selectImage() async {
    image = await pickImage(context);
    setState(() {});
  }

  // String dropdownValue = 'Option 1';
  String selectedValue1 = 'Choose Your Branch        ';
  List<String> dropdownItems1 = [
    'Choose Your Branch        ',
    'CSE',
    'ECE',
    'EN',
    'CIVIL',
    'MECHANICS'
  ];
  String selectedValue2 = 'Specialization';
  List<String> dropdownItems2 = ['Specialization', 'None', 'DS', 'AI&ML', 'CS'];
  String selectedValue3 = 'Year';
  List<String> dropdownItem3 = ['Year', '1', '2', '3', '4'];
  File? fileToDisplay;
  bool status = false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black38,
        body:ProgressHUD(
          child: Form(
            key: globalFormKey,
            child: _updateUI(context),
          ),
          inAsyncCall: isApiCallProcess,
          opacity: 0.3,
          key: UniqueKey(),
        ),
      ),
    );
  }

  Widget _updateUI(BuildContext context){
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 25.0, horizontal: 5.0),
      child: Center(
        child: Column(
          children: [
            InkWell(
              onTap: () => selectImage(),
              child: image == null
                  ? const CircleAvatar(
                backgroundColor: Colors.black38,
                radius: 50,
                child: Icon(
                  Icons.account_circle,
                  size: 100,
                  color: Colors.white,
                ),
              )
                  : CircleAvatar(
                backgroundImage: FileImage(image!),
                radius: 50,
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              padding:
              const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
              margin: const EdgeInsets.only(top: 20),
              child: Column(
                children: [
                  // name field
                  textFeld(
                    hintText: "Name",
                    icon: Icons.account_circle,
                    inputType: TextInputType.name,
                    maxLines: 1,
                    controller: nameController,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: DropdownButton<String>(
                      dropdownColor: Colors.transparent,
                      focusColor: Colors.white,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w500),
                      value: selectedValue1,
                      items: dropdownItems1.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedValue1 = newValue!;
                          branchController.text = newValue;
                        });
                      },
                    ),
                  ),
                  Row(
                    children: [
                      const SizedBox(width: 20),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.4,
                        child: DropdownButton<String>(
                          dropdownColor: Colors.transparent,
                          focusColor: Colors.white,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w500),
                          value: selectedValue2,
                          items: dropdownItems2.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedValue2 = newValue!;
                              specializationController.text = newValue;
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 20),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.3,
                        child: DropdownButton<String>(
                          dropdownColor: Colors.transparent,
                          focusColor: Colors.white,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w500),
                          value: selectedValue3,
                          items: dropdownItem3.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedValue3 = newValue!;
                              yearController.text = newValue;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  textFeld(
                    hintText: "College",
                    icon: Icons.home_repair_service_rounded,
                    inputType: TextInputType.name,
                    maxLines: 1,
                    controller: collegeController,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            status == true
                ? Container(
                decoration: BoxDecoration(
                  border: Border.all(
                      color:
                      Colors.white10), // Set border properties here
                  borderRadius: BorderRadius.circular(
                      8), // Optional: Set border radius
                ),
                child: ListTile(
                  leading: const Icon(
                    Icons.picture_as_pdf,
                    color: Colors.white,
                  ),
                  subtitle: Text(
                    'File:$fileToDisplay',
                    style: const TextStyle(color: Colors.blue),
                  ),
                ))
                : GestureDetector(
              onTap: () => pickFile(),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.50,
                height: 45,
                color: Colors.blue,
                child: const Row(
                  children: [
                    Icon(Icons.upload_file,color: Colors.white,),
                    SizedBox(width: 10,),
                    Text(
                      "Upload Resume",
                      style: TextStyle(fontSize: 16,color: Colors.white),
                    )
                  ],
                ),
              ),
            ),

            SizedBox(
              height: 20,
            ),
            SizedBox(
              height: 50,
              width: MediaQuery.of(context).size.width * 0.90,
              child: CustomButton(
                text: 'Continue',
                onPressed: () => sentDatatoDatabase(),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget textFeld({
    required String hintText,
    required IconData icon,
    required TextInputType inputType,
    required int maxLines,
    required TextEditingController controller,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextFormField(
        cursorColor: Colors.white,
        controller: controller,
        keyboardType: inputType,
        maxLines: maxLines,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white70,
        ),
        decoration: InputDecoration(
          fillColor: Colors.transparent,
          prefixIcon: Container(
            margin: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.black38,
            ),
            child: Icon(
              icon,
              size: 20,
              color: Colors.white,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: Colors.white10,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: Colors.white54,
            ),
          ),
          hintText: hintText,
          hintStyle: const TextStyle(
            color: Colors.white70,
            fontWeight: FontWeight.w500,
            fontSize: 15,
          ),
          alignLabelWithHint: true,
          border: InputBorder.none,
          // fillColor: Colors.white60,
          filled: true,
        ),
      ),
    );
  }

  Future<void> pickFile() async {
    try {
      FilePickerResult? result;
      String? _fileName;
      PlatformFile? pickedFile;
      bool isLoading = false;

      result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowMultiple: false,
        allowedExtensions: ['pdf', 'doc'],
      );
      if (result != null) {
        _fileName = result!.files.first.name;
        pickedFile = result!.files.first;

        setState(() {
          fileToDisplay = File(pickedFile!.path.toString());
          status = true;
        });
        print("file name:$fileToDisplay");
      } else {
        // User canceled the picker
        print('User canceled file picker');
      }
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  Future<void> sentDatatoDatabase() async {
    if(image==null){
      showSnackBar(context, "Add profile image");
    }
    if(fileToDisplay==null){
      showSnackBar(context, "Add resume pdf");
    }
    uploadInfo(image!, fileToDisplay!);
    // Navigator.pushReplacementNamed(context, '/home');
  }

  Future<void> uploadInfo(File profileImage, File resume) async {
    if(nameController.text==""||branchController.text==""||specializationController.text==""||yearController.text==""||collegeController.text==""){
      showSnackBar(context, "Enter all details");
    }
    else{
      setState(() {
        isApiCallProcess = true;
      });

      UpdateuserRequestModel model = UpdateuserRequestModel(
        name: nameController.text,
        branch: branchController.text,
        specialization: specializationController.text,
        year: yearController.text,
        college: collegeController.text,
      );
      APIService.updateuser(model,profileImage.path,resume.path).then(
            (response) {
          setState(() {
            isApiCallProcess = false;
          });
          if (response) {
            bool signup = true;
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



    // var url = Uri.parse('YOUR_SERVER_URL/uploadinfo');
    //
    // var request = http.MultipartRequest('POST', url);
    //
    // // Add profile image file
    // if (profileImage != null) {
    //   request.files.add(await http.MultipartFile.fromPath(
    //       'profileimage', profileImage.path));
    // }
    //
    // // Add resume file
    // if (resume != null) {
    //   request.files.add(
    //       await http.MultipartFile.fromPath('resume', resume.path));
    // }
    //
    // // Send the request
    // var response = await request.send();
    //
    // // Check the response status
    // if (response.statusCode == 200) {
    //   print('Upload successful');
    // } else {
    //   print('Upload failed with status ${response.statusCode}');
    // }
  }
  // Future<http.Response> fetchAlbum() {
  //   return http.get(Uri.parse('https://jsonplaceholder.typicode.com/albums/1'));
  // }
}
