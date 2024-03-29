import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:otp_text_field_v2/otp_field_v2.dart';
import 'package:soleharbor/model/user.dart';
import 'package:soleharbor/pages/home_page.dart';

class LoginController extends GetxController{
  GetStorage box = GetStorage();
  FirebaseFirestore firestore= FirebaseFirestore.instance;
  late CollectionReference userCollection;

  TextEditingController registerNameCtrl = TextEditingController();
  TextEditingController registerNumberCtrl = TextEditingController();

  TextEditingController loginumctrl = TextEditingController();

  OtpFieldControllerV2 otpController = OtpFieldControllerV2();
  bool otpfieldshow = false;
  int? otpsent;
  int? otpenter;

  User? loginUser;

@override
  void onReady() {
    Map<String, dynamic>? user = box.read('loginUser');
    if(user!=null){
      loginUser=User.fromJson(user);
      Get.to(const Homepage());
    }
    super.onReady();
  }

  @override
  void onInit() {
    userCollection = firestore.collection('users');
    super.onInit();
  }

  addUser(){
    try {
      if(otpenter == otpsent){
        DocumentReference doc = userCollection.doc();
        User user = User(
          id: doc.id,
          name: registerNameCtrl.text,
          number: int.parse(registerNumberCtrl.text),
        );
        final userJson = user.toJson();
        doc.set(userJson);
        Get.snackbar('Success', 'user added successfully',colorText: Colors.green);
        registerNameCtrl.clear();
        registerNumberCtrl.clear();
        otpController.clear();
      }else{
        Get.snackbar('Error','OTP incorrect',colorText: Colors.redAccent);
      }
    } catch (e) {
      Get.snackbar('Error', e.toString(),colorText: Colors.redAccent);
      print(e);
    }
  }

  sendOtp(){
    try {
      if(registerNumberCtrl.text.isEmpty || registerNameCtrl.text.isEmpty){
        Get.snackbar('Error', 'Please fill the fields',colorText: Colors.red);
        return;
      }
      final random = Random();
      int otp = 1000 +  random.nextInt(9000);
      print(otp);
      if(otp!=null){
            otpfieldshow=true;
            otpsent = otp;
            Get.snackbar('Success', 'Otp sent successfully',colorText: Colors.green);
        }else {
            Get.snackbar('Error', 'Otp not sent',colorText: Colors.red);
          }
    } catch (e) {
      print(e);
    }finally{
      update();
    }
    }

  Future<void> loginwithph() async{
    try{
      String phonenum = loginumctrl.text;
      if(phonenum.isNotEmpty){
        var querySnapshot =await userCollection.where('number',isEqualTo: int.tryParse(phonenum)).limit(1).get();
        if(querySnapshot.docs.isNotEmpty){
          var userdoc = querySnapshot.docs.first;
          var userdata = userdoc.data() as Map<String, dynamic>;
          box.write('loginUser',userdata);
          loginumctrl.clear();
          Get.to(const Homepage());
          Get.snackbar('Success', 'login successfull',colorText: Colors.green);
        }else{
          Get.snackbar('Error','User not found',colorText: Colors.red);
        }
      }else{
        Get.snackbar('Error','Please Enter a phone number',colorText: Colors.red);
      }
    } catch(error){
      print("Failed to login: $error");
      Get.snackbar('Error','Failed to login',colorText: Colors.red);
    }
  }
}