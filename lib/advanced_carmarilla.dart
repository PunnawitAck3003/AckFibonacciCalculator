import 'package:flutter/material.dart';
import 'package:flutter_application_fib1/custom_date.dart';

class CamarillaCalculatorPage extends StatefulWidget {
  const CamarillaCalculatorPage({super.key});

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
      'H09': close + (1.65 * range),
      'H08': close + (1.5202 * range),
      'H07': close + (1.3596 * range),
      'H06': (high / low) * close,
      'H05': ((high / low) * close + close + (0.55 * range)) / 2,
      'H04': close + (0.55 * range),
      'H03': close + (0.275 * range),
      'H02': close + (0.18333333 * range),
      'H01': close + (0.09166666 * range),
      'L01': close - (0.09166666 * range),
      'L02': close - (0.18333333 * range),
      'L03': close - (0.275 * range),
      'L04': close - (0.55 * range),
      'L05': 2 * close - ((high / low) * close + close + (0.55 * range)) / 2,
      'L06': close - (((high / low) * close) - close),
      'L07': close - (1.3596 * range),
      'L08': close - (1.5202 * range),
      'L09': close - (1.65 * range),
      'L10': close - (1.7798 * range),
    };
  }

  Widget _buildCamarillaLevels() {

  return LayoutBuilder(
    builder: (context, constraints) {
      final double horizontalPadding = constraints.maxWidth / 3;

      return ListView(
        shrinkWrap: true, // Prevent unnecessary space in ListView
        physics: NeverScrollableScrollPhysics(), // Disable scrolling if embedded
        children: _camarillaLevels.entries.map((entry) {
          final String key = entry.key.trim();
          final double value = entry.value;

          final redKeys = {
            'H01', 'H02', 'H03', 'H04', 'H07', 'H08', 'H09', 'H10'
          };
          final redImportantKeys = {'H05', 'H06'};
          final greenKeys = {
            'L01', 'L02', 'L03', 'L04', 'L07', 'L08', 'L09', 'L10'
          };
          final greenImportantKeys = {'L05', 'L06'};

          final bool isRed = redKeys.contains(key);
          final bool isImportantRed = redImportantKeys.contains(key);
          final bool isGreen = greenKeys.contains(key);
          final bool isImportantGreen = greenImportantKeys.contains(key);

          final Color textColor = isImportantGreen
              ? Colors.green[900]!
              : isImportantRed
                  ? Colors.red[900]!
                  : isGreen
                      ? Colors.green
                      : Colors.red;

          return Padding(
            padding: EdgeInsets.symmetric(
              vertical: 0.5,
              horizontal: horizontalPadding,   // Reduce vertical padding for tighter spacing
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min, // Prevent Row from expanding
              mainAxisAlignment: MainAxisAlignment.spaceBetween, // Align ends
              children: [
                Text(
                  key,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: textColor,
                    fontSize: 16,
                  ),
                ),
                SizedBox(width: 8),
                Text(
                  value.toStringAsFixed(2),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: textColor,
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
        title: FittedBox(
          fit: BoxFit.scaleDown,
          child: const Text('Advanced Camarilla Calculator'),
        ),
        centerTitle: true,
        backgroundColor: Colors.tealAccent,
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
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _calculateCamarillaLevels,
                  child: Text('Cal.'),
                ),
              ],
            ),
            //SizedBox(height: 8),

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
