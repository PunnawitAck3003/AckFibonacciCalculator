import 'package:flutter/material.dart';
import 'fibonacci_levels.dart';

class FibonacciProjectionPage extends StatefulWidget {
  const FibonacciProjectionPage({super.key});

  @override
  _FibonacciProjectionPageState createState() =>
      _FibonacciProjectionPageState();
}

class _FibonacciProjectionPageState extends State<FibonacciProjectionPage> {
  final TextEditingController _startController = TextEditingController();
  final TextEditingController _endController = TextEditingController();
  final TextEditingController _retracementController = TextEditingController();
  final TextEditingController _newLevelController = TextEditingController();

  bool _isInternalMode = true; // Toggle state
  bool _isUpMode = true;
  Map<String, double>? _projectionResults;
  final List<double> _levels =
      levels; // Using the levels from the imported file
  final Set<double> _importantLevels = importantLevels;

  void _calculateProjections() {
    final double? start = double.tryParse(_startController.text);
    final double? end = double.tryParse(_endController.text);
    final double? retracement = double.tryParse(_retracementController.text);

    if (start != null && end != null) {
      final double range = (end - start).abs();

      setState(() {
        if (_isInternalMode && _isUpMode && retracement != null) {
          // Internal Projection Up Calculation
          _projectionResults = {
            for (double ratio in _levels)
              '${(ratio * 100).toStringAsFixed(1)}%':
                  retracement + (range * ratio),
          };
        } else if (!_isInternalMode && _isUpMode) {
          // External Projection Up Calculatio
          _projectionResults = {
            for (double ratio in _levels)
              '${(ratio * 100).toStringAsFixed(1)}%': end + (range * ratio),
          };
        } else if (_isInternalMode && !_isUpMode && retracement != null) {
          // Internal Projection Down Calculation
          _projectionResults = {
            for (double ratio in _levels)
              '${(ratio * 100).toStringAsFixed(1)}%':
                  retracement - (range * ratio),
          };
        } else if (!_isInternalMode && !_isUpMode) {
          // External Projection Down Calculation
          _projectionResults = {
            for (double ratio in _levels)
              '${(ratio * 100).toStringAsFixed(1)}%': end - (range * ratio),
          };
        } else {
          _projectionResults = null;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Please enter valid retracement value.'),
            ),
          );
        }
      });
    } else {
      setState(() {
        _projectionResults = null;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter valid values for Start and End.')),
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
        _calculateProjections();
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
        title: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
              'Fibonacci ${_isInternalMode ? 'Internal' : 'External'} Projection ${_isUpMode ? 'Up' : 'Down'}'),
        ),
        centerTitle: true,
        backgroundColor: (_isUpMode&&_isInternalMode)? Colors.greenAccent
                      : (_isUpMode&&!_isInternalMode)? Colors.green
                      : (!_isUpMode&&_isInternalMode)? Colors.redAccent
                      : Colors.red,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _startController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Start',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _endController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'End',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                if (_isInternalMode)
                  Expanded(
                    child: TextField(
                      controller: _retracementController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Custom',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                if (_isInternalMode) SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _calculateProjections,
                  child: Text('Calculate Projections'),
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Text('External'),
                        Switch(
                          value:
                              _isInternalMode, // External is when _isInternalMode is false
                          onChanged: (value) {
                            setState(() {
                              _isInternalMode = value;
                            });
                          },
                        ),
                        Text('Internal'),
                      ],
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Text('Down'),
                        Switch(
                          value: _isUpMode, // Down is when _isUpMode is false
                          onChanged: (value) {
                            setState(() {
                              _isUpMode = value;
                            });
                          },
                        ),
                        Text('Up'),
                      ],
                    ),
                  ],
                ),
              ],
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
                            if (_projectionResults != null)
                              Text(
                                _projectionResults![levelStr]
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
