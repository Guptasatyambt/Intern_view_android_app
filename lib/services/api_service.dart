import 'dart:convert';
import 'dart:io';

import 'package:intern_view/models/login_request_model.dart';
import 'package:intern_view/models/login_responce_model.dart';
import 'package:intern_view/models/register_request_model.dart';
import 'package:intern_view/models/register_responce_model.dart';
import 'package:http/http.dart' as http;

import '../../config.dart';
import '../models/feedback_request_model.dart';
import '../models/updateuser_request_model.dart';
import '../models/updateuser_responce_model.dart';
import 'shared_service.dart';

class APIService {
  static var client = http.Client();
  static const int maxRedirects = 5;
  static const int maxRedirectssignin = 5;

  static Future<bool> login(LoginRequestModel model,) async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
    };

    var url = Uri.http(
      Config.apiURL,
      Config.loginAPI,
    );

    var response = await client.post(
      url,
      headers: requestHeaders,
      body: jsonEncode(model.toJson()),
    );
    int redirectCount = 0;
    while (response.statusCode == 307) {
      // Check if the maximum number of redirects has been reached
      if (redirectCount >= maxRedirects) {
        throw Exception('Exceeded maximum number of redirections');
      }

      // Get the redirect URL from the Location header
      var redirectUrl = response.headers['location'];
      if (redirectUrl == null || redirectUrl.isEmpty) {
        throw Exception('Redirect URL is missing or empty');
      }
      var redirectUri = Uri.parse(redirectUrl);
      // Send a request to the redirect URL
      response = await client.post(
        redirectUri,
        headers: requestHeaders,
        body: jsonEncode(model.toJson()),
      );

      redirectCount++;
    }
    if (response.statusCode == 200) {
      await SharedService.setLoginDetails(
        loginResponseJson(
          response.body,
        ),
      );

      return true;
    } else {
      return false;
    }
  }

  static Future<bool> register(RegisterRequestModel model,) async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
    };

    var url = Uri.http(
      Config.apiURL,
      Config.registerAPI,
    );

    var response = await client.post(
      url,
      headers: requestHeaders,
      body: jsonEncode(model.toJson()),
    );
    int redirectCount = 0;
    while (response.statusCode == 307) {
      // Check if the maximum number of redirects has been reached
      if (redirectCount >= maxRedirectssignin) {
        throw Exception('Exceeded maximum number of redirections');
      }

      // Get the redirect URL from the Location header
      var redirectUrl = response.headers['location'];
      if (redirectUrl == null || redirectUrl.isEmpty) {
        throw Exception('Redirect URL is missing or empty');
      }
      var redirectUri = Uri.parse(redirectUrl);
      // Send a request to the redirect URL
      response = await client.post(
        redirectUri,
        headers: requestHeaders,
        body: jsonEncode(model.toJson()),
      );

      redirectCount++;
    }
    if (response.statusCode == 200) {
      await SharedService.setLoginDetails(
        loginResponseJson(
          response.body,
        ),
      );

      return true;
    } else {
      return false;
    }
  }


  static Future<bool> updateuser(UpdateuserRequestModel model,
      String profileimage,
      String resume,) async {
    var baseUrl = Config.apiURL;
    var apiUrl = Config.userupdateAPI;
    var url = Uri.parse('https://intern-view.onrender.com/user/uploadinfo');
    var request = http.MultipartRequest('POST', url);
    // Add profile image file
    if (profileimage != null) {
      var file = File(profileimage!);
      var multipartFile = await http.MultipartFile.fromPath(
        'profileimage',
        file.path,
      );


      // Add the multipart file to the request's files list
      request.files!.add(multipartFile);
    }


    // Add resume file
    if (resume != null) {
      var file = File(resume!);
      var multipartFile = await http.MultipartFile.fromPath(
        'resume',
        file.path,
      );


      // Add the multipart file to the request's files list
      request.files!.add(multipartFile);
    }
    request.fields['name'] = model.name!;
    request.fields['branch'] = model.branch!;
    request.fields['specialization'] = model.specialization!;
    request.fields['year'] = model.year!;
    request.fields['college'] = model.college!;
    try {
      var cacheData = await SharedService.loginDetails();
      var token = cacheData?.data.token;
      if (token != null) {
        // Add token to request headers
        request.headers['Authorization'] = 'Bearer $token';
      } else {
        return false;
      }
      var response = await request.send();
      if (response.statusCode == 200) {
        await SharedService.setusername(
          UpdateuserResponseModel(
            message: 'Success',
            name: model.name!,
          ),
        );
        return true;
      }
      else {
        return false;
      }
    }
    catch (e) {
      return false;
    }
  }


  static Future<String> getUserProfile() async {
    var loginDetails = await SharedService.loginDetails();

    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${loginDetails!.data.token}'
    };
    var baseUrl = Config.apiURL;
    var apiUrl = Config.userProfileAPI;
    var url = Uri.parse('https://intern-view.onrender.com/user/getinfo');
    // var url = Uri.http(Config.apiURL, Config.userProfileAPI);
    print('${loginDetails.data.token}');
    var response = await client.get(
      url,
      headers: requestHeaders,
    );
    print('${response.statusCode}');
    if (response.statusCode == 200) {
      print('${response.statusCode}');

      return response.body;
    } else {
      return "";
    }
  }


  //feedback

  static Future<bool> givefeedback(FeedbackRequestModel model,) async {
    var loginDetails = await SharedService.loginDetails();

    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${loginDetails!.data.token}'
    };

    var url = Uri.http(
      Config.apiURL,
      Config.feedbackAPI,
    );

    var response = await client.post(
      url,
      headers: requestHeaders,
      body: jsonEncode(model.toJson()),
    );
     int redirectCount = 0;
    while (response.statusCode == 307) {
      // Check if the maximum number of redirects has been reached
      if (redirectCount >= maxRedirects) {
        throw Exception('Exceeded maximum number of redirections');
      }

      // Get the redirect URL from the Location header
      var redirectUrl = response.headers['location'];
      if (redirectUrl == null || redirectUrl.isEmpty) {
        throw Exception('Redirect URL is missing or empty');
      }
      var redirectUri = Uri.parse(redirectUrl);
      // Send a request to the redirect URL
      response = await client.post(
        redirectUri,
        headers: requestHeaders,
        body: jsonEncode(model.toJson()),
      );

      redirectCount++;
    }
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
//start interview
  static Future<bool> startinterview() async {
    var loginDetails = await SharedService.loginDetails();

    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${loginDetails!.data.token}'
    };
    String uri = 'https://intern-view.onrender.com/interview/start';

    // Define your query parameters
    Map<String, String> queryParams = {
      'level': 'beginner',
    };

    // Encode the query parameters into a format that can be appended to the URL
    String queryString = Uri(queryParameters: queryParams).query;

    // Concatenate the URL with the query string
    String requestUrl = '$uri?$queryString';
    // var url = Uri.http(
    //   Config.apiURL,
    //   Config.feedbackAPI,
    // );
    var url=Uri.parse(requestUrl);

    var response = await client.post(
      url,
      headers: requestHeaders,
    );
    int redirectCount = 0;
    while (response.statusCode == 307) {
      // Check if the maximum number of redirects has been reached
      if (redirectCount >= maxRedirects) {
        throw Exception('Exceeded maximum number of redirections');
      }

      // Get the redirect URL from the Location header
      var redirectUrl = response.headers['location'];
      if (redirectUrl == null || redirectUrl.isEmpty) {
        throw Exception('Redirect URL is missing or empty');
      }
      var redirectUri = Uri.parse(redirectUrl);
      // Send a request to the redirect URL
      response = await client.post(
        redirectUri,
        headers: requestHeaders,

      );

      redirectCount++;
    }
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}