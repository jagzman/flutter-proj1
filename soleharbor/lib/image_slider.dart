import 'package:another_carousel_pro/another_carousel_pro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:soleharbor/pages/login_page.dart';

class imageSliders extends StatefulWidget{
  const imageSliders({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<imageSliders>{
  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        backgroundColor: Color(0xFF9370DB),
        title: Text("Sole Harbor Store",
          style: GoogleFonts.acme(color: Colors.white,fontWeight: FontWeight.bold)),
        centerTitle: true,
          actions: [
          IconButton(onPressed: () {
    GetStorage box = GetStorage();
    box.erase();
    Get.offAll( Loginpage());
    },
        icon: Icon(Icons.logout_rounded)
    ),
    ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: Color(0xFF9370DB),
        child: Text("For making a query or a complaint please contact on 8075162003 or you may use this email id: jagannathanoob2002@gmail.com",
        style: GoogleFonts.roboto(color:Colors.white,fontWeight: FontWeight.bold),),
      ),
      body: Column(
        children: [
           SizedBox(
              height: 400,
              width: double.infinity,
              child: AnotherCarousel(images: const [
                AssetImage(
                    'asset/Blue Simple Shoes Sale  (Banner (Landscape)).png'),
                AssetImage(
                    'asset/Screenshot 2024-02-28 102248.png'),
              ],
                dotSize: 6,
                indicatorBgPadding: 5.0,
              ),
    ),
    Expanded(
    child: ListView(
    children: [
    Container(
    padding: EdgeInsets.all(16),
    color: Colors.grey[200],
    child: Text(
    'Welcome to Sole Harbor Store - Where Comfort Meets Style!',
    style: GoogleFonts.dancingScript(fontSize: 24, fontWeight: FontWeight.bold),
    ),
    ),
      Container(
        padding: EdgeInsets.all(16),
        child: Text("At Sole Harbor, we take immense pride in providing a seamless shopping experience for our valued customers."
            "Our commitment to customer satisfaction is unwavering, and we strive to exceed your expectations at every step. We understand that comfort and style are of utmost importance when it comes to footwear,"
            "and thats why we curate a diverse collection of high-quality shoes that not only look fantastic but also ensure unparalleled comfort.",
        style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16,fontStyle: FontStyle.italic,
          decoration: TextDecoration.underline,
          decorationColor: Colors.deepOrangeAccent,
          decorationThickness: 1.5),
        ),
      ),
      Container(
        padding: EdgeInsets.all(16),
        child: Text("Our dedication to customer satisfaction goes beyond just delivering exceptional products. "
            "We value your feedback and continuously work towards enhancing our services. From the moment you browse our website to the swift and secure delivery of your order, "
            "our focus remains on ensuring your complete satisfaction.",
          style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16,fontStyle: FontStyle.italic,
              decoration: TextDecoration.underline,
              decorationColor: Colors.deepOrangeAccent,
              decorationThickness: 1.5),
        ),
      ),
      Container(
        padding: EdgeInsets.all(16),
        child: Text("Quality is at the heart of everything we do. Each pair of shoes at Sole Harbor is"
            "crafted with precision and care, using premium materials to guarantee durability"
            "and style that lasts. We believe in offering more than just shoes; we provide a lifestyle that combines fashion, comfort, and durability.",
          style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16,fontStyle: FontStyle.italic,
              decoration: TextDecoration.underline,
              decorationColor: Colors.deepOrangeAccent,
              decorationThickness: 1.5),
        ),
      ),
    ],
      ),
    ),
      ],
      ),
    );
  }
}