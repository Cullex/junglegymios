import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:junglegym/services/dimensions.dart';

class PersonalTrainersScreen extends StatefulWidget {

  PersonalTrainersScreen({super.key});

  @override
  State<PersonalTrainersScreen> createState() => _PersonalTrainersScreenState();
}

class _PersonalTrainersScreenState extends State<PersonalTrainersScreen> {

  final box = GetStorage();
  List<Map<String, dynamic>> bookings = [];


  @override
  void initState() {
    super.initState();
    _loadBookings();
  }

  void _loadBookings() {
    final stored = box.read('bookings') ?? [];
    if (mounted) {
      setState(() {
        bookings = List<Map<String, dynamic>>.from(stored);
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    Dimensions.init(context);
    List<dynamic> schedules = box.read('schedules') ?? [];

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
                      "My Trainers",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: Dimensions.blockSizeVertical * 3,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: Dimensions.blockSizeVertical * 3),

                // If no schedules
                if (bookings.isEmpty)
                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.person_outline, color: Colors.white30, size: Dimensions.blockSizeVertical * 10),
                          SizedBox(height: Dimensions.blockSizeVertical * 2),
                          Text(
                            "You have no personal trainers.",
                            style: TextStyle(color: Colors.white70, fontSize: Dimensions.blockSizeVertical * 2),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                // Schedule List
                  Expanded(
                    child: ListView.builder(
                      itemCount: bookings.length,
                      itemBuilder: (context, index) {
                        final booking = bookings[index];
                        return Container(
                          margin: EdgeInsets.only(bottom: Dimensions.blockSizeVertical * 2),
                          padding: EdgeInsets.all(Dimensions.blockSizeHorizontal * 4),
                          decoration: BoxDecoration(
                            color: Colors.black87,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Trainer: ${booking['trainer']}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white)),
                              SizedBox(height: 5),
                              Text(booking['date']),
                              SizedBox(height: 5),
                              Text(
                                "Session: ${booking['sessionType']}",
                                style: TextStyle(color: Colors.redAccent, fontSize: 16),
                              ),
                              Divider(color: Colors.white24),
                            ],
                          ),
                        );
                      },
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
