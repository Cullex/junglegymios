import 'package:flutter/material.dart';
import 'package:junglegym/services/dimensions.dart';
import 'package:junglegym/services/external_apps_service.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {

  late ExternalAppsService externalAppsService;

  @override
  void initState() {
    externalAppsService = ExternalAppsService();
  }

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
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height,
              ),
              child: Padding(
                padding: EdgeInsets.all(Dimensions.blockSizeHorizontal * 4),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.arrow_back,
                              color: Colors.white,
                              size: Dimensions.iconSize24),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                        SizedBox(width: Dimensions.blockSizeHorizontal * 2),
                        Text(
                          "About JungleGym",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: Dimensions.blockSizeVertical * 3,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: Dimensions.blockSizeVertical * 4),

                    // App Overview
                    Text(
                      "Welcome to JungleGym!",
                      style: TextStyle(
                        fontSize: Dimensions.blockSizeVertical * 2.5,
                        color: Colors.redAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: Dimensions.blockSizeVertical * 1),
                    Text(
                      "JungleGym is your ultimate fitness companion designed to help you book sessions, manage memberships, and access premium workout content via our mobile platform. Whether you're into strength training, yoga, Zumba, or bodyweight workouts, we've got something for you.",
                      style: TextStyle(
                        fontSize: Dimensions.blockSizeVertical * 1.8,
                        color: Colors.white70,
                      ),
                    ),

                    SizedBox(height: Dimensions.blockSizeVertical * 3),

                    // Services
                    Text(
                      "What We Offer",
                      style: TextStyle(
                        fontSize: Dimensions.blockSizeVertical * 2.3,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: Dimensions.blockSizeVertical),
                    _buildBulletPoint(
                        "✔ Book personal training and group sessions."),
                    _buildBulletPoint("✔ Access to our mobile fitness app."),
                    _buildBulletPoint(
                        "✔ Jungle Gym classes (Zumba, Stretching, Aerobics)."),
                    _buildBulletPoint("✔ Membership packages for all levels."),
                    _buildBulletPoint("✔ Guest passes and exclusive promotions."),

                    SizedBox(height: Dimensions.blockSizeVertical * 3),

                    // Location
                    Text(
                      "Location",
                      style: TextStyle(
                        fontSize: Dimensions.blockSizeVertical * 2.3,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: Dimensions.blockSizeVertical * 0.5),
                    Text(
                      "📍 3 Ridgeway North Highlands Harare Zimbabwe",
                      style: TextStyle(
                        fontSize: Dimensions.blockSizeVertical * 1.8,
                        color: Colors.white70,
                      ),
                    ),

                    SizedBox(height: Dimensions.blockSizeVertical * 3),

                    // Contact Info
                    Text(
                      "Contact Us",
                      style: TextStyle(
                        fontSize: Dimensions.blockSizeVertical * 2.3,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: Dimensions.blockSizeVertical * 2),
                    GestureDetector(
                      onTap: (){
                        externalAppsService.makePhoneCall();
                      },
                      child: Text(
                        "📞 +263 779 038 820",
                        style: TextStyle(
                          fontSize: Dimensions.blockSizeVertical * 1.8,
                          color: Colors.white70,
                        ),
                      ),
                    ),
              SizedBox(height: Dimensions.blockSizeVertical*2),
              GestureDetector(
                child: Text(
                  "✉️ contactus@thejungle-gym.com",
                  style: TextStyle(
                    fontSize: Dimensions.blockSizeVertical * 1.8,
                    color: Colors.white70,
                  ),
                ),
              ),


                    SizedBox(height: Dimensions.blockSizeVertical * 3),

                    Center(
                      child: Text(
                        "© 2025 JungleGym. All rights reserved.",
                        style: TextStyle(
                          fontSize: Dimensions.blockSizeVertical * 1.5,
                          color: Colors.white30,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),

                    SizedBox(height: Dimensions.blockSizeVertical * 2),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: Dimensions.blockSizeVertical * 0.8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("• ",
              style: TextStyle(
                  color: Colors.white70,
                  fontSize: Dimensions.blockSizeVertical * 2)),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                  color: Colors.white70,
                  fontSize: Dimensions.blockSizeVertical * 1.8),
            ),
          ),
        ],
      ),
    );
  }
}