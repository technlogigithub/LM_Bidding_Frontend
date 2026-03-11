import 'package:flutter/material.dart';
import '../../core/app_color.dart';
import '../../core/app_textstyle.dart';
import './app_textfield.dart';

class CustomSearchDropdown extends StatefulWidget {
  final String label;
  final String hintText;
  final List<String> options;
  final String? value;
  final ValueChanged<String?> onChanged;

  const CustomSearchDropdown({
    super.key,
    required this.label,
    required this.hintText,
    required this.options,
    this.value,
    required this.onChanged,
  });

  @override
  State<CustomSearchDropdown> createState() => _CustomSearchDropdownState();
}

class _CustomSearchDropdownState extends State<CustomSearchDropdown> {
  final LayerLink _layerLink = LayerLink();
  final GlobalKey _textFieldKey = GlobalKey();
  OverlayEntry? _overlayEntry;

  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _displayController = TextEditingController();

  List<String> _filteredOptions = [];
  bool _isOpen = false;

  @override
  void initState() {
    super.initState();
    _filteredOptions = widget.options;
    _displayController.text = widget.value ?? "";
  }

  void _toggleDropdown() {
    if (_isOpen) {
      _closeDropdown();
    } else {
      _openDropdown();
    }
  }

  void _openDropdown() {
    _overlayEntry = _createOverlay();
    Overlay.of(context).insert(_overlayEntry!);

    setState(() {
      _isOpen = true;
      _filteredOptions = widget.options;
    });
  }

  void _closeDropdown() {
    _overlayEntry?.remove();
    _overlayEntry = null;

    setState(() {
      _isOpen = false;
      _searchController.clear();
      _filteredOptions = widget.options;
    });
  }

  OverlayEntry _createOverlay() {
    RenderBox? box = _textFieldKey.currentContext?.findRenderObject() as RenderBox?;
    Size size = box?.size ?? Size.zero;

    return OverlayEntry(
      builder: (context) => Positioned(
        width: size.width,
        child: CompositedTransformFollower(
          link: _layerLink,
          offset: Offset(0, size.height + 1),
          showWhenUnlinked: false,
          child: Material(
            elevation: 4,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              constraints: const BoxConstraints(maxHeight: 320),
              decoration: BoxDecoration(
                gradient:AppColors.appPagecolor ,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(8),
                  bottomRight: Radius.circular(8),
                ),
                // border: Border.all(color: AppColors.kBorderColorTextField),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [

                  /// SEARCH
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: TextField(
                      controller: _searchController,
                      autofocus: true,
                      style: AppTextStyle.description(color: AppColors.appTitleColor),
                      decoration: InputDecoration(
                        hintText: "Search here...",
                        prefixIcon: Icon(Icons.search, size: 20, color: AppColors.appDescriptionColor),
                        contentPadding: const EdgeInsets.symmetric(vertical: 12),
                        border: InputBorder.none,
                        hintStyle: AppTextStyle.description(color: AppColors.appDescriptionColor.withOpacity(0.6)),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _filteredOptions = widget.options
                              .where((e) => e
                              .toLowerCase()
                              .contains(value.toLowerCase()))
                              .toList();
                        });
                        _overlayEntry?.markNeedsBuild();
                      },
                    ),
                  ),
                  Divider(height: 1, color: AppColors.kBorderColorTextField.withOpacity(0.5)),

                  Flexible(
                    child: _filteredOptions.isEmpty
                        ? Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: Center(child: Text("No result", style: AppTextStyle.body(color: Colors.grey))),
                        )
                        : ListView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      itemCount: _filteredOptions.length,
                      itemBuilder: (context, index) {
                        final item = _filteredOptions[index];
                        final selected = item == widget.value;

                        return InkWell(
                          onTap: () {
                            widget.onChanged(item);
                            _displayController.text = item;
                            _closeDropdown();
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              color: selected
                                  ? AppColors.appColor.withOpacity(0.08)
                                  : Colors.transparent,
                              border: Border(
                                left: BorderSide(
                                  color: selected ? AppColors.appColor : Colors.transparent,
                                  width: 3,
                                ),
                              ),
                            ),
                            child: Text(
                              item,
                                style: AppTextStyle.description(
                                  fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
                                  color: AppColors.appTitleColor,
                                ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _overlayEntry?.remove();
    _searchController.dispose();
    _displayController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        /// LABEL
        if (widget.label.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Text(
              widget.label,
              style: AppTextStyle.description(
                fontWeight: FontWeight.w600,
                color: AppColors.appBodyTextColor,
              ),
            ),
          ),

        /// FIELD
        CompositedTransformTarget(
          link: _layerLink,
          key: _textFieldKey,
          child: CustomTextfield(
            label: "",
            hintText: widget.hintText,
            controller: _displayController,
            readOnly: true,
            onTap: _toggleDropdown,
            suffixIcon: Icon(
                _isOpen
                    ? Icons.keyboard_arrow_up
                    : Icons.keyboard_arrow_down,
                color: AppColors.appIconColor
              ),
          ),
        ),
      ],
    );
  }
}