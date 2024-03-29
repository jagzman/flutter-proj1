import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projectsh/controller/home_controller.dart';
import 'package:projectsh/edit_page.dart';
import 'package:projectsh/order_status.dart';
import 'package:projectsh/pages/add_product_page.dart';
import 'package:get/route_manager.dart';
import 'package:projectsh/wallet.dart';

class homepage extends StatelessWidget {
  const homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(builder: (ctrl) {
      return Scaffold(
        appBar: AppBar(title: Text("Sole Harbor Admin Page"),
            actions: [
            IconButton(onPressed: () {
      Get.to(const Orderstatus());
      },
          icon: Icon(Icons.reorder)
      ),
              IconButton(onPressed: () {
                Get.to(const AdminWalletPage());
              },
                  icon: Icon(Icons.call_to_action)
              ),
      ],
        ),
        body: ListView.builder(
            itemCount: ctrl.products.length,
            itemBuilder: (context, index) {
              return ListTile(title: Text(ctrl.products[index].name ?? ''),
                subtitle: Text((ctrl.products[index].price ?? 0).toString()),
                trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
    IconButton(icon: Icon(Icons.edit),
    onPressed: () {
      HomeController ctrl = Get.find<HomeController>();
      ctrl.setValuesDefault();
      Get.to(EditProduct(product: ctrl.products[index]));
    }),
              IconButton(icon: Icon(Icons.delete),
                  onPressed: () {
                  ctrl.deleteProduct(ctrl.products[index].id ?? '');
                  }
              ),
              ],
                ),
              );
            }
        ),
        floatingActionButton: FloatingActionButton(onPressed: () {
          Get.to(Addproduct());
        },
          child: Icon(Icons.add),
        ),
      );
    });
  }
}
