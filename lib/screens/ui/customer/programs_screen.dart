import 'package:flutter/material.dart';
import 'package:junglegym/services/dimensions.dart';

class PackagesScreen extends StatelessWidget {
  const PackagesScreen({super.key});

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
                      _buildPackageCard(
                        title: "Basic Package",
                        monthlyPrice: "120 per month",
                        quarterlyPrice: "299 for 3 months",
                        details: "Includes access to the mobile app only.",
                      ),
                      _buildPackageCard(
                        title: "Standard Package",
                        monthlyPrice: "150 per month",
                        quarterlyPrice: "379 for 3 months",
                        details: "Includes mobile app access plus 2x Jungle Gym classes.",
                      ),
                      _buildPackageCard(
                        title: "Premium Package",
                        monthlyPrice: "200 per month",
                        quarterlyPrice: "499 for 3 months upfront",
                        details: "Unlimited Jungle Gym classes + 2 free day guest passes/month.",
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
}
