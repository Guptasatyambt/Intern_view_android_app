import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intern_view/config.dart';

import '../services/api_service.dart';
import '../services/shared_service.dart';



class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  static const valueOfCoins = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return userProfile();

  }

  Widget userProfile() {
    return FutureBuilder(
      future: APIService.getUserProfile(),
      builder: (
          BuildContext context,
          AsyncSnapshot<String> model,
          ) {
        if (model.connectionState == ConnectionState.waiting) {
          // Loading state
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        else if (model.hasError) {
          // Error state
          return Center(
            child: Text('Error fetching user profile'),
          );
        }
        else if (model.hasData) {
          // Data available
          var userProfileData = jsonDecode(model.data!);

          String name = userProfileData['name'];
          String email = userProfileData['email'];
          String id = userProfileData['_id'];
          String profileimage = userProfileData['profileimage'];
          String college = userProfileData['college'];
          String branch = userProfileData['branch'];
          String specialization = userProfileData['specialization'];
          String year = userProfileData['year'];
          String resume = userProfileData['resume'];
          var coins = userProfileData['coins'];

          return Scaffold(
            appBar: AppBar(
              elevation: 0.2,
              backgroundColor: Colors.white,
              iconTheme: const IconThemeData(color: Colors.blueGrey),
              actions: [
                Padding(
                  padding: EdgeInsets.only(right: 20.0),
                  child: Row(
                    children: [
                      Image.asset(
                        'assets/images/coin.png',
                        width: 30,
                        height: 30,
                      ),
                      Text(
                        '$coins',
                        style: const TextStyle(color: Colors.blueGrey),
                      )
                    ],
                  ),
                ),
              ],
            ),
            body: Center(
              child: Column(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.black38,
                    backgroundImage: NetworkImage("http://"+Config.apiURL+"/"+profileimage),
                    radius: 50,
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: Container(
                        padding: const EdgeInsets.all(0),
                        decoration: const BoxDecoration(
                          color: Colors.transparent,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                SizedBox(
                  height: 30,
                ),
                  textField( data: name, edit: 0),
                  textField( data: email, edit: 0),
                  textField( data: college, edit: 0),
                  textField( data: branch, edit: 0),
                  textField( data: specialization, edit: 0),
                  textField( data: "${year}rd Year", edit: 0),

                ],
              ),
            ),
          );

        }
        else {
          // Placeholder for other states
          return const SizedBox();
        }
      },
    );
  }

  Widget textField({
    required String data,
    required int edit,
  }) {
    return Padding(
      padding: const EdgeInsets.only(left: 13.0, top: 15, bottom: 15),
      child: Row(
        children: [

          SizedBox(
            width: MediaQuery.of(context).size.width * 0.1,
          ),
          Text(
            data,
            style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w400,
                color: Colors.black),
          ),
          edit == 1
              ? SizedBox(
            width: MediaQuery.of(context).size.width * .5,
            child: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.edit),
              color: Colors.black45,
            ),
          )
              : const Text("")
        ],
      ),
    );
  }

}
