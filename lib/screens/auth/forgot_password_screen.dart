import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:junglegym/controllers/auth_controller.dart';
import 'package:junglegym/screens/ui/customer/home_screen.dart';
import 'package:junglegym/services/dimensions.dart';



class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final AuthController authController = AuthController();
  final _formKey = GlobalKey<FormState>();
  PhoneNumber _phoneNumber = PhoneNumber(isoCode: 'ZW');


  @override
  Widget build(BuildContext context) {
    Dimensions.init(context);
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage('assets/images/img_2.png'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.50),
              BlendMode.darken,
            ),
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Forgot Password',
                      style: GoogleFonts.roboto(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color:  Colors.white,
                      ),
                    ),
                    SizedBox(height: Dimensions.blockSizeVertical*1),
                    Text(
                      'Enter your phone number to reset your password.',
                      style: GoogleFonts.roboto(fontSize: Dimensions.blockSizeVertical*1.85, color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: Dimensions.blockSizeVertical*3),
                    _buildPhoneNumberInput(),
                    SizedBox(height: Dimensions.blockSizeVertical*3),

                    // Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            String rawPhoneNumber = _phoneNumber.phoneNumber ?? '';
                            if (rawPhoneNumber.startsWith('+')) {
                              rawPhoneNumber = rawPhoneNumber.substring(1);
                            }
                            authController.getPasswordResetToken(context, rawPhoneNumber);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child:  Text(
                          'Send OTP',
                          style: TextStyle(color: Colors.black, fontSize: Dimensions.blockSizeVertical*1.7),
                        ),
                      ),
                    ),

                    SizedBox(height: Dimensions.blockSizeVertical*2.5),

                    // Optional: Back to login
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>HomeScreen()));
                      },
                      child: Text(
                        'Back to Login',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPhoneNumberInput() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: Dimensions.blockSizeVertical * 1.5),
      child: InternationalPhoneNumberInput(
        textStyle: const TextStyle(color: Colors.white),
        onInputChanged: (PhoneNumber number) {
          _phoneNumber = number;
          print(_phoneNumber.toString());
        },
        onInputValidated: (bool value) {},
        selectorConfig: const SelectorConfig(
          selectorType: PhoneInputSelectorType.DIALOG,
        ),
        ignoreBlank: false,
        autoValidateMode: AutovalidateMode.onUserInteraction,
        selectorTextStyle: const TextStyle(color: Colors.white),
        initialValue: _phoneNumber,
        textFieldController: authController.msisdn,
        formatInput: true,
        keyboardType: TextInputType.phone,
        inputDecoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: 5, vertical: 20),
          label: Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text('Mobile Number', style: GoogleFonts.roboto(color: Colors.white)),
          ),
          border: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.white, width: 3),
            borderRadius: BorderRadius.circular(25),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.white, width: 3),
            borderRadius: BorderRadius.circular(25),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.red, width: 4),
            borderRadius: BorderRadius.circular(25),
          ),
        ),
      ),
    );
  }
}
