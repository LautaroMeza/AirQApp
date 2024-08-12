import 'const/constant.dart';
import 'custom_card_widget.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'data_control.dart';

class LineChartCard extends StatelessWidget {
  final List<ExpansionRegistro>? data;
  const LineChartCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
   double xAxis(String cad)=>double.parse(cad.replaceFirst(RegExp(r':'), '.'));
    
    final spotCo = [FlSpot(xAxis(data!.first.hora),data!.first.co)];
    final spotTemp  = [FlSpot(xAxis(data!.first.hora),data!.first.temp)];
    final spotHum  = [FlSpot(xAxis(data!.first.hora),data!.first.hum)]; 
    final spotCo2  = [FlSpot(xAxis(data!.first.hora),data!.first.co2)];
    final spotPm10  = [FlSpot(xAxis(data!.first.hora),data!.first.pm_10)];
    final spotPm25  = [FlSpot(xAxis(data!.first.hora),data!.first.pm_25)];
    final spotHcho  = [FlSpot(xAxis(data!.first.hora),data!.first.hcho)];
    for (ExpansionRegistro e in data!) {
  
      spotCo.add(FlSpot(xAxis(e.hora),e.co));
      spotTemp.add(FlSpot(xAxis(e.hora),e.temp));
      spotHum.add(FlSpot(xAxis(e.hora),e.hum));
      spotCo2.add(FlSpot(xAxis(e.hora),e.co2));
      spotPm10.add(FlSpot(xAxis(e.hora),e.pm_10));
      spotPm25.add(FlSpot(xAxis(e.hora),e.pm_25));
      spotHcho.add(FlSpot(xAxis(e.hora),e.hcho));
    }return SingleChildScrollView(
      child: SafeArea(
        child: Column(
        children: [
          _createGraph("Grafica CO", spotCo),
          _createGraph("Grafica CO2", spotCo2),
          _createGraph("Grafica Temperatura", spotTemp),
          _createGraph("Grafica Humedad", spotHum),
          _createGraph("Grafica Particulas PM10", spotPm10),
          _createGraph("Grafica Particulas PM2.5",spotPm25)
          ]
      ))
    );

  }

 CustomCard _createGraph(String title,List<FlSpot> spot,){
  return     CustomCard(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 20),
          AspectRatio(
            aspectRatio:2.5,
            child: LineChart(
              LineChartData(
                lineTouchData:const LineTouchData(
                  handleBuiltInTouches: true,
                ),
                gridData: const FlGridData(show:true,drawHorizontalLine: true),
                titlesData:  FlTitlesData(
                  show:  true,
                rightTitles: const  AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles:  const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    axisNameSize: 10,
                    
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 50,
                      getTitlesWidget:bottomTitleWidgets,
                      ),
                                      
                                                                 
                  ),
                  leftTitles: const AxisTitles(),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    color: selectionColor,
                    barWidth: 2.5,                    
                    belowBarData: BarAreaData(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          selectionColor.withOpacity(0.5),
                          Colors.transparent
                        ],
                      ),
                      show: true,
                    ),
                    dotData:const  FlDotData(show: false),
                    spots:spot,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
 }

Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontSize: 10,
      color:Colors.grey,
      fontWeight: FontWeight.bold,
    );
    
    String text =  (value+0.002).toString();
    text = text.replaceFirst(RegExp('.'), ':',2).replaceRange(5, text.length,'');
      return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 4,
      child: Text(text, style: style),
    );
  }
}
