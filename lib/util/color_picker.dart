import 'package:flutter/material.dart';

class SliderPainter extends CustomPainter {
  final double position;
  final Color color;

  SliderPainter(this.position, {this.color = const Color.fromRGBO(33, 33, 33, 1)});

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawCircle(
      Offset(position, size.height / 2),
      10,
      Paint()..color = color
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class ColorPicker extends StatefulWidget {
  final double width;
  final double height;

  final double borderRadius;
  final double borderWidth;
  final Color borderColor;

  final void Function(Color color)? setColor;

  const ColorPicker({
    super.key,
    this.width = 20.0,
    this.height = 15.0,
    this.borderRadius = 0.0,
    this.borderWidth = 2.0,
    this.borderColor = const Color.fromRGBO(33, 33, 33, 1),
    this.setColor,
  });

  @override
  State<ColorPicker> createState() => _ColorPickerState();
}

class _ColorPickerState extends State<ColorPicker> {
  final List<Color> colors = const [
    Color.fromARGB(255, 255, 0, 0),
    Color.fromARGB(255, 255, 128, 0),
    Color.fromARGB(255, 255, 255, 0),
    Color.fromARGB(255, 128, 255, 0),
    Color.fromARGB(255, 0, 255, 0),
    Color.fromARGB(255, 0, 255, 128),
    Color.fromARGB(255, 0, 255, 255),
    Color.fromARGB(255, 0, 128, 255),
    Color.fromARGB(255, 0, 0, 255),
    Color.fromARGB(255, 127, 0, 255),
    Color.fromARGB(255, 255, 0, 255),
    Color.fromARGB(255, 255, 0, 127),
    Color.fromARGB(255, 128, 128, 128),
    Color.fromARGB(255, 0, 0, 0),
  ];

  double colorSliderPosition = 0;
  Color currentColor = Colors.grey.shade900;

  @override
  void initState() {
    currentColor = calculateSelectedColor(colorSliderPosition);
    super.initState();
  }

  void colorChangeHandler(double position) {
    if (position > widget.width) position = widget.width;
    if (position < 0) position = 0;

    setState(() {
        colorSliderPosition = position;
        currentColor = calculateSelectedColor(colorSliderPosition);
        widget.setColor!(currentColor);
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: gestureDetector(),
        ),
      ],
    );
  }

  GestureDetector gestureDetector() {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onHorizontalDragStart: (details) => colorChangeHandler(details.localPosition.dx),
      onHorizontalDragUpdate: (details) => colorChangeHandler(details.localPosition.dx),
      onTapDown: (details) => colorChangeHandler(details.localPosition.dx),
      child: colorPickerBody(),
    );
  }

  Padding colorPickerBody() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
        width: widget.width,
        height: widget.height,
        decoration: colorPickerBodyDecoration(),
        child: CustomPaint(painter: SliderPainter(colorSliderPosition)),
      ),
    );
  }

  BoxDecoration colorPickerBodyDecoration() {
    return BoxDecoration(
      border: Border.all(
        width: widget.borderWidth,
        color: Colors.grey.shade900
      ),
      borderRadius: BorderRadius.circular(widget.borderRadius),
      gradient: LinearGradient(colors: colors)
    );
  }

  Color calculateSelectedColor(double position) {
    double positionInColorArray = (position / widget.width * (colors.length - 1));
    int index = positionInColorArray.truncate();
    double remainder = positionInColorArray - index;

    if (remainder == 0.0) return colors[index];

    int redValue = colors[index].red == colors[index + 1].red
        ? colors[index].red
        : (colors[index].red + (colors[index + 1].red - colors[index].red) * remainder).round();
    int greenValue = colors[index].green == colors[index + 1].green
        ? colors[index].green
        : (colors[index].green + (colors[index + 1].green - colors[index].green) * remainder).round();
    int blueValue = colors[index].blue == colors[index + 1].blue
        ? colors[index].blue
        : (colors[index].blue + (colors[index + 1].blue - colors[index].blue) * remainder).round();
    
    return Color.fromARGB(255, redValue, greenValue, blueValue);
  }
}
