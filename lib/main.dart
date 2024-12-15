import 'package:flutter/material.dart';
import 'package:flutter_application_fib1/advanced_carmarilla.dart';
import 'package:flutter_application_fib1/fibonacci_projection_page.dart';
import 'package:flutter_application_fib1/fibonacci_retracement_page.dart';

void main() {
  runApp(FibonacciApp());
}

class FibonacciApp extends StatelessWidget {
  const FibonacciApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ack Fibonacci Calculators'),
        centerTitle: true,
        backgroundColor: Colors.amber[50],
      ),
      body: Center(
        // Center the entire Column widget within the body
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Vertically center
            crossAxisAlignment:
                CrossAxisAlignment.center, // Horizontally center
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
                child: Text('Fibonacci Retracement/Rebounding Calculator'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FibonacciProjectionPage(),
                    ),
                  );
                },
                child: Text('Fibonacci Projection Calculator'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CamarillaCalculatorPage(),
                    ),
                  );
                },
                child: Text('Advanced Camarilla Trading Calculator'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
