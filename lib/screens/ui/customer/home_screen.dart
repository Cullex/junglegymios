import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:junglegym/controllers/auth_controller.dart';
import 'package:junglegym/screens/auth/forgot_password_screen.dart';
import 'package:junglegym/screens/ui/customer/about_screen.dart';
import 'package:junglegym/screens/ui/customer/book_session_screen.dart';
import 'package:junglegym/screens/ui/customer/my_bookings_screen.dart';
import 'package:junglegym/screens/ui/customer/myjungle_screen.dart';
import 'package:junglegym/screens/ui/customer/personaltrainer_screen.dart';
import 'package:junglegym/screens/ui/customer/programs_screen.dart';
import 'package:junglegym/services/external_apps_service.dart';
import '../../../services/dimensions.dart';

enum FilterOptions { profile, uploads, logout }

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late ExternalAppsService externalAppsService;
  final AuthController authController = AuthController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  PhoneNumber _phoneNumber = PhoneNumber(isoCode: 'ZW');

  @override
  void initState() {
    super.initState();
    externalAppsService = ExternalAppsService();
  }

  bool _isLoggedIn = false;
  String _username = "Guest User";

  void openDrawer() {
    _scaffoldKey.currentState?.openDrawer();
  }

  @override
  Widget build(BuildContext context) {
    Dimensions.init(context);

    return Scaffold(
      key: _scaffoldKey,
      drawer: _buildSidebarMenu(),
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
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: Dimensions.blockSizeHorizontal * 5,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: Dimensions.blockSizeVertical * 3),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: openDrawer,
                      icon: const Icon(Icons.menu,
                          color: Color.fromARGB(255, 255, 255, 255)),
                    ),
                    ColorFiltered(
                      colorFilter: const ColorFilter.mode(
                        Colors.white,
                        BlendMode.srcATop,
                      ),
                      child: Image.asset(
                        'assets/logos/img_1.png',
                        width: Dimensions.blockSizeHorizontal * 20,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        _showLoginBottomSheet(context);
                      },
                      icon: const Icon(Icons.person_2_rounded,
                          color: Color.fromARGB(255, 255, 255, 255)),
                    ),
                  ],
                ),
                SizedBox(height: Dimensions.blockSizeVertical * 2),
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: Dimensions.blockSizeHorizontal * 4,
                    mainAxisSpacing: Dimensions.blockSizeVertical * 4,
                    children: [
                      _buildFeatureCard(
                        context,
                        title: 'Book a Session',
                        icon: Icons.fitness_center,
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const BookingScreen()));
                        },
                      ),
                      _buildFeatureCard(
                        context,
                        title: 'Programs',
                        icon: Icons.calendar_today,
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => PackagesScreen()));
                        },
                      ),
                      _buildFeatureCard(
                        context,
                        title: 'My Bookings',
                        icon: Icons.card_membership,
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => MyBookingsScreen()));
                        },
                      ),
                      _buildFeatureCard(
                        context,
                        title: 'My Jungle',
                        icon: Icons.featured_play_list,
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => MyJungleScreen()));
                        },
                      ),
                      _buildFeatureCard(
                        context,
                        title: 'Personal Trainer',
                        icon: Icons.people,
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => PersonalTrainersScreen()));
                        },
                      ),
                      _buildFeatureCard(
                        context,
                        title: 'About',
                        icon: Icons.info_outline_rounded,
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => AboutScreen()));
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSidebarMenu() {
    return Drawer(
      backgroundColor: Colors.black.withOpacity(0.85),
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: Dimensions.blockSizeVertical * 5,
                  backgroundColor: Colors.grey[800],
                  child: Icon(
                    Icons.person,
                    size: Dimensions.iconSize24 * 2,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: Dimensions.blockSizeVertical),
                Text(
                  data.read('name') ?? 'Guest User',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: Dimensions.blockSizeHorizontal * 4,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                Divider(color: Colors.grey[700]),
                Padding(
                  padding: EdgeInsets.all(Dimensions.blockSizeHorizontal * 4),
                  child: Text(
                    'Connect With Us',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: Dimensions.blockSizeHorizontal * 3.5,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: Dimensions.blockSizeHorizontal * 4,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            icon: FaIcon(FontAwesomeIcons.whatsapp,
                                color: Colors.green),
                            onPressed: () {
                              externalAppsService.openWhatsApp();
                            },
                          ),
                          Text('Whatsapp',
                              style: GoogleFonts.roboto(color: Colors.white))
                        ],
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: FaIcon(FontAwesomeIcons.facebook,
                                color: Colors.blue),
                            onPressed: () {
                              externalAppsService.openFacebook();
                            },
                          ),
                          Text('Facebook',
                              style: GoogleFonts.roboto(color: Colors.white))
                        ],
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: FaIcon(FontAwesomeIcons.instagram,
                                color: Colors.red),
                            onPressed: () {
                              externalAppsService.openInstagram();
                            },
                          ),
                          Text('Instagram',
                              style: GoogleFonts.roboto(color: Colors.white))
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: Dimensions.blockSizeVertical * 2),
                Padding(
                  padding: EdgeInsets.all(Dimensions.blockSizeHorizontal * 4),
                  child: Text(
                    'App Version 1.0.0',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: Dimensions.blockSizeHorizontal * 3,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showLoginBottomSheet(BuildContext context) {
    final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(Dimensions.blockSizeHorizontal * 5),
          decoration: BoxDecoration(
            color: Colors.grey[900]!.withOpacity(0.95),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(Dimensions.blockSizeHorizontal * 5),
              topRight: Radius.circular(Dimensions.blockSizeHorizontal * 5),
            ),
          ),
          child: Form(
            key: _loginFormKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _isLoggedIn ? 'User Profile' : 'Login',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: Dimensions.blockSizeVertical * 3,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: Dimensions.blockSizeVertical * 3),
                  TextFormField(
                    controller: authController.email,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Email',
                      labelStyle: TextStyle(color: Colors.white70),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white70),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                      ),
                      errorStyle: TextStyle(color: Colors.red),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!value.contains('@')) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: Dimensions.blockSizeVertical * 2),
                  TextFormField(
                    controller: authController.password,
                    obscureText: true,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Password',
                      labelStyle: TextStyle(color: Colors.white70),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white70),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                      ),
                      errorStyle: TextStyle(color: Colors.red),
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
                  SizedBox(height: Dimensions.blockSizeVertical * 3),
                  ElevatedButton(
                    onPressed: () {
                      if (_loginFormKey.currentState!.validate()) {
                        authController.login(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      minimumSize: Size(
                        double.infinity,
                        Dimensions.blockSizeVertical * 6,
                      ),
                    ),
                    child: Text(
                      'Login',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: Dimensions.blockSizeVertical * 2,
                      ),
                    ),
                  ),
                  SizedBox(height: Dimensions.blockSizeVertical),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () {
                         Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ForgotPasswordScreen()));
                        },
                        child: Text(
                          'Forgot Password',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: Dimensions.blockSizeVertical * 1.8,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          _showRegisterBottomSheet(context);
                        },
                        child: Text(
                          'Sign Up',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: Dimensions.blockSizeVertical * 1.8,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showRegisterBottomSheet(BuildContext context) {
    final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(Dimensions.blockSizeHorizontal * 5),
          decoration: BoxDecoration(
            color: Colors.grey[900]!.withOpacity(0.95),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(Dimensions.blockSizeHorizontal * 5),
              topRight: Radius.circular(Dimensions.blockSizeHorizontal * 5),
            ),
          ),
          child: Form(
            key: _loginFormKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Register Profile',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: Dimensions.blockSizeVertical * 3,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: Dimensions.blockSizeVertical * 3),
                  TextFormField(
                    controller: authController.name,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Name',
                      labelStyle: TextStyle(color: Colors.white70),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white70),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                      ),
                      errorStyle: TextStyle(color: Colors.red),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your name';
                      }
                      if (!value.contains('@')) {
                        return 'Please enter a valid name';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: Dimensions.blockSizeVertical * 2),
                  TextFormField(
                    controller: authController.middle_name,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Other Name',
                      labelStyle: TextStyle(color: Colors.white70),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white70),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                      ),
                      errorStyle: TextStyle(color: Colors.red),
                    ),
                  ),
                  SizedBox(height: Dimensions.blockSizeVertical * 2),
                  TextFormField(
                    controller: authController.last_name,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Last Name',
                      labelStyle: TextStyle(color: Colors.white70),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white70),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                      ),
                      errorStyle: TextStyle(color: Colors.red),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your surname';
                      }
                      if (!value.contains('@')) {
                        return 'Please enter a valid surname';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: Dimensions.blockSizeVertical * 2),
                  TextFormField(
                    controller: authController.email,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Email',
                      labelStyle: TextStyle(color: Colors.white70),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white70),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                      ),
                      errorStyle: TextStyle(color: Colors.red),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!value.contains('@')) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: Dimensions.blockSizeVertical * 2),
                  TextFormField(
                    controller: authController.password,
                    obscureText: true,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Password',
                      labelStyle: TextStyle(color: Colors.white70),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white70),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                      ),
                      errorStyle: TextStyle(color: Colors.red),
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
                  SizedBox(height: Dimensions.blockSizeVertical *2),
                  Padding(
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
                          borderSide: const BorderSide(color: Colors.white, width: 1),
                          borderRadius: BorderRadius.circular(1),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.white, width: 1),
                          borderRadius: BorderRadius.circular(1),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.red, width: 4),
                          borderRadius: BorderRadius.circular(1),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: Dimensions.blockSizeVertical *3),
                  ElevatedButton(
                    onPressed: () {
                      // Get the phone number and remove the + if it exists
                      String phoneNumber = _phoneNumber.phoneNumber ?? '';
                      if (phoneNumber.startsWith('+')) {
                        phoneNumber = phoneNumber.substring(1);
                      }

                      // Pass the modified phone number to the registration function
                      authController.registerProfile(context, phoneNumber);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      minimumSize: Size(
                        double.infinity,
                        Dimensions.blockSizeVertical * 6,
                      ),
                    ),
                    child: Text(
                      'Register',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: Dimensions.blockSizeVertical * 2,
                      ),
                    ),
                  ),
                  SizedBox(height: Dimensions.blockSizeVertical),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ForgotPasswordScreen()));
                        },
                        child: Text(
                          'Forgot Password',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: Dimensions.blockSizeVertical * 1.8,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          _showLimitedDialog(context, 'Registration');
                        },
                        child: Text(
                          'Sign Up',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: Dimensions.blockSizeVertical * 1.8,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFeatureCard(BuildContext context,
      {required String title,
        required IconData icon,
        required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius:
          BorderRadius.circular(Dimensions.blockSizeHorizontal * 2),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: Dimensions.iconSize24 * 2,
              color: Colors.white,
            ),
            SizedBox(height: Dimensions.blockSizeVertical * 2),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: Dimensions.blockSizeHorizontal * 4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLimitedDialog(BuildContext context, String title) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: Text(
          "Feature Coming Soon",
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          "$title is currently under development. This feature will be coming very soon",
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            child: Text(
              "OK",
              style: TextStyle(color: Colors.red),
            ),
            onPressed: () => Navigator.of(ctx).pop(),
          ),
        ],
      ),
    );
  }
}