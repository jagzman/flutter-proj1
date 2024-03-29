import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projectsh/model/product/product.dart';

class HomeController extends GetxController{

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  late CollectionReference productCollection;

  TextEditingController productNameCtrl = TextEditingController();
  TextEditingController productDescriptionCtrl = TextEditingController();
  TextEditingController productImgCtrl = TextEditingController();
  TextEditingController productPriceCtrl = TextEditingController();

  String category = 'general';
  String brand = 'unbranded';
  bool offer = false;

  List<Product> products = [];

  @override
  Future<void> onInit() async {
    productCollection = firestore.collection('products');
    await fetchProducts();
    super.onInit();
  }

  addProduct(){
    try {
      DocumentReference doc = productCollection.doc();
      Product product = Product(
            id: doc.id,
            name: productNameCtrl.text,
            category: category,
            description: productDescriptionCtrl.text,
            price: double.tryParse(productPriceCtrl.text),
            brand: brand,
            image: productImgCtrl.text,
            offer: offer,
          );
      final productJson = product.toJson();
      doc.set(productJson);
      Get.snackbar('Success', 'product added successfully',colorText: Colors.green);
      setValuesDefault();
    } catch (e) {
      Get.snackbar('Error', e.toString(),colorText: Colors.redAccent);
      print(e);
    }
  }

  fetchProducts() async {
    try {
      QuerySnapshot productSnapshot = await productCollection.get();
      final List<Product> retrievedProducts = productSnapshot.docs.map((doc) =>
           Product.fromJson(doc.data() as Map <String, dynamic>)).toList();
      products.clear();
      products.assignAll(retrievedProducts);
      Get.snackbar('Success', 'product fetch successfully',colorText: Colors.blueAccent);
    } catch (e) {
      Get.snackbar('Error', e.toString(),colorText: Colors.red);
      print(e);
    }finally{
      update();
    }
  }

  updateProduct(String id) async {
    try {
      DocumentReference doc = productCollection.doc(id);
      Product updatedProduct = Product(
        id: id,
        name: productNameCtrl.text,
        category: category,
        description: productDescriptionCtrl.text,
        price: double.tryParse(productPriceCtrl.text),
        brand: brand,
        image: productImgCtrl.text,
        offer: offer,
      );
      final updatedProductJson = updatedProduct.toJson();
      await doc.update(updatedProductJson);
      Get.snackbar('Success', 'Product updated successfully', colorText: Colors.green);
      fetchProducts();
      Get.back();
    } catch (e) {
      Get.snackbar('Error', e.toString(), colorText: Colors.redAccent);
      print(e);
    }
  }

  deleteProduct(String id) async {
  try {
    await productCollection.doc(id).delete();
    fetchProducts();
  } catch (e) {
    Get.snackbar('Error', e.toString(),colorText: Colors.red);
    print(e);
  }
  }

  setValuesDefault(){
    productNameCtrl.clear();
    productDescriptionCtrl.clear();
    productImgCtrl.clear();
    productPriceCtrl.clear();

     category = 'general';
     brand = 'unbranded';
     offer = false;
     update();
  }
}