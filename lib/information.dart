import 'package:firebaseflutter/const/constant.dart';
import 'package:firebaseflutter/data_control.dart';
import 'package:flutter/material.dart';


import 'dashboard.dart';



class AcercaDe extends StatelessWidget{
  const AcercaDe({super.key});
  
  @override
  Widget build(BuildContext context) {
    return PopScope(
       child: Scaffold(
        backgroundColor: backgroundColor2,
        appBar: AppBar(
          backgroundColor: backgroundColor2,
          leading:const  Image(image: AssetImage('assets/images/UTNLOGO2.png'),),
          title: const Text('\t \t \t \t \t Calidad del Aire',textAlign: TextAlign.start,style: TextStyle(fontStyle: FontStyle.italic,fontSize: 30,fontWeight: FontWeight.bold)),
            ),
        body: SafeArea(
              child:Padding(
                padding: const EdgeInsets.all(20.0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  reverse: false,
                  primary: true,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                        Container(
                        height: (MediaQuery.of(context).orientation == Orientation.portrait)? MediaQuery.of(context).size.height*0.15 : MediaQuery.of(context).size.height*0.4, // maximum item width
                        width:  (MediaQuery.of(context).orientation == Orientation.portrait)? MediaQuery.of(context).size.width*0.8: MediaQuery.of(context).size.width*0.4, // maximum item width
                        decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/UTNLOGO2.png'),fit: BoxFit.contain,),shape: BoxShape.rectangle),
                      ),
                        const Center(
                          child:Text(
                              'Monitoreo y presentación digital de calidad de aire mediante detección de CO, HCHO, CO2 y Partículas',
                          style:TextStyle(fontSize: 24,fontStyle:FontStyle.normal,fontFamily: 'Times New Roman',fontWeight: FontWeight.bold ),
                          textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 35,),
                        const Text(
                          "\n\t \t Declaracion de Autoria:",
                          style:TextStyle(fontSize: 20,fontStyle:FontStyle.normal,fontFamily: 'Times New Roman',fontWeight: FontWeight.w500 ),
                          textAlign: TextAlign.justify,
                        ),
                        const SizedBox(height: 16,),
                        const Text(
                          """\t \t Este trabajo fue realizado en su totalidad, o principalmente, para acceder al título de grado de Ingeniero en Electrónica en la Universidad Tecnológica Nacional, Regional Paraná.
                          Se establece claramente que el desarrollo realizado y el informe que lo acompaña no han sido previamente utilizados para acceder a otro título de grado o pre-grado.
                          Siempre que se ha utilizado trabajo de otros autores, el mismo ha sido correctamente citado.
                          El resto del trabajo es de autoría propia.Se ha indicado y agradecido correctamente a todos aquellos que han colaborado con el presente trabajo.
                          Cuando el trabajo forma parte de un trabajo de mayores dimensiones donde han participado otras personas, se ha indicado claramente el alcance del trabajo realizado.""",
                          style:TextStyle(fontSize: 16,fontStyle:FontStyle.normal,fontFamily: 'Times New Roman',fontWeight: FontWeight.w500 ),
                          textAlign: TextAlign.justify,
                        ),
                        const SizedBox(height: 45,),
                        const Text(
                          "\tAutores:",
                          style:TextStyle(fontSize: 20,fontStyle:FontStyle.normal,fontFamily: 'Times New Roman',fontWeight: FontWeight.w600 ),
                          textAlign: TextAlign.justify,
                        ),
                        const SizedBox(height: 10,),
                        const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                                  Text(
                          'Meza, Lautaro',
                          style:TextStyle(fontSize: 18,fontStyle:FontStyle.normal,fontFamily: 'Times New Roman',fontWeight: FontWeight.w500 ),
                        ),
                                  Text(
                          'Ré, Boris',
                          style:TextStyle(fontSize: 18,fontStyle:FontStyle.normal,fontFamily: 'Times New Roman',fontWeight: FontWeight.w500 ),
                        ),
                            ],
                          )
                    ],
                  ) 
                  
                )
                )
          ),
        bottomNavigationBar: 
          BottomNavigationBar(
           backgroundColor: backgroundColor2,
           items: [
              BottomNavigationBarItem(icon:Icon(Icons.home,color: Colors.grey.shade800,) ,label: 'Inicio',backgroundColor: backgroundColor2),
              BottomNavigationBarItem(icon:Icon(Icons.history,color: Colors.grey.shade800) ,label: 'Registro',backgroundColor: backgroundColor2),
              BottomNavigationBarItem(icon:Icon(Icons.info_outline_rounded,color: Colors.grey.shade800) ,label: 'Informacion',backgroundColor: backgroundColor2),    
              ],
           onTap:(value) => _handleroutes(true,value,context),
            ) 
   ));
 }

}




class InformationPage extends StatelessWidget{
  const InformationPage({super.key});

  @override
  Widget build(BuildContext context) {
   return PopScope( child: Scaffold(
    backgroundColor: backgroundColor2,
      appBar: AppBar(
        backgroundColor: backgroundColor2,
        leading:const  Image(image: AssetImage('assets/images/UTNLOGO2.png'),),
        title: const Text('\t \t \t \t \t Calidad del Aire',textAlign: TextAlign.start,style: TextStyle(fontStyle: FontStyle.italic,fontSize: 30,fontWeight: FontWeight.bold)),
      ),
      body: const SafeArea(
        child: Padding(
          padding:  EdgeInsets.all(20.0),
          child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                reverse: false,
                primary: true,
                child:Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                Center(
                  child:Text(
                  'Monitoreo y presentación digital de calidad de aire mediante detección de CO, HCHO, CO2 y Partículas',
                  style:TextStyle(fontSize: 24,fontStyle:FontStyle.normal,fontFamily: 'Times New Roman',fontWeight: FontWeight.bold ),
                  textAlign: TextAlign.center,
                ),),
                SizedBox(height: 24,),
                              Text(
                  "\t La contaminación del aire es la presencia en la atmosfera de sustancias que implican una alteración de sus características naturales.",
                  style:TextStyle(fontSize: 16,fontStyle:FontStyle.normal,fontFamily: 'Times New Roman',fontWeight: FontWeight.w200 ),
                  textAlign: TextAlign.justify,
                ),
                SizedBox(height: 30,),
                Text(
                  "\t \t Particulas PM10 y PM2.5",
                  style:TextStyle(fontSize: 20,fontStyle:FontStyle.normal,fontFamily: 'Times New Roman',fontWeight: FontWeight.w500 ),
                  textAlign: TextAlign.justify,
                ),
                SizedBox(height: 16,),
                Text(
                  "\t \tEl material particulado presente en aire corresponde a partículas solidas y liquidas que están en suspensión en la atmosfera, se generan por una mezcla de diversas sustancias como silicatos, carbonatos, sulfatos, hongos, bacterias, entre otras. Su denominación PM10 o PM2.5 se debe a su tamaño, 10 um o 2.5 um y en gran concentración pueden ser peligrosas para la salud humana ya que su diminuto tamaño les permite ingresar a nuestro organismo por medio de los poros o sistema respiratorio.",
                  style:TextStyle(fontSize: 16,fontStyle:FontStyle.normal,fontFamily: 'Times New Roman',fontWeight: FontWeight.w200 ),
                  textAlign: TextAlign.justify,
                ),
                SizedBox(height: 20,),
                Text(
                  "\t \t Monoxido de Carbono (CO)",
                  style:TextStyle(fontSize: 20,fontStyle:FontStyle.normal,fontFamily: 'Times New Roman',fontWeight: FontWeight.w500 ),
                  textAlign: TextAlign.justify,
                ),
                SizedBox(height: 16,),
                Text(
                  "\t \t El monóxido de carbono es un contaminante que se produce por la incompleta combustión de un material. El ejemplo hogareño más común, es la llama color amarillo en una hornalla donde el gas no se quema por completo liberando monóxido de carbono. Un valor de concentración de 25 ppm prolongado por 8 horas en un ambiente puede producir Anoxia y afecciones al sistema nervioso central, si la concentración asciende a los 50-60 ppm los síntomas de anoxia( mareos, visión borrosa, desmayos) comienzan a los 15 minutos.",
                  style:TextStyle(fontSize: 16,fontStyle:FontStyle.normal,fontFamily: 'Times New Roman',fontWeight: FontWeight.w200 ),
                  textAlign: TextAlign.justify,
                ),
                SizedBox(height: 20,),
                Text(
                  "\t \t Dioxido de Carbono (CO2)",
                  style:TextStyle(fontSize: 20,fontStyle:FontStyle.normal,fontFamily: 'Times New Roman',fontWeight: FontWeight.w500 ),
                  textAlign: TextAlign.justify,
                ),
                SizedBox(height: 16,),
                Text(
                  "\t \t El dióxido no es un contaminante en si, pero en grandes concentraciones puede ser peligroso. Es un gas liberado por el humano en el proceso de respiración, grandes concentraciones por un tiempo prolongado de mas de 8 horas puede provocar asfixia, iniciando con cansancio corporal y luego mareos.",
                  style:TextStyle(fontSize: 16,fontStyle:FontStyle.normal,fontFamily: 'Times New Roman',fontWeight: FontWeight.w200 ),
                  textAlign: TextAlign.justify,
                ),
                SizedBox(height: 20,),
                Text(
                  "\t \t Formaldehido (HCHO)",
                  style:TextStyle(fontSize: 20,fontStyle:FontStyle.normal,fontFamily: 'Times New Roman',fontWeight: FontWeight.w500 ),
                  textAlign: TextAlign.justify,
                ),
                SizedBox(height: 16,),
                Text(
                  "\t \t El formaldehido es un gas contaminante del aire natural proveniente de muchas fuentes, inclusive el humano. En el hogar, el formaldehído es producido por cigarrillos y otros productos de tabaco, estufas de gas y chimeneas abiertas al aire. También se encuentra en muchos productos que se usan diariamente en el hogar, por ejemplo, antisépticos, medicamentos, cosméticos, líquidos para lavar platos, suavizadores de telas, artículos para el cuidado de zapatos, limpiadores de alfombras, pegamentos y adhesivos, barnices, papel, plásticos y en algunos productos de madera. \n Valores cercanos a los 3 ppm  pueden producir afecciones a la salud humana, iniciando con irritación de los tejidos, irritación de ojos, nariz y garganta y lagrimeo. Una concentración cercana a los 20 ppm sugiere un peligro inmediato para la salud.",
                  style:TextStyle(fontSize: 16,fontStyle:FontStyle.normal,fontFamily: 'Times New Roman',fontWeight: FontWeight.w200 ),
                  textAlign: TextAlign.justify,
                ),
                SizedBox(height: 20,),
                
            ],
          ),)
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(backgroundColor: backgroundColor2,
      items: [
                BottomNavigationBarItem(icon:Icon(Icons.home,color: Colors.grey.shade800,) ,label: 'Inicio',backgroundColor: backgroundColor2),
                BottomNavigationBarItem(icon:Icon(Icons.history,color: Colors.grey.shade800) ,label: 'Registro',backgroundColor: backgroundColor2),
                BottomNavigationBarItem(icon:Icon(Icons.question_mark_outlined,color: Colors.grey.shade800) ,label: 'Acerca De',backgroundColor: backgroundColor2),
                
      ],
      onTap:(value) => _handleroutes(false,value,context),
  )
  ));
  }

}
 _handleroutes(bool info,int value,BuildContext context){
  
  switch (value) {
      case 0:
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>const Dashboard()));
      break;
      case 1:
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>const DataControl()));      
      break;
      case 2:
      if(info)
      {Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>const InformationPage()));}
      else
      {Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>const AcercaDe()));}
      break;
  }
 }

