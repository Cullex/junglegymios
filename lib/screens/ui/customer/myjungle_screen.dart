import 'package:flutter/material.dart';
import 'package:junglegym/services/dimensions.dart';

class MyJungleScreen extends StatelessWidget {
  const MyJungleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Dimensions.init(context);

    return Scaffold(
      backgroundColor: Colors.black,
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
          child: Padding(
            padding: EdgeInsets.all(Dimensions.blockSizeHorizontal * 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.white, size: Dimensions.iconSize24),
                      onPressed: () => Navigator.pop(context),
                    ),
                    SizedBox(width: Dimensions.blockSizeHorizontal * 2),
                    Text(
                      "My Jungle Card",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: Dimensions.blockSizeVertical * 3,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: Dimensions.blockSizeVertical * 10),
                Center(
                  child: Column(
                    children: [
                      Icon(Icons.local_cafe, color: Colors.white30, size: Dimensions.blockSizeVertical * 10),
                      SizedBox(height: Dimensions.blockSizeVertical * 2),
                      Text(
                        "No credits available.",
                        style: TextStyle(color: Colors.white70, fontSize: Dimensions.blockSizeVertical * 2),
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
}
