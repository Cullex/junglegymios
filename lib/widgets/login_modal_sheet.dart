import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:junglegym/screens/auth/register_screen.dart';
import '../controllers/auth_controller.dart';
import '../screens/ui/customer/home_screen.dart';
import '../services/dimensions.dart';
import '../services/fingerprint_login_service.dart';

class LoginModalBottomSheet extends StatefulWidget {
  const LoginModalBottomSheet({super.key});

  @override
  State<LoginModalBottomSheet> createState() => _LoginModalBottomSheetState();
}

class _LoginModalBottomSheetState extends State<LoginModalBottomSheet> {

  final _resetPasswordFormKey = GlobalKey<FormState>();
  AuthController authController = AuthController();
  bool isBiometricSupported = false;
  final FingerPrintLoginService _fingerAuth = FingerPrintLoginService();

  Future<void> _fingerLogin(BuildContext context) async {
    bool isAuthenticated = await _fingerAuth.authenticate();

    if (isAuthenticated) {
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => HomeScreen()), (route) => false);
      Fluttertoast.showToast(msg: 'Login Successful, Welcome Back, ${data.read('name')}');
    } else {
      Fluttertoast.showToast(
        msg: 'Biometrics Scan Failed',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black54,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      print('Authentication failed');
    }
  }

  @override
  Widget build(BuildContext context) {
    Dimensions.init(context);
    return Container(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 15, right: 15, top: 15),
      child: Form(
        key: _resetPasswordFormKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Login',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: Dimensions.blockSizeVertical*2.2,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                GestureDetector(
                  onTap: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>RegisterScreen()));
                  },
                  child: Text(
                    'Not Registered? Click Here',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: Dimensions.blockSizeVertical*1.5,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: Dimensions.blockSizeVertical*2),
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              controller: authController.email,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Email',
                labelStyle: const TextStyle(color: Colors.white70),
                filled: true,
                fillColor: Colors.grey[800],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide.none,
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                }
                if (!RegExp(r"^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+\$").hasMatch(value)) {
                  return 'Enter a valid email';
                }
                return null;
              },
            ),
            SizedBox(height: Dimensions.blockSizeVertical*2),
            TextFormField(
              controller: authController.password,
              obscureText: true,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Password',
                labelStyle: const TextStyle(color: Colors.white70),
                filled: true,
                fillColor: Colors.grey[800],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide.none,
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your password';
                }
                if (value.length < 6) {
                  return 'Password must be at least 6 characters';
                }
                return null;
              },
            ),
            SizedBox(height: Dimensions.blockSizeVertical*2),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        minimumSize: Size(0, Dimensions.blockSizeVertical * 6),
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(Dimensions.safeBlockHorizontal * 4))),
                    onPressed: () {
                      if (_resetPasswordFormKey.currentState!.validate()) {
                        //handle login logic
                        Navigator.of(context).pop();
                      }
                    },
                    child:  Text(
                      'Login',
                      style: TextStyle(fontSize: Dimensions.safeBlockHorizontal * 4, color: Colors.black),
                    ),
                  ),
                ),
                SizedBox(width: Dimensions.blockSizeVertical*2),
                //if (isBiometricSupported)
                SizedBox(
                  width: Dimensions.blockSizeHorizontal*15, // Adjust the width as needed
                  child: ElevatedButton(
                    onPressed: () {
                      data.read('token') == null ?
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children:  [
                                Icon(Icons.error,color: Colors.red, size: Dimensions.blockSizeVertical*6),
                                SizedBox(height: Dimensions.blockSizeVertical*2),
                                const Text('Login Via Email & Password First!'),
                                SizedBox(height: Dimensions.blockSizeVertical*2),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red,
                                      ),
                                      onPressed: (){
                                        Navigator.of(context).pop();
                                      }, child: const Text('OK', style: TextStyle(color: Colors.white))),
                                )
                              ],
                            ),
                          );
                        },
                      ) :  _fingerLogin(context);
                    },
                    style: ButtonStyle(
                      padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
                        EdgeInsets.all(Dimensions.blockSizeHorizontal*3),
                      ),
                      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(Dimensions.safeBlockHorizontal * 4),
                        ),
                      ),
                      backgroundColor: WidgetStateProperty.all<Color>(
                          Colors.white), // Set the background color to black45
                    ),
                    // Set the icon color using a ColorFilter
                    child: const Icon(Icons.fingerprint, color: Colors.black),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

