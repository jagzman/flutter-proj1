import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projectsh/controller/home_controller.dart';
import 'package:projectsh/firebase_options.dart';
import 'package:projectsh/pages/login_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: firebaseOptions);
  //? registering my controller
  Get.put(HomeController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sole Harbor',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.redAccent),
        useMaterial3: true,
      ),
      home: AdminLoginPage(),
        initialBinding: BindingsBuilder(() {
    Get.put(HomeController());
    }),
    );
  }
}
class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Retrieve HomeController using Get.find
            HomeController ctrl = Get.find<HomeController>();
            ctrl.updateProduct("product.id ?? ''");
          },
          child: Text("Update Product"),
        ),
      ),
    );
  }
}

