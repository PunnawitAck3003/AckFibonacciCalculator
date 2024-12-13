import 'package:flutter/material.dart';
import 'package:flutter_application_fib1/fibonacci_rebounding_page.dart';
import 'package:flutter_application_fib1/fibonacci_retracement_page.dart';

void main() {
  runApp(FibonacciApp());
}

class FibonacciApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fibonacci Calculators'),
        centerTitle: true,
        backgroundColor: Colors.amber[50],
      ),
      body: Center( // Center the entire Column widget within the body
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Vertically center
            crossAxisAlignment: CrossAxisAlignment.center, // Horizontally center
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FibonacciRetracementPage(),
                    ),
                  );
                },
                child: Text('Fibonacci Retracement Calculator'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FibonacciReboundingPage(),
                    ),
                  );
                },
                child: Text('Fibonacci Rebounding Calculator'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

