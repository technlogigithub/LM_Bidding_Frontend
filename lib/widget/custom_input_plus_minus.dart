import 'package:flutter/material.dart';
import '../core/app_color.dart';
import '../core/app_textstyle.dart';
import '../models/App_moduls/AppResponseModel.dart';

class CustomInputPlusMinus extends StatefulWidget {
  final String label;
  final String name;
  final dynamic value;
  final List<dynamic> validations;
  final ValueChanged<String> onChanged;
  final bool required;

  const CustomInputPlusMinus({
    super.key,
    required this.label,
    required this.name,
    this.value,
    required this.validations,
    required this.onChanged,
    this.required = false,
  });

  @override
  State<CustomInputPlusMinus> createState() => _CustomInputPlusMinusState();
}

class _CustomInputPlusMinusState extends State<CustomInputPlusMinus> {
  late double _currentValue;

  // Configuration derived from validations
  double _min = 0;
  double _max = double.infinity;
  double _point = 1;
  int _decimalPlaces = 0;
  String _dataType = 'int';
  String? _iconType; // 'plus', 'minus', or 'both'/'null'

  @override
  void initState() {
    super.initState();
    _parseConfiguration();
    _initializeValue();
  }

  void _parseConfiguration() {
    // Defaults
    _min = 0;
    _max = double.infinity;
    _point = 1;
    _decimalPlaces = 0;
    _dataType = 'int';
    _iconType = null;

    for (var validation in widget.validations) {
      String? type;
      dynamic value;

      if (validation is InputValidation) {
        type = validation.type;
        // Check meta first
        if (validation.meta != null && validation.meta!.containsKey('value')) {
          value = validation.meta!['value'];
        } else {
          value = validation.value ?? validation.stringValue;
        }
      } else if (validation is Map) {
        type = validation['type'];
        final meta = validation['meta'];
        if (meta is Map) {
          value = meta['value'];
        } else {
          value = validation['value'];
        }
      }

      if (type != null && value != null) {
        switch (type) {
          case 'min':
            _min = double.tryParse(value.toString()) ?? 0;
            break;
          case 'max':
            _max = double.tryParse(value.toString()) ?? double.infinity;
            break;
          case 'point':
            _point = double.tryParse(value.toString()) ?? 1;
            break;
          case 'decimal_places':
            _decimalPlaces = int.tryParse(value.toString()) ?? 0;
            break;
          case 'data_type':
            _dataType = value.toString();
            break;
          case 'icon':
            _iconType = value.toString().toLowerCase();
            break;
        }
      }
    }
  }

  void _initializeValue() {
    if (widget.value != null && widget.value.toString().isNotEmpty) {
      _currentValue = double.tryParse(widget.value.toString()) ?? _min;
    } else {
      _currentValue = _min;
    }

    // Ensure initial value respects constraints
    if (_currentValue < _min) _currentValue = _min;
    if (_max != double.infinity && _currentValue > _max) _currentValue = _max;
  }

  void _handleIncrease() {
    setState(() {
      double newValue = _currentValue + _point;
      if (_max != double.infinity && newValue > _max) {
        newValue = _max;
      }
      _currentValue = newValue;
    });
    _notifyChange();
  }

  void _handleDecrease() {
    setState(() {
      double newValue = _currentValue - _point;
      if (newValue < _min) {
        newValue = _min;
      }
      _currentValue = newValue;
    });
    _notifyChange();
  }

  void _notifyChange() {
    String formattedValue;
    if (_dataType == 'int' || _decimalPlaces == 0) {
      formattedValue = _currentValue.toInt().toString();
    } else {
      formattedValue = _currentValue.toStringAsFixed(_decimalPlaces);
    }
    widget.onChanged(formattedValue);
  }

  @override
  Widget build(BuildContext context) {
    String displayValue;
    if (_dataType == 'int' || _decimalPlaces == 0) {
      displayValue = _currentValue.toInt().toString();
    } else {
      displayValue = _currentValue.toStringAsFixed(_decimalPlaces);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label.isNotEmpty) ...[
          Text(
             " ${widget.label}",
            // widget.label + (widget.required ? " *" : ""),
            style: AppTextStyle.description(
              color: AppColors.appDescriptionColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
        ],
        Container(
          height: 55,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: AppColors.appPagecolor,
            // boxShadow: [
            //   BoxShadow(
            //     color: AppColors.appMutedColor.withOpacity(0.1),
            //     blurRadius: 5,
            //     spreadRadius: 1,
            //     offset: const Offset(0, 10),
            //   ),
            // ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
               _buildButton(Icons.remove, _currentValue > _min ? _handleDecrease : null),
               const SizedBox(width: 12),
               Expanded(
                child: Center(
                  child: Text(
                    displayValue,
                    style: AppTextStyle.title(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(width: 12),
               _buildButton(Icons.add, (_max == double.infinity || _currentValue < _max) ? _handleIncrease : null),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildButton(IconData icon, VoidCallback? onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          gradient: AppColors.appPagecolor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 26, color: onTap != null ? AppColors.appIconColor : AppColors.appMutedColor),
      ),
    );
  }
}

