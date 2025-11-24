import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomDateRangePicker extends StatefulWidget {
  final String title;
  final Function(DateTime?, DateTime?) onDateRangeSelected;
  final DateTime? initialStart;
  final DateTime? initialEnd;

  const CustomDateRangePicker({
    super.key,
    required this.title,
    required this.onDateRangeSelected,
    this.initialStart,
    this.initialEnd,
  });

  @override
  State<CustomDateRangePicker> createState() => _CustomDateRangePickerState();
}

class _CustomDateRangePickerState extends State<CustomDateRangePicker> {
  DateTime? _startDate;
  DateTime? _endDate;

  final DateFormat formatter = DateFormat('dd MMM yyyy');

  @override
  void initState() {
    super.initState();
    _startDate = widget.initialStart;
    _endDate = widget.initialEnd;
  }

  Future<void> _pickDateRange() async {
    DateTimeRange? result = await showDateRangePicker(
      context: context,
      initialDateRange: _startDate != null && _endDate != null
          ? DateTimeRange(start: _startDate!, end: _endDate!)
          : null,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.blue,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (result != null) {
      setState(() {
        _startDate = result.start;
        _endDate = result.end;
      });

      widget.onDateRangeSelected(result.start, result.end);
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _pickDateRange,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade400),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(Icons.calendar_today, size: 20, color: Colors.grey.shade700),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                _startDate == null
                    ? widget.title
                    : "${formatter.format(_startDate!)}  →  ${formatter.format(_endDate!)}",
                style: TextStyle(
                  fontSize: 15,
                  color: _startDate == null ? Colors.grey : Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Icon(Icons.arrow_drop_down, color: Colors.grey.shade700),
          ],
        ),
      ),
    );
  }
}
