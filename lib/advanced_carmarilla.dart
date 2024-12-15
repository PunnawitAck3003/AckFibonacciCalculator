import 'package:flutter/material.dart';

class CamarillaCalculatorPage extends StatefulWidget {
  @override
  _CamarillaCalculatorPageState createState() =>
      _CamarillaCalculatorPageState();
}

class _CamarillaCalculatorPageState extends State<CamarillaCalculatorPage> {
  final TextEditingController _highController = TextEditingController();
  final TextEditingController _lowController = TextEditingController();
  final TextEditingController _closeController = TextEditingController();

  Map<String, double>? _camarillaLevels;

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
      setState(() {
        _camarillaLevels = null;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Please enter valid high, low, and close values.')),
      );
    }
  }

  Map<String, double> _generateCamarillaLevels(
      double high, double low, double close, double range) {
    //const double k = 0.55;
    //const double m = 0.475;

    return {
      'H10': close + (1.7798 * range),
      'H9': close + (1.65 * range),//1.1*1.5
      'H8': close + (1.5202 * range),
      'H7': close + (1.3596 * range),
      'H6': (high/low)*close,//c
      'H5': ((high/low)*close + close + (0.55 * range))/2,
      'H4': close + (0.55 * range),//1.1/2
      'H3': close + (0.275 * range),//1.1/4
      'H2': close + (0.18333333 * range),//1.1/6
      'H1': close + (0.09166666 * range),//1.1/12
      'L1': close - (0.09166666 * range),
      'L2': close - (0.18333333 * range),
      'L3': close - (0.275 * range),
      'L4': close - (0.55 * range),
      'L5': 2*close - ((high/low)*close + close + (0.55 * range))/2,
      'L6': close - (((high/low)*close)-close),
      'L7': close - (1.3596 * range),
      'L8': close - (1.5202 * range),
      'L9': close - (1.65 * range),
      'L10': close - (1.7798 * range),
    };
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
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _calculateCamarillaLevels,
              child: Text('Calculate Levels'),
            ),
            SizedBox(height: 24),
            if (_camarillaLevels != null)
              Expanded(
                child: ListView(
                  children: _camarillaLevels!.entries.map((entry) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            '${entry.key}',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '${entry.value.toStringAsFixed(2)}',
                            style: TextStyle(color: Colors.grey[700]),
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
