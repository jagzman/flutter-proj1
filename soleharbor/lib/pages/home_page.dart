import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:soleharbor/controller/home_controller.dart';
import 'package:soleharbor/image_slider.dart';
import 'package:soleharbor/my_account.dart';
import 'package:soleharbor/my_cart.dart';
import 'package:soleharbor/pages/Productdesc.dart';
import 'package:soleharbor/pages/login_page.dart';
import 'package:soleharbor/track_order.dart';
import 'package:soleharbor/widgets/dropdown_btn.dart';
import 'package:soleharbor/widgets/multi_dd.dart';
import 'package:soleharbor/widgets/product_card.dart';

class Homepage extends StatelessWidget {
   const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<Homecontroller>(builder: (ctrl) {
      return RefreshIndicator(
        onRefresh: () async{
          ctrl.fetchProducts();
        },
        child: Scaffold(
          backgroundColor:  Color(0xFF4B0082),
          appBar: AppBar(
            backgroundColor: Color(0xFF9370DB),
            title: Text("Sole Harbor Store",
              style: GoogleFonts.acme(fontSize: 30,color: Color(0xFF800020),fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
            actions: [
              IconButton(onPressed: () {
                Get.to(const Mycart());
              },
                  icon: Icon(Icons.add_shopping_cart_rounded)
              ),
              IconButton(onPressed: () {
                Get.to(Ordertrack());
              },
                  icon: Icon(Icons.notification_important_sharp)
              ),
              IconButton(onPressed: () {
                Get.to(const imageSliders());
              },
                  icon: Icon(Icons.home_filled)
              ),
              IconButton(onPressed: () {
                Get.to(AccountPage());
              },
                  icon: Icon(Icons.account_circle_sharp)
              ),
            ],
          ),
          body: Column(
            children: [
              SizedBox(height: 50,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: ctrl.productCategories.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                        ctrl.filterbyCategory(ctrl.productCategories[index].name ?? '');
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(6),
                          child: Chip(label: Text(ctrl.productCategories[index].name ?? 'error')),
                        ),
                      );
                    }),
              ),
              Row(
                children: [
                  Flexible(
                    child: Dropdown(items: ['Rs: Low to High', 'Rs: High to Low'],
                      selectedItemText: 'Sort',
                      onSelected: (selected) {
                        ctrl.sortbyPrice(ascending: selected =='Rs: Low to High'? true : false);
                      },
                    ),
                  ),
                  Flexible(child: Multidd(items: ['Adidas', 'Nike', 'New Balance','Puma'],
                    onSelectionChanged: (selectedItems) {
                    ctrl.filterbyBrand(selectedItems);
                    },
                  )),
                ],
              ),
              Expanded(
                child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        childAspectRatio: 0.8,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8
                    ),
                    itemCount: ctrl.productshowinui.length,
                    itemBuilder: (context, index) {
                      return Productcard(name: ctrl.productshowinui[index].name ?? 'No name',
                        imageUrl: ctrl.productshowinui[index].image ?? 'url',
                        price: ctrl.productshowinui[index].price ?? 00,
                        offerTag: '30% OFF',
                        onTap: () {
                          Get.to(() => const Productdesc(), arguments: {'data':ctrl.productshowinui[index]});
                        },
                      );
                    }),
              )
            ],
          ),
        ),
      );
    });
  }
}
