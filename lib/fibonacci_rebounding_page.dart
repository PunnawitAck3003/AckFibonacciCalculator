import 'package:flutter/material.dart';
import 'package:flutter_application_fib1/fibonacci_retracement_page.dart';
import 'fibonacci_levels.dart';

class FibonacciReboundingPage extends StatefulWidget {
  @override
  _FibonacciReboundingPageState createState() =>
      _FibonacciReboundingPageState();
}

class _FibonacciReboundingPageState extends State<FibonacciReboundingPage> {
  final TextEditingController _highController = TextEditingController();
  final TextEditingController _lowController = TextEditingController();
  final TextEditingController _newLevelController = TextEditingController();

  Map<String, double>? _reboundingLevels;
  List<double> _levels = levels;  // Using the levels from the imported file
  Set<double> _importantLevels = importantLevels;

  void _calculateReboundingLevels() {
    final double? high = double.tryParse(_highController.text);
    final double? low = double.tryParse(_lowController.text);

    if (low != null && high != null && high > low) {
      final double range = high - low;
      setState(() {
        _reboundingLevels = {
          for (double level in _levels)
            '${(level * 100).toStringAsFixed(1)}%': low + (range * level),
        };
      });
    } else {
      setState(() {
        _reboundingLevels = null;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter valid low and high values.')),
      );
    }
  }

  void _addNewLevel() {
    final double? newLevel = double.tryParse(_newLevelController.text);
    if (newLevel != null && !_levels.contains(newLevel / 100)) {
      setState(() {
        _levels.add(newLevel / 100); // Convert to decimal
        _levels.sort(); // Sort levels after adding
        _newLevelController.clear();
        _calculateReboundingLevels();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a valid unique level.')),
      );
    }
  }

  void _deleteLevel(double level) {
    setState(() {
      _levels.remove(level);
      _levels.sort(); // Sort levels after removing
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fibonacci Rebounding Calculator'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent[100],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _highController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'High Value',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _lowController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Low Value',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _calculateReboundingLevels,
              child: Text('Calculate Rebounding Levels'),
            ),
            SizedBox(height: 16),
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
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _newLevelController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Add New Level (%)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _addNewLevel,
                  child: Text('Add'),
                ),
              ],
            ),
            SizedBox(height: 24),
            // Show all levels initially (before calculation)
            Expanded(
              child: ListView(
                children: _levels.map((level) {
                  // Convert decimal back to percentage string
                  final String levelStr =
                      '${(level * 100).toStringAsFixed(1)}%';
                  final bool isImportant = _importantLevels.contains(level);
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Level $levelStr',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isImportant
                                ? Colors.red
                                : Colors.black, // Highlight important levels
                          ),
                        ),
                        Row(
                          children: [
                            if (_reboundingLevels != null)
                              Text(
                                _reboundingLevels![levelStr]
                                        ?.toStringAsFixed(2) ??
                                    '',
                                style: TextStyle(
                                    fontSize: 16,
                                    color: isImportant
                                        ? Colors.red
                                        : Colors.grey[700]),
                              ),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _deleteLevel(level),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
