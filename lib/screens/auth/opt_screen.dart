import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:smart_auth/smart_auth.dart';
import '../../../services/dimensions.dart';
import '../../controllers/auth_controller.dart';

class OtpScreen extends StatefulWidget {
  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  AuthController authController = AuthController();
  late final SmsRetriever smsRetriever;
  late final TextEditingController pinController;
  late final FocusNode focusNode;
  late final GlobalKey<FormState> formKey;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    formKey = GlobalKey<FormState>();
    pinController = TextEditingController();
    focusNode = FocusNode();

    smsRetriever = SmsRetrieverImpl(
      SmartAuth(),
    );
  }

  @override
  void dispose() {
    pinController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Dimensions.init(context);

    const focusedBorderColor = Color.fromRGBO(255, 255, 255, 1.0);
    const fillColor = Color.fromRGBO(243, 246, 249, 0);
    const borderColor = Color.fromRGBO(233, 226, 243, 1.0);

    final defaultPinTheme = PinTheme(
      width: Dimensions.blockSizeHorizontal * 14,
      height: Dimensions.blockSizeVertical * 8,
      textStyle: TextStyle(
        fontSize: Dimensions.blockSizeHorizontal * 5,
        color: Colors.white,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(19),
        border: Border.all(color: borderColor),
        color: Colors.grey[850],
      ),
    );

    return Scaffold(
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width, // Fill the screen width
          height: MediaQuery.of(context).size.height, // Fill the screen height
          decoration: BoxDecoration(
            image: DecorationImage(
              image: const AssetImage('assets/images/img_2.png'),
              fit:
                  BoxFit.cover, // Ensures the image covers the entire container
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
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Verification',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: Dimensions.blockSizeVertical * 3,
                          color: Colors.white)),
                  SizedBox(height: Dimensions.blockSizeVertical * 5),
                  const Text('Enter the code sent to number',
                      style: TextStyle(color: Colors.white)),
                  SizedBox(height: Dimensions.blockSizeVertical * 2),
                  Text(data.read('msisdn'),
                      style: const TextStyle(color: Colors.white)),
                  SizedBox(height: Dimensions.blockSizeVertical * 5),
                  Pinput(
                    smsRetriever: smsRetriever,
                    controller: pinController,
                    focusNode: focusNode,
                    defaultPinTheme: defaultPinTheme,
                    separatorBuilder: (index) =>
                        SizedBox(width: Dimensions.blockSizeHorizontal * 2),
                    hapticFeedbackType: HapticFeedbackType.lightImpact,
                    onCompleted: (pin) {
                      debugPrint('onCompleted: $pin');
                      authController.checkRegToken(context, pin);
                      setState(() {
                        Navigator.of(context).pop();
                      });
                    },
                    onChanged: (value) {
                      debugPrint('onChanged: $value');
                    },
                    cursor: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(bottom: 9),
                          width: Dimensions.blockSizeHorizontal * 5,
                          height: Dimensions.blockSizeVertical * 0.2,
                          color: focusedBorderColor,
                        ),
                      ],
                    ),
                    focusedPinTheme: defaultPinTheme.copyWith(
                      decoration: defaultPinTheme.decoration!.copyWith(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: focusedBorderColor),
                      ),
                    ),
                    submittedPinTheme: defaultPinTheme.copyWith(
                      decoration: defaultPinTheme.decoration!.copyWith(
                        color: fillColor,
                        borderRadius: BorderRadius.circular(19),
                        border: Border.all(color: focusedBorderColor),
                      ),
                    ),
                    errorPinTheme: defaultPinTheme.copyBorderWith(
                      border: Border.all(color: Colors.redAccent),
                    ),
                  ),
                  SizedBox(height: Dimensions.blockSizeVertical * 4),
                  const Text("Didn't received code?",
                      style: TextStyle(color: Colors.white)),
                  SizedBox(height: Dimensions.blockSizeVertical * 1.12),
                  isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : GestureDetector(
                    onTap: () async {
                      setState(() {
                        isLoading = true;
                      });
                      await authController.resendRegToken(context);
                      setState(() {
                        isLoading = false; // Ensure UI updates after request completion
                      });
                    },
                    child: const Text(
                      "Resend",
                      style: TextStyle(
                        color: Colors.white,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  )

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SmsRetrieverImpl implements SmsRetriever {
  const SmsRetrieverImpl(this.smartAuth);

  final SmartAuth smartAuth;

  @override
  Future<void> dispose() {
    return smartAuth.removeSmsListener();
  }

  @override
  Future<String?> getSmsCode() async {
    final signature = await smartAuth.getAppSignature();
    debugPrint('App Signature: $signature');
    final res = await smartAuth.getSmsCode(
      useUserConsentApi: true,
    );
    if (res.succeed && res.codeFound) {
      return res.code!;
    }
    return null;
  }

  @override
  bool get listenForMultipleSms => false;
}
