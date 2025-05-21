import 'package:flutter/material.dart';

import '../services/dimensions.dart';

class HomeScreenWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Dimensions.init(context); // Initialize Dimensions

    return Scaffold(
      backgroundColor: Colors.black, // Dark black background
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: Text(
          'GymApp',
          style: TextStyle(
            color: Colors.white,
            fontSize: Dimensions.blockSizeHorizontal * 6,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.account_circle, color: Colors.white),
            onPressed: () {
              // Navigate to profile or login/signup
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: Dimensions.blockSizeHorizontal * 5,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: Dimensions.blockSizeVertical * 3),
            Text(
              'Welcome to Your Fitness Journey!',
              style: TextStyle(
                color: Colors.white,
                fontSize: Dimensions.blockSizeHorizontal * 5,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: Dimensions.blockSizeVertical * 3),
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
                    onTap: () => _requireSignIn(context),
                  ),
                  _buildFeatureCard(
                    context,
                    title: 'View Schedule',
                    icon: Icons.calendar_today,
                    onTap: () => _requireSignIn(context),
                  ),
                  _buildFeatureCard(
                    context,
                    title: 'Membership Plans',
                    icon: Icons.card_membership,
                    onTap: () {
                      // Navigate to membership plans
                    },
                  ),
                  _buildFeatureCard(
                    context,
                    title: 'Shop',
                    icon: Icons.shopping_cart,
                    onTap: () {
                      // Navigate to shop
                    },
                  ),
                  _buildFeatureCard(
                    context,
                    title: 'Progress Tracker',
                    icon: Icons.bar_chart,
                    onTap: () => _requireSignIn(context),
                  ),
                  _buildFeatureCard(
                    context,
                    title: 'Settings',
                    icon: Icons.settings,
                    onTap: () {
                      // Navigate to settings
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureCard(BuildContext context, {
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(Dimensions.blockSizeHorizontal * 2),
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

  void _requireSignIn(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.grey[900],
          title: Text(
            'Sign Up or Sign In',
            style: TextStyle(color: Colors.white),
          ),
          content: Text(
            'You need to sign up or sign in to access this feature.',
            style: TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Navigate to sign-up screen
              },
              child: Text(
                'Sign Up',
                style: TextStyle(color: Colors.blue),
              ),
            ),
            TextButton(
              onPressed: () {
                // Navigate to sign-in screen
              },
              child: Text(
                'Sign In',
                style: TextStyle(color: Colors.blue),
              ),
            ),
          ],
        );
      },
    );
  }
}
