import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pet/features/home/home.dart'; // Update this import path based on your project structure

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
  DateTime? selectedDate;
  String selectedSlot = '';
  String address = '';
  String selectedPaymentMethod = '';
  List<String> timeSlots = [
    '9:00 AM', '9:30 AM', '10:00 AM', '10:30 AM',
    '11:00 AM', '11:30 AM', '12:00 PM', '12:30 PM',
    '1:00 PM', '1:30 PM', '2:00 PM', '2:30 PM',
    '3:00 PM', '3:30 PM', '4:00 PM', '4:30 PM',
    '5:00 PM'
  ];
  List<String> unavailableSlots = [];

  // Fetch unavailable slots from Firestore
  Future<void> fetchUnavailableSlots() async {
    if (selectedDate == null) return;

    final snapshot = await FirebaseFirestore.instance
        .collection('appointments')
        .where('date', isEqualTo: selectedDate!.toIso8601String().split('T')[0])
        .get();

    setState(() {
      unavailableSlots = snapshot.docs.map((doc) => doc['slot'] as String).toList();
    });
  }

  // Save appointment to Firestore and navigate to Home
  Future<void> saveAppointment() async {
    if (selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a date.')),
      );
      return;
    }

    if (selectedSlot.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a time slot.')),
      );
      return;
    }

    if (address.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter your address.')),
      );
      return;
    }

    if (selectedPaymentMethod.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a payment method.')),
      );
      return;
    }

    await FirebaseFirestore.instance.collection('appointments').add({
      'userName': widget.userName,
      'userEmail': widget.userEmail,
      'serviceName': widget.name,
      'description': widget.description,
      'price': widget.price,
      'date': selectedDate!.toIso8601String().split('T')[0],
      'slot': selectedSlot,
      'address': address,
      'paymentMethod': selectedPaymentMethod,
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Appointment booked successfully!')),
    );

    // Navigate to Home screen
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => Home()), // Replace with your Home widget
          (route) => false, // Remove all routes below
    );
  }

  // Select date
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
        selectedSlot = ''; // Reset selected slot
      });
      await fetchUnavailableSlots(); // Fetch slots for the selected date
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Select Appointment')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text('Service: ${widget.name}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text(widget.description),
            SizedBox(height: 8),
            Text('Price: \$${widget.price.toStringAsFixed(2)}'),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Select Date:', style: TextStyle(fontWeight: FontWeight.bold)),
                Text(selectedDate != null
                    ? selectedDate!.toLocal().toString().split(' ')[0]
                    : 'No date selected'),
                IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: () => _selectDate(context),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text('Select Time Slot:', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            GridView.builder(
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: timeSlots.length,
              itemBuilder: (context, index) {
                String slot = timeSlots[index];
                bool isUnavailable = unavailableSlots.contains(slot);
                return GestureDetector(
                  onTap: isUnavailable
                      ? null
                      : () {
                    setState(() {
                      selectedSlot = slot;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: isUnavailable
                          ? Colors.grey
                          : (selectedSlot == slot ? Colors.blue : Colors.white),
                      border: Border.all(
                        color: selectedSlot == slot ? Colors.blue : Colors.black,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        slot,
                        style: TextStyle(
                          color: isUnavailable ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                labelText: 'Enter Address',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  address = value;
                });
              },
            ),
            SizedBox(height: 20),
            Text('Select Payment Method:', style: TextStyle(fontWeight: FontWeight.bold)),
            ListTile(
              title: Text('Credit Card'),
              leading: Radio<String>(
                value: 'Credit Card',
                groupValue: selectedPaymentMethod,
                onChanged: (value) {
                  setState(() {
                    selectedPaymentMethod = value!;
                  });
                },
              ),
            ),
            ListTile(
              title: Text('Cash on Delivery'),
              leading: Radio<String>(
                value: 'Cash on Delivery',
                groupValue: selectedPaymentMethod,
                onChanged: (value) {
                  setState(() {
                    selectedPaymentMethod = value!;
                  });
                },
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: saveAppointment,
              child: Text('Confirm Appointment'),
            ),
          ],
        ),
      ),
    );
  }
}
