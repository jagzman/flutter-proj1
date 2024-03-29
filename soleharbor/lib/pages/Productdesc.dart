import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:soleharbor/controller/purchase_controller.dart';
import 'package:soleharbor/model/product/product.dart';
import 'package:soleharbor/my_cart.dart';

class Productdesc extends StatelessWidget {
  const Productdesc({super.key});

  @override
  Widget build(BuildContext context) {
    Product product = Get.arguments['data'];
    PurchaseController ctrl = Get.find();
    return GetBuilder<PurchaseController>(builder: (ctrl) {
      return Scaffold(
        backgroundColor: Color(0xFF9370DB),
        appBar: AppBar(
          backgroundColor:  Color(0xFF4B0082),
          title: Text(
              "Product Details", style: GoogleFonts.acme(fontWeight: FontWeight.w900,color: Colors.white)),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(product.image ?? '',
                  fit: BoxFit.contain,
                  width: double.infinity,
                  height: 300,
                ),
              ),
              const SizedBox(height: 20),
              Text(product.name ?? '',
                style: GoogleFonts.acme(fontWeight: FontWeight.w900,
                  fontSize: 30,),
              ),
              const SizedBox(height: 20),
              Text(product.description ?? '',
                style: GoogleFonts.acme(fontWeight: FontWeight.w500,
                  fontSize: 16,),
              ),
              const SizedBox(height: 20),
              Text('Rs: ${product.price ?? ''}',
                style: GoogleFonts.acme(fontWeight: FontWeight.w900,
                    fontSize: 30,
                    color: Colors.black),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: ctrl.addressController,
                maxLines: 3,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  labelText: "Enter the Billing Address",
                ),
              ),
              const SizedBox(height: 20),
              Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(vertical: 15),
                                backgroundColor: Colors.redAccent),
                            child: const Text("Buy Now", style: TextStyle(
                                fontSize: 18,fontWeight: FontWeight.bold,color: Colors.white),),
                            onPressed: () {
                                            ctrl.submitOrder(price: product.price ?? 0, item: product.name ?? '', description: product.description ?? '');
                            },
                          ),
                        ),
                        const SizedBox(height: 10),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 15),
                              backgroundColor: Colors.redAccent,
                            ),
                            child: const Text(
                              "Add to Cart",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            onPressed: () {
                              ctrl.addToCart(
                                name: product.name ?? '',
                                price: product.price ?? 0,
                                description: product.description ?? '',
                                image: product.image ?? '',
                              );
                              Get.to(Mycart());
                              Get.snackbar('Success', 'Item added to cart',colorText: Colors.green);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }
}
