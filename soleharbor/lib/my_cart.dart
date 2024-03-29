import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:soleharbor/controller/login_controller.dart';
import 'package:soleharbor/controller/purchase_controller.dart';
import 'package:soleharbor/my_orders.dart';
import 'package:soleharbor/wallet.dart';

class Mycart extends StatefulWidget {
  const Mycart({super.key});

  @override
  State<Mycart> createState() => _MycartState();
}

class _MycartState extends State<Mycart> {
  late Map<String, dynamic> product;
  PurchaseController ctrl = Get.find();


  void incrementQuantity(int index) {
    setState(() {
      ctrl.quantities[index]++;
    });
  }

  void decrementQuantity(int index) {
    setState(() {
      ctrl.quantities[index]--;
    });
  }

  double getCartToal() {
    double total = 0.0;
    for (int i = 0; i < ctrl.productNames.length; i++) {
      total += ctrl.quantities[i] * ctrl.prices[i];
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PurchaseController>(builder: (ctrl) {
      return Scaffold(
        backgroundColor: Color(0xFF9370DB),
        appBar: AppBar(backgroundColor: Color(0xFF4B0082),
          title: Text("Cart Details", style: GoogleFonts.acme(fontSize: 26, fontWeight: FontWeight.bold,color: Colors.white),),
            actions: [
              IconButton(onPressed: () {
                Get.to(MyOrdersPage(userPhoneNumber: Get.find<LoginController>().loginumctrl.text));
              },
                  icon: Icon(Icons.reorder)
              ),
              IconButton(onPressed: () {
                Get.to(WalletPage(userId: '',));
              },
                  icon: Icon(Icons.call_to_action)
              ),
            ],
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: ctrl.productNames.length,
                    itemBuilder: (context, index) {
                      return Dismissible(
                        key: Key(ctrl.productNames[index]),
                        direction: DismissDirection.endToStart,
                        onDismissed: (direction) {
                          setState(() {
                            ctrl.productNames.removeAt(index);
                            ctrl.quantities.removeAt(index);
                            ctrl.prices.removeAt(index);
                            ctrl.images.removeAt(index);
                          });
                        },
                        background: Container(
                          color: Colors.red,
                          child: Icon(
                              Icons.cancel_rounded, color: Colors.white),
                          alignment: Alignment.centerRight,
                          padding: EdgeInsets.only(right: 16.0),
                        ),
                        child: Container(
                          margin: EdgeInsets.all(10.0),
                          padding: EdgeInsets.only(right: 16.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Image.network(
                                ctrl.images[index],
                                height: 150,
                                width: 150,
                              ),
                              SizedBox(width: 15.0),
                              Column(
                                children: [
                                  Text(
                                    ctrl.productNames[index],
                                    style: TextStyle(fontSize: 18.0),
                                  ),
                                  Text(
                                    "Rs: ${ctrl.prices[index]}",
                                    style: TextStyle(
                                        fontSize: 16.0, color: Colors.grey),
                                  ),
                                ],
                              ),
                              Spacer(),
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      decrementQuantity(index);
                                    },
                                    icon: Icon(Icons.remove_circle_outlined),
                                  ),
                                  Text(
                                    ctrl.quantities[index].toString(),
                                    style: TextStyle(fontSize: 18.0),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      incrementQuantity(index);
                                    },
                                    icon: Icon(Icons.add_box_rounded),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Divider(),
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Text(
                        'Cart Total:',
                        style: TextStyle(fontSize: 18.0),
                      ),
                      SizedBox(width: 50.0),
                      Text(
                        'Rs: ${getCartToal().toStringAsFixed(2)}',
                        style:
                        TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Divider(),
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            ctrl.submitOrder(price: getCartToal(),
                              item: 'Cart Items',
                              description: 'Purchase from My Cart');
                          },
                          child: Text("Proceed to Checkout"),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}