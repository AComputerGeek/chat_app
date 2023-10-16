import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Messages'),
        backgroundColor: const Color.fromRGBO(168, 255, 255, 1),
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
