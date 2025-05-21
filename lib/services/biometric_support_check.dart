import 'package:local_auth/local_auth.dart';

class BiometricSupportCheck {
  final LocalAuthentication _localAuth = LocalAuthentication();

  Future<bool> checkBiometricSupport() async {
    bool canCheckBiometrics = await _localAuth.canCheckBiometrics;
    return canCheckBiometrics;
  }
}
