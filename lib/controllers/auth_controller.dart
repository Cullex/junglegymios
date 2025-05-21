import 'dart:io';
import 'dart:ui';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter/material.dart';

import '../screens/auth/opt_screen.dart';
import '../screens/auth/splash_screen.dart';
import '../screens/auth/token_screen.dart';
import '../screens/ui/customer/home_screen.dart';
import '../services/urls.dart';
import '../widgets/processing_dialog_widget.dart';


final GetStorage data = GetStorage();

class AuthController {
  Dio dio = Dio();
  TextEditingController name = TextEditingController();
  TextEditingController middle_name = TextEditingController();
  TextEditingController last_name = TextEditingController();
  TextEditingController username = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
  TextEditingController msisdn = TextEditingController();
  TextEditingController message = TextEditingController();
  TextEditingController address = TextEditingController();
  String city = '';
  File? profileImage;
  bool isLoading = false;




  Future<void> login(BuildContext context) async {
    showProcessingDialog(context);
    try {
      final response = await dio.post(Urls.login,
          options: Options(
            headers: {
              'Content-Type': 'application/json',
            },
          ),
          data: {'email': email.text, 'password': password.text});
      if (response.statusCode == 200) {
        var success = response.data['success'].toString();
        if (success == true.toString()) {
          data.write('user_id', response.data['user']['id'].toString());
          data.write('name', response.data['user']['name'].toString());
          data.write('email', response.data['user']['email'].toString());
          data.write('msisdn', response.data['user']['msisdn'].toString());
          data.write('role', response.data['user']['role'].toString());
          data.write('token', response.data['token']).toString();
          print('token: ${data.read('token')}');
          print('user_id: ${data.read('user_id')}');
          // Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
          //     builder: (BuildContext context) => HomeScreen()),
          //       (route) => false,
          // );
          Fluttertoast.showToast(msg: response.data['message']).toString();
          print("name: ${data.read('name')}".toString());
        }
        if (success == false.toString()) {
          Navigator.of(context).pop();
          Fluttertoast.showToast(msg: response.data['message']).toString();
        }
      } else {
        Navigator.of(context).pop();
        Fluttertoast.showToast(msg: response.data['message'].toString());
      }
    } catch (e) {
      Navigator.of(context).pop();
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  Future<void> resendRegToken(BuildContext context) async {
    try {
      final response = await dio.post(Urls.resendRegToken,
          options: Options(
            headers: {
              'Content-Type': 'application/json',
            },
          ),
          data: {'token': data.read('token').toString()});
      if (response.statusCode == 200) {
        var success = response.data['success'].toString();
        if (success == true.toString()) {
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context) => OtpScreen()), (route) => false);
          Fluttertoast.showToast(msg: response.data['message']).toString();
          print("name: ${data.read('name')}".toString());
        }
        if (success == false.toString()) {
          Fluttertoast.showToast(msg: response.data['message']).toString();
        }
      } else {
        isLoading = false;
        Fluttertoast.showToast(msg: response.data['message'].toString());
      }
    } catch (e) {
      isLoading = false;
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  Future<void> registerProfile(BuildContext context, String gender, String age, String rawPhoneNumber) async {
    showProcessingDialog(context);
    try {
      FormData formData = FormData.fromMap({
        'username': username.text,
        'name': name.text,
        'middle_name': middle_name.text,
        'last_name': last_name.text,
        'email': email.text,
        'password': password.text,
        'msisdn': rawPhoneNumber.toString(),
        'gender': gender.toString(),
        'age': age.toString(),
      });

      final response = await dio.post(Urls.registerProfile, data: formData);

      if (response.statusCode == 200) {
        var success = response.data['success'].toString();
        data.write('msisdn', response.data['data']['msisdn']);
        data.write('token', response.data['regToken']);
        print('msisdn: ${data.read('msisdn').toString()}');
        print('regToken: ${data.read('token').toString()}');
        if (success == true.toString()) {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => OtpScreen()));
          Fluttertoast.showToast(msg: response.data['message']);
        } else {
          Navigator.of(context).pop();
          Fluttertoast.showToast(msg: response.data['message']);
        }
      } else {
        Navigator.of(context).pop();
        Fluttertoast.showToast(msg: response.data['message']);
      }
    } catch (e) {
      Navigator.of(context).pop();

      // Handling DioError specifically for better debugging
      if (e is DioError) {
        if (e.response != null) {
          // Server error with a response
          print("DioError Response: ${e.response?.data}");
          Fluttertoast.showToast(msg: "Error: ${e.response?.data}");
        } else {
          // Request or connectivity error
          print("DioError Message: ${e.message}");
          Fluttertoast.showToast(msg: "Error: ${e.message}");
        }
      } else {
        // Generic error
        print("Generic Error: $e");
        Fluttertoast.showToast(msg: "Error: $e");
      }
    }
  }

  Future<void> checkRegToken(BuildContext context, String token) async {
    showProcessingDialog(context);
    try {
      final response = await dio.post(Urls.checkRegToken,
          options: Options(
            headers: {
              'Content-Type': 'application/json',
            },
          ),
          data: {'token': token.toString()});
      if (response.statusCode == 200) {
        var success = response.data['success'].toString();
        if (success == true.toString()) {
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
              builder: (BuildContext context) => HomeScreen()),
                (route) => false,
          );
          Fluttertoast.showToast(msg: response.data['message']).toString();
        }
        if (success == false.toString()) {
          Fluttertoast.showToast(msg: response.data['message']).toString();
        }
      } else {
        Fluttertoast.showToast(msg: response.data['message'].toString());
      }
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }



  Future<void> contactSupport(BuildContext context, String selectedTopic) async {
    showProcessingDialog(context);
    try {
      final response = await dio.post(Urls.contactSupport, data: {
        'senderName': data.read('username').toString(),
        'message': message.text,
        'messageType': selectedTopic.toString(),
      });
      if (response.statusCode == 200) {
        var success = response.data['success'].toString();
        if (success == true.toString()) {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) =>  HomeScreen()));
          Fluttertoast.showToast(msg: response.data['message']).toString();
        }
        if (success == false.toString()) {
          Navigator.of(context).pop();
          Fluttertoast.showToast(msg: response.data['message']).toString();
        }
      } else {
        Navigator.of(context).pop();
        Fluttertoast.showToast(msg: response.data['message'].toString());
      }
    } catch (e) {
      Navigator.of(context).pop();
      Fluttertoast.showToast(msg: e.toString());
    }
  }
}
