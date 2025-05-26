import 'dart:io';

import 'package:dio/dio.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter/material.dart';
import 'package:junglegym/models/users.dart';
import 'package:junglegym/screens/auth/otp_screen.dart';
import 'package:junglegym/screens/auth/password_reset_screen.dart';
import 'package:junglegym/screens/auth/splash_screen.dart';
import 'package:junglegym/screens/ui/customer/home_screen.dart';
import 'package:junglegym/services/urls.dart';
import 'package:junglegym/widgets/processing_dialog_widget.dart';

final GetStorage data = GetStorage();

class AuthController {
  Dio dio = Dio();
  final String bearerToken =  data.read('token').toString();
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
          await data.write('user_id', response.data['user']['id'].toString());
          await data.write('username', response.data['user']['username'].toString());
          await data.write('name', response.data['user']['name'].toString());
          await data.write('lastname', response.data['user']['last_name'].toString());
          await data.write('email', response.data['user']['email'].toString());
          await data.write('msisdn', response.data['user']['msisdn'].toString());
          await data.write('isAdmin', response.data['user']['isAdmin'].toString());
          await data.write('token', response.data['token']).toString();
          await data.write('status', response.data['user']['status']).toString();
          print('token: ${data.read('token')}');
          print('user_id: ${data.read('user_id')}');
          print('username: ${data.read('username').toString()}');
          if (data.read('role') == 1.toString()) {
            Fluttertoast.showToast(msg: response.data['message']).toString();
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>HomeScreen()));
          }
          else {
           //go to user screen
            Fluttertoast.showToast(msg: response.data['message']).toString();
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>HomeScreen()));
            print("username: ${data.read('username')}".toString());
          }
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

  Future<void> registerProfile(
      BuildContext context, String phoneNumber) async {
    showProcessingDialog(context);
    try {
      final response = await dio.post(
        Urls.registerProfile,
        data: {
          'username': username.text,
          'name': name.text,
          'middle_name': middle_name.text,
          'last_name': last_name.text,
          'email': email.text,
          'password': password.text,
          'msisdn': phoneNumber
        },

      );
      print('name: ${name.text}');
      print('surname: ${last_name.text}');
      if (response.statusCode == 200) {
        var success = response.data['success'].toString();
        if (success == true.toString()) {
          Fluttertoast.showToast(msg: response.data['message'].toString());

          await Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => HomeScreen()));
        } else {
          Fluttertoast.showToast(msg: response.data['message'].toString());
          Navigator.of(context).pop();
        }
      }
    } on DioException catch (e) {
      print("DioException: ${e.message}");
      if (e.response != null) {
        Fluttertoast.showToast(msg: 'An error occurred. Try Later');
        Navigator.of(context).pop();
        print("Response Status: ${e.response?.statusCode}");
        print("Response Data: ${e.response?.data}");
      }
      Fluttertoast.showToast(msg: 'An error occurred. Try Later');
      Navigator.of(context).pop();
    } catch (e) {
      print("Unexpected Error: $e");
      Fluttertoast.showToast(msg: 'An error occurred. Try Later');
      Navigator.of(context).pop();
    }
  }

  Future<void> resendRegToken(BuildContext context) async {
    try {
      final response = await dio.post('',
          options: Options(
            headers: {
              'Content-Type': 'application/json',
            },
          ),
          data: {'token': data.read('token').toString()});
      if (response.statusCode == 200) {
        var success = response.data['success'].toString();
        if (success == true.toString()) {
          //Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context) => OtpScreen()), (route) => false);
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



  Future<void> checkRegToken(BuildContext context, String token) async {
    showProcessingDialog(context);
    try {
      final response = await dio.post(
        Urls.checkRegToken,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
        data: {'token': token},
      );

      Navigator.of(context).pop(); // Close the dialog before navigating

      if (response.statusCode == 200) {
        final success = response.data['success'];
        final message = response.data['message'] ?? 'No message received';

        if (success == true) {
          data.remove('token');
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const SplashScreen()),
                (Route<dynamic> route) => false,
          );
          Fluttertoast.showToast(msg: message);
        } else {
          Fluttertoast.showToast(msg: message);
        }
      } else {
        Fluttertoast.showToast(
            msg: response.data['message']?.toString() ??
                'Unexpected error occurred');
      }
    } catch (e) {
      Navigator.of(context).pop(); // Ensure the dialog is closed on error
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  static Future<bool> checkNetwork() async {
    return true;
  }

  Future<void> profileUpdateEmail(BuildContext context, String userId) async {
    print("user id: ${userId}");
    showProcessingDialog(context);
    try {
      final response = await dio.post(Urls.updateProfileEMail, data: {
        'user_id' : userId.toString(),
        'email' : email.text
      });
      if(response.statusCode == 200){
        var success = response.data['success'].toString();
        if(success == true.toString()){
          Fluttertoast.showToast(msg: response.data['message'].toString());
          data.write('email', email.text.toString());
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>HomeScreen()));
          print(response.data.toString());
        } else {
          Fluttertoast.showToast(msg: response.data['message'].toString());
          Navigator.of(context).pop();
          print(response.data.toString());
        }
      }
    } on DioException catch (e) {
      Fluttertoast.showToast(msg: 'An error occurred. Try Later');
      Navigator.of(context).pop();
      print(e.response?.data.toString());
    } catch (e) {
      Fluttertoast.showToast(msg: 'An error occurred. Try Later');
      Navigator.of(context).pop();
      print(e.toString());;
    }
  }

  Future<void> profileUpdatePhone(BuildContext context, String userId, String rawPhoneNumber) async {
    print("user id: ${userId}");
    showProcessingDialog(context);
    try {
      final response = await dio.post(Urls.profileUpdatePhone, data: {
        'user_id' : userId.toString(),
        'msisdn' : rawPhoneNumber
      });
      if(response.statusCode == 200){
        var success = response.data['success'].toString();
        if(success == true.toString()){
          Fluttertoast.showToast(msg: response.data['message'].toString());
          data.write('msisdn', rawPhoneNumber);
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>HomeScreen()));
          print(response.data.toString());
        } else {
          Fluttertoast.showToast(msg: response.data['message'].toString());
          Navigator.of(context).pop();
          print(response.data.toString());
        }
      }
    } on DioException catch (e) {
      Fluttertoast.showToast(msg: 'An error occurred. Try Later');
      Navigator.of(context).pop();
      print(e.response?.data.toString());
    } catch (e) {
      Fluttertoast.showToast(msg: 'An error occurred. Try Later');
      Navigator.of(context).pop();
      print(e.toString());;
    }
  }

  Future<void> setAsAdmin(BuildContext context, String userId) async {
    print("user id: ${userId}");
    showProcessingDialog(context);
    try {
      final response = await dio.post(Urls.updateProfile, data: {
        'user_id' : userId.toString()
      });
      if(response.statusCode == 200){
        var success = response.data['success'].toString();
        if(success == true.toString()){
          Fluttertoast.showToast(msg: response.data['message'].toString());
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>HomeScreen()));
          print(response.data.toString());
        } else {
          Fluttertoast.showToast(msg: response.data['message'].toString());
          Navigator.of(context).pop();
          print(response.data.toString());
        }
      }
    } on DioException catch (e) {
      Fluttertoast.showToast(msg: 'An error occurred. Try Later');
      Navigator.of(context).pop();
      print(e.response?.data.toString());
    } catch (e) {
      Fluttertoast.showToast(msg: 'An error occurred. Try Later');
      Navigator.of(context).pop();
      print(e.toString());;
    }
  }

  Future<void> unsetAdmin(BuildContext context, String userId) async {
    showProcessingDialog(context);
    try {
      final response = await dio.post(Urls.removeAsAdmin, data: {
        'user_id' : userId.toString()
      });
      if(response.statusCode == 200){
        var success = response.data['success'].toString();
        if(success == true.toString()){
          Fluttertoast.showToast(msg: response.data['message'].toString());
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>HomeScreen()));
          print(response.data.toString());
        } else {
          Fluttertoast.showToast(msg: response.data['message'].toString());
          Navigator.of(context).pop();
          print(response.data.toString());
        }
      }
    } on DioException catch (e) {
      Fluttertoast.showToast(msg: 'An error occurred. Try Later');
      Navigator.of(context).pop();
      print(e.response?.data.toString());
    } catch (e) {
      Fluttertoast.showToast(msg: 'An error occurred. Try Later');
      Navigator.of(context).pop();
      print(e.toString());;
    }
  }

  Future<void> getPasswordResetToken(BuildContext context, String formattedNumber) async {
    print("number: ${formattedNumber.toString()}");
    showProcessingDialog(context);
    try {
      final response = await dio.post(Urls.getPasswordResetToken, data: {
        'msisdn' : formattedNumber
      });
      if(response.statusCode == 200){
        var success = response.data['success'].toString();
        if(success == true.toString()){
          await data.write('resetNumber', formattedNumber);
          await data.write('sentToken', response.data['data'].toString());
          Fluttertoast.showToast(msg: response.data['message'].toString());
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>OtpScreen()));
          print(response.data.toString());
        } else {
          Fluttertoast.showToast(msg: response.data['message'].toString());
          Navigator.of(context).pop();
          print(response.data.toString());
        }
      }
    } on DioException catch (e) {
      Fluttertoast.showToast(msg: 'An error occurred. Try Later');
      Navigator.of(context).pop();
      print(e.response?.data.toString());
    } catch (e) {
      Fluttertoast.showToast(msg: 'An error occurred. Try Later');
      Navigator.of(context).pop();
      print(e.toString());;
    }
  }

  Future<bool> checkSentToken(BuildContext context, String pin) async {
    var involvedNumber = data.read('resetNumber').toString();
    try {
      final response = await dio.post(Urls.checkSentToken,
          data: {'token': pin, 'msisdn': involvedNumber});
      if (response.statusCode == 200) {
        var success = response.data['success'].toString();
        if (success == 'true') {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => PasswordResetScreen()));
          return true;
        } else {
          Fluttertoast.showToast(msg: response.data['message']);
          print(response.data.toString());
          return false;
        }
      } else {
        Fluttertoast.showToast(msg: 'An error occurred. Try Later');
        print(response.data.toString());
        return false;
      }
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      print(e.toString());
      return false;
    }
  }


  Future<void> resetPassword(BuildContext context) async {
    var sentToken = data.read('sentToken').toString();
    showProcessingDialog(context);
    try {
      final response = await dio.post(Urls.resetPassword,
          data: {'token': sentToken, 'password': password.text});
      if (response.statusCode == 200) {
        var success = response.data['success'].toString();
        if (success == true.toString()) {
          Fluttertoast.showToast(msg: response.data['message']).toString();

          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                builder: (BuildContext context) => SplashScreen()),
                  (route) => false,
            );
          });
          print("name: ${data.read('name')}".toString());
        }
        if (success == false.toString()) {
          print(response.data.toString());
          Navigator.of(context).pop();
          Fluttertoast.showToast(msg: response.data['message']).toString();
        } else {
          print(response.data.toString());
          Navigator.of(context).pop();
          Fluttertoast.showToast(msg: response.data['message']);
        }
      } else {
        print(response.data.toString());
        Navigator.of(context).pop();
        Fluttertoast.showToast(msg: 'An error occurred. Try Later');
      }
    } catch (e) {
      print(e.toString());
      Navigator.of(context).pop();
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  Future<void> resendToken(BuildContext context) async {
    var sentToken = data.read('sentToken').toString();
    try {
      final response = await dio.post(Urls.resendToken, data: {
        'token' : sentToken
      });
      if(response.statusCode == 200){
        var success = response.data['success'].toString();
        if(success == true.toString()){
          Fluttertoast.showToast(msg: response.data['message'].toString());
          print(response.data.toString());
        } else {
          Fluttertoast.showToast(msg: 'An error occurred');
          print(response.data.toString());
        }
      }
    } on DioException catch (e) {
      Fluttertoast.showToast(msg: 'An error occurred. Try Later');
      print(e.response?.data.toString());
    } catch (e) {
      Fluttertoast.showToast(msg: 'An error occurred. Try Later');
      print(e.toString());;
    }
  }

  Future<List<UserModel?>> usersList(BuildContext context) async {
    try {
      print("token: ${data.read('token')}");
      final response = await dio.get(
        Urls.usersList,
        options: Options(
          headers: {
            'Authorization': 'Bearer $bearerToken',
          },
        ),
      );

      if (response.statusCode == 200) {
        var success = response.data['success'].toString();
        if (success == true.toString()) {
          final data = response.data['data'];
          print("response: ${response.data['message']}");
          return UserModel.fromJsonList(data);
        } else {
          print("response: ${response.data['message']}");
          Fluttertoast.showToast(msg: response.data['message']);
          return [];
        }
      }
    } on DioException catch (e) {
      print("DioException occurred: ${e.toString()}");
      print("DioError response: ${e.response?.data}");
      Fluttertoast.showToast(msg: e.message ?? 'Unknown Dio error');
      return [];
    } catch (e, stackTrace) {
      print("Unexpected error: $e");
      print("Stack trace: $stackTrace");
      Fluttertoast.showToast(msg: e.toString());
      return [];
    }

    return [];
  }
}
