import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pet/constants/constants.dart';
import 'package:pet/features/home/home.dart';

class AppointmentSelectionScreen extends StatefulWidget {
  final String userName;
  final String userEmail;
  final String name;
  final String description;
  final double price;

  AppointmentSelectionScreen({
    required this.userName,
    required this.userEmail,
    required this.name,
    required this.description,
    required this.price,
  });

  @override
  _AppointmentSelectionScreenState createState() =>
      _AppointmentSelectionScreenState();
}

class _AppointmentSelectionScreenState
    extends State<AppointmentSelectionScreen> {
  DateTime selectedDate = DateTime.now();
  String selectedSlot = '';
  String address = ''; // Variable to store the entered address
  String selectedPaymentMethod = ''; // To store the selected payment method
  List<String> timeSlots = [
    '9:00 AM', '9:30 AM', '10:00 AM', '10:30 AM',
    '11:00 AM', '11:30 AM', '12:00 PM', '12:30 PM',
    '1:00 PM', '1:30 PM', '2:00 PM', '2:30 PM',
    '3:00 PM', '3:30 PM', '4:00 PM', '4:30 PM',
    '5:00 PM'
  ];

  // Function to select the date
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2023),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  // Function to select the time slot
  void _selectTimeSlot(String slot) {
    setState(() {
      selectedSlot = slot;
    });
  }

  // Validate if all inputs are valid
  bool _isValidSelection() {
    return selectedSlot.isNotEmpty &&
        selectedDate != null &&
        address.isNotEmpty &&
        selectedPaymentMethod.isNotEmpty;
  }

  // Navigate to home screen after successful booking
  void _navigateToHome() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Home()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Appointment'),
        backgroundColor: backgrndclrpurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Date Picker
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Select Date:",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "${selectedDate.toLocal()}".split(' ')[0],
                    style: TextStyle(fontSize: 16),
                  ),
                  IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: () => _selectDate(context),
                  ),
                ],
              ),
              SizedBox(height: 20),
          
              // Time Slot Selection using GridView
              Text(
                "Select Time Slot:",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              GridView.builder(
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 4.0,
                  mainAxisSpacing: 4.0,
                  childAspectRatio: 2.5,
                ),
                itemCount: timeSlots.length,
                itemBuilder: (context, index) {
                  return ChoiceChip(
                    label: Text(timeSlots[index]),
                    selected: selectedSlot == timeSlots[index],
                    onSelected: (selected) {
                      _selectTimeSlot(timeSlots[index]);
                    },
                    backgroundColor: backgrndclrpurple,
                    selectedColor: Colors.purple[200],
                    labelStyle: TextStyle(color: Colors.black),
                  );
                },
              ),
              SizedBox(height: 20),
          
              // Address Input Field
              Text(
                "Enter Address:",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              TextField(
                onChanged: (value) {
                  setState(() {
                    address = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Enter your address',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
          
              // Payment Method Selection
              Text(
                "Select Payment Method:",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Column(
                children: [
                  ListTile(
                    title: Text("Credit/Debit Card"),
                    leading: Radio<String>(
                      value: "Credit/Debit Card",
                      groupValue: selectedPaymentMethod,
                      onChanged: (value) {
                        setState(() {
                          selectedPaymentMethod = value!;
                        });
                      },
                    ),
                  ),
                  ListTile(
                    title: Text("Digital Wallets"),
                    leading: Radio<String>(
                      value: "Digital Wallets",
                      groupValue: selectedPaymentMethod,
                      onChanged: (value) {
                        setState(() {
                          selectedPaymentMethod = value!;
                        });
                      },
                    ),
                  ),
                  ListTile(
                    title: Text("Bank Transfer"),
                    leading: Radio<String>(
                      value: "Bank Transfer",
                      groupValue: selectedPaymentMethod,
                      onChanged: (value) {
                        setState(() {
                          selectedPaymentMethod = value!;
                        });
                      },
                    ),
                  ),
                  ListTile(
                    title: Text("Cash on Delivery (COD)"),
                    leading: Radio<String>(
                      value: "Cash on Delivery",
                      groupValue: selectedPaymentMethod,
                      onChanged: (value) {
                        setState(() {
                          selectedPaymentMethod = value!;
                        });
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
          
              // Confirm Button
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (_isValidSelection()) {
                      String currentUserEmail =
                          FirebaseAuth.instance.currentUser?.email ?? 'No User';
          
                      FirebaseFirestore.instance.collection('appointments').add({
                        'providerName': widget.userName,
                        'providerEmail': widget.userEmail,
                        'serviceName': widget.name,
                        'appointmentDate': selectedDate,
                        'appointmentTime': selectedSlot,
                        'userEmail': currentUserEmail,
                        'address': address,
                        'paymentMethod': selectedPaymentMethod,
                      }).then((_) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Appointment booked successfully!')),
                        );
                        _navigateToHome();
                      }).catchError((e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Failed to book appointment: $e')),
                        );
                      });
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text(
                                'Please select a valid date, time, address, and payment method')),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: backgrndclrpurple,
                    padding: EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                    textStyle: TextStyle(fontSize: 18),
                  ),
                  child: Text("Confirm Booking"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
