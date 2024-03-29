import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:razorpay_web/razorpay_web.dart';
import 'package:soleharbor/controller/login_controller.dart';
import 'package:soleharbor/model/user.dart';
import 'package:soleharbor/pages/home_page.dart';

class PurchaseController extends GetxController{
  List<String> productNames = [];
  List<int> quantities = [];
  List<double> prices = [];
  List<String> images = [];
  TextEditingController addressController = TextEditingController();
  double orderPrice = 0;
  String itemName = '';
  String orderAddress = '';

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  late CollectionReference orderCollection;

  @override
  void onInit(){
  orderCollection = firestore.collection('orders');
  super.onInit();
  }

  void addToCart({
    required String name,
    required double price,
    required String description,
    required String image,
  }) {
    productNames.add(name);
    quantities.add(1);
    prices.add(price);
    images.add(image);

    update(); // Trigger UI update
  }

  submitOrder({required double price, required String item, required String description}){
    orderPrice= price;
    itemName= item;
    orderAddress= addressController.text;
    orderPrice = 0.0;
    for (int i = 0; i < productNames.length; i++) {
      orderPrice += quantities[i] * prices[i];
    }

    Razorpay _razorpay= Razorpay();
    var options = {
      'key': 'rzp_test_ASfrG1i4ZBDJLM',
      'amount': price*100,
      'name': item,
      'description': description,
    };

    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.open(options);
  }


  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    orderSuccess(transactionId: response.paymentId);
    Get.snackbar('Success', 'Payment is Successfull',colorText: Colors.green);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Get.snackbar('Error', '${response.message}',colorText: Colors.red);
  }

  Future<void> orderSuccess({required String? transactionId}) async{
    User? loginUse = Get.find<LoginController>().loginUser;
    try{
      if(transactionId != null){
        DocumentReference docRef =await orderCollection.add({
          'customer': loginUse?.name ?? '',
          'phone': loginUse?.number ?? '',
          'item': itemName,
          'price': orderPrice,
          'address': orderAddress,
          'transactionId': transactionId,
          'dateTime': DateTime.now().toString(),
          'productImage': images,
        });
        print("Order created successfully: ${docRef.id}");
        showOrderSuccessDialog(docRef.id);
        Get.snackbar('Success', 'Order created Successfull',colorText: Colors.green);
      }else{
        Get.snackbar('Error', 'Please fill all the fields',colorText: Colors.red);
      }
    }catch (error){
      print("Failed to register user: $error");
      Get.snackbar('Error', 'Failed to create order',colorText: Colors.red);
    }
  }
  void showOrderSuccessDialog(String orderId){
    Get.defaultDialog(
      title: "Order Success",
      content: Text("Your OrderId is $orderId"),
      confirm: ElevatedButton(onPressed: () {
        Get.off(const Homepage());
      },
          child: const Text("Close"),
      ),
    );
  }
}