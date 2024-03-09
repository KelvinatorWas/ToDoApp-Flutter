import 'package:flutter/material.dart';

enum CCheckboxShape { box, circle }

class CCheckbox extends StatefulWidget {
  final void Function(bool? v)? onChange;
  final double width;
  final double height;
  final bool value;
  final CCheckboxShape? shape;
  final double borderWidth;
  final double iconSize;

  final Color borderColor;
  final Color borderActiveColor;
  final Color iconColor;

  const CCheckbox({
    super.key,
    required this.onChange,
    this.value = false,
    this.shape = CCheckboxShape.box,
    this.width = 24.0,
    this.height = 24.0,
    this.borderWidth = 1.0,
    this.iconSize = 18.0,
    this.borderColor = Colors.black,
    this.borderActiveColor = Colors.black,
    this.iconColor = Colors.black,
  });

  @override
  State<CCheckbox> createState() => CCheckboxState();
}

class CCheckboxState extends State<CCheckbox> {

  bool checkboxValue = false;

  @override
  void initState() {
    checkboxValue = widget.value;
    super.initState();
  }
  
    void onChange(bool? v) {
    checkboxValue = !checkboxValue; 
    widget.onChange!(v);
  }
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onChange(!checkboxValue);
      },
      child: Container(
        width: widget.width,
        height: widget.width,
        decoration: BoxDecoration(
          shape: widget.shape == CCheckboxShape.box ? BoxShape.rectangle : BoxShape.circle,
          border: Border.all(color: checkboxValue ? widget.borderActiveColor : widget.borderColor, width: widget.borderWidth),
        ),
        child: Center(
          child: checkboxValue ? Icon(Icons.check, size: widget.iconSize, color: widget.iconColor) : null,
        ),
      ),
    );
  }
}
