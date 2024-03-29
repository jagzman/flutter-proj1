import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soleharbor/model/product/product.dart';
import 'package:soleharbor/model/product_category/product_category.dart';

class Homecontroller extends GetxController{

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  late CollectionReference productCollection;
  late CollectionReference categoryCollection;

  List<Product> products = [];
  List<Product> productshowinui = [];
  List<ProductCategory> productCategories = [];

  @override
  Future<void> onInit() async {
    productCollection = firestore.collection('products');
    categoryCollection = firestore.collection('category');
    await fetchCategory();
    await fetchProducts();
    super.onInit();
  }

  fetchProducts() async {
    try {
      QuerySnapshot productSnapshot = await productCollection.get();
      final List<Product> retrievedProducts = productSnapshot.docs.map((doc) =>
          Product.fromJson(doc.data() as Map <String, dynamic>)).toList();
      products.clear();
      products.assignAll(retrievedProducts);
      productshowinui.assignAll(products);
      Get.snackbar('Success', 'product fetch successfully',colorText: Colors.blueAccent);
    } catch (e) {
      Get.snackbar('Error', e.toString(),colorText: Colors.red);
      print(e);
    }finally{
      update();
    }
  }

  fetchCategory() async {
    try {
      QuerySnapshot categorySnapshot = await categoryCollection.get();
      final List<ProductCategory> retrievedCategories = categorySnapshot.docs.map((doc) =>
          ProductCategory.fromJson(doc.data() as Map <String, dynamic>)).toList();
      productCategories.clear();
      productCategories.assignAll(retrievedCategories);
    } catch (e) {
      Get.snackbar('Error', e.toString(),colorText: Colors.red);
      print(e);
    }finally{
      update();
    }
  }

  filterbyCategory(String category){
    productshowinui.clear();
    productshowinui =products.where((product)=> product.category == category).toList();
    update();
  }

  filterbyBrand(List<String> brands){
    if(brands.isEmpty){
      productshowinui=products;
    }else{
      List<String> lowerCaseBrands = brands.map((brand) => brand.toLowerCase()).toList();
      productshowinui=products.where((product) => lowerCaseBrands.contains(product.brand?.toLowerCase())).toList();
    }
    update();
  }

  sortbyPrice({required bool ascending}){
    List<Product> sortedProducts = List<Product>.from(productshowinui);
    sortedProducts.sort((a,b)=> ascending ? a.price!.compareTo(b.price!) : b.price!.compareTo(a.price!));
    productshowinui=sortedProducts;
    update();
  }
}