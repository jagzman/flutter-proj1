import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';
import 'package:soleharbor/controller/login_controller.dart';
import 'package:soleharbor/pages/register_page.dart';

class Loginpage extends StatelessWidget {
  final RoundedLoadingButtonController _btnController = RoundedLoadingButtonController();
  Loginpage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LoginController>(builder: (ctrl) {
      return Scaffold(
        body: Container(
          width: double.maxFinite,
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF4B0082),  // Deep Purple
                Color(0xFF9370DB),  // Lavender
                Color(0xFFC0C0C0)]
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
               Text("Welcome Back!..",
                style: GoogleFonts.acme(
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF800020),
                ),),
              const SizedBox(height: 20),
              TextField(
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.account_box_rounded),
                  labelText: 'Username',
                  hintText: 'Enter your Username',
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: ctrl.loginumctrl,
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
              Center(
                child: RoundedLoadingButton(
                  color: Colors.redAccent,
                  controller: _btnController,
                  onPressed: () {
                  ctrl.loginwithph();
                },
                  child: const Text("Login",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),),
              ),
              const SizedBox(height: 20),
              TextButton(onPressed: () {
                Get.to(Registerpage());
              },
                child: const Text("Register New Account"),),
            ],
          ),
        ),
      );
    });
  }
}
