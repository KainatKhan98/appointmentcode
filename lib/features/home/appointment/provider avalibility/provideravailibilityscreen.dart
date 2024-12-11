import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProviderAvailabilityScreen extends StatefulWidget {
  @override
  _ProviderAvailabilityScreenState createState() => _ProviderAvailabilityScreenState();
}

class _ProviderAvailabilityScreenState extends State<ProviderAvailabilityScreen> {
  List<String> timeSlots = [
    '9:00 AM', '9:30 AM', '10:00 AM', '10:30 AM',
    '11:00 AM', '11:30 AM', '12:00 PM', '12:30 PM',
    '1:00 PM', '1:30 PM', '2:00 PM', '2:30 PM',
    '3:00 PM', '3:30 PM', '4:00 PM', '4:30 PM',
    '5:00 PM'
  ];

  Set<String> selectedSlots = {}; // Track selected slots
  DateTime selectedDate = DateTime.now(); // Default date is today

  void toggleSlotSelection(String slot) {
    setState(() {
      if (selectedSlots.contains(slot)) {
        selectedSlots.remove(slot);
      } else {
        selectedSlots.add(slot);
      }
    });
  }

  Future<void> saveAvailability() async {
    // Save to database (Firestore example)
    try {
      // Replace with your provider's email or ID
      final String providerEmail = "provider@example.com";

      await FirebaseFirestore.instance.collection('providerAvailability').doc(providerEmail).set({
        'providerEmail': providerEmail,
        'availability': FieldValue.arrayUnion([
          {
            'date': selectedDate.toIso8601String().split('T')[0],
            'slots': Map.fromIterable(timeSlots, key: (slot) => slot, value: (slot) => selectedSlots.contains(slot) ? 'free' : 'unavailable'),
          }
        ])
      }, SetOptions(merge: true));

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Availability saved successfully')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error saving availability: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Set Availability')),
      body: Column(
        children: [
          // Date picker for selecting the date
          ListTile(
            title: Text('Selected Date: ${selectedDate.toLocal()}'.split(' ')[0]),
            trailing: Icon(Icons.calendar_today),
            onTap: () async {
              final DateTime? picked = await showDatePicker(
                context: context,
                initialDate: selectedDate,
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(Duration(days: 30)), // Limit date selection
              );
              if (picked != null && picked != selectedDate) {
                setState(() {
                  selectedDate = picked;
                });
              }
            },
          ),
          // Slots as selectable buttons
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, // Number of slots per row
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 2.5,
              ),
              itemCount: timeSlots.length,
              itemBuilder: (context, index) {
                final slot = timeSlots[index];
                final isSelected = selectedSlots.contains(slot);

                return GestureDetector(
                  onTap: () => toggleSlotSelection(slot),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.purple : Colors.grey[300],
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      slot,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          // Save button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: saveAvailability,
              child: Text('Save Availability'),
            ),
          ),
        ],
      ),
    );
  }
}
