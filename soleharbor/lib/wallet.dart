import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';

class WalletPage extends StatefulWidget {
  final String userId;

  const WalletPage({Key? key, required this.userId}) : super(key: key);

  @override
  _WalletPageState createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  late double balance = 10000.0; // Set initial balance to 10000
  late CollectionReference walletRef;

  @override
  void initState() {
    super.initState();
    walletRef = FirebaseFirestore.instance.collection('wallets');
    // Load wallet balance
    loadBalance();
  }

  Future<void> loadBalance() async {
    DocumentSnapshot walletDoc = await walletRef.doc(widget.userId).get();
    if (walletDoc.exists) {
      setState(() {
        balance = walletDoc.get('balance');
      });
    } else {
      // If wallet document doesn't exist, create one with initial balance
      await walletRef.doc(widget.userId).set({'balance': 10000.0});
      setState(() {
        balance = 10000.0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold( backgroundColor:Color(0xFF9370DB),
      appBar: AppBar(backgroundColor: Color(0xFF4B0082),
        title: Text('Wallet',style: GoogleFonts.acme(fontSize: 26, fontWeight: FontWeight.bold,color: Colors.white),),
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Your Wallet Balance',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Text(
                'Rs:${balance.toStringAsFixed(2)}',
                style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
