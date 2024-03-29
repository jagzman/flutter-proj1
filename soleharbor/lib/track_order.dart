import 'dart:js';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Order {
  final String id;
  final String status;

  Order(this.id, this.status);

  factory Order.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    return Order(
      snapshot.id,
      snapshot.get('status') as String,
    );
  }
}

class Ordertrack extends StatefulWidget {
  const Ordertrack({Key? key}) : super(key: key);

  @override
  State<Ordertrack> createState() => _OrdertrackState();
}

class _OrdertrackState extends State<Ordertrack> with TickerProviderStateMixin {
  bool result = false;
  late String orderId;
  late List<Step> steps;

  void updateOrderStatus() {
    print('Updating order status for order ID: $orderId to $result');
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  TextEditingController orderIdController = TextEditingController();
  late GlobalKey<ScaffoldState> scaffoldKey;

  @override
  void initState() {
    super.initState();
    scaffoldKey = GlobalKey<ScaffoldState>(); // Initialize GlobalKey
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF9370DB),
      body: content(),
    );
  }

  Widget content() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            height: 300,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(50),
                bottomRight: Radius.circular(50),
              ),
            ),
            child: Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.only(top: 30.0),
                child: Column(
                  children: [
                    Image.asset(
                      "asset/delivery.jpg",
                      height: 220,
                    ),
                    Text(
                      "Track your order",
                      style: GoogleFonts.dancingScript(fontWeight: FontWeight.bold, fontSize: 30),
                    ),
                  ],
                ),
              ),
            ),
          ),
          body(),
        ],
      ),
    );
  }

  Widget body() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 50,
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.only(left: 35.0),
          child: Text(
            "Tracking Number:",
            style: GoogleFonts.dancingScript(fontWeight: FontWeight.bold, fontSize: 30),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(30, 0, 20, 0),
          child: Row(
            children: [
              Container(
                height: 60,
                width: 310,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: TextField(
                  onChanged: (value) {
                    orderId = value;
                  },
                  decoration: InputDecoration(
                      border: OutlineInputBorder(borderSide: BorderSide.none),
                      hintText: "eg-#134567892"),
                ),
              ),
              SizedBox(
                width: 30,
              ),
              GestureDetector(
                onTap: () {
                  fetchDataAndBuild();
                },
                child: Icon(Icons.search_rounded, size: 35),
              ),
            ],
          ),
        ),
        SizedBox(height: 20),
        result
            ? Padding(
          padding: const EdgeInsets.fromLTRB(35, 2, 31, 0),
          child: Row(
            children: [
              Text(
                "Order Status:-",
                style: GoogleFonts.dancingScript(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              Spacer(),
              GestureDetector(
                onTap: () {
                  Future.delayed(Duration.zero, () {
                    setState(() {
                      result = false;
                    });
                  });
                },
                child: Icon(
                  Icons.close,
                  size: 25,
                ),
              ),
            ],
          ),
        )
            : SizedBox(),
        SizedBox(height: 5),
        result
            ? Padding(
          padding: const EdgeInsets.fromLTRB(15, 2, 15, 0),
          child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            stream: _firestore.collection('orders').doc(orderId).snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (!snapshot.hasData || !snapshot.data!.exists) {
                return Text('Order not found');
              } else {
                Order order = Order.fromSnapshot(snapshot.data!);
                updateSteps(order.status);
                return Stepper(
                  currentStep: steps.length - 1,
                  steps: steps,
                );
              }
            },
          ),
        )
            : Transform(
            transform: Matrix4.translationValues(0, -50, 0),
            child: Lottie.asset("asset/Essentials_Ecommerce_02.json")),
        SizedBox(height: 10),
        Center(
          child: ElevatedButton(
            onPressed: () {
              cancelOrder();
            },
            child: Text('Cancel Order',style: TextStyle(fontWeight: FontWeight.bold),),
          ),
        ),
      ],
    );
  }

  void fetchDataAndBuild() {
    Future.delayed(Duration.zero, () {
      setState(() {
        result = true;
      });
    });
  }

  void updateSteps(String orderStatus) {
    // Get the current date and time
    DateTime now = DateTime.now();
    String formattedDateTime = "${now.day}-${now.month}-${now.year} ${now.hour}:${now.minute}";

    steps = [
      Step(
        title: Text('Order Confirmed', style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Your product will be dispatched soon'),
            Text('Date and Time: $formattedDateTime'),
          ],
        ),
        content: YourCustomViewHere(),
        state: orderStatus == 'Confirmed' ? StepState.complete : StepState.indexed,
        isActive: orderStatus == 'Confirmed',
      ),
      Step(
        title: Text('Order Shipped', style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Your product has been shipped'),
            Text('Date and Time: $formattedDateTime'),
          ],
        ),
        content: YourCustomViewHere(),
        state: orderStatus == 'Shipped' ? StepState.complete : StepState.indexed,
        isActive: orderStatus == 'Shipped',
      ),
      Step(
        title: Text('Out For Delivery', style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Your product has reached the nearest hub'),
            Text('Date and Time: $formattedDateTime'),
          ],
        ),
        content: YourCustomViewHere(),
        state: orderStatus == 'Out for Delivery' ? StepState.complete : StepState.indexed,
        isActive: orderStatus == 'Out for Delivery',
      ),
      Step(
        title: Text('Order Delivered', style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Your order has been delivered to your doorstep'),
            Text('Date and Time: $formattedDateTime'),
          ],
        ),
        content: YourCustomViewHere(),
        state: orderStatus == 'Delivered' ? StepState.complete : StepState.indexed,
        isActive: orderStatus == 'Delivered',
      ),
      Step(
        title: Text('Order Cancelled', style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Your order has been cancelled'),
            Text('Date and Time: $formattedDateTime'),
          ],
        ),
        content: YourCustomViewHere(),
        state: orderStatus == 'Cancelled' ? StepState.complete : StepState.indexed,
        isActive: orderStatus == 'Cancelled',
      ),
    ];
  }


  void cancelOrder() {
    if (orderId != null && orderId.isNotEmpty) {
      _firestore.collection('orders').doc(orderId).update({
        'status': 'Cancelled',
      }).then((value) {
        Get.snackbar('Success', 'Order has been cancelled.',
            snackPosition: SnackPosition.TOP,
            colorText: Colors.blueAccent);
        setState(() {
          result = false;
        });
      }).catchError((error) {
        Get.snackbar('Error', 'Error cancelling order: $error',
            snackPosition: SnackPosition.TOP, colorText: Colors.red);
      });
    } else {
      Get.snackbar('Error', 'Please enter a valid Order ID.',
          snackPosition: SnackPosition.TOP, colorText: Colors.red);
    }
  }


  Widget YourCustomViewHere() {
    return Container(
      child: Text(
        'Thank You for Ordering from your favourite store',
        style: GoogleFonts.dancingScript(fontSize: 25, fontWeight: FontWeight.bold),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: Ordertrack(),
  ));
}