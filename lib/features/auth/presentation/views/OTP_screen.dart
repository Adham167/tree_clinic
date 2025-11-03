// import 'package:flutter/material.dart';
// import 'package:tree_clinic/core/constants/app_colors.dart';
// import 'package:tree_clinic/features/auth/presentation/widgets/custom_button.dart';

// class OTPScreen extends StatefulWidget {
//   OTPScreen({super.key});
//   String id = "OTPScreen";
//   @override
//   State<OTPScreen> createState() => _OTPScreenState();
// }

// class _OTPScreenState extends State<OTPScreen> {
//   final pinController = TextEditingController();
//   final focusNode = FocusNode();

//   @override
//   void dispose() {
//     pinController.dispose();
//     focusNode.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     // This is the theme for each box.
//     final defaultPinTheme = PinTheme(
//       width: 56,
//       height: 60,
//       textStyle: const TextStyle(
//         fontSize: 22,
//         color: Color.fromRGBO(30, 60, 87, 1),
//       ),
//       decoration: BoxDecoration(
//         color: Colors.white, // Or any background color you want
//         borderRadius: BorderRadius.circular(8),
//         border: Border.all(
//           color: Colors.blue.shade300,
//         ), // Border color from your image
//       ),
//     );

//     return Scaffold(
//       backgroundColor: AppColors.kPrimaryColor,
//       appBar: AppBar(backgroundColor: AppColors.kPrimaryColor, actions: <Widget>[
//         ],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // --- Your other widgets like the title ---
//             const Text(
//               'Check Your Email',
//               style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 10),
//             const Text(
//               'We sent a reset link to contact@dscode...com\nenter 5 digit code that mentioned in the email',
//               style: TextStyle(fontSize: 16, color: Colors.grey),
//             ),
//             const SizedBox(height: 30),

//             // --- The Pinput Widget ---
//             Center(
//               child: Pinput(
//                 length: 6, // The number of boxes from your image
//                 controller: pinController,
//                 focusNode: focusNode,
//                 defaultPinTheme: defaultPinTheme,
//                 // Apply a different style when a box is focused
//                 focusedPinTheme: defaultPinTheme.copyWith(
//                   decoration: defaultPinTheme.decoration!.copyWith(
//                     border: Border.all(color: Colors.blueAccent),
//                   ),
//                 ),
//                 // Apply a different style when the user has submitted the code
//                 submittedPinTheme: defaultPinTheme.copyWith(
//                   decoration: defaultPinTheme.decoration!.copyWith(
//                     border: Border.all(color: Colors.green),
//                   ),
//                 ),
//                 onCompleted: (pin) {
//                   // This function is called when all boxes are filled.
//                   debugPrint('PIN Completed: $pin');
//                   // You can add your verification logic here.
//                 },
//               ),
//             ),
//             const SizedBox(height: 40),

//             // --- Your Reset Password Button ---
//             GestureDetector(
//               onTap: () {
//                 // Navigator.pushNamed(context, PasswordResetView().id);
//               },
//               child: CustomButton(name: "Reset Password"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
