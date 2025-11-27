import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/app_color.dart';

class CustomDateTimePicker extends StatelessWidget {
  final String label;
  final DateTime? value;
  final ValueChanged<DateTime?> onChanged;

  const CustomDateTimePicker({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  Future<void> _pick(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      initialDate: value ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      builder: (context, child) => themedPicker(context, child!),
    );

    if (date == null) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(value ?? DateTime.now()),
      builder: (context, child) => themedPicker(context, child!),
    );

    if (time == null) {
      onChanged(date);
      return;
    }

    onChanged(DateTime(date.year, date.month, date.day, time.hour, time.minute));
  }

  @override
  Widget build(BuildContext context) {
    Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: AppColors.appBodyTextColor)),
        const SizedBox(height: 6),
        pickerContainerforDateandTime(
          text: value != null
              ? DateFormat("dd/MM/yyyy hh:mm a").format(value!)
              : "Select date & time",
          onTap: () => _pick(context),
          icon:Icon(Icons.calendar_month_outlined),
          iconsecond:Icon(Icons.access_time),
        ),
      ],
    );
  }
}

//
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
            // Date range picker theme for range highlight color
            datePickerTheme: DatePickerThemeData(
              // Range highlight strip color
              rangeSelectionBackgroundColor: AppColors.appColor.withValues(alpha: 0.3),
              rangeSelectionOverlayColor:
                  WidgetStateProperty.all(AppColors.appColor.withOpacity(0.2)),
              // Header (top bar) color
              rangePickerHeaderBackgroundColor: AppColors.appColor,
              // Selected start/end circle
              dayBackgroundColor: MaterialStateColor.resolveWith((states) {
                if (states.contains(MaterialState.selected)) {
                  return AppColors.appColor;
                }
                return Colors.transparent;
              }),
              // Selected day text color
              dayForegroundColor: MaterialStateColor.resolveWith((states) {
                if (states.contains(MaterialState.selected)) {
                  return Colors.white;
                }
                return AppColors.appBodyTextColor;
              }),
              // Today outline
              todayBorder: BorderSide(color: AppColors.appColor),
            ),
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
          style:  TextStyle(
            fontSize: 16,
            color: AppColors.appBodyTextColor,
          ),
        ),
        const SizedBox(height: 6),

        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          decoration: BoxDecoration(
            border: Border.all(color:AppColors.appBodyTextColor),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              /// Selected date or placeholder
              Text(
                displayText,
                style: TextStyle(
                  color: AppColors.appDescriptionColor,
                  fontSize: 14,
                ),
              ),

              /// Calendar Icon
              InkWell(
                  onTap: () => _pickRange(context),
                  child:  Icon(Icons.calendar_month_outlined, color: AppColors.appIconColor)),
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

  const CustomDatePicker({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  Future<void> _pickDate(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      initialDate: value ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      builder: (context, child) => themedPicker(context, child!),
    );

    onChanged(date);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: AppColors.appBodyTextColor)),
        const SizedBox(height: 6),
        pickerContainer(
          text: value != null
              ? DateFormat("dd/MM/yyyy").format(value!)
              : "Select date",
          onTap: () => _pickDate(context),
          icon: Icon(Icons.calendar_month_outlined)
        ),
      ],
    );
  }
}



class CustomDateTimeRangePicker extends StatelessWidget {
  final String label;
  final DateTimeRangeResult? value;
  final ValueChanged<DateTimeRangeResult?> onChanged;

  const CustomDateTimeRangePicker({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  String _format(DateTime date) {
    return DateFormat("dd/MM/yyyy hh:mm a").format(date);
  }

  @override
  Widget build(BuildContext context) {
    String displayText = "Select date & time range";

    if (value != null) {
      displayText = "${_format(value!.start)} → ${_format(value!.end)}";
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: AppColors.appBodyTextColor)),
        const SizedBox(height: 6),

        InkWell(
          onTap: () async {
            final result = await showDateTimeRangePicker(context);
            onChanged(result);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.appBodyTextColor),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    displayText,
                    style: TextStyle(
                      color: AppColors.appDescriptionColor,
                      fontSize: 14,
                    ),
                    maxLines: 2,
                  ),
                ),
                const SizedBox(width: 8),
                Row(
                  children: [
                    Icon(Icons.calendar_month_outlined,
                        size: 20, color: AppColors.appIconColor),
                    const SizedBox(width: 8),
                    Icon(Icons.access_time,
                        size: 20, color: AppColors.appIconColor),
                  ],
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}

class DateTimeRangeResult {
  final DateTime start;
  final DateTime end;

  DateTimeRangeResult({required this.start, required this.end});
}

Future<DateTimeRangeResult?> showDateTimeRangePicker(BuildContext context) async {
  // Pick date range first
  final pickedDateRange = await showDateRangePicker(
    context: context,
    firstDate: DateTime(2000),
    lastDate: DateTime(2100),
  );

  if (pickedDateRange == null) return null;

  // Pick START time
  final startTime = await showTimePicker(
    context: context,
    initialTime: TimeOfDay.now(),
  );

  if (startTime == null) return null;

  // Pick END time
  final endTime = await showTimePicker(
    context: context,
    initialTime: TimeOfDay.now(),
  );

  if (endTime == null) return null;

  // Combine date + time
  final startDateTime = DateTime(
    pickedDateRange.start.year,
    pickedDateRange.start.month,
    pickedDateRange.start.day,
    startTime.hour,
    startTime.minute,
  );

  final endDateTime = DateTime(
    pickedDateRange.end.year,
    pickedDateRange.end.month,
    pickedDateRange.end.day,
    endTime.hour,
    endTime.minute,
  );

  return DateTimeRangeResult(start: startDateTime, end: endDateTime);
}





Widget pickerContainer({
  required String text,
  required VoidCallback onTap,
  required Icon icon,
}) {
  return InkWell(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.appBodyTextColor),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            text,
            style: TextStyle(
              color: AppColors.appDescriptionColor,
              fontSize: 14,
            ),
          ),
          Icon(icon.icon, size: 20, color: AppColors.appBodyTextColor),
        ],
      ),
    ),
  );
}
Widget pickerContainerforDateandTime({
  required String text,
  required VoidCallback onTap,
  required Icon icon,
  required Icon iconsecond,
}) {
  return InkWell(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.appBodyTextColor),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            text,
            style: TextStyle(
              color: AppColors.appDescriptionColor,
              fontSize: 14,
            ),
          ),
          Row(
            children: [
              Icon(icon.icon, size: 20, color: AppColors.appIconColor),
              const SizedBox(width: 8),
              Icon(iconsecond.icon, size: 20, color: AppColors.appIconColor),
            ],
          ),
        ],
      ),
    ),
  );
}



Widget themedPicker(BuildContext context, Widget child) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  return Theme(
    data: ThemeData.light().copyWith(
      primaryColor: AppColors.appColor,
      colorScheme: ColorScheme.light(
        primary: AppColors.appColor,
        onPrimary: AppColors.appBodyTextColor,
        onSurface: AppColors.appBodyTextColor,
      ),
      dialogBackgroundColor: Colors.yellow,

      // ⭐ TIME PICKER THEME ⭐
      timePickerTheme: TimePickerThemeData(
        dialHandColor: AppColors.appColor,

        hourMinuteColor: MaterialStateColor.resolveWith(
              (states) => states.contains(MaterialState.selected)
              ? AppColors.appColor
              : Colors.grey.shade200,
        ),

        hourMinuteTextColor: MaterialStateColor.resolveWith(
              (states) => states.contains(MaterialState.selected)
              ? AppColors.appBodyTextColor
              : AppColors.appBodyTextColor,
        ),

        entryModeIconColor: AppColors.appColor,

        dayPeriodColor: MaterialStateColor.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return AppColors.appColor;
          }
          return AppColors.appColor.withOpacity(0.2);
        }),

        dayPeriodTextColor: MaterialStateColor.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return AppColors.appBodyTextColor;
          }
          return AppColors.appBodyTextColor.withOpacity(0.7);
        }),

        dayPeriodBorderSide: const BorderSide(color: Colors.transparent),
      ),

      // ⭐ DATE RANGE PICKER THEME ⭐
      datePickerTheme: DatePickerThemeData(
        // Range highlight strip
        rangeSelectionBackgroundColor: AppColors.appColor,
        rangeSelectionOverlayColor:
        WidgetStateProperty.all(AppColors.appColor.withOpacity(0.2)),

        // Header (top bar) color
        rangePickerHeaderBackgroundColor: AppColors.appColor,

        // Selected start/end circle
        dayBackgroundColor: MaterialStateColor.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return AppColors.appColor.withValues(alpha: 0.3);
          }
          return Colors.transparent;
        }),

        // Selected day text color
        dayForegroundColor: MaterialStateColor.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return Colors.white;
          }
          return AppColors.appBodyTextColor;
        }),

        // Today outline
        todayBorder: BorderSide(color: AppColors.appColor),
      ),
    ),
    child: child,
  );
}




