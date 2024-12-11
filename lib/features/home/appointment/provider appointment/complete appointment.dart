import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CompletedAppointmentProvider extends StatelessWidget {
  const CompletedAppointmentProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('appointments')
          .where('status', isEqualTo: 'completed') // Fetch only completed appointments
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return const Center(child: Text('Failed to load completed appointments'));
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text(
              'No completed appointments',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          );
        }

        final appointments = snapshot.data!.docs;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Completed Appointments'),
          ),
          body: ListView.builder(
            itemCount: appointments.length,
            itemBuilder: (context, index) {
              final appointment = appointments[index];
              final appointmentData = appointment.data() as Map<String, dynamic>;

              return ListTile(
                title: Text(appointmentData['serviceName'] ?? 'Service'),
                subtitle: Text('User: ${appointmentData['userEmail']}'),
                trailing: Text(
                  'Date: ${(appointmentData['appointmentDate'] as Timestamp).toDate()}',
                ),
              );
            },
          ),
        );
      },
    );
  }
}
