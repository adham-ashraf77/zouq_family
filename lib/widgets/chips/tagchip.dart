import 'package:flutter/material.dart';
import 'package:zouqadmin/theme/common.dart';


/// chip widget used for displaying search tag
/// it take one paramter [tagName] and
/// * use as a chip label

typedef void OnSelectCallback(bool isClick);

class TagChip extends StatefulWidget {
  final String tagName;
  final bool isSelected;
  final OnSelectCallback onSelect;
  TagChip({this.tagName = "", this.onSelect, this.isSelected = false});
  @override
  _TagChipState createState() => _TagChipState();
}

class _TagChipState extends State<TagChip> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Transform(
        transform: new Matrix4.identity()..scale(1.20),
        child: FilterChip(
          checkmarkColor:Colors.white,
          backgroundColor: Colors.white,
          selectedColor: accent,
          selected: widget.isSelected,
          label: Text(
            "  ${widget.tagName}  ",
            textAlign: TextAlign.center,
            style:
                TextStyle(color: widget.isSelected ? mainColor : Colors.black),
          ),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(7)),
              side: BorderSide(
                  color: widget.isSelected ? accent : inputBackgrounds)),
          onSelected: widget.onSelect,
        ),
      ),
    );
  }
}
