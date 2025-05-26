
import 'package:flutter/material.dart';
import 'package:junglegym/controllers/auth_controller.dart';
import 'package:junglegym/services/dimensions.dart';
import 'package:pinput/pinput.dart';
import 'package:smart_auth/smart_auth.dart';

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
  bool isLoading2 = false;

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

    const borderColor = Colors.grey;
    const fillColor = Colors.white;
    const focusedBorderColor = Colors.grey;

    final defaultPinTheme = PinTheme(
      width: Dimensions.blockSizeHorizontal * 14,
      height: Dimensions.blockSizeVertical * 8,
      textStyle: TextStyle(
        fontSize: Dimensions.blockSizeHorizontal * 5,
        color: Colors.black,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(19),
        border: Border.all(color: borderColor),
        color: fillColor,
      ),
    );

    return Scaffold(
      body: SafeArea(
        child: Container(
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
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
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
                  const Text('Waiting to automatically detect an sms sent to',
                      style: TextStyle(color: Colors.white)),
                  SizedBox(height: Dimensions.blockSizeVertical * 2),
                  Text('+ ${data.read('resetNumber') ?? 'Unknown number'}',
                      style: const TextStyle(color: Colors.white)),
                  SizedBox(height: Dimensions.blockSizeVertical * 5),
                  isLoading2
                      ? const CircularProgressIndicator(
                    color: Colors.white,
                  )
                      : Pinput(
                    smsRetriever: smsRetriever,
                    controller: pinController,
                    focusNode: focusNode,
                    defaultPinTheme: defaultPinTheme,
                    separatorBuilder: (index) => SizedBox(
                        width: Dimensions.blockSizeHorizontal * 2),
                    hapticFeedbackType: HapticFeedbackType.lightImpact,
                    onCompleted: (pin) async {
                      setState(() {
                        isLoading2 = true;
                      });

                      bool result = await authController.checkSentToken(context, pin);

                      await Future.delayed(const Duration(milliseconds: 500)); // smooth transition

                      if (!result) {
                        setState(() {
                          isLoading2 = false;
                        });
                      }
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
                        borderRadius: BorderRadius.circular(19),
                        border: Border.all(color: focusedBorderColor, width: 2),
                        color: fillColor,
                      ),
                    ),
                    submittedPinTheme: defaultPinTheme.copyWith(
                      decoration: defaultPinTheme.decoration!.copyWith(
                        borderRadius: BorderRadius.circular(19),
                        border: Border.all(color: borderColor, width: 2),
                        color: fillColor,
                      ),
                    ),
                    errorPinTheme: defaultPinTheme.copyBorderWith(
                      border: Border.all(color: Colors.redAccent, width: 2),
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
                      await authController.resendToken(context);
                      setState(() {
                        isLoading = false;
                      });
                    },
                    child: isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                      "Resend",
                      style: TextStyle(
                        color: Colors.white,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
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
