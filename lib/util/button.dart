import 'package:flutter/material.dart';

class Button extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;

  const Button(
    {
      super.key,
      required this.label,
      this.onPressed,
    }
  );

  @override
  State<Button> createState() => _ButtonState();
}

class _ButtonState extends State<Button> {
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: widget.onPressed,
      color: Theme.of(context).primaryColor,
      child: Text(widget.label),
    );
  }
}
