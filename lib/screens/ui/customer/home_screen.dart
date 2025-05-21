import 'package:flutter/material.dart';
import 'package:junglegym/screens/ui/customer/about_screen.dart';
import 'package:junglegym/screens/ui/customer/book_session_screen.dart';
import 'package:junglegym/screens/ui/customer/myjungle_screen.dart';
import 'package:junglegym/screens/ui/customer/myprograms_screen.dart';
import 'package:junglegym/screens/ui/customer/personaltrainer_screen.dart';
import 'package:junglegym/screens/ui/customer/programs_screen.dart';
import '../../../services/dimensions.dart';

enum FilterOptions { profile,uploads,logout }


class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  Widget build(BuildContext context) {
    Dimensions.init(context); // Initialize Dimensions

    return Scaffold(
      body: SafeArea(
        child: Container(
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
                    IconButton(onPressed: () {
                      _showLimitedDialog(context, 'This');
                    },
                        icon: const Icon(Icons.line_weight_sharp,
                            color: Color.fromARGB(255, 255, 255, 255))),
                    ColorFiltered(
                      colorFilter: const ColorFilter.mode(
                        Colors.white, // Change black areas to white
                        BlendMode
                            .srcATop, // Blend mode determines how colors are applied
                      ),
                      child: Image.asset(
                        'assets/logos/img_1.png',
                        width: Dimensions.blockSizeHorizontal * 20,
                      ),
                    ),
                    IconButton(onPressed: () {
                      _showLimitedDialog(context, 'This');
                    },
                        icon: const Icon(Icons.person_2_rounded,
                            color: Color.fromARGB(255, 255, 255, 255))),
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
                        title: 'My Programs',
                        icon: Icons.card_membership,
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => MyProgramsScreen()));
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
                              builder: (context) => PersonalTrainerScreen()));
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
          borderRadius: BorderRadius.circular(
              Dimensions.blockSizeHorizontal * 2),
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

// }


  void _showLimitedDialog(BuildContext context, String title) {
    showDialog(
      context: context,
      builder: (ctx) =>
          AlertDialog(
            title: Text("Feature Coming Soon"),
            content: Text(
              "$title is currently under development "
                  "This feature will be coming very soon",
            ),
            actions: [
              TextButton(
                child: Text("OK"),
                onPressed: () => Navigator.of(ctx).pop(),
              ),
            ],
          ),
    );
  }
}
