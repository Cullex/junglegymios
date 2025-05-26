import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_storage/get_storage.dart';
import 'package:junglegym/controllers/auth_controller.dart';
import 'package:junglegym/screens/ui/customer/home_screen.dart';
import 'package:junglegym/services/dimensions.dart';
import 'package:junglegym/widgets/processing_dialog_widget.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:intl/intl.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({Key? key}) : super(key: key);

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final box = GetStorage();
  String selectedSessionType = '';
  int selectedTrainer = -1;
  String selectedDuration = '';
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

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

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Colors.red,
              onPrimary: Colors.white,
              surface: Colors.black,
              onSurface: Colors.white,
            ),
            dialogBackgroundColor: Colors.black,
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedDate) {
      setState(() => selectedDate = picked);
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Colors.red,
              onPrimary: Colors.white,
              surface: Colors.black,
              onSurface: Colors.white,
            ),
            dialogBackgroundColor: Colors.black,
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedTime) {
      setState(() => selectedTime = picked);
    }
  }

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
                      onPressed: () => Navigator.of(context).pop(),
                      icon: Icon(Icons.arrow_back, color: Colors.white),
                      iconSize: Dimensions.iconSize24,
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
                            border: isSelected
                                ? Border.all(color: Colors.white, width: 2)
                                : null,
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
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: Dimensions.blockSizeVertical * 1.8,
                                ),
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

                SizedBox(height: Dimensions.blockSizeVertical * 3),

                // Date Selection
                _buildSectionTitle("Select Date"),
                SizedBox(height: Dimensions.blockSizeVertical),
                GestureDetector(
                  onTap: () => _selectDate(context),
                  child: Container(
                    padding: EdgeInsets.all(Dimensions.blockSizeHorizontal * 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white24),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          selectedDate == null
                              ? "Tap to select date"
                              : DateFormat('EEE, MMM d, y')
                                  .format(selectedDate!),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: Dimensions.blockSizeVertical * 1.8,
                          ),
                        ),
                        Icon(
                          Icons.calendar_today,
                          color: Colors.white,
                          size: Dimensions.iconSize24,
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: Dimensions.blockSizeVertical * 3),

                // Time Selection
                _buildSectionTitle("Select Time"),
                SizedBox(height: Dimensions.blockSizeVertical),
                GestureDetector(
                  onTap: () => _selectTime(context),
                  child: Container(
                    padding: EdgeInsets.all(Dimensions.blockSizeHorizontal * 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white24),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          selectedTime == null
                              ? "Tap to select time"
                              : selectedTime!.format(context),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: Dimensions.blockSizeVertical * 1.8,
                          ),
                        ),
                        Icon(
                          Icons.access_time,
                          color: Colors.white,
                          size: Dimensions.iconSize24,
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: Dimensions.blockSizeVertical * 4),

                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      if(data.read('username') == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text("You have to login first")),
                        );
                      }
                      if (selectedSessionType.isEmpty ||
                          selectedDuration.isEmpty ||
                          selectedTrainer == -1 ||
                          selectedDate == null ||
                          selectedTime == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text("Please complete all fields")),
                        );
                        return;
                      }

                      showProcessingDialog(context);
                      final trainerName = trainers[selectedTrainer]["name"]!;
                      await sendBookingEmail(
                        selectedSessionType,
                        trainerName,
                        selectedDuration,
                        selectedDate!,
                        selectedTime!,
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
                      elevation: 5,
                      shadowColor: Colors.red.withOpacity(0.5),
                    ),
                    child: Text(
                      "Confirm Booking",
                      style: TextStyle(
                        fontSize: Dimensions.blockSizeVertical * 2.2,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(left: Dimensions.blockSizeHorizontal),
      child: Text(
        title,
        style: TextStyle(
          fontSize: Dimensions.blockSizeVertical * 2.2,
          color: Colors.white70,
          fontWeight: FontWeight.w600,
        ),
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
              label: Text(
                label,
                style: TextStyle(
                  fontSize: Dimensions.blockSizeVertical * 1.8,
                ),
              ),
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
    String sessionType,
    String trainer,
    String duration,
    DateTime date,
    TimeOfDay time,
  ) async {
    final smtpServer = SmtpServer(
      'softifysolutionsgroup.com',
      username: 'notifications@softifysolutionsgroup.com',
      password: 'Nora@2023Nora@2023',
      ignoreBadCertificate: true,
    );

    final formattedDate = DateFormat('EEE, MMM d, y').format(date);
    final formattedTime =
        MaterialLocalizations.of(context).formatTimeOfDay(time);

    var fullname = data.read('name') + ' ' + data.read('lastname');
    final message = Message()
      ..from = Address('notifications@softifysolutionsgroup.com', 'Jungle Gym')
      ..recipients.add('contactus@thejungle-gym.com')
      ..subject = 'New Session Booking'
      ..text = '''
Session Type: $sessionType
Trainer: $trainer
Duration: $duration
Date: $formattedDate
Time: $formattedTime
Customer: ${fullname}
''';


    final bookings = box.read('bookings') ?? [];
    bookings.add({
      'sessionType': selectedSessionType,
      'trainer': trainer,
      'duration': selectedDuration,
      'date': formattedDate,
      'time': formattedTime,
    });
    box.write('bookings', bookings);

    try {
      final sendReport = await send(message, smtpServer);
      Fluttertoast.showToast(msg: 'Booking Sent Successfully');
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => HomeScreen()));
      print('Message sent: ' + sendReport.toString());
    } catch (e) {
      Fluttertoast.showToast(msg: 'Failed to send booking. Please try again.');
      Navigator.of(context).pop();
      print('Message not sent. $e');
    }
  }
}
