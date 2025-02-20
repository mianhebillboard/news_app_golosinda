import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }
}

double screenPadding(BuildContext context) {
  return MediaQuery.of(context).size.width - 45;
}

// Height
final double primaryHeight = 10;
final double secondaryHeight = 15;
final double smallHeight = 5;

// Date formatter
// Function to format the date
String formatDate(String dateString) {
  try {
    DateTime date = DateTime.parse(dateString);
    return DateFormat('MMMM d, y').format(date); // Example: "February 20, 2025"
  } catch (e) {
    return 'Unknown Date'; // Fallback if parsing fails
  }
}