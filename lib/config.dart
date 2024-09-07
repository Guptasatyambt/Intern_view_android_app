class Config {
  static const String appName = "Internview";
  static const String apiURL = 'intern-view.onrender.com';//PROD_URL
  static const String mlApiURL = 'https://python-project-7bs3.onrender.com';
  static const loginAPI = "/user/login";
  static const registerAPI = "/user/signin";

  static const userProfileAPI = "/user/getinfo";
  static const userupdateAPI="/user/uploadinfo";
  static const feedbackAPI="feedback/uploadfeedback";
  static const getQuestion="extract_skills";
  static const updateyear="user/updateyear";
  static const sendotp="user/passwordresetreq";
  static const validateotp="user/validateotp";
  static const updatepassword="user/updatepassword";
  static const getInterview="interview/getdetail";


}