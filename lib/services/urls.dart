class Urls {
  static String baseUrl = 'http://10.0.2.2:8000/api/';
  //static String baseUrl = 'http://54.88.229.146/api/';

  //check network connectivity
  static String checkConnectivity =  'https://google.com';
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

  //save Patient Record
  static String savePatient = '${baseUrl}save_patient';
  //return list of all patients
  static String allPatients = '${baseUrl}all_patients';
  //add prescription
  static String addPrescription = '${baseUrl}add_prescription';
  //get patient prescription history
  static String prescriptionHistory = '${baseUrl}prescription_history';
  //add patient note
  static String addNotes = '${baseUrl}add_notes';
  //return patient's notes
  static String patientNotes = '${baseUrl}patient_notes';
  //contact support
  static String contactSupport =  '${baseUrl}customer_contact_support';
  //return all prescriptions
 static String allPrescriptions = '${baseUrl}all_prescriptions';

 //APPOINTMENTS
 //return all appointments
  static String allAppointments = '${baseUrl}logged_cus_appointments';
  //return list of all doctors
  static String allDoctors = '${baseUrl}all_doctors';
  //schedule appointment
  static String scheduleAppointment = '${baseUrl}add_appointment';
  //patient upload image
  static String patientPrepUpload = '${baseUrl}patient_prep_upload';


  //questions
  static String ask = '${baseUrl}ask';
}