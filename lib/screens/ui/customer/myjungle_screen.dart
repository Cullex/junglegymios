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
                      icon: Icon(Icons.arrow_back,
                          color: Colors.white,
                          size: Dimensions.iconSize24),
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
                SizedBox(height: Dimensions.blockSizeVertical * 5),

                // Card-style container
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(
                      horizontal: Dimensions.blockSizeHorizontal * 3),
                  padding: EdgeInsets.all(Dimensions.blockSizeHorizontal * 5),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withOpacity(0.3),
                        blurRadius: 10,
                        spreadRadius: 3,
                      )
                    ],
                  ),
                  child: Column(
                    children: [
                      Icon(Icons.credit_card,
                          color: Colors.white,
                          size: Dimensions.blockSizeVertical * 8),
                      SizedBox(height: Dimensions.blockSizeVertical * 3),
                      Text(
                        "JUNGLE GYM CARD",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: Dimensions.blockSizeVertical * 2.5,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                        ),
                      ),
                      SizedBox(height: Dimensions.blockSizeVertical * 4),
                      Container(
                        padding: EdgeInsets.all(Dimensions.blockSizeHorizontal * 3),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.white, width: 1),
                        ),
                        child: Column(
                          children: [
                            Text(
                              "HOW TO DEPOSIT",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: Dimensions.blockSizeVertical * 1.8,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: Dimensions.blockSizeVertical * 1.5),
                            Text(
                              "Visit our gym location to deposit cash",
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: Dimensions.blockSizeVertical * 2,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: Dimensions.blockSizeVertical * 1),
                            Icon(Icons.location_on,
                                color: Colors.white,
                                size: Dimensions.blockSizeVertical * 3),
                            Text(
                              "3 Ridgeway North, Highlands\nHarare, Zimbabwe",
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: Dimensions.blockSizeVertical * 1.8,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: Dimensions.blockSizeVertical * 5),

              ],
            ),
          ),
        ),
      ),
    );
  }
}