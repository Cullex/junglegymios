import 'package:get/get.dart';

import '../screens/auth/splash_screen.dart';



class RoutesClass {
  static String splashScreen = '/splashScreen';
  static String getSplashScreen()=>splashScreen;

  static List<GetPage> routes = [
    GetPage(name: splashScreen, page: ()=> SplashScreen()),
  ];
}