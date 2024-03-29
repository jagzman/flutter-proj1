import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class AccountDetails {
  String firstName = '';
  String lastName = '';
  String email = '';
  String gender = '';
  List<String> addresses = [];
  List<String> phoneNumbers = [];
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AccountPage(),
    );
  }
}

class AccountPage extends StatefulWidget {
  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final AccountDetails _accountDetails = AccountDetails();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final CollectionReference usersCollection =
  FirebaseFirestore.instance.collection('users');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white10,
      appBar: AppBar(backgroundColor: Color(0xFF9370DB),
        title: Text("Profile Information", style: GoogleFonts.acme(fontSize: 26, fontWeight: FontWeight.bold,color: Color(0xFF800020)),),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10),
              TextFormField(
                decoration: InputDecoration(labelText: 'First Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your first name';
                  }
                  return null;
                },
                onSaved: (value) {
                  _accountDetails.firstName = value!;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                decoration: InputDecoration(labelText: 'Last Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your last name';
                  }
                  return null;
                },
                onSaved: (value) {
                  _accountDetails.lastName = value!;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                decoration: InputDecoration(labelText: 'Email Address'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email address';
                  }
                  return null;
                },
                onSaved: (value) {
                  _accountDetails.email = value!;
                },
              ),
              SizedBox(height: 10),
              _buildGenderSelection(),
              SizedBox(height: 10),
              _buildDynamicFormField(
                'Residential Address',
                _accountDetails.addresses,
              ),
              SizedBox(height: 10),
              _buildDynamicFormField(
                'Phone Number',
                _accountDetails.phoneNumbers,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _saveAccountDetails();
                },
                child: Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGenderSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Gender'),
        Row(
          children: [
            Radio(
              value: 'Male',
              groupValue: _accountDetails.gender,
              onChanged: (value) {
                setState(() {
                  _accountDetails.gender = value.toString();
                });
              },
            ),
            Text('Male'),
            Radio(
              value: 'Female',
              groupValue: _accountDetails.gender,
              onChanged: (value) {
                setState(() {
                  _accountDetails.gender = value.toString();
                });
              },
            ),
            Text('Female'),
            Radio(
              value: 'Others',
              groupValue: _accountDetails.gender,
              onChanged: (value) {
                setState(() {
                  _accountDetails.gender = value.toString();
                });
              },
            ),
            Text('Others'),
          ],
        ),
      ],
    );
  }

  Widget _buildDynamicFormField(String label, List<String> values) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        for (int i = 0; i < values.length; i++)
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: '${label} ${i + 1}',
                  ),
                  onSaved: (value) {
                    values[i] = value!;
                  },
                ),
              ),
              IconButton(
                icon: Icon(Icons.remove),
                onPressed: () {
                  setState(() {
                    values.removeAt(i);
                  });
                },
              ),
            ],
          ),
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () {
            setState(() {
              values.add('');
            });
          },
        ),
      ],
    );
  }

  void _saveAccountDetails() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {
        await usersCollection.add({
          'first_name': _accountDetails.firstName,
          'last_name': _accountDetails.lastName,
          'email': _accountDetails.email,
          'gender': _accountDetails.gender,
          'addresses': _accountDetails.addresses,
          'phone_numbers': _accountDetails.phoneNumbers,
        });

        Get.snackbar(
          'Success',
          'Account details saved successfully',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
        );
      } catch (e) {
        print('Error saving account details: $e');
        Get.snackbar(
          'Error',
          'Error saving account details',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
        );
      }
    }
  }
}
