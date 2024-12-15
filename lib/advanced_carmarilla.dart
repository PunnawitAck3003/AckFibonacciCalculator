import 'package:flutter/material.dart';
import 'package:flutter_application_fib1/custom_date.dart';

class CamarillaCalculatorPage extends StatefulWidget {
  @override
  _CamarillaCalculatorPageState createState() =>
      _CamarillaCalculatorPageState();
}

class _CamarillaCalculatorPageState extends State<CamarillaCalculatorPage> {
  final TextEditingController _highController = TextEditingController();
  final TextEditingController _lowController = TextEditingController();
  final TextEditingController _closeController = TextEditingController();

  Map<String, double> _camarillaLevels = {}; // Default levels

  @override
  void initState() {
    super.initState();
    _calculateDefaultLevels();
  }

  void _calculateDefaultLevels() {
    // Default dummy values for high, low, close
    const double high = 1;
    const double low = 1;
    const double close = 0;
    final double range = high - low;

    setState(() {
      _camarillaLevels = _generateCamarillaLevels(high, low, close, range);
    });
  }

  void _calculateCamarillaLevels() {
    final double? high = double.tryParse(_highController.text);
    final double? low = double.tryParse(_lowController.text);
    final double? close = double.tryParse(_closeController.text);

    if (high != null && low != null && close != null && high >= low) {
      final double range = high - low;
      setState(() {
        _camarillaLevels = _generateCamarillaLevels(high, low, close, range);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Please enter valid high, low, and close values.')),
      );
    }
  }

  Map<String, double> _generateCamarillaLevels(
      double high, double low, double close, double range) {
    return {
      'H10': close + (1.7798 * range),
      'H9': close + (1.65 * range),
      'H8 ': close + (1.5202 * range),
      'H7 ': close + (1.3596 * range),
      'H6 ': (high / low) * close,
      'H5 ': ((high / low) * close + close + (0.55 * range)) / 2,
      'H4 ': close + (0.55 * range),
      'H3 ': close + (0.275 * range),
      'H2 ': close + (0.18333333 * range),
      'H1 ': close + (0.09166666 * range),
      'L1 ': close - (0.09166666 * range),
      'L2 ': close - (0.18333333 * range),
      'L3 ': close - (0.275 * range),
      'L4 ': close - (0.55 * range),
      'L5 ': 2 * close - ((high / low) * close + close + (0.55 * range)) / 2,
      'L6 ': close - (((high / low) * close) - close),
      'L7 ': close - (1.3596 * range),
      'L8 ': close - (1.5202 * range),
      'L9 ': close - (1.65 * range),
      'L10': close - (1.7798 * range),
    };
  }

  Widget _buildCamarillaLevels() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double horizontalPadding = constraints.maxWidth / 4;

        return ListView(
          children: _camarillaLevels.entries.map((entry) {
            final String key = entry.key.trim();
            final double value = entry.value;
            final bool isImportantGreen = key == 'H5' || key == 'H6';
            final bool isImportantRed = key == 'L5' || key == 'L6';

            return Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: horizontalPadding,
                  vertical: 1.0), // Responsive padding
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Key aligned to left
                  Expanded(
                    child: Text(
                      key,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isImportantGreen
                            ? Colors.green
                            : isImportantRed
                                ? Colors.red
                                : Colors.black,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  // Value aligned to right
                  Text(
                    value.toStringAsFixed(2),
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: isImportantGreen
                          ? Colors.green
                          : isImportantRed
                              ? Colors.red
                              : Colors.grey[700],
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Advanced Camarilla Calculator'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent[100],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Input fields in the same row
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _highController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'High',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _lowController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Low',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _closeController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Close',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            ElevatedButton(
              onPressed: _calculateCamarillaLevels,
              child: Text('Calculate Levels'),
            ),
            SizedBox(height: 8),
            // date time component here
            DateButtonComponent(),
            SizedBox(height: 8),
            Expanded(child: _buildCamarillaLevels()), // Levels shown here
          ],
        ),
      ),
    );
  }
}
