

import 'dart:math';
import 'dart:core';
import 'package:flutter/material.dart';


class CircleProgress extends CustomPainter{
  double value;
  
  double maxvalue;

 
  CircleProgress(this.value,this.maxvalue);
  
  @override
  void paint(Canvas canvas, Size size) {  //Aca realiza pinta el circulo
   

    Paint outerCircle = Paint()
    ..strokeWidth = 20
    ..color =  Colors.black
    .. style = PaintingStyle.stroke;

    Paint valueArc = Paint()
    ..strokeWidth = 20
    ..color = _colordefine()
    .. style = PaintingStyle.stroke
    .. strokeCap = StrokeCap.round;

    Offset center = Offset(size.width/2, size.height/2);
    double radius = min(size.width/2, size.height/2) -14;
    //canvas.drawCircle(center, radius, outerCircle);

    double angle = pi* (value/maxvalue);
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), pi, 0,false,
    outerCircle);
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), pi, angle,false,
    valueArc); 
  }

  @override
  bool shouldRepaint(covariant CircleProgress oldDelegate) {   // Si cambia el valor vuelve a repintar el circulo
    if(oldDelegate.value != value){
      return true;
    }else{
      return false;
    }
   
  }
  Color _colordefine(){
    
    List<Color> colores= [
        Colors.blue.shade600,
        Colors.green,
        Colors.yellow,
        Colors.orange.shade400,
        Colors.red.shade900
    ];
    if(value < maxvalue*0.2){
      return colores.first;
    }else if(value> maxvalue*0.2 && value < maxvalue*0.4){
      return colores[1];
    }else if(value > maxvalue*0.4 && value < maxvalue*0.6){
      return colores[2];
    }else if(value> maxvalue*0.6 && value < maxvalue*0.8){
      return colores[3];
    }else if(value > maxvalue*0.8){
      return colores[4];
    }else{
      return const Color.fromARGB(255, 229, 30, 179);
    }
    
  }


  
}