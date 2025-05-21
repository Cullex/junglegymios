import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

class ExternalAppsService {
  // Function to initiate a call
  Future<void> makePhoneCall() async {
    var phoneNumber = '+263779038820';
    final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
    if(!await launchUrl(launchUri)){
      throw Fluttertoast.showToast(msg: 'An error occurred. Try again');
    }
  }


  Future<void> makePhoneCall2() async {
    var phoneNumber = '+2638677000716';
    final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
    if(!await launchUrl(launchUri)){
      throw Fluttertoast.showToast(msg: 'An error occurred. Try again');
    }
  }

  // Function to open WhatsApp using inAppWebView
  Future<void> openWhatsApp() async {
    final whatsappNumber = '+263772126120';
    final message = 'I would like help with...';
    final whatsappUrl = Uri.parse('https://wa.me/$whatsappNumber?text=${Uri.encodeFull(message)}');
    if (!await launchUrl(whatsappUrl, mode: LaunchMode.externalNonBrowserApplication)) {
      throw Exception('Could not launch $whatsappUrl');
    }
  }

  Future<void> openFacebook() async {
    final facebookUrl = Uri.parse('https://www.facebook.com/profile.php?id=61552586095917');
    if (!await launchUrl(facebookUrl, mode: LaunchMode.externalApplication)) {
      Fluttertoast.showToast(msg: 'Unable to open Facebook.');
    }
  }

  Future<void> openInstagram() async {
    final instagramUrl = Uri.parse('https://www.instagram.com/firstresponderafrica/#');
    if (!await launchUrl(instagramUrl, mode: LaunchMode.externalApplication)) {
      Fluttertoast.showToast(msg: 'Unable to open Instagram.');
    }
  }
}
