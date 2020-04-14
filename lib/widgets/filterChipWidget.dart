import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zouqadmin/theme/common.dart';

typedef void OnSelectCallback(bool isClick);

class FilterChipWidget extends StatefulWidget {
  final String chipName;
  final bool isSelected;
  final OnSelectCallback onSelect;
  FilterChipWidget({this.chipName, this.isSelected, this.onSelect});

  @override
  _FilterChipWidgetState createState() => _FilterChipWidgetState();
}

class _FilterChipWidgetState extends State<FilterChipWidget> {
  @override
  Widget build(BuildContext context) {
    return FilterChip(
        checkmarkColor: Colors.white,
        label: Text(widget.chipName),
        labelStyle: TextStyle(
          color: widget.isSelected ? Colors.white : Color(0xFF737373),
        ),
        backgroundColor: Colors.white,
        selectedColor: accent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(7),
          ),
          side: BorderSide(
            color: widget.isSelected ? accent : Color(0xFF737373),
          ),
        ),
        selected: widget.isSelected,
        onSelected: widget.onSelect);
  }
}
