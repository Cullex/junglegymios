// showModalBottomSheet(
//   context: context,
//   isScrollControlled: true,
//   isDismissible: false,
//   backgroundColor: Colors.grey[900],
//   shape: RoundedRectangleBorder(
//     borderRadius: BorderRadius.vertical(
//       top: Radius.circular(20.0),
//     ),
//   ),
//   builder: (context) {
//     final emailController = TextEditingController();
//     final passwordController = TextEditingController();
//     final formKey = GlobalKey<FormState>();
//
//     return Padding(
//       padding: EdgeInsets.only(
//         left: 16.0,
//         right: 16.0,
//         top: 20.0,
//         bottom: MediaQuery.of(context).viewInsets.bottom + 20.0,
//       ),
//       child: Form(
//         key: formKey,
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Login',
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 24.0,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             SizedBox(height: 20.0),
//             TextFormField(
//               controller: emailController,
//               style: TextStyle(color: Colors.white),
//               decoration: InputDecoration(
//                 labelText: 'Email',
//                 labelStyle: TextStyle(color: Colors.white70),
//                 filled: true,
//                 fillColor: Colors.grey[800],
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(10.0),
//                   borderSide: BorderSide.none,
//                 ),
//               ),
//               validator: (value) {
//                 if (value == null || value.isEmpty) {
//                   return 'Please enter your email';
//                 }
//                 if (!RegExp(r"^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+\$").hasMatch(value)) {
//                   return 'Enter a valid email';
//                 }
//                 return null;
//               },
//             ),
//             SizedBox(height: 20.0),
//             TextFormField(
//               controller: passwordController,
//               obscureText: true,
//               style: TextStyle(color: Colors.white),
//               decoration: InputDecoration(
//                 labelText: 'Password',
//                 labelStyle: TextStyle(color: Colors.white70),
//                 filled: true,
//                 fillColor: Colors.grey[800],
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(10.0),
//                   borderSide: BorderSide.none,
//                 ),
//               ),
//               validator: (value) {
//                 if (value == null || value.isEmpty) {
//                   return 'Please enter your password';
//                 }
//                 if (value.length < 6) {
//                   return 'Password must be at least 6 characters';
//                 }
//                 return null;
//               },
//             ),
//             SizedBox(height: Dimensions.blockSizeVertical*2),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Expanded(
//                   child: ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                         minimumSize: Size(0, Dimensions.blockSizeVertical * 6),
//                         backgroundColor: Colors.white,
//                         shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(Dimensions.safeBlockHorizontal * 4))),
//                     onPressed: () {
//                       if (formKey.currentState!.validate()) {
//                         //handle login logic
//                         Navigator.of(context).pop();
//                       }
//                     },
//                     child:  Text(
//                       'Login',
//                       style: TextStyle(fontSize: Dimensions.safeBlockHorizontal * 4, color: Colors.black),
//                     ),
//                   ),
//                 ),
//                 SizedBox(width: Dimensions.blockSizeVertical*2),
//                 //if (isBiometricSupported)
//                 SizedBox(
//                   width: Dimensions.blockSizeHorizontal*15, // Adjust the width as needed
//                   child: ElevatedButton(
//                     onPressed: () {
//                       data.read('token') == null ?
//                       showDialog(
//                         context: context,
//                         barrierDismissible: false,
//                         builder: (BuildContext context) {
//                           return AlertDialog(
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(10.0),
//                             ),
//                             content: Column(
//                               mainAxisSize: MainAxisSize.min,
//                               children:  [
//                                 Icon(Icons.error,color: Colors.red, size: Dimensions.blockSizeVertical*6),
//                                 SizedBox(height: Dimensions.blockSizeVertical*2),
//                                 const Text('Login Via Email & Password First!'),
//                                 SizedBox(height: Dimensions.blockSizeVertical*2),
//                                 Container(
//                                   width: MediaQuery.of(context).size.width,
//                                   child: ElevatedButton(
//                                       style: ElevatedButton.styleFrom(
//                                         backgroundColor: Colors.red,
//                                       ),
//                                       onPressed: (){
//                                         Navigator.of(context).pop();
//                                       }, child: const Text('OK', style: TextStyle(color: Colors.white))),
//                                 )
//                               ],
//                             ),
//                           );
//                         },
//                       ) :  _fingerLogin(context);
//                     },
//                     style: ButtonStyle(
//                       padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
//                         EdgeInsets.all(Dimensions.blockSizeHorizontal*3),
//                       ),
//                       shape: WidgetStateProperty.all<RoundedRectangleBorder>(
//                         RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(Dimensions.safeBlockHorizontal * 4),
//                         ),
//                       ),
//                       backgroundColor: WidgetStateProperty.all<Color>(
//                           Colors.white), // Set the background color to black45
//                     ),
//                     // Set the icon color using a ColorFilter
//                     child: Icon(Icons.fingerprint, color: Colors.black),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   },
// );