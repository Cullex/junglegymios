import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:junglegym/controllers/auth_controller.dart';
import 'package:junglegym/services/dimensions.dart';
import 'package:junglegym/widgets/processing_dialog_widget.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class MyBookingsScreen extends StatefulWidget {
  const MyBookingsScreen({Key? key}) : super(key: key);

  @override
  State<MyBookingsScreen> createState() => _MyBookingsScreenState();
}

class _MyBookingsScreenState extends State<MyBookingsScreen> {
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

  void _deleteBooking(int index) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: Text(
          "Confirm Delete",
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          "Are you sure you want to delete this booking?",
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text("Cancel", style: TextStyle(color: Colors.white70)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      showProcessingDialog(context);
      try {
        await _sendDeleteEmail(bookings[index]);
        if (mounted) {
          setState(() {
            bookings.removeAt(index);
            box.write('bookings', bookings);
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Booking deleted successfully")),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Failed to delete booking")),
          );
        }
      } finally {
        if (mounted) {
          Navigator.of(context).pop(); // Close processing dialog
        }
      }
    }
  }

  Future<void> _sendDeleteEmail(Map<String, dynamic> booking) async {
    var fullname = data.read('name') + ' ' + data.read('lastname');
    final smtpServer = SmtpServer(
      'softifysolutionsgroup.com',
      username: 'notifications@softifysolutionsgroup.com',
      password: 'Nora@2023Nora@2023',
      ignoreBadCertificate: true,
    );

    final message = Message()
      ..from = Address('notifications@softifysolutionsgroup.com', 'Jungle Gym')
      ..recipients.add('sidyrich@gmail.com')
      ..subject = 'Booking Cancellation'
      ..text = '''
The following booking has been cancelled:

Session Type: ${booking['sessionType']}
Trainer: ${booking['trainer']}
Date: ${booking['date']}
Time: ${booking['time']}
Customer: $fullname
''';

    await send(message, smtpServer);
  }

  Future<void> _updateBooking(int index) async {
    var fullname = data.read('name') + ' ' + data.read('lastname');
    final booking = bookings[index];
    final result = await showDialog(
      context: context,
      builder: (context) => _EditBookingDialog(initialBooking: booking),
    );

    if (result != null && mounted) {
      showProcessingDialog(context);
      try {
        await _sendUpdateEmail(bookings[index], result);
        if (mounted) {
          setState(() {
            bookings[index] = result;
            box.write('bookings', bookings);
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Booking updated successfully")),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Failed to update booking")),
          );
        }
      } finally {
        if (mounted) {
          Navigator.of(context).pop(); // Close processing dialog
        }
      }
    }
  }

  Future<void> _sendUpdateEmail(

      Map<String, dynamic> oldBooking,
      Map<String, dynamic> newBooking
      ) async {
    final smtpServer = SmtpServer(
      'softifysolutionsgroup.com',
      username: 'notifications@softifysolutionsgroup.com',
      password: 'Nora@2023Nora@2023',
      ignoreBadCertificate: true,
    );

    var fullname = data.read('name') + ' ' + data.read('lastname');
    final message = Message()
      ..from = Address('notifications@softifysolutionsgroup.com', 'Jungle Gym')
      ..recipients.add('sidyrich@gmail.com')
      ..subject = 'Booking Updated'
      ..text = '''
Booking has been updated:

Previous Details:
Session Type: ${oldBooking['sessionType']}
Trainer: ${oldBooking['trainer']}
Date: ${oldBooking['date']}
Time: ${oldBooking['time']}

New Details:
Session Type: ${newBooking['sessionType']}
Trainer: ${newBooking['trainer']}
Date: ${newBooking['date']}
Time: ${newBooking['time']}
Customer: ${fullname}
''';

    await send(message, smtpServer);
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
          child: Column(
            children: [
              // Header
              Padding(
                padding: EdgeInsets.all(Dimensions.blockSizeHorizontal * 4),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(Icons.arrow_back, color: Colors.white),
                      iconSize: Dimensions.iconSize24,
                    ),
                    Text(
                      "My Bookings",
                      style: TextStyle(
                        fontSize: Dimensions.blockSizeVertical * 3.5,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),

              // Bookings List
              Expanded(
                child: bookings.isEmpty
                    ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.fitness_center,
                        color: Colors.white30,
                        size: Dimensions.blockSizeVertical * 10,
                      ),
                      SizedBox(height: Dimensions.blockSizeVertical * 2),
                      Text(
                        "You have no bookings yet",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: Dimensions.blockSizeVertical * 2,
                        ),
                      ),
                    ],
                  ),
                )
                    : ListView.builder(
                  padding: EdgeInsets.all(Dimensions.blockSizeHorizontal * 4),
                  itemCount: bookings.length,
                  itemBuilder: (context, index) {
                    final booking = bookings[index];
                    return _buildBookingCard(booking, index);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBookingCard(Map<String, dynamic> booking, int index) {
    return Card(
      margin: EdgeInsets.only(bottom: Dimensions.blockSizeVertical * 2),
      color: Colors.black.withOpacity(0.6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Dimensions.blockSizeHorizontal * 2),
        side: BorderSide(color: Colors.white24),
      ),
      child: Padding(
        padding: EdgeInsets.all(Dimensions.blockSizeHorizontal * 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  booking['sessionType'],
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: Dimensions.blockSizeVertical * 2.5,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit, color: Colors.blue),
                      onPressed: () => _updateBooking(index),
                      iconSize: Dimensions.iconSize24,
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deleteBooking(index),
                      iconSize: Dimensions.iconSize24,
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: Dimensions.blockSizeVertical),
            Text(
              "Trainer: ${booking['trainer']}",
              style: TextStyle(
                color: Colors.white70,
                fontSize: Dimensions.blockSizeVertical * 1.8,
              ),
            ),
            SizedBox(height: Dimensions.blockSizeVertical * 0.5),
            Text(
              "Duration: ${booking['duration']}",
              style: TextStyle(
                color: Colors.white70,
                fontSize: Dimensions.blockSizeVertical * 1.8,
              ),
            ),
            SizedBox(height: Dimensions.blockSizeVertical * 0.5),
            Text(
              "Date: ${booking['date']}",
              style: TextStyle(
                color: Colors.white70,
                fontSize: Dimensions.blockSizeVertical * 1.8,
              ),
            ),
            SizedBox(height: Dimensions.blockSizeVertical * 0.5),
            Text(
              "Time: ${booking['time']}",
              style: TextStyle(
                color: Colors.white70,
                fontSize: Dimensions.blockSizeVertical * 1.8,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EditBookingDialog extends StatefulWidget {
  final Map<String, dynamic> initialBooking;

  const _EditBookingDialog({required this.initialBooking});

  @override
  State<_EditBookingDialog> createState() => _EditBookingDialogState();
}

class _EditBookingDialogState extends State<_EditBookingDialog> {
  late TextEditingController _sessionTypeController;
  late TextEditingController _trainerController;
  late TextEditingController _durationController;
  late TextEditingController _dateController;
  late TextEditingController _timeController;

  @override
  void initState() {
    super.initState();
    _sessionTypeController = TextEditingController(text: widget.initialBooking['sessionType']);
    _trainerController = TextEditingController(text: widget.initialBooking['trainer']);
    _durationController = TextEditingController(text: widget.initialBooking['duration']);
    _dateController = TextEditingController(text: widget.initialBooking['date']);
    _timeController = TextEditingController(text: widget.initialBooking['time']);
  }

  @override
  void dispose() {
    _sessionTypeController.dispose();
    _trainerController.dispose();
    _durationController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Dimensions.init(context);

    return AlertDialog(
      backgroundColor: Colors.grey[900],
      title: Text(
        "Edit Booking",
        style: TextStyle(color: Colors.white),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildEditField("Session Type", _sessionTypeController),
            SizedBox(height: Dimensions.blockSizeVertical),
            _buildEditField("Trainer", _trainerController),
            SizedBox(height: Dimensions.blockSizeVertical),
            _buildEditField("Duration", _durationController),
            SizedBox(height: Dimensions.blockSizeVertical),
            _buildEditField("Date", _dateController),
            SizedBox(height: Dimensions.blockSizeVertical),
            _buildEditField("Time", _timeController),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text("Cancel", style: TextStyle(color: Colors.white70)),
        ),
        TextButton(
          onPressed: () {
            final updatedBooking = {
              'sessionType': _sessionTypeController.text,
              'trainer': _trainerController.text,
              'duration': _durationController.text,
              'date': _dateController.text,
              'time': _timeController.text,
            };
            Navigator.pop(context, updatedBooking);
          },
          child: Text("Update", style: TextStyle(color: Colors.red)),
        ),
      ],
    );
  }

  Widget _buildEditField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.white70),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white70),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
        ),
      ),
    );
  }
}