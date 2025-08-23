import 'package:flutter/material.dart';

class CustomerDashboardScreen extends StatelessWidget {
  const CustomerDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        backgroundColor: const Color(0xFF0C1B2A),
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text('Customer Dashboard Screen'),
      ),
    );
  }
}