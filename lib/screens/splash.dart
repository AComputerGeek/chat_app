import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Chat'),
        backgroundColor: Colors.grey,
      ),
      body: const Center(
        child: Text(
          'Loading...',
          style: TextStyle(
            color: Colors.lightBlue,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
