import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';




class DataLevel extends StatelessWidget {
  final ValueNotifier<double> newvalue;

  const DataLevel(this.newvalue, {super.key});

  @override
  Widget build(BuildContext context) {
    final maxHeight = MediaQuery.of(context).size.height*0.12;
    final maxWidth =  maxHeight/3;

    final maxContainedMercuryHeight = maxHeight*0.8;
    final maxContainedMercuryWidth = maxWidth*0.95;

    return SizedBox(
      height: maxHeight,
      width: maxWidth,
      child: Center(
        child: Container(
          height: maxContainedMercuryHeight,
          width: maxContainedMercuryWidth,
          decoration: const  BoxDecoration(
            color:  ui.Color.fromARGB(255, 5, 5, 5),
            shape: BoxShape.rectangle,
          ),
          clipBehavior: Clip.antiAlias,
          child: ValueListenableBuilder(
            valueListenable: newvalue,
            builder: (context, newvalue, _) {
              return  AnimatedMercuryPaintWidget(
                newvalue:newvalue,
              );
            },
          ),
        ),
      ),
    );
  }
}

class AnimatedMercuryPaintWidget extends StatefulWidget {
  final double newvalue;

  const AnimatedMercuryPaintWidget({
    super.key,
    required this.newvalue,
  });

  @override
  State<AnimatedMercuryPaintWidget> createState() =>
      _AnimatedMercuryPaintWidgetState();
}

class _AnimatedMercuryPaintWidgetState extends State<AnimatedMercuryPaintWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController =
      AnimationController(vsync: this, duration: const Duration(seconds: 1));
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController);
    _animationController.repeat();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, _) {
        return CustomPaint(
          painter: MercuryPainter(
            animation: _animation.value,
            newvalueReduced: widget.newvalue,
          ),
        );
      },
    );
  }
}

class MercuryPainter extends CustomPainter {
  final double newvalueReduced;
  final double animation;

  MercuryPainter({
    required this.animation,
    required this.newvalueReduced,
  });

  void paintOneWave(
    Canvas canvas,
    Size size, {
    required double newvalueHeight,
    required double cyclicAnimationValue,
    required List<double> colorStops,
    required List<Color> colors,
  }) {
    assert(colorStops.length == colors.length);

    Path path = Path();

    path.moveTo(0, newvalueHeight);

    for (double i = 0.0; i < size.width; i++) {
      path.lineTo(
        i,
        newvalueHeight +
            sin((i / size.width * 2 * pi) + (cyclicAnimationValue * 2 * pi)),
                  );
    }
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    Paint paint = Paint();
    paint.shader = ui.Gradient.linear(
      const Offset(0, 0),
      Offset(0, size.height),
      colors,
      colorStops,
    );

    canvas.drawPath(path, paint);
  }

  @override
  void paint(Canvas canvas, Size size) {
    final newvalueHeight = size.height - newvalueReduced * size.height;
    final paintColorStops = [0.0, 0.2, 0.4, 0.6, 0.8];

    paintOneWave(
      canvas,
      size,
      newvalueHeight: newvalueHeight,
      cyclicAnimationValue: (1 - animation),
      colorStops: paintColorStops,
      colors: [
        Colors.red.shade100,
        Colors.red.shade200,
        Colors.orange.shade200,
        Colors.yellow.shade200,
        Colors.blue.shade100,
      ],
    );
    paintOneWave(
      canvas,
      size,
      newvalueHeight: newvalueHeight,
      cyclicAnimationValue: animation,
      colorStops: paintColorStops,
      colors: [
        
        const ui.Color.fromARGB(255, 255, 0, 0),
        Colors.orange,
        Colors.yellow,
        Colors.green,       
        const ui.Color.fromARGB(255, 0, 68, 255),
        
      
      ],
    );
  }

  @override
  bool shouldRepaint(MercuryPainter oldDelegate) =>
      animation != oldDelegate.animation ||
      newvalueReduced != oldDelegate.newvalueReduced;

  @override
  bool shouldRebuildSemantics(MercuryPainter oldDelegate) => false;
}

