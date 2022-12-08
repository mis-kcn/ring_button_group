library ring_button_group;

import 'package:flutter/material.dart';
import 'dart:math' as math;

class RingButtonGroup extends StatefulWidget {
  //how many buttons on ring
  final int buttonNumber;

  //list button index (start from 0) pressed at beginning, notice, when type is SINGLE_SELECTABLE, set size must less 2
  final Set<int> pressedIndex;

  //function when button pressing, args: index - index of pressing button, selected: all buttons now selected (only available when MULTIPLE_SELECTABLE)
  final OnPressedFunction? onPressed;

  //entire group disabled
  final bool disabled;

  //type of behavior - see: RingButtonGroupType
  final RingButtonGroupType type;

  //ring button size |<-size->|----o----|------|(bulleye)
  final double buttonSize;

  //main color of button
  final Color toneColor;

  //pressing color
  final Color tintColor;

  //pressed color
  final Color activeColor;

  //disabled border color, when color same with borderColor, auto transform to grayscale
  final Color disableBorderColor;

  //disabled main color, when color same with toneColor, auto transform to grayscale
  final Color disableColor;

  //border color of buttons
  final Color borderColor;

  //icons on button, size must be same with buttonNumber
  final List<Icon>? icons;

  //labels on button, size must be same with buttonNumber
  final List<Text>? labels;

  //child widget of ring button group
  final Widget? child;

  //allow shadow effects when button pressed
  final bool shadowEffect;

  //the width of line split the button, note that this is not the border of circle
  final double splitStrokeSize;

  const RingButtonGroup({
    super.key,
    required this.buttonNumber,
    this.pressedIndex = const {},
    this.onPressed,
    this.buttonSize = 40,
    this.disabled = false,
    this.type = RingButtonGroupType.SINGLE_SELECTABLE,
    this.toneColor = Colors.blueAccent,
    this.tintColor = Colors.blueGrey,
    this.activeColor = Colors.lightBlueAccent,
    this.disableBorderColor = Colors.lightBlueAccent,
    this.disableColor = Colors.blueAccent,
    this.borderColor = Colors.lightBlueAccent,
    this.icons,
    this.labels,
    this.child,
    this.shadowEffect = false,
    this.splitStrokeSize = 0.5
  })  : assert(buttonNumber > 1),
        assert(labels != null ? labels.length == buttonNumber : true),
        assert(icons != null ? icons.length == buttonNumber : true),
        assert(type == RingButtonGroupType.SINGLE_SELECTABLE ? pressedIndex.length < 2 : true);

  @override
  State<StatefulWidget> createState() => RingButtonGroupState();
}

class RingButtonGroupState extends State<RingButtonGroup> {
  late ButtonStatus status;

  @override
  void initState() {
    super.initState();
    status = ButtonStatus(widget.pressedIndex, false);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      var widgets = <Widget>[];
      widgets.addAll([for (var i = 0; i < widget.buttonNumber; i++) i].map((index) => GestureDetector(
            onTapCancel: () {
              if (!widget.disabled) {
                setState(() {
                  status._pressedDown = null;
                });
              }
            },
            onTapUp: (detial) {
              if (!widget.disabled) {
                setState(() {
                  switch (widget.type) {
                    case RingButtonGroupType.SINGLE_SELECTABLE:
                      status.pressed.clear();
                      status.pressed.add(index);
                      break;
                    case RingButtonGroupType.MULTIPLE_SELECTABLE:
                      !status.pressed.remove(index) ? status.pressed.add(index) : null;
                      break;
                    default:
                  }

                  widget.onPressed!(index, widget.type == RingButtonGroupType.MULTIPLE_SELECTABLE ? status._pressed : null);

                  status._pressedDown = null;
                });
              }
            },
            onTapDown: (detial) {
              setState(() {
                status._pressedDown = index;
              });
            },
            child: FractionallySizedBox(
                widthFactor: 1,
                heightFactor: 1,
                child: Stack(
                  children: [
                    FractionallySizedBox(
                      widthFactor: 1,
                      heightFactor: 1,
                      child: CustomPaint(
                          painter: RingButtonPainter(
                              toneColor: widget.toneColor,
                              tintColor: widget.tintColor,
                              activeColor: widget.activeColor,
                              disableColor: widget.disableColor,
                              disableBorderColor: widget.disableBorderColor,
                              borderColor: widget.borderColor,
                              buttonNumber: widget.buttonNumber,
                              buttonSize: widget.buttonSize,
                              buttonIndex: index,
                              pressed: status.pressed.contains(index),
                              disabled: widget.disabled,
                              shadowEffect: widget.shadowEffect,
                              splitStrokeSize: widget.splitStrokeSize,
                              pressDown: status._pressedDown == index)),
                    ),
                    RingButtonIcon(
                      index: index,
                      buttonSize: widget.buttonSize,
                      size: constraints.minWidth,
                      total: widget.buttonNumber,
                      child: FractionalTranslation(
                          translation: const Offset(-0.5, -0.5),
                          child: widget.icons != null
                              ? widget.icons![index]
                              : widget.labels != null
                                  ? widget.labels![index]
                                  : null),
                    ),
                  ],
                )),
          )));
      widgets.add(IgnorePointer(
        ignoring: true,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(MediaQuery.of(context).size.height),
              border: Border.all(
                color: widget.disabled ? (widget.disableBorderColor == widget.borderColor ? getGreyScale(widget.borderColor) : widget.disableBorderColor) : widget.borderColor,
                width: 0.5,
                style: BorderStyle.solid,
              )),
          child: Padding(
            padding: EdgeInsets.all(widget.buttonSize - 1),
            child: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(MediaQuery.of(context).size.height),
                  border: Border.all(
                    color: widget.disabled ? (widget.disableBorderColor == widget.borderColor ? getGreyScale(widget.borderColor) : widget.disableBorderColor) : widget.borderColor,
                    width: 0.5,
                    style: BorderStyle.solid,
                  )),
            ),
          ),
        ),
      ));

      widget.child != null ? widgets.add(widget.child!) : null;
      return Stack(children: widgets);
    });
  }
}

class RingButtonIcon extends Positioned {
  final int index;
  final int total;

  final double size;
  final double buttonSize;
  //double right;

  RingButtonIcon({super.key, required this.index, required this.total, required this.buttonSize, required this.size, required super.child})
      : super(
          left: calcLeft(total, index, buttonSize, size),
          top: calcTop(total, index, buttonSize, size),
        );

  static double calcLeft(int total, int index, double buttonSize, double size) {
    double angle01 = 360 / total * index + 360 / total / 2;
    return math.sin(math.pi * angle01 / 180) * (size / 2 - buttonSize / 2) + size / 2;
  }

  static double calcTop(int total, int index, double buttonSize, double size) {
    double angle01 = 360 / total * index + 360 / total / 2;
    return size / 2 - math.cos(math.pi * (360 - angle01) / 180) * (size / 2 - buttonSize / 2);
  }
}

class RingButtonPainter extends CustomPainter {
  final Color toneColor;
  final Color tintColor;
  final Color activeColor;
  final Color disableBorderColor;
  final Color disableColor;
  final Color borderColor;
  final int buttonNumber;
  final int buttonIndex;
  final double buttonSize;
  final double splitStrokeSize;
  final bool pressed;
  final bool pressDown;
  final bool disabled;
  final bool shadowEffect;

  Path path = Path();

  RingButtonPainter(
      {required this.toneColor,
      required this.buttonNumber,
      required this.buttonSize,
      required this.borderColor,
      required this.buttonIndex,
      required this.pressed,
      required this.pressDown,
      required this.tintColor,
      required this.activeColor,
      required this.disableBorderColor,
      required this.disableColor,
      required this.disabled,
      required this.splitStrokeSize,
      required this.shadowEffect});

  @override
  void paint(Canvas canvas, Size size) {
    var paintStroke = Paint()
      ..color = disabled
          ? disableBorderColor == borderColor
              ? getGreyScale(borderColor)
              : disableBorderColor
          : borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = splitStrokeSize;
    var paintFill = Paint()
      ..color = disabled
          ? disableColor == toneColor
              ? getGreyScale(toneColor)
              : disableColor
          : pressDown && !pressed
              ? tintColor
              : (pressed
                  ? shadowEffect
                      ? toneColor
                      : activeColor
                  : toneColor)
      ..style = PaintingStyle.fill
      ..strokeWidth = 0.0;
    // paintFill.maskFilter = pressDown ? MaskFilter.blur(BlurStyle.normal, convertRadiusToSigma(5)) : paintFill.maskFilter;
    var shadowPaint = shadowEffect
        ? (Paint()
          ..color = activeColor.withAlpha(245)
          ..maskFilter = MaskFilter.blur(BlurStyle.inner, convertRadiusToSigma(buttonSize / 5)))
        : null;

    double innerRadius = size.width / 2 - buttonSize;
    double outterRadius = size.width / 2;

    _drawButton(canvas, paintStroke, paintFill, !disabled && pressed ? shadowPaint : null, path, innerRadius, outterRadius,
        _calcOffsets(buttonIndex, innerRadius, outterRadius, size.width / 2));
  }

  static double convertRadiusToSigma(double radius) {
    return radius * 0.57735 + 0.1;
  }

  List<Offset> _calcOffsets(int index, double innerRadius, double outterRadius, double base) {
    double angle01 = 360 / buttonNumber * index;
    // print(angle01);
    double p0x = math.sin(math.pi * angle01 / 180) * innerRadius + base;
    double p0y = base - math.cos(math.pi * (360 - angle01) / 180) * innerRadius;

    double p1x = math.sin(math.pi * angle01 / 180) * outterRadius + base;
    double p1y = base - math.cos(math.pi * (360 - angle01) / 180) * outterRadius;

    double angle23 = 360 / buttonNumber * (index + 1);
    double p3x = math.sin(math.pi * angle23 / 180) * innerRadius + base;
    double p3y = base - math.cos(math.pi * (360 - angle23) / 180) * innerRadius;

    double p2x = math.sin(math.pi * angle23 / 180) * outterRadius + base;
    double p2y = base - math.cos(math.pi * (360 - angle23) / 180) * outterRadius;

    return [Offset(p0x, p0y), Offset(p1x, p1y), Offset(p2x, p2y), Offset(p3x, p3y)];
  }

  void _drawButton(Canvas canvas, Paint paintStroke, Paint paintFill, Paint? shadowPaint, Path path, double innerRadius, double outterRadius, List<Offset> offsets) {
    path.moveTo(offsets[0].dx, offsets[0].dy);
    path.lineTo(offsets[1].dx, offsets[1].dy);
    path.arcToPoint(offsets[2], radius: Radius.circular(outterRadius));
    path.lineTo(offsets[3].dx, offsets[3].dy);
    path.arcToPoint(offsets[0], radius: Radius.circular(innerRadius), clockwise: false);
    path.close();

    canvas.drawPath(path, paintFill);
    canvas.drawPath(path, paintStroke);
    shadowPaint != null ? canvas.drawPath(path, shadowPaint) : null;
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

  @override
  bool hitTest(Offset position) {
    return path.contains(position);
  }
}

class ButtonStatus {
  final Set<int> _pressed = <int>{};
  int? _pressedDown;
  bool _disabled = false;

  Set<int> get pressed => _pressed;

  bool get isDisabled => _disabled;

  int? get pressedDown => _pressedDown;

  ButtonStatus(Set<int> pressed, bool disabled) {
    _pressed.addAll(pressed);
    _disabled = disabled;
  }
}

typedef OnPressedFunction = Function(int index, Set<int>? selected);

enum RingButtonGroupType { PRESS_ONLY, SINGLE_SELECTABLE, MULTIPLE_SELECTABLE }

Color getGreyScale(Color orginalColor) {
  int gray = (orginalColor.red * 0.199).toInt() + (orginalColor.green * 0.387).toInt() + (orginalColor.blue * 0.414).toInt();
  return Color.fromARGB(orginalColor.alpha, gray, gray, gray);
}
