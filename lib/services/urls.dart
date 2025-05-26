class Urls {
  //static String baseUrl = 'http://localhost:8000/api/';
  //static String baseUrl = 'http://18.235.229.147/api/';
  static String baseUrl = 'https://softifysolutionsgroup.com/api/';

  //check network connectivity
  static String checkConnectivity =  '${baseUrl}checkConnectivity';
  //login user
  static String login = '${baseUrl}login';
  // register user
  static String registerProfile = '${baseUrl}register';
  //register doctor
  static String registerDoctor = '${baseUrl}register_doctor';

  //getPasswordResetToken
  static String resendRegToken = '${baseUrl}resendRegToken';

  //checkRegToken
  static String checkRegToken = '${baseUrl}check_reg_token';

  //return list of shared location
  static String sharedLocations = '${baseUrl}shared_locations';

  //share location to db
  static String saveLocation = '${baseUrl}save_location';

  //return dashboard stats
  static String dashboardStats = '${baseUrl}dashboard_stats';

  //get reset token
  static String getPasswordResetToken = '${baseUrl}getPasswordResetToken';

  //resend token
  static String resendToken = '${baseUrl}resend_token';

  //check sent token
  static String checkSentToken = '${baseUrl}check_sent_token';

  //reset password
  static String resetPassword = '${baseUrl}reset_password';

  //set as attended
  static String setAttended = '${baseUrl}set';


  //set as unattended
  static String setAsUnattended = '${baseUrl}setAsUnattended';

  //users list
  static String usersList = '${baseUrl}users_list';

  //set as admin
  static String updateProfile = '${baseUrl}update_profile';

  //set as ordinary
  static String removeAsAdmin = '${baseUrl}removeAsAdmin';

  //save package
  static String savePackage = '${baseUrl}save_package';

  //get list of packages
  static String packages = '${baseUrl}packages';

  //archive package
  static String deletePackage = '${baseUrl}delete_package';

  //upload client file
  static String uploadFile = '${baseUrl}customer_file_upload';

  //update email
  static String updateProfileEMail = '${baseUrl}profile_email_update';

  //update number
  static String profileUpdatePhone = '${baseUrl}profile_update_phone';



}