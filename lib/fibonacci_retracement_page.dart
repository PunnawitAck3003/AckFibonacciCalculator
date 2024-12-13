import 'package:flutter/material.dart';
import 'package:flutter_application_fib1/fibonacci_rebounding_page.dart';
import 'fibonacci_levels.dart';

class FibonacciRetracementPage extends StatefulWidget {
  @override
  _FibonacciRetracementPageState createState() =>
      _FibonacciRetracementPageState();
}

class _FibonacciRetracementPageState extends State<FibonacciRetracementPage> {
  final TextEditingController _highController = TextEditingController();
  final TextEditingController _lowController = TextEditingController();
  final TextEditingController _newLevelController = TextEditingController();

  Map<String, double>? _retracementLevels;
  List<double> _levels = levels;  // Using the levels from the imported file
  Set<double> _importantLevels = importantLevels;

  void _calculateRetracementLevels() {
    final double? high = double.tryParse(_highController.text);
    final double? low = double.tryParse(_lowController.text);

    if (high != null && low != null && high > low) {
      final double range = high - low;
      setState(() {
        _retracementLevels = {
          for (double level in _levels)
            '${(level * 100).toStringAsFixed(1)}%': high - (range * level),
        };
      });
    } else {
      setState(() {
        _retracementLevels = null;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter valid high and low values.')),
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
        _calculateRetracementLevels();
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
        title: const Text('Fibonacci Retracement Calculator'),
        centerTitle: true,
        backgroundColor: Colors.greenAccent[100],
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
              onPressed: _calculateRetracementLevels,
              child: Text('Calculate Retracement Levels'),
            ),
            SizedBox(height: 16),
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
                  final String levelStr = '${(level * 100).toStringAsFixed(1)}%';
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
                            color: isImportant ? Colors.red : Colors.black, // Highlight important levels
                          ),
                        ),
                        Row(
                          children: [
                            if (_retracementLevels != null)
                              Text(
                                _retracementLevels![levelStr]?.toStringAsFixed(2) ?? '',
                                style: TextStyle(fontSize: 16, color: isImportant ? Colors.red : Colors.grey[700]),
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