import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projectsh/controller/home_controller.dart';
import 'package:projectsh/widgets/dropdown_btn.dart';

class Addproduct extends StatelessWidget {
  const Addproduct({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(builder: (ctrl) {
      return Scaffold(
        appBar: AppBar(title: Text("Add product"),),
        body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.all(10),
            child: SizedBox(
              width: double.maxFinite,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Add Product", style: TextStyle(fontSize: 30,
                      color: Colors.redAccent,
                      fontWeight: FontWeight.bold),),
                  TextField(
                    controller: ctrl.productNameCtrl,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)
                        ),
                        label: Text("Product Name"),
                        hintText: "Enter the product name"
                    ),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: ctrl.productDescriptionCtrl,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)
                        ),
                        label: Text("Product Description"),
                        hintText: "Enter the product description"
                    ),
                    maxLines: 4,
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: ctrl.productImgCtrl,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)
                        ),
                        label: Text("Product Image"),
                        hintText: "Enter Image URL"
                    ),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: ctrl.productPriceCtrl,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)
                        ),
                        label: Text("Product Price"),
                        hintText: "Enter the Product Price"
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Flexible(child: Dropdown(items: const ['Football boots', 'Shoes', 'Flip Flops'],
                        selectedItemText: ctrl.category,
                        onSelected: (selectedValue) {
                          ctrl.category = selectedValue ?? 'general';
                          ctrl.update();
                        },)),
                      Flexible(child: Dropdown(items: const ['Adidas', 'Nike', 'New Balance','Puma'],
                        selectedItemText: ctrl.brand,
                        onSelected: (selectedValue) {
                          ctrl.brand = selectedValue ?? 'unbranded';
                          ctrl.update();
                        },)),
                    ],
                  ),
                  SizedBox(height: 10),
                  Text("offer or discount for the product ?."),
                  Dropdown(items: ['true', 'false'],
                    selectedItemText: ctrl.offer.toString(),
                    onSelected: (selectedValue) {
                    ctrl.offer = bool.tryParse(selectedValue ?? 'false') ?? false;
                    ctrl.update();
                    },),
                  SizedBox(height: 10),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          foregroundColor: Colors.white
                      ),
                      onPressed: () {
                        ctrl.addProduct();
                      }, child: Text("Add Product")),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
