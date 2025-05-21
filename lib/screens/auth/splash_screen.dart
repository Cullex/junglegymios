import 'package:flutter/material.dart';
import 'package:junglegym/screens/ui/customer/home_screen.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../controllers/auth_controller.dart';
import '../../services/dimensions.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isLoading = true;
  bool displayRestartButton = false;

  @override
  void initState() {
    checkNetwork();
    super.initState();
  }

  void checkNetwork() async {
    setState(() {
      isLoading = true;
    });

    await Future.delayed(const Duration(seconds: 3));

    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>HomeScreen()));

    setState(() {
      isLoading = false;
    });

  }

  @override
  Widget build(BuildContext context) {
    Dimensions.init(context); // Initialize Dimensions
    return Scaffold(
      body: Container(
        decoration:  BoxDecoration(
          image: DecorationImage(
            image: const AssetImage('assets/images/img.jpeg'),
            fit: BoxFit.fitHeight,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.63),
              BlendMode.darken,
            ),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ColorFiltered(
                      colorFilter: const ColorFilter.mode(
                        Colors.white, // Change black areas to white
                        BlendMode
                            .srcATop, // Blend mode determines how colors are applied
                      ),
                      child: Image.asset(
                        'assets/logos/img_1.png',
                        //width: Dimensions.blockSizeHorizontal*8,
                        height: Dimensions.blockSizeVertical*22,
                      ),
                    ),
                  ],
                ),
                if (isLoading)
                  LoadingAnimationWidget.staggeredDotsWave(
                    color: Colors.white,
                    size: Dimensions.iconSize24*1.4,
                  ),
              ],
            ),
            if (displayRestartButton == true)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Check internet connection', style: TextStyle(color: Color.fromARGB(255, 255, 255, 255))),
                  Padding(
                    padding: EdgeInsets.only(
                        left: Dimensions.blockSizeHorizontal * 10),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 9, 9, 9),
                        side: const BorderSide(
                          color: Color.fromARGB(255, 255, 255, 255)
                        )
                      ),
                      onPressed: () {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const SplashScreen()));
                      },
                      child: const Text('RESTART',
                          style: TextStyle(color: Colors.white)),
                    ),
                  )
                ],
              ),
          ],
        ),
      ),
    );
  }
}
