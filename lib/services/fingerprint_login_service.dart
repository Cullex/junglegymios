import 'package:fluttertoast/fluttertoast.dart';
import 'package:local_auth/local_auth.dart';

class FingerPrintLoginService {

  final LocalAuthentication _localAuthentication = LocalAuthentication();

  Future<bool> authenticate() async {
    bool authenticated = false;
    try {
      authenticated = await _localAuthentication.authenticate(
          localizedReason: 'Scan your biometrics to login',
          options: const AuthenticationOptions(
            useErrorDialogs: true,
            stickyAuth: true,
          )
      );
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      print('Error: $e');
    }
    return authenticated;
  }
}
