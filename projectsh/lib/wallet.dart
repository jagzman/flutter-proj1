import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminWalletPage extends StatefulWidget {
  const AdminWalletPage({Key? key}) : super(key: key);

  @override
  _AdminWalletPageState createState() => _AdminWalletPageState();
}

class _AdminWalletPageState extends State<AdminWalletPage> {
  late TextEditingController _balanceController;
  late CollectionReference walletRef;

  @override
  void initState() {
    super.initState();
    _balanceController = TextEditingController();
    walletRef = FirebaseFirestore.instance.collection('wallets');
  }

  @override
  void dispose() {
    _balanceController.dispose();
    super.dispose();
  }

  void updateBalance() {
    double newBalance = double.tryParse(_balanceController.text) ?? 0.0;
    walletRef.doc('admin').set({'balance': newBalance}).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Balance updated successfully')),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update balance: $error')),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Wallet'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Current Balance:',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            StreamBuilder<DocumentSnapshot>(
              stream: walletRef.doc('admin').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data!.exists) {
                  double currentBalance =
                      snapshot.data!['balance'] ?? 0.0;
                  return Text(
                    '$currentBalance',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  );
                } else {
                  return Text(
                    'Balance not available',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  );
                }
              },
            ),
            SizedBox(height: 20),
            Text(
              'Update Balance:',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _balanceController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Enter new balance',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: updateBalance,
              child: Text('Update'),
            ),
          ],
        ),
      ),
    );
  }
}
