import 'package:flutter/material.dart';
import 'package:soleharbor/image_slider.dart';
import 'package:soleharbor/pages/home_page.dart';
import 'package:soleharbor/pages/login_page.dart';

class Mysplashpg extends StatefulWidget {
  const Mysplashpg({super.key});

  @override
  State<Mysplashpg> createState() => _MysplashpgState();
}

class _MysplashpgState extends State<Mysplashpg> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    jumptomyscreen();
  }
  jumptomyscreen()async{
  await Future.delayed(Duration(seconds: 2));
  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Loginpage(),));
  }
  Widget build(BuildContext context) {
    return Scaffold(
    body: Padding(padding: EdgeInsets.all(25),
    child: Image(image: AssetImage('asset/Red Modern New Arrival Shoes Instagram Post.png')),),
    );
  }
}

