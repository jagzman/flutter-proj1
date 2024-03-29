import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Orderstatus extends StatefulWidget {
  const Orderstatus({Key? key}) : super(key: key);

  @override
  _OrderstatusState createState() => _OrderstatusState();
}

class _OrderstatusState extends State<Orderstatus> {
  String selectedStatus = 'Confirmed'; // Default status
  late String orderId;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Status'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Enter Order ID:',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            TextField(
              onChanged: (value) {
                orderId = value;
              },
              decoration: InputDecoration(
                hintText: 'Order ID',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Select Order Status:',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            DropdownButton<String>(
              value: selectedStatus,
              onChanged: (String? newValue) {
                setState(() {
                  selectedStatus = newValue!;
                });
              },
              items: <String>[
                'Confirmed',
                'Shipped',
                'Out for Delivery',
                'Delivered'
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                updateOrderStatus(orderId, selectedStatus);
              },
              child: Text('Update Order Status'),
            ),
          ],
        ),
      ),
    );
  }

  void updateOrderStatus(String orderId, String newStatus) {
    _firestore.collection('orders').doc(orderId).update({
      'status': newStatus,
    }).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Order status updated successfully!'),
        ),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error updating order status: $error'),
        ),
      );
    });
  }
}

void main() {
  runApp(MaterialApp(
    home: Orderstatus(),
  ));
}
