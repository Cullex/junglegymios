import 'package:flutter/material.dart';

import '../../services/dimensions.dart';


void showProcessingDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children:  [
            const CircularProgressIndicator(color: Colors.black),
            SizedBox(height: Dimensions.blockSizeVertical * 2),
            const Text('Processing...', style: TextStyle(color: Colors.black54)),
          ],
        ),
      );
    },
  );
}