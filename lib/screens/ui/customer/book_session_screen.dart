import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:junglegym/screens/ui/customer/home_screen.dart';
import 'package:junglegym/services/dimensions.dart';
import 'package:junglegym/widgets/processing_dialog_widget.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({Key? key}) : super(key: key);

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  String selectedSessionType = '';
  int selectedTrainer = -1;
  String selectedDuration = '';

  final List<String> sessionTypes = [
    "Strength Training",
    "Yoga",
    "Stretching",
    "Zumba",
    "Aerobics",
    "Aqua",
    "Bodyweight",
  ];

  final List<String> durations = ["30 min", "1 hour", "2 hours"];

  final List<Map<String, String>> trainers = [
    {"name": "Mark Smallbones", "image": "assets/images/mark.jpg"},
    {"name": "Dan Sullivan", "image": "assets/images/dan.jpeg"},
  ];

  @override
  Widget build(BuildContext context) {
    Dimensions.init(context);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/img_2.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(Dimensions.blockSizeHorizontal * 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: Icon(Icons.arrow_back, color: Colors.white),
                    ),
                    Text(
                      "Book a Session",
                      style: TextStyle(
                        fontSize: Dimensions.blockSizeVertical * 3.5,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: Dimensions.blockSizeVertical * 2),

                _buildSectionTitle("Session Type"),
                _buildScrollableChips(
                  sessionTypes,
                  selectedSessionType,
                      (value) => setState(() => selectedSessionType = value),
                ),

                SizedBox(height: Dimensions.blockSizeVertical * 3),

                _buildSectionTitle("Choose a Trainer"),
                SizedBox(
                  height: Dimensions.blockSizeVertical * 22,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: trainers.length,
                    separatorBuilder: (_, __) =>
                        SizedBox(width: Dimensions.blockSizeHorizontal * 3),
                    itemBuilder: (context, index) {
                      final isSelected = selectedTrainer == index;
                      return GestureDetector(
                        onTap: () => setState(() => selectedTrainer = index),
                        child: Container(
                          width: Dimensions.blockSizeHorizontal * 45,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: isSelected
                                ? Colors.red
                                : Colors.black.withOpacity(0.6),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                radius: Dimensions.blockSizeVertical * 6,
                                backgroundImage:
                                AssetImage(trainers[index]["image"]!),
                              ),
                              SizedBox(height: Dimensions.blockSizeVertical),
                              Text(
                                trainers[index]["name"]!,
                                style: const TextStyle(color: Colors.white),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                SizedBox(height: Dimensions.blockSizeVertical * 3),

                _buildSectionTitle("Choose Duration"),
                _buildScrollableChips(
                  durations,
                  selectedDuration,
                      (value) => setState(() => selectedDuration = value),
                ),

                SizedBox(height: Dimensions.blockSizeVertical * 4),

                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      if (selectedSessionType.isEmpty ||
                          selectedDuration.isEmpty ||
                          selectedTrainer == -1) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Please select all fields.")),
                        );
                        return;
                      }

                      showProcessingDialog(context);
                      final trainerName =
                      trainers[selectedTrainer]["name"]!;
                      await sendBookingEmail(
                        selectedSessionType,
                        trainerName,
                        selectedDuration
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                        horizontal: Dimensions.blockSizeHorizontal * 10,
                        vertical: Dimensions.blockSizeVertical * 1.8,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      "Confirm Booking",
                      style: TextStyle(
                        fontSize: Dimensions.blockSizeVertical * 2.2,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: Dimensions.blockSizeVertical * 80),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: Dimensions.blockSizeVertical * 2.2,
        color: Colors.white70,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildScrollableChips(
      List<String> labels,
      String selectedValue,
      Function(String) onSelected,
      ) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: labels.map((label) {
          final isSelected = selectedValue == label;
          return Container(
            margin: EdgeInsets.only(
              right: Dimensions.blockSizeHorizontal * 3,
              top: Dimensions.blockSizeVertical,
            ),
            child: ChoiceChip(
              label: Text(label),
              selected: isSelected,
              selectedColor: Colors.red,
              backgroundColor: Colors.black.withOpacity(0.5),
              labelStyle: const TextStyle(color: Colors.white),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
                side: const BorderSide(color: Colors.white24),
              ),
              onSelected: (_) => onSelected(label),
            ),
          );
        }).toList(),
      ),
    );
  }

  Future<void> sendBookingEmail(

      String sessionType, String trainer, String duration) async {
    final smtpServer = SmtpServer(
      'softifysolutionsgroup.com',
      username: 'notifications@softifysolutionsgroup.com',
      password: 'Nora@2023Nora@2023',
      ignoreBadCertificate: true,
    );

    final message = Message()
      ..from = Address('notifications@softifysolutionsgroup.com', 'Jungle Gym Booking')
      ..recipients.add('sidyrich@gmail.com') // Change to actual user if needed
      ..subject = 'New Session Booking'
      ..text = 'Session Type: $sessionType\nTrainer: $trainer\nDuration: $duration';

    try {
      final sendReport = await send(message, smtpServer);
      Fluttertoast.showToast(msg: 'Booking Sent Successfully');
      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>HomeScreen()));
      print('Message sent: ' + sendReport.toString());
    } catch (e) {
      Fluttertoast.showToast(msg: '$e');
      Navigator.of(context).pop();
      print('Message not sent. $e');
    }
  }
}
