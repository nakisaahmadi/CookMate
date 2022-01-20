import 'package:flutter/material.dart';

/// We followed this tutorial to create the dialog for selecting allergens
/// https://medium.com/@KarthikPonnam/flutter-multi-select-choicechip-244ea016b6fa

class MultiSelectChip extends StatefulWidget {
  
  final List<String> allAllergens;
  final List<String> currentAllergens;
  final Function(List<String>) onSelectionChanged;
  MultiSelectChip(
      this.allAllergens,
      this.currentAllergens,
      {this.onSelectionChanged} 
      );
  @override
  _MultiSelectChipState createState() => _MultiSelectChipState();
}

class _MultiSelectChipState extends State<MultiSelectChip> {

  _buildChoiceList() {
    List<Widget> choices = List();
    widget.allAllergens.forEach((item) {
      choices.add(Container(
        padding: const EdgeInsets.all(2.0),
        child: ChoiceChip(
          label: Text(item),
          selected: widget.currentAllergens.contains(item),
          onSelected: (selected) {
            setState(() {
              if (widget.currentAllergens.contains(item)){
                widget.currentAllergens.remove(item);
              }
              else{
                widget.currentAllergens.add(item);
              }
              widget.onSelectionChanged(widget.currentAllergens);
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
      children: _buildChoiceList(),
    );
  }
}