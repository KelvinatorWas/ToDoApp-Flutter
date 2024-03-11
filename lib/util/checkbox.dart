import 'package:flutter/material.dart';

enum CCheckboxShape { box, circle }

class CCheckbox extends StatefulWidget {
  final void Function(bool? v)? onChange;
  final double size;
  final bool value;
  final CCheckboxShape shape;

  final Color? backgroundColor;
  final Color? backgroundActiveColor;

  final double borderWidth;
  final Color borderColor;
  final Color borderActiveColor;
  
  final double iconSize;
  final Color iconColor;
  final IconData icon;

  const CCheckbox({
    super.key,
    required this.onChange,
    this.value = false,
    this.shape = CCheckboxShape.box,
    this.size = 24.0,
    this.borderWidth = 1.0,
    this.iconSize = 18.0,
    this.borderColor = Colors.black,
    this.borderActiveColor = Colors.black,
    this.iconColor = Colors.black,
    this.icon = Icons.check,
    this.backgroundActiveColor,
    this.backgroundColor,
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
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          color: backgroundColor(),
          shape: widget.shape == CCheckboxShape.box
              ? BoxShape.rectangle
              : BoxShape.circle,
          border: Border.all(
              color:
                  checkboxValue ? widget.borderActiveColor : widget.borderColor,
              width: widget.borderWidth),
        ),
        child: Center(
          child: checkboxValue
              ? Icon(widget.icon,
                  size: widget.iconSize, color: widget.iconColor)
              : null,
        ),
      ),
    );
  }
  
  Color? backgroundColor() {
    if (widget.value && widget.backgroundActiveColor != null) return widget.backgroundActiveColor;
    if (widget.backgroundColor != null) return widget.backgroundColor; 

    return null;
  }
}
