import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:soleharbor/controller/login_controller.dart';
import 'package:soleharbor/pages/login_page.dart';
import 'package:soleharbor/widgets/otp_textfield.dart';

class Registerpage extends StatelessWidget {
  const Registerpage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LoginController>(builder: (ctrl) {
      return Scaffold(
        body: Container(
          width: double.maxFinite,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF4B0082),
                  Color(0xFF9370DB),
                  Color(0xFFC0C0C0)]
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
               Text("Create your Account!.",
                style: GoogleFonts.acme(
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF800020),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: ctrl.registerNameCtrl,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.account_box_rounded),
                  labelText: 'Name',
                  hintText: 'Enter your Name',
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: ctrl.registerNumberCtrl,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.phone_android),
                  labelText: 'Mobile Number',
                  hintText: 'Enter your mobile number',
                ),
              ),
              const SizedBox(height: 20),
              otpText(otpController: ctrl.otpController, visble: ctrl.otpfieldshow, oncomplete: (otp) {
                ctrl.otpenter = int.tryParse(otp ?? '0000');
              },),
              const SizedBox(height: 20),
              ElevatedButton(onPressed: () {
                if(ctrl.otpfieldshow){
                  ctrl.addUser();
                }else{
                  ctrl.sendOtp();
                }
              },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.redAccent,
                ),
                child: Text( ctrl.otpfieldshow ? 'Register' : "Send OTP"),
              ),
              const SizedBox(height: 15),
              TextButton(onPressed: () {
                Get.to( Loginpage());
              },
                child: const Text("Login"),),
            ],
          ),
        ),
      );
    });
  }
}
