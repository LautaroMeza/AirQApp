
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'data_control.dart';

class DataGrap  extends StatelessWidget{
  final List<ExpansionRegistro>? listRegistros;
const DataGrap({super.key,required this.listRegistros});
      
   
  @override
  Widget build(BuildContext context) {
    return PopScope(
            child: Scrollbar(
                    interactive: true,
                    radius: const Radius.circular(10),
                    //thumbVisibility: true,
                    //trackVisibility: true,
                    thickness: 15,

                    child:SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    reverse: false,
                    primary: true,
                    padding:const EdgeInsets.only(left:1,top: 10,bottom: 5,right: 0),
                    child:SafeArea(
                          child:Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [   
                          _createGraph(0),
                          _createGraph(1),
                          _createGraph(2),
                          _createGraph(3),
                          _createGraph(4),
                          _createGraph(5),
                          _createGraph(6),
                          ]
                        )
                      )
                  )
               )
          );
    
}

Widget _createGraph(int index){ // Cambiar maxvalues.
  String text ="";
  String unidad="";
  double maxvalue= 0;
  switch (index) {
      case 0:
      text = 'Temperatura';
      unidad = '°C';
      maxvalue = 100;
      break;                                        
      case 1:
      text = 'Humedad';
      unidad = '%';
      maxvalue = 120;
      break;                                                                                
      case 2:         
      text = 'Monoxido de Carbono';
      unidad = 'ppm';
      maxvalue = 60;
      break;                                                                       
      case 3: 
      text = 'Dioxido de Carbono';
      unidad = 'ppm';
      maxvalue = 10000;
      break;                                                                    
      case 4:         
      text = 'Particulas PM 10';
      unidad = 'ug/m3';
      maxvalue = 60;
      break;
      case 5:         
      text = 'Particulas PM 2.5';
      unidad = 'ug/m3';
      maxvalue = 150;
      break;                                                                 
    default:         
      text = 'Formaldehido';
      unidad = 'ppm';
      maxvalue = 5;
      break;
  }
  return SfCartesianChart(
      onTooltipRender: ((tooltipArgs) =>tooltipArgs.text= '${tooltipArgs.text} $unidad'),
      zoomPanBehavior: ZoomPanBehavior(enablePinching: true,),
      primaryXAxis: DateTimeAxis(majorGridLines: MajorGridLines(color: Colors.grey[400],width: 0.7,dashArray: const [1,2,3,4]),interval: 5,labelStyle: const TextStyle(color: Colors.white)),
      title: ChartTitle(alignment: ChartAlignment.center,text: text,textStyle: const TextStyle(
                fontFamily: 'Arial',
                fontSize: 15,
                color: Colors.grey,
                fontWeight: FontWeight.w500,)),
      primaryYAxis: NumericAxis(
          majorGridLines: MajorGridLines(color: Colors.grey[400],width: 0.7,dashArray: const [1,2,3,4]),
          labelStyle:const TextStyle(color: Colors.white) ,
          title: AxisTitle(text: unidad,alignment: ChartAlignment.center,textStyle:const TextStyle(color:Colors.white)),
          maximum: maxvalue,
          ),
          
      plotAreaBorderWidth: 0,
      tooltipBehavior: TooltipBehavior(enable: true),
      series:<CartesianSeries>[
        AreaSeries<ExpansionRegistro,DateTime>(
          color: Colors.grey[400],
          enableTooltip: true,
          name: text, 
          opacity: 0.3,
          borderWidth: 2,
          borderColor: Colors.blueGrey[600],
          dataSource: listRegistros!,
          xValueMapper: (ExpansionRegistro item, _)=> item.hour,
          yValueMapper: (ExpansionRegistro item, _){
                            switch (index) {
                                        case 0:
                                        return item.temp;                                        
                                        case 1:
                                        return item.hum;                                                                                
                                        case 2:         
                                        return item.co;                                                                       
                                        case 3: 
                                        return item.co2;                                                                    
                                        case 4:         
                                        return item.pm_10;                                                                  
                                        case 5:
                                        return item.pm_25;
                                        default:
                                        return item.hcho;
                                    }
                                  } ,
          ),
      ]
     );
}
}
