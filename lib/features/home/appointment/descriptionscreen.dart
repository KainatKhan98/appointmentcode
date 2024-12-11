
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pet/constants/constants.dart';
import 'package:pet/constants/text.dart';

import 'appointment_service.dart';
import '../home.dart';

class BookingScreen extends StatelessWidget {
final String name;
final String description;
final double price;
final int duration;
final String userName;
final String userEmail;
final String profileImageUrl; // URL or path for the profile image

BookingScreen({
  required this.name,
  required this.description,
  required this.price,
  required this.duration,
  required this.userName,
  required this.userEmail,
  required this.profileImageUrl, // Add profile image URL to the constructor
});

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text("Service Provider Details"),
      backgroundColor: backgrndclrpurple,
    ),
    body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Picture Section (Moved here before the card)
            Center(
              child: CircleAvatar(
                radius: 100, // Adjust the radius for profile picture size
                backgroundImage: profileImageUrl.isNotEmpty
                    ? NetworkImage(profileImageUrl) // Display image from URL
                    : null, // No image if the URL is empty
                backgroundColor: Colors.grey[200], // Fallback color
                child: profileImageUrl.isEmpty
                    ? Icon(
                  Icons.person, // Default profile icon
                  size: 50, // Adjust size of the icon
                  color: Colors.grey[600], // Icon color
                )
                    : null, // No icon if the image is provided
              ),
            ),

            SizedBox(height: 16), // Space between profile picture and content

            // Title Section
            Text(
              "Details",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),

            // Provider Information Section (Card widget)
            Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                child: Card(
                  elevation: 5,
                  margin: EdgeInsets.only(bottom: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        // Profile Info (Provider Info)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // RichText for Provider and Username
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: "Provider: ",
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black),
                                  ),
                                  TextSpan(
                                    text: "$userName",
                                    style: TextStyle(fontWeight: FontWeight.normal, fontSize: 16, color: Colors.black),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 8),

                            // RichText for Provider Email and Email
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: "Provider Email: ",
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black),
                                  ),
                                  TextSpan(
                                    text: "$userEmail", // Using phoneNo here instead of email
                                    style: TextStyle(fontWeight: FontWeight.normal, fontSize: 16, color: Colors.black),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Service Details Section (Card widget)
            Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.9, // Same width as the first card
                child: Card(
                  elevation: 5,
                  margin: EdgeInsets.only(bottom: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // RichText for Service Name
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "Service Name: ",
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black),
                              ),
                              TextSpan(
                                text: "$name",
                                style: TextStyle(fontWeight: FontWeight.normal, fontSize: 16, color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 8),

                        // RichText for Description
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "Description: ",
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black),
                              ),
                              TextSpan(
                                text: "$description",
                                style: TextStyle(fontWeight: FontWeight.normal, fontSize: 16, color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 8),

                        // RichText for Price
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "Price: ",
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black),
                              ),
                              TextSpan(
                                text: "\$$price",
                                style: TextStyle(fontWeight: FontWeight.normal, fontSize: 16, color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 8),

                        // RichText for Duration
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "Duration: ",
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black),
                              ),
                              TextSpan(
                                text: "$duration minutes",
                                style: TextStyle(fontWeight: FontWeight.normal, fontSize: 16, color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: () {
                    // Custom navigation with animation using PageRouteBuilder
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) => AppointmentSelectionScreen(
                            userName: userName,
                            userEmail: userEmail,
                            name: name,
                            description: description,
                            price: price,
                             // duration: duration
                        ),
                        transitionsBuilder: (context, animation, secondaryAnimation, child) {
                          // Custom animation: Slide transition
                          var begin = Offset(1.0, 0.0); // From right to left
                          var end = Offset.zero; // Ending position
                          var curve = Curves.easeInOut; // Animation curve

                          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                          var offsetAnimation = animation.drive(tween);

                          return SlideTransition(position: offsetAnimation, child: child); // Slide transition
                        },
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: backgrndclrpurple, // Button color
                    padding: EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                    textStyle: TextStyle(fontSize: 18),
                  ),
                  child: Text("Book Appointment"), // Simple button text
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
}

