import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:junglegym/services/dimensions.dart';
import 'package:junglegym/services/external_apps_service.dart';

class PackagesScreen extends StatefulWidget {
  const PackagesScreen({super.key});

  @override
  State<PackagesScreen> createState() => _PackagesScreenState();
}

class _PackagesScreenState extends State<PackagesScreen> {

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
            image: const AssetImage(
                'assets/images/img_2.png'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.50),
              BlendMode.darken,
            ),
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(Dimensions.blockSizeHorizontal * 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.white, size: Dimensions.iconSize24),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    SizedBox(width: Dimensions.blockSizeHorizontal * 2),
                    Text(
                      "Membership Packages",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: Dimensions.blockSizeVertical * 3,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: Dimensions.blockSizeVertical * 4),
                Expanded(
                  child: ListView(
                    children: [
                      GestureDetector(
                        onTap: () {
                          _showContactOptions(context);
                        },
                        child: _buildPackageCard(
                          title: "Basic Package",
                          monthlyPrice: "120 USD per month",
                          quarterlyPrice: "299 USD for 3 months",
                          details: "Includes access to the mobile app only.",
                        ),
                      ),
                      GestureDetector(
                        onTap: (){
                          _showContactOptions(context);
                        },
                        child: _buildPackageCard(
                          title: "Standard Package",
                          monthlyPrice: "150 USD per month",
                          quarterlyPrice: "379 USD for 3 months",
                          details: "Includes mobile app access plus 2x Jungle Gym classes.",
                        ),
                      ),
                      GestureDetector(
                        onTap: (){
                          _showContactOptions(context);
                        },
                        child: _buildPackageCard(
                          title: "Premium Package",
                          monthlyPrice: "200 USD per month",
                          quarterlyPrice: "499 USD for 3 months upfront",
                          details: "Unlimited Jungle Gym classes + 2 free day guest passes/month.",
                        ),
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

  Widget _buildPackageCard({
    required String title,
    required String monthlyPrice,
    required String quarterlyPrice,
    required String details,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: Dimensions.blockSizeVertical * 3),
      padding: EdgeInsets.all(Dimensions.blockSizeHorizontal * 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: Dimensions.blockSizeVertical * 2.4,
              fontWeight: FontWeight.bold,
              color: Colors.redAccent,
            ),
          ),
          SizedBox(height: Dimensions.blockSizeVertical),
          Text(
            monthlyPrice,
            style: TextStyle(
              fontSize: Dimensions.blockSizeVertical * 2,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: Dimensions.blockSizeVertical * 0.5),
          Text(
            quarterlyPrice,
            style: TextStyle(
              fontSize: Dimensions.blockSizeVertical * 1.9,
              color: Colors.white70,
            ),
          ),
          SizedBox(height: Dimensions.blockSizeVertical),
          Text(
            details,
            style: TextStyle(
              fontSize: Dimensions.blockSizeVertical * 1.7,
              color: Colors.white60,
            ),
          ),
        ],
      ),
    );
  }
  void _showContactOptions(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Colors.white60,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.all(Dimensions.safeBlockHorizontal * 4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Contact Us",
                style: GoogleFonts.roboto(
                  fontSize: Dimensions.safeBlockHorizontal * 5,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: Dimensions.safeBlockVertical * 2),
              Text(
                "Only cash payments accepted",
                style: GoogleFonts.roboto(
                  fontSize: Dimensions.safeBlockHorizontal * 3,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: Dimensions.safeBlockVertical * 3),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  minimumSize: Size(double.infinity, 50),
                ),
                icon: FaIcon(FontAwesomeIcons.whatsapp, color: Colors.white),
                label: Text(
                  "Contact via WhatsApp",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () async {
                  externalAppsService.openWhatsApp();
                },
              ),
              SizedBox(height: Dimensions.safeBlockVertical * 2),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  minimumSize: Size(double.infinity, 50),
                ),
                icon: Icon(Icons.call, color: Colors.white),
                label: Text(
                  "Call Us Directly",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () async {
                  externalAppsService.makePhoneCall();
                },
              ),
              SizedBox(height: Dimensions.safeBlockVertical * 2),
            ],
          ),
        );
      },
    );
  }
}
