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
  DateTime _selectedDate3 = DateTime.now();
  bool _isOut = true;
  bool _isS50 = true;

  String _formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  void _changeDate(int days, int dateIndex) {
    setState(() {
      if (dateIndex == 1) {
        _selectedDate1 = _selectedDate1.add(Duration(days: days));
      } else if (dateIndex == 2){
        _selectedDate2 = _selectedDate2.add(Duration(days: days));
      } else {
        _selectedDate3 = _selectedDate3.add(Duration(days: days));
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
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 1.0),
      child: Wrap(
        spacing: 4.0, // Space between items
        runSpacing: 0.5, // Space between lines for wrapping
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Row(
            children: [
              _buildDateComponent(
                date: _selectedDate1,
                onAdd: () => _changeDate(1, 1),
                onSubtract: () => _changeDate(-1, 1),
              ),
            ],
          ),
          if (!_isS50)
            _buildDateComponent(
              date: _selectedDate2,
              onAdd: () => _changeDate(1, 2),
              onSubtract: () => _changeDate(-1, 2),
            ),
          if (!_isS50)
            Text(
              'to',
              style: TextStyle(
                fontSize: isSmallScreen ? 14 : 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          _buildDateComponent(
            date: _selectedDate3,
            onAdd: () => _changeDate(1, 3),
            onSubtract: () => _changeDate(-1, 3),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _isS50 = !_isS50;
                  });
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                      vertical: isSmallScreen ? 8 : 12,
                      horizontal: isSmallScreen ? 12 : 16),
                  backgroundColor: _isS50 ? Colors.red : Colors.amber,
                  foregroundColor: Colors.white,
                ),
                child: Text(
                  _generateButtonText(_isS50),
                  style: TextStyle(fontSize: isSmallScreen ? 14 : 14),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: _toggleOutIn,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                      vertical: isSmallScreen ? 8 : 12,
                      horizontal: isSmallScreen ? 12 : 16),
                  backgroundColor: _isOut ? Colors.red : Colors.green,
                  foregroundColor: Colors.white,
                ),
                child: Text(
                  _isOut ? 'OUT' : 'IN',
                  style: TextStyle(fontSize: isSmallScreen ? 14 : 14),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDateComponent({
    required DateTime date,
    required VoidCallback onAdd,
    required VoidCallback onSubtract,
  }) {
    final isSmallScreen =
        MediaQuery.of(context).size.width < 600; // Check screen size
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(
            Icons.remove_circle,
            size: isSmallScreen ? 16 : 20,
            color: Colors.red,
          ),
          onPressed: onSubtract,
        ),
        Text(
          _formatDate(date),
          style: TextStyle(
              fontSize: isSmallScreen ? 14 : 14, fontWeight: FontWeight.bold),
        ),
        IconButton(
          icon: Icon(
            Icons.add_circle,
            size: isSmallScreen ? 16 : 20,
            color: Colors.green,
          ),
          onPressed: onAdd,
        ),
      ],
    );
  }
}
