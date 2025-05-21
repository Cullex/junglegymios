import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import '../../../services/dimensions.dart';
import '../../controllers/auth_controller.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final AuthController authController = AuthController();
  final _formKey = GlobalKey<FormState>();
  PhoneNumber _phoneNumber = PhoneNumber(isoCode: 'ZW');
  bool _passwordVisible = false;
  bool hidePassword = true;
  double _age = 18;
  String? _selectedSex;

  @override
  Widget build(BuildContext context) {
    Dimensions.init(context);

    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: const AssetImage(
                  'assets/images/img_2.png'),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.50),
                BlendMode.darken,
              ),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: Dimensions.blockSizeHorizontal * 5,
            ),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: Dimensions.blockSizeVertical * 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(onPressed: (){
                          Navigator.of(context).pop();
                        }, icon: const Icon(Icons.arrow_back_outlined,
                          color: Colors.white)),
                        Text(
                          "Register",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: Dimensions.blockSizeHorizontal * 7,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: Dimensions.blockSizeVertical * 3),

                    // Name Field
                    _buildTextField(
                      controller: authController.name,
                      hint: "Name",
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Name is required";
                        }
                        return null;
                      },
                    ),

                    // Middle Name Field
                    _buildTextField(
                      controller: authController.middle_name,
                      hint: "Middle Name",
                    ),

                    // Last Name Field
                    _buildTextField(
                      controller: authController.last_name,
                      hint: "Last Name",
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Last name is required";
                        }
                        return null;
                      },
                    ),

                    // Username Field
                    _buildTextField(
                      controller: authController.username,
                      hint: "Username",
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Username is required";
                        }
                        return null;
                      },
                    ),

                    // Email Field
                    _buildTextField(
                      controller: authController.email,
                      hint: "Email",
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your email address';
                        }
                        String emailRegex = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
                        RegExp regExp = RegExp(emailRegex);
                        if (!regExp.hasMatch(value)) {
                          return 'Please enter a valid email address';
                        }
                        return null;
                      },
                    ),

                    // Phone Field
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: Dimensions.blockSizeVertical * 1.5),
                      child: InternationalPhoneNumberInput(
                        textStyle: const TextStyle(color: Colors.white),
                        onInputChanged: (PhoneNumber number) {
                          _phoneNumber = number;
                          print(_phoneNumber.toString());
                        },
                        onInputValidated: (bool value) {
                          // Optionally handle validation status
                        },
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
                          hintText: "Mobile Number",

                          hintStyle: const TextStyle(color: Colors.white70),
                          filled: true,
                          fillColor: Colors.grey[850],
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Colors.white70),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Colors.blue),
                          ),
                        ),
                      ),
                    ),

                    // Sex Dropdown
                    DropdownButtonFormField<String>(
                      dropdownColor: Colors.grey[900],
                      value: _selectedSex,
                      hint: const Text(
                        "Select Gender",
                        style: TextStyle(color: Colors.white70),
                      ),
                      decoration:  InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.white70),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.white),
                        ),
                      ),
                      items: ["Male", "Female"]
                          .map((sex) => DropdownMenuItem(
                        value: sex,
                        child: Text(sex, style: const TextStyle(color: Colors.white)),
                      ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedSex = value;
                        });
                      },
                      validator: (value) => value == null ? "Sex is required" : null,
                    ),

                    SizedBox(height: Dimensions.blockSizeVertical * 2),

                    // Age Slider
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Age: ${_age.round()}",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: Dimensions.blockSizeHorizontal * 4,
                          ),
                        ),
                        Slider(
                          value: _age,
                          min: 12,
                          max: 100,
                          activeColor: Colors.white,
                          inactiveColor: Colors.grey,
                          onChanged: (value) {
                            setState(() {
                              _age = value.roundToDouble();
                            });
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: Dimensions.blockSizeVertical * 2.5),
                    TextFormField(
                      style: const TextStyle(color: Colors.white),
                        controller: authController.password,
                        obscureText: !_passwordVisible,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Colors.white70),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Colors.blue),
                          ),
                          labelText: 'Password',
                          labelStyle: const TextStyle(color: Colors.white),
                          suffixIcon: IconButton(
                            icon: Icon(
                                _passwordVisible ? Icons.visibility : Icons.visibility_off, color: Colors.white
                            ),
                            onPressed: () {
                              setState(() {
                                _passwordVisible = !_passwordVisible;
                              });
                            },
                          ),
                          border: const OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter a password';
                          }
                          if (value.length < 8) {
                            return 'Password must be at least 8 characters long';
                          }
                          return null;
                        },
                      ),
                    SizedBox(height: Dimensions.blockSizeVertical*3),
                    TextFormField(
                      style: const TextStyle(color: Colors.white),
                      controller: authController.confirmPassword,
                      obscureText: !_passwordVisible,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.white70),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.blue),
                        ),
                        labelText: 'Confirm Password',
                        labelStyle: const TextStyle(color: Colors.white),
                        suffixIcon: IconButton(
                          icon: Icon(
                              _passwordVisible ? Icons.visibility : Icons.visibility_off,
                              color: Colors.white),
                          onPressed: () {
                            setState(() {
                              _passwordVisible = !_passwordVisible;
                            });
                          },
                        ),
                        border: const OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please confirm your password';
                        }
                        if (value != authController.password.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    ),


                    SizedBox(height: Dimensions.blockSizeVertical * 4),

                    // Submit Button
                    Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                            horizontal: Dimensions.blockSizeHorizontal * 10,
                            vertical: Dimensions.blockSizeVertical * 1.5,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        onPressed: () {
                          String rawPhoneNumber = _phoneNumber.phoneNumber ?? '';
                          if (rawPhoneNumber.startsWith('+')) {
                            rawPhoneNumber = rawPhoneNumber.substring(1);
                          }
                          if (_formKey.currentState!.validate()) {
                            print("gender: ${_selectedSex.toString()}");
                            print("age: ${_age.toString()}");
                            print("number: ${rawPhoneNumber.toString()}");
                            //Navigator.of(context).push(MaterialPageRoute(builder: (context)=>OtpScreen()));
                            authController.registerProfile(context, _selectedSex.toString(), _age.toString(), rawPhoneNumber);
                          }
                        },
                        child: Text(
                          "Register",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: Dimensions.blockSizeHorizontal * 4.5,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: Dimensions.blockSizeVertical * 3),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
    int maxLines = 1,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: Dimensions.blockSizeVertical * 1.5),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: validator,
        maxLines: maxLines,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.white70),
          filled: true,
          fillColor: Colors.grey[850],
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.white70),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.blue),
          ),
        ),
      ),
    );
  }
}
