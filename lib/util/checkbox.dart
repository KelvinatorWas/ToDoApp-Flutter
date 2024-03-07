import 'package:flutter/material.dart';

class CCheckbox extends StatefulWidget {
  final void Function(bool? v)? onChange;
  final double? size;
  final bool? value;

  const CCheckbox(
    {
      super.key,
      required this.onChange,
      this.size,
      this.value,
    }
  );

  @override
  State<CCheckbox> createState() => CCheckboxState();
}

class CCheckboxState extends State<CCheckbox> {

  bool checkBoxValue = false; 

  @override
  void initState() {
    if (widget.value != null) checkBoxValue = widget.value!;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Checkbox(
      value: widget.value,
      onChanged: widget.onChange,
    );
  }
}
