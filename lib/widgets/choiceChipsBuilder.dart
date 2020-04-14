import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zouqadmin/theme/common.dart';

class ChoiceChipsBuilder extends StatefulWidget {
  final List<String> chipNames;
  ChoiceChipsBuilder({this.chipNames});

  @override
  _ChoiceChipsBuilderState createState() => _ChoiceChipsBuilderState();
}

class _ChoiceChipsBuilderState extends State<ChoiceChipsBuilder> {
  String selectedChoice = '';
  _BuildChoiceList() {
    List<Widget> choices = List<Widget>();

    widget.chipNames.forEach((choiceName) {
      choices.add(Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
        child: ChoiceChip(
          label: Text(choiceName),
          labelStyle: TextStyle(
            color:
                selectedChoice == choiceName ? Colors.white : Color(0xFF737373),
          ),
          backgroundColor: Colors.white,
          selectedColor: accent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(7),
            ),
            side: BorderSide(
              color: selectedChoice == choiceName ? accent : Color(0xFF737373),
            ),
          ),
          selected: selectedChoice == choiceName,
          onSelected: (selected) {
            setState(() {
              selectedChoice = choiceName;
            });
          },
        ),
      ));
    });
    return choices;
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 5,
      runSpacing: 5,
      children: _BuildChoiceList(),
    );
  }
}
