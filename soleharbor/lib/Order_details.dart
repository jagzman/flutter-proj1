import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class OrderDetailsPage extends StatelessWidget {
  final String orderId; // Pass the order ID to this widget

  OrderDetailsPage({required this.orderId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF9370DB),
      appBar: AppBar(
        backgroundColor: Color(0xFF4B0082),
        title: Text('Order Details',
          style: GoogleFonts.acme(fontSize: 26,color: Colors.white,fontWeight: FontWeight.bold),
        ),
      ),
      body: FutureBuilder(
        future: _fetchOrderDetails(),
        builder: (context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          final orderDetails = snapshot.data;

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Order ID: $orderId', style: TextStyle(fontSize: 20)),
                // Display product details
                // Text('Product Name: ${orderDetails?['productName'] ?? 'Not available'}'),
                // Text('Product Price: Rs ${orderDetails?['productPrice'] ?? '0.0'}'),
                if (orderDetails?['productImage'] != null)
                  Image.network(
                    orderDetails?['productImage'],
                    height: 100,
                    width: 100,
                    fit: BoxFit.cover,
                  ),

                // Return Product Button
                ElevatedButton(
                  onPressed: () async {
                    // Handle the return product action
                    // You can navigate to another page, show a confirmation dialog, etc.
                    // Implement your logic here.
                    // For now, let's show a snackbar.
                    await FirebaseFirestore.instance
                        .collection('orders')
                        .doc(orderId)
                        .update({'status': 'Returned'});
                    Get.snackbar(
                      'Product Returned',colorText: Colors.green,
                      'Your Product will be taken by our executive within 2-3 days--'
                      'Product returned for Order ID: $orderId',
                      snackPosition: SnackPosition.TOP,
                      duration: Duration(seconds: 3),
                    );
                  },
                  child: Text('Return Product'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<Map<String, dynamic>> _fetchOrderDetails() async {
    try {
      final orderSnapshot = await FirebaseFirestore.instance
          .collection('orders')
          .doc(orderId)
          .get();

      if (!orderSnapshot.exists) {
        throw Exception('Order with ID $orderId does not exist.');
      }

      final orderData = orderSnapshot.data() as Map<String, dynamic>;

      print('Order Data: $orderData');

      // Assuming there's a 'productId' field in the order details
      final productId = orderData['productId'];

      if (productId == null) {
        // Handle the case where 'productId' is null
        print('Product ID is null in order with ID $orderId.');
        return {
          'name': 'Product Name not available',
          'price': 0.0,
          'image': null,
        };
      }

      // Fetch product details using the productId
      final productSnapshot = await FirebaseFirestore.instance
          .collection('products')
          .doc(productId)
          .get();

      if (!productSnapshot.exists) {
        throw Exception('Product with ID $productId does not exist.');
      }

      final productData = productSnapshot.data() as Map<String, dynamic>;

      print('Product Data: $productData');

      // Include the 'image' field in the returned data
      return {
        'name': productData['name'] ?? 'Product Name not available',
        'price': productData['price'] ?? 0.0,
        'image': productData['image'],
      };
    } catch (error) {
      print('Error fetching order details: $error');
      throw error;
    }
  }
}
