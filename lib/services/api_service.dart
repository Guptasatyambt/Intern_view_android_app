import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:camera/camera.dart';
import 'package:intern_view/models/login_request_model.dart';
import 'package:intern_view/models/login_responce_model.dart';
import 'package:intern_view/models/otp_request_model.dart';
import 'package:intern_view/models/register_request_model.dart';
import 'package:intern_view/models/register_responce_model.dart';
import 'package:http/http.dart' as http;
import 'package:intern_view/models/upload_video_request_model.dart';
import 'package:path/path.dart' as path;
import 'package:http_parser/http_parser.dart';
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

  static Future<bool> forgotPassword(String email) async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
    };

    var url = Uri.http(
      Config.apiURL,
      Config.sendotp,
    );
    var response = await client.post(
      url,
      headers: requestHeaders,
      body: jsonEncode({"email": email}),
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
        body: jsonEncode({"email": email}),
      );

      redirectCount++;
    }
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> verifyOtp(OtpRequestModel model) async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
    };

    var url = Uri.http(
      Config.apiURL,
      Config.validateotp,
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

  static Future<bool> updatePassword(LoginRequestModel model,) async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
    };

    var url = Uri.http(
      Config.apiURL,
      Config.updatepassword,
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

  static Future<String> register(RegisterRequestModel model,) async {
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
    print(response.statusCode);
    if (response.statusCode == 200) {
      await SharedService.setLoginDetails(
        loginResponseJson(
          response.body,
        ),
      );

      return "true";
    } else {
      var responseJson = json.decode(response.body);

      // Extract the message from the JSON
      return responseJson['message'];
    }
  }

  static Future<String> uploadvideo(String video) async {
    var url = Uri.parse('https://intern-view.onrender.com/user/uploadvideo');
    var request = http.MultipartRequest('POST', url);
    // Add video file
    if (video!=null) {
      // var file = File(video.path);
      var multipartFile = await http.MultipartFile.fromPath(
        'video',
        video,
        contentType: MediaType('video', 'mp4'),
      );
      // Add the multipart file to the request's files list
      request.files.add(multipartFile);
    }
    // request.fields['uid'] = model.uid!;
    try {
      var cacheData = await SharedService.loginDetails();
      var token = cacheData?.data.token;
      request.fields['uid'] = cacheData!.data.id;
      if (token != null) {
        // Add token to request headers
        request.headers['Authorization'] = 'Bearer $token';
      } else {
        return "Token is null";
      }

      var response = await request.send();

      if (response.statusCode == 200) {
        // Assuming that on success, you might want to return the response as a string
        var responseData = await http.Response.fromStream(response);
        var responseBody = json.decode(responseData.body);

        // Assuming the response body contains the uid field
        if (responseBody.containsKey('url')) {
          return responseBody['url'];
        } else {
          return "uid not found in response";
        }
      } else {
        return "Failed to upload: ${response.statusCode}";// Adjust this based on your actual needs
      }
    } catch (e) {
      return "Error: $e";
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

    if (loginDetails == null || loginDetails.data.token == null) {
      throw Exception('Login details or token is missing');
    }

    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${loginDetails.data.token}',
    };

    // Base URI
    String uri = 'https://intern-view.onrender.com/user/startinterview';

    // Define your query parameters
    Map<String, String> queryParams = {
      'level': 'beginner',
    };

    // Encode the query parameters into a format that can be appended to the URL
    String queryString = Uri(queryParameters: queryParams).query;

    // Concatenate the URL with the query string
    String requestUrl = '$uri?$queryString';

    // Parse the full URL
    var url = Uri.parse(requestUrl);

    // Send the POST request
    var response = await client.get(
      url,
      headers: requestHeaders,
    );

    int redirectCount = 0;
    const int maxRedirects = 5;  // Set a reasonable maximum number of redirects

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
    return response.statusCode == 200;
  }


  static Future<bool> updateImage(String profileimage) async {
// var baseUrl = Config.apiURL;
// var apiUrl = Config.userupdateAPI;
    var url = Uri.parse('https://intern-view.onrender.com/user/updateimage');
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

  static Future<bool> updateResume(String resume) async {
// var baseUrl = Config.apiURL;
// var apiUrl = Config.userupdateAPI;
    var url = Uri.parse('https://intern-view.onrender.com/user/updateresume');
    var request = http.MultipartRequest('POST', url);


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
      print(response.statusCode);
      if (response.statusCode == 200) {
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

  static Future<bool> updateyear(String year) async {
    var loginDetails = await SharedService.loginDetails();

    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${loginDetails!.data.token}'
    };

    var url = Uri.http(
      Config.apiURL,
      Config.updateyear,
    );

    var response = await client.post(
      url,
      headers: requestHeaders,
      body: jsonEncode({'year': year}),
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
        body: jsonEncode({'year': year}),
      );

      redirectCount++;
    }
    if (response.statusCode == 200) {
      return true;
    } else {
      print(response.statusCode);
      return false;
    }
  }

  static Future<String> getInterview(String id) async {
    var loginDetails = await SharedService.loginDetails();
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${loginDetails!.data.token}'
    };

    // Add the interview_id as a query parameter
    // var url = Uri.http(
    //     Config.apiURL,
    //     Config.getInterview,
    //     {"interview_id": id}  // Add query parameter here
    // );
    var url=Uri.parse('http://intern-view.onrender.com/interview/getdetail?interview_id=66b6741aff20562c449ca58f');

    print(url);
print(requestHeaders);
    try {
      final response = await http.get(
        Uri.parse('http://intern-view.onrender.com/interview/getdetail?interview_id=66b6741aff20562c449ca58f'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${loginDetails!.data.token}',
        },
      );

      // If it reaches here, print the response
      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");



    print(response.statusCode);

    int redirectCount = 0;
    const int maxRedirects = 5;  // Define a max redirect count

    // while (response.statusCode == 307) {
    //   // Check if the maximum number of redirects has been reached
    //   if (redirectCount >= maxRedirects) {
    //     throw Exception('Exceeded maximum number of redirections');
    //   }
    //
    //   // Get the redirect URL from the Location header
    //   var redirectUrl = response.headers['location'];
    //   if (redirectUrl == null || redirectUrl.isEmpty) {
    //     throw Exception('Redirect URL is missing or empty');
    //   }
    //
    //   var redirectUri = Uri.parse(redirectUrl);
    //
    //   // Send a request to the redirect URL
    //   response = await client.get(
    //     redirectUri,
    //     headers: requestHeaders,
    //   );
    //
    //   redirectCount++;
    // }

    if (response.statusCode == 200) {
      return response.body;
    } else {
      return "";
    }
    } catch (e) {
      print("Error occurred: $e");
      return "";
    }
  }
// static Future<List<String>> getQuestionList() async{
// var responce=await getUserProfile();
// final Map<String,dynamic> body=jsonDecode(responce);
// String resume_url=body['url'];
//
// Map<String, String> requestHeaders = {
//   'Content-Type': 'application/json',
// };
//
// var url = Uri.http(
//   Config.mlApiURL,
//   Config.getQuestion,
// );
//
// var responseQuestion = await client.post(
//   url,
//   headers: requestHeaders,
//   body: jsonEncode({'resume_url':resume_url}),
// );
// List<String,String> questions
// if (responseQuestion.statusCode == 200) {
//   print('URL sent successfully: ${responseQuestion.body}');
//   return responseQuestion;
// } else {
//   print('Failed to send URL: ${response.statusCode}');
//   print('Response body: ${response.body}');
// }
// }
}