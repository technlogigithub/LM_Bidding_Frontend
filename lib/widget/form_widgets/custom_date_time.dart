import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/app_color.dart';

class CustomDateTimePicker extends StatelessWidget {
  final String label;
  final DateTime? value;
  final ValueChanged<DateTime?> onChanged;

  const CustomDateTimePicker({super.key, required this.label, required this.value, required this.onChanged});

  Future<void> _pick(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      initialDate: value ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: AppColors.appColor,
            colorScheme: ColorScheme.light(
              primary: AppColors.appColor,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            dialogTheme: DialogThemeData(backgroundColor: Colors.white),
          ),
          child: child!,
        );
      },
    );
    if (date == null) return;
    // --- Time Picker ---
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(value ?? DateTime.now()),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: AppColors.appColor,
            colorScheme: ColorScheme.light(
              primary: AppColors.appColor,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
            timePickerTheme: TimePickerThemeData(
              dialHandColor: AppColors.appColor,
              hourMinuteColor: MaterialStateColor.resolveWith(
                    (states) => states.contains(MaterialState.selected)
                    ? AppColors.appColor
                    : Colors.grey.shade200,
              ),
              hourMinuteTextColor: MaterialStateColor.resolveWith(
                    (states) => states.contains(MaterialState.selected)
                    ? Colors.white
                    : Colors.black,
              ),
              entryModeIconColor: AppColors.appColor,
            ),
          ),
          child: child!,
        );
      },
    );
    if (time == null) {
      onChanged(date);
      return;
    }
    onChanged(DateTime(date.year, date.month, date.day, time.hour, time.minute));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: AppColors.appTextColor)),
        const SizedBox(height: 6),
        InkWell(
          onTap: () => _pick(context),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.appTextColor.withValues(alpha: 0.3)),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              value != null ? value.toString() : 'Select date & time',
              style: TextStyle(color: AppColors.appTextColor.withValues(alpha: 0.7)),
            ),
          ),
        ),
      ],
    );
  }
}

// class CustomDateRangePicker extends StatelessWidget {
//   final String label;
//   final DateTimeRange? value;
//   final ValueChanged<DateTimeRange?> onChanged;
//
//   const CustomDateRangePicker({super.key, required this.label, required this.value, required this.onChanged});
//
//   Future<void> _pickRange(BuildContext context) async {
//     final range = await showDateRangePicker(
//       context: context,
//       firstDate: DateTime(1900),
//       lastDate: DateTime(2100),
//       initialDateRange: value,
//     );
//     onChanged(range);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(label, style: TextStyle(color: AppColors.appTextColor)),
//         const SizedBox(height: 6),
//         InkWell(
//           onTap: () => _pickRange(context),
//           child: Container(
//             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
//             decoration: BoxDecoration(
//               // border: Border.all(color: Colors.black.withValues(alpha: 0.3)),
//               border: Border.all(color: AppColors.appTextColor.withValues(alpha: 0.3)),
//               borderRadius: BorderRadius.circular(4),
//             ),
//             child: Text(
//               value != null ? "${value!.start.toString()} - ${value!.end.toString()}" : 'Select date range',
//               style: TextStyle(color: AppColors.appTextColor.withValues(alpha: 0.7)),
//               // style: TextStyle(color: Colors.black.withValues(alpha: 0.7)),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
class CustomDateRangePicker extends StatelessWidget {
  final String label;
  final DateTimeRange? value;
  final ValueChanged<DateTimeRange?> onChanged;

  CustomDateRangePicker({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final dateFormat = DateFormat('dd/MM/yyyy');

  Future<void> _pickRange(BuildContext context) async {
    final range = await showDateRangePicker(
      context: context,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      initialDateRange: value,

      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: AppColors.appColor,
            colorScheme: ColorScheme.light(
              primary: AppColors.appColor,
              onPrimary: Colors.white,
              onSurface: Colors.black,

            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );
    onChanged(range);
  }

  @override
  Widget build(BuildContext context) {
    String displayText = "Select date range";

    if (value != null) {
      final start = dateFormat.format(value!.start);
      final end = dateFormat.format(value!.end);
      displayText = "$start → $end";
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 6),

        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black.withOpacity(0.3)),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              /// Selected date or placeholder
              Text(
                displayText,
                style: TextStyle(
                  color: Colors.black.withOpacity(0.7),
                  fontSize: 14,
                ),
              ),

              /// Calendar Icon
              InkWell(
                  onTap: () => _pickRange(context),
                  child: const Icon(Icons.calendar_month_outlined, color: Colors.black54)),
            ],
          ),
        )
      ],
    );
  }
}


class CustomDatePicker extends StatelessWidget {
  final String label;
  final DateTime? value;
  final ValueChanged<DateTime?> onChanged;

  const CustomDatePicker({super.key, required this.label, required this.value, required this.onChanged});

  Future<void> _pickDate(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      initialDate: value ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    onChanged(date);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: AppColors.appTextColor)),
        const SizedBox(height: 6),
        InkWell(
          onTap: () => _pickDate(context),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.appTextColor.withValues(alpha: 0.3)),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              value != null ? value!.toString().split(' ').first : 'Select date',
              style: TextStyle(color: AppColors.appTextColor.withValues(alpha: 0.7)),
            ),
          ),
        ),
      ],
    );
  }
}


