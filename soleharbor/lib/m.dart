// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// class OrderDetailsPage extends StatelessWidget {
//   final String orderId; // Pass the order ID to this widget
//
//   OrderDetailsPage({required this.orderId});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Order Details'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text('Order ID: $orderId', style: TextStyle(fontSize: 20)),
//             // Add more order details as needed
//
//             // Return Product Button
//             ElevatedButton(
//               onPressed: () {
//                 // Handle the return product action
//                 // You can navigate to another page, show a confirmation dialog, etc.
//                 // Implement your logic here.
//                 // For now, let's show a snackbar.
//                 Get.snackbar(
//                   'Product Returned',colorText: Colors.green,
//                   'Product returned for Order ID: $orderId',
//                   snackPosition: SnackPosition.TOP,
//                   duration: Duration(seconds: 3),
//                 );
//               },
//               child: Text('Return Product'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }