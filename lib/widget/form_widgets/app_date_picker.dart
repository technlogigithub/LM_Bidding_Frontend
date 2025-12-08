import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomDatePickerForm extends StatefulWidget {
  final String label;
  final DateTime? initialDate;
  final Function(DateTime) onDateSelected;

  const CustomDatePickerForm({
    super.key,
    required this.label,
    required this.onDateSelected,
    this.initialDate,
  });

  @override
  State<CustomDatePickerForm> createState() => _CustomDatePickerFormState();
}

class _CustomDatePickerFormState extends State<CustomDatePickerForm> {
  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    selectedDate = widget.initialDate;
  }

  Future<void> pickDate() async {
    DateTime now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? now,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.blue,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() => selectedDate = picked);
      widget.onDateSelected(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: pickDate,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade400),
        ),
        child: Row(
          children: [
            Icon(Icons.calendar_month, color: Colors.grey.shade700),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                selectedDate == null
                    ? widget.label
                    : DateFormat('dd-MM-yyyy').format(selectedDate!),
                style: TextStyle(
                  color: selectedDate == null
                      ? Colors.grey
                      : Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
