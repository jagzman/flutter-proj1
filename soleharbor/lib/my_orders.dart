import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:soleharbor/Order_details.dart';

class MyOrdersPage extends StatelessWidget {
  final String userPhoneNumber; // Pass the user's phone number to this widget

  MyOrdersPage({required this.userPhoneNumber});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF4B0082),
        title: Text('My Orders',
          style: GoogleFonts.acme(fontSize: 26,color: Colors.white,fontWeight: FontWeight.bold),
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('orders')
            .where('phone', isEqualTo: userPhoneNumber)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.data?.docs.isEmpty ?? true) {
            return Center(
              child: Text('No orders found for this user.'),
            );
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic>? data =
              document.data() as Map<String, dynamic>?;

              // Check if data is not null
              if (data == null) {
                return Container(); // or some other fallback UI
              }

              // You can customize this part based on your data structure
              return ListTile(
                title: Text('Order ID: ${document.id}'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Add an Image widget here using the 'image' field
                    if (data['image'] != null)
                      Image.network(
                        data['image'],
                        height: 100,
                        width: 100,
                        fit: BoxFit.cover, // Adjust the BoxFit as needed
                      ),
                    Text('Item: ${data['item']}'),
                    Text('Price: Rs ${data['price']}'),
                    Text('Address: ${data['address']}'),
                    Text('Status: ${data['status']}'),
                    Text('Date Time: ${data['dateTime']}'),
                  ],
                ),
                onTap: () {
                  Get.to(OrderDetailsPage(orderId: document.id,));
                },
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
