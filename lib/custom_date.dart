import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateButtonComponent extends StatefulWidget {
  const DateButtonComponent({super.key});

  @override
  _DateButtonComponentState createState() => _DateButtonComponentState();
}

class _DateButtonComponentState extends State<DateButtonComponent> {
  DateTime _selectedDate1 = DateTime.now();
  DateTime _selectedDate2 = DateTime.now();
  bool _isOut = true;
  bool _isS50 = true;

  String _formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  void _changeDate(int days, int dateIndex) {
    setState(() {
      if (dateIndex == 1) {
        _selectedDate1 = _selectedDate1.add(Duration(days: days));
      } else {
        _selectedDate2 = _selectedDate2.add(Duration(days: days));
      }
    });
  }

  void _toggleOutIn() {
    setState(() {
      _isOut = !_isOut;
    });
  }

  String _generateButtonText(bool isS50) {
    final month = _selectedDate1.month;
    final yearLastTwoDigits = _selectedDate1.year.toString().substring(2);

    String suffix = '';
    if (month >= 1 && month <= 3) {
      suffix = 'H';
    } else if (month >= 4 && month <= 6) {
      suffix = 'M';
    } else if (month >= 7 && month <= 9) {
      suffix = 'U';
    } else {
      suffix = 'Z';
    }

    return isS50
        ? 'S50$suffix$yearLastTwoDigits'
        : 'GO$suffix$yearLastTwoDigits';
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (!_isS50)
          _buildDateComponent(
            date: _selectedDate2,
            onAdd: () => _changeDate(1, 2),
            onSubtract: () => _changeDate(-1, 2),
          ),
        if (!_isS50)
          Text(
            'to',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
        _buildDateComponent(
          date: _selectedDate1,
          onAdd: () => _changeDate(1, 1),
          onSubtract: () => _changeDate(-1, 1),
        ),
        Spacer(), // Pushes everything after this to the right
        Row(
          mainAxisSize: MainAxisSize.min, // Groups the buttons together
          children: [
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _isS50 = !_isS50;
                });
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                backgroundColor:
                    _isS50 ? Colors.red : Colors.amber, // Background color
                foregroundColor: Colors.white, // Text color
              ),
              child: Text(
                _generateButtonText(_isS50),
                style: TextStyle(fontSize: 14),
              ),
            ),
            SizedBox(width: 3),
            ElevatedButton(
              onPressed: _toggleOutIn,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                backgroundColor:
                    _isOut ? Colors.red : Colors.green, // Background color
                foregroundColor: Colors.white, // Text color
              ),
              child: Text(
                _isOut ? 'OUT' : 'IN',
                style: TextStyle(fontSize: 14),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDateComponent({
    required DateTime date,
    required VoidCallback onAdd,
    required VoidCallback onSubtract,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(Icons.remove_circle, size: 20, color: Colors.red),
          onPressed: onSubtract,
        ),
        Text(
          _formatDate(date),
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        IconButton(
          icon: Icon(Icons.add_circle, size: 20, color: Colors.green),
          onPressed: onAdd,
        ),
      ],
    );
  }
}
