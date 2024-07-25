import 'dart:async';
import 'package:firebaseflutter/data_level.dart';
import 'package:firebaseflutter/main.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard>
     with TickerProviderStateMixin {

  bool isLoading= false;

  final GoogleSignIn googleSignIn = GoogleSignIn();
  final databaseReference = FirebaseDatabase.instance.ref();

  late AnimationController progressController;
  late Animation<double> tempAnimation;
  late Animation<double> humidityAnimation; 
  late Animation<double> dioxAnimation;
  late Animation<double> monoxAnimation; 
  late Animation<double> hchoAnimation;
  late Animation<double> pm10Animation; 
  late Animation<double> pm25Animation;
  late ValueNotifier<double> dataexample;
  late ValueNotifier<double> dataexample1;
  late ValueNotifier<double> dataexample2;
       int data =0 ;
       Map<dynamic, dynamic>? jsonData;
  late List<dynamic>tempList;
  late List<dynamic>humidityList;
  late List<dynamic>dateList;    //Revisar. Aun no se como tratar los datos

  @override
  void initState(){
    super.initState();
  
     databaseReference
 .child('Sensores')
 .onValue.listen((event) {
  if(event.snapshot.exists){
    int valor = 1715205356;
    Map<dynamic, dynamic> dataj=  event.snapshot.value as Map<dynamic, dynamic>;
     data = dataj['$valor']['timespan'];
  }});

   databaseReference
 .child('Actual')
 .onValue.listen((event) {
  if(event.snapshot.exists){

    Map<dynamic, dynamic> curr=  event.snapshot.value as Map<dynamic, dynamic>;
    if(jsonData ==null || jsonData != curr){
      jsonData = curr;
    }
  dataexample = ValueNotifier((curr['Temperatura'])/(50)) ;
  dataexample1 = ValueNotifier((curr['Humedad'])/(100)) ;
  dataexample2 = ValueNotifier((curr['CO2'])/(2000)) ;
    
    _dashboardInit(curr,jsonData);
    isLoading = true;


  }
   });

  }


  _dashboardInit(Map<dynamic,dynamic> curr, Map<dynamic,dynamic>? old){
    progressController = AnimationController(
      vsync: this, duration:  const Duration(milliseconds: 4500)); //5s

    tempAnimation = 
      Tween<double>(begin: old!['Temperatura'], end: curr['Temperatura']).animate(progressController)
      ..addListener(() {setState(() {
      });
    });
  
    humidityAnimation = 
      Tween<double>(begin: old['Humedad'], end: curr['Humedad']).animate(progressController)
      ..addListener(() {
        setState(() {
      });
    });
    
        dioxAnimation = 
      Tween<double>(begin: old['CO2'], end: curr['CO2']).animate(progressController)
      ..addListener(() {setState(() {
      });
    });

    monoxAnimation = 
      Tween<double>(begin: old['CO'], end: curr['CO']).animate(progressController)
      ..addListener(() {
        setState(() {
      });
    });

      hchoAnimation = 
      Tween<double>(begin: old['HCHO'], end: curr['HCHO']).animate(progressController)
      ..addListener(() {setState(() {
      });
    });

    pm10Animation = 
      Tween<double>(begin: old['Humedad'], end: curr['Humedad']).animate(progressController)
      ..addListener(() {
        setState(() {
      });
    });
     pm25Animation = 
      Tween<double>(begin: old['Humedad'], end: curr['Humedad']).animate(progressController)
      ..addListener(() {
        setState(() {
      });
    });
    progressController.forward();
  
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade100,
      appBar: AppBar(
        backgroundColor: Colors.blue.shade100,
        title: const Center(  child: Text('Calidad del Aire',textAlign: TextAlign.justify,style: TextStyle(fontStyle: FontStyle.italic,fontSize: 30,fontWeight: FontWeight.bold),)),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
             const DrawerHeader(
              decoration: BoxDecoration(color:Colors.blueGrey),
              child: Text(
                'Menu',
                style:TextStyle(color:Colors.white, fontSize: 19),
              ),
              ),
              ListTile(
              leading:  const Icon(Icons.home),
              title:  const Text('Inicio'),
              selectedColor: Colors.blueGrey,
              onTap: _handleHome,
              ),
              ListTile(
              leading:  const Icon(Icons.history),
              title:  const Text('Registro'),
              selectedColor: Colors.blueGrey,
              onTap: _handleRegistro,
              ),
               ListTile(
              leading:  const Icon(Icons.logout_sharp),
              title:  const Text('Cerrar Sesión'),
              selectedColor: Colors.blueGrey,
              onTap: _handleLoginOutPopUp,
            ),
          ],
        ),
          ),
      body: SafeArea(child: isLoading? GridView.count(
              crossAxisCount: _screenRotate()? 1:2,
              mainAxisSpacing:0,
              crossAxisSpacing: 80,
              childAspectRatio: 1,
              controller: ScrollController(keepScrollOffset: false),
              padding: const EdgeInsets.all(0),
              children: <Widget>[
                Flex(
                    direction: Axis.vertical,
                    children: [ 
                                  Flexible(
                                     fit: FlexFit.tight,
                                     flex: 5,
                                     child:_generalstatuscont(tempAnimation.value)),
                      
                                  Flexible(
                                      fit: FlexFit.tight,
                                      flex:1,
                                      child:Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children:<Widget> [                
                                              Image.asset('assets/images/Status1.png',scale: 1.6,),
                                              Image.asset('assets/images/Status2.png',scale: 1.6,),
                                              Image.asset('assets/images/Status3.png',scale: 1.6,),
                                              Image.asset('assets/images/Status4.png',scale: 1.6,),
                                              Image.asset('assets/images/Status5.png',scale: 1.6,),
                                                   ],
                                            ) 
                                      )       
                  ]
            
            ),
            GridView.count(
              crossAxisCount:1,
              mainAxisSpacing:1,
              crossAxisSpacing: 5,
              padding: const EdgeInsets.all(1),
              childAspectRatio: 5, 
              children:<Widget>[
                            Row( 
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children:<Widget> [
                                      /*Image.asset(
                                      'assets/images/termometro.png',
                                      alignment: Alignment.centerLeft,    
                                      scale: 2,
                                  ),*/
                                   DataLevel(dataexample),
                                  const Icon(Icons.thermostat_outlined,size: 35,),
                                        Text(
                                            '${tempAnimation.value}',
                                            style: const TextStyle(
                                                    fontSize: 50, fontWeight: FontWeight.bold),
                                        ),
                                        const Text(
                                          '°C', 
                                          style: TextStyle(
                                            fontSize: 50, fontWeight: FontWeight.bold),
                                        )

                            ]
                            ),
                            Row( 
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children:<Widget> [
                                    DataLevel(dataexample1),
                                      const Icon(Icons.water_drop_outlined,size: 35,),
                                      Text(
                                          '${humidityAnimation.value}',
                                          style: const TextStyle(
                                                  fontSize: 50, fontWeight: FontWeight.bold),
                                      ),
                                      const Text(
                                        '%', 
                                        style: TextStyle(
                                          fontSize: 50, fontWeight: FontWeight.bold),
                                      )
                                    ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children:<Widget> [
                                DataLevel(dataexample2),
                                const Text('CO2',style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold,),),
                                Text(
                                    '${dioxAnimation.value}',
                                    style: const TextStyle(
                                            fontSize: 50, fontWeight: FontWeight.bold),
                                ),
                                const Text(
                                  'ppm', 
                                  style: TextStyle(
                                    fontSize: 40, fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children:<Widget> [
                                const Text('CO',style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),),
                                Text(
                                    '${monoxAnimation.value}',
                                    style: const TextStyle(
                                            fontSize: 50, fontWeight: FontWeight.bold),
                                ),
                                const Text(
                                  'ppm', 
                                  style: TextStyle(
                                    fontSize: 40, fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children:<Widget> [
                                  const Text('HCHO',style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold,),),
                                Text(
                                    '${hchoAnimation.value}',
                                    style: const TextStyle(
                                            fontSize: 50, fontWeight: FontWeight.bold),
                                ),
                                const Text(
                                  'ppm', 
                                  style: TextStyle(
                                    fontSize: 30, fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children:<Widget> [
                                const Text('PM10',style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),),
                                Text(
                                    '${pm10Animation.value}',
                                    style: const TextStyle(
                                            fontSize: 50, fontWeight: FontWeight.bold),
                                ),
                                const Text(
                                  'ppm', 
                                  style: TextStyle(
                                    fontSize: 40, fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children:<Widget> [
                                  const Text('PM2.5',style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold,),),
                                Text(
                                    '${pm25Animation.value}',
                                    style: const TextStyle(
                                            fontSize: 50, fontWeight: FontWeight.bold),
                                ),
                                const Text(
                                  'ppm', 
                                  style: TextStyle(
                                    fontSize: 30, fontWeight: FontWeight.bold),
                                )
                              ],
                            ),

              ] ,

            ),
            ],
        ) :const  Center(child:  Text('Cargando',
              style: TextStyle(
              fontSize: 30, fontWeight:  FontWeight.bold),
         )
     )),    
  /*    bottomNavigationBar: SizedBox(
      height: _screenRotate()? MediaQuery.of(context).size.height * 0.1:  MediaQuery.of(context).size.height * 0.2 , // altura dependiendo la orientacion
      //width: _screenRotate()? MediaQuery.of(context).size.width:MediaQuery.of(context).size.width*0.5,
      child: isLoading?Row(
      
        //maxCrossAxisExtent: _screenRotate()? MediaQuery.of(context).size.width:MediaQuery.of(context).size.width*0.5,//crossAxisCount: 5,        
        //crossAxisCount: 5,
        mainAxisSize: MainAxisSize.min,
        //mainAxisAlignment: MainAxisAlignment.center,
        children:<Widget>[
          Container(
            width: 45,
            foregroundDecoration: const BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/termometro.png'),fit: BoxFit.scaleDown),shape: BoxShape.rectangle),
          ),
          SizedBox(
            width: 100,
            child: Center( child: Text(
                    '${tempAnimation.value} °C',
                    
                    style: const TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold)
                    ))
          ),
          const Spacer(),
          Container(
            width: 50,
            foregroundDecoration: const BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/gotadeagua.png'),fit: BoxFit.scaleDown),shape: BoxShape.rectangle),
          ),
          SizedBox(
            width: 100,
            child: Center( child: Text(
                    '${humidityAnimation.value} %',
                    style: const TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold)
                    ))
          ),
     ]
    ):const Text('Cargando',
              style: TextStyle(
              fontSize: 20, fontWeight:  FontWeight.bold),
         )
       ),
*/
    );
  }
  Widget _generalstatuscont(double currval){
  

    List <GaugeRange> buildrange(){
        return <GaugeRange>[
          GaugeRange(
            startValue: 0,
            endValue: 50, 
            gradient: const SweepGradient(colors: [
                                    Colors.blue,
                                    Colors.green,
                                    Colors.yellow,
                                    Colors.orange, 
                                    Colors.red,                                                                  
                                    ]
                                ),                       
            sizeUnit: GaugeSizeUnit.factor,                       
            startWidth: 0.3,
            endWidth: 0.3
                      ),
                   ];
    }
      
    return SfRadialGauge(
      //title: const GaugeTitle(text:'Estado del aire',textStyle: TextStyle(fontWeight: FontWeight.bold,fontSize:20)),
      enableLoadingAnimation: true,
      animationDuration: 2500,
      axes: <RadialAxis>[
                  // Create primary radial axis
                  RadialAxis(
                    ranges: buildrange(),
                    minimum: 0,                  
                    maximum: 50,                      
                    showLabels: false,
                    showTicks: false,showAxisLine: true,
                    startAngle: 180,
                    endAngle: 0,
                    radiusFactor: 0.95,
                    canScaleToFit: true,                  
                   pointers:  <GaugePointer>[
                         NeedlePointer(
                            animationDuration:2500,
                            enableDragging: false,
                            enableAnimation:  true,
                            value:currval,
                            tailStyle: const TailStyle(
                                            width: 8,
                                            length: 0.15
                                            ),
                            ),
                           ]
                          
                   /* const <GaugePointer>[
                      RangePointer(
                          value: 50,
                          width: 0.25,
                          pointerOffset: 0,
                          enableAnimation: true,
                          animationDuration: 2500,
                          gradient:  SweepGradient(colors: [ Color.fromARGB(255, 0, 199, 7),Colors.greenAccent,Color.fromARGB(255, 195, 255, 65),Colors.orange,Color.fromARGB(255, 255, 17, 0)]),
                          //color: Colors.blueAccent,
                          sizeUnit: GaugeSizeUnit.factor,
                          
                          ),
                    ]*/,
                  ),
                  // Create secondary radial axis for segmented line
                /* RadialAxis(
                    minimum: 0,
                    interval: 1,
                    maximum: 5,
                    useRangeColorForAxis: true,
                    canScaleToFit: true,
                    showLabels: false,
                    showTicks: true,
                    showAxisLine: false,
                    tickOffset: 0,
                    offsetUnit: GaugeSizeUnit.factor,
                    minorTicksPerInterval: 0,
                    startAngle: 180,
                    endAngle: 0,
                    radiusFactor: 0.95,
                    majorTickStyle: const MajorTickStyle(
                        length: 0.25,
                        thickness: 2,
                        lengthUnit: GaugeSizeUnit.factor,
                        color: Colors.white),
                    
                  )*/
                ]);
    
  }
  bool _screenRotate(){
        return (MediaQuery.of(context).orientation == Orientation.portrait);
    }
  _handleHome(){
      Navigator.pop(context);
    }
  _handleRegistro(){
      Alert(
        context: context,
        type:AlertType.warning,
        title:'Registro historico',
        desc: 'Pagina en construccion',
        buttons: [DialogButton(
        onPressed:()=>Navigator.pop(context),
          width: 120,
          child: const Text(
            "OK",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        )]
        ).show();
    }
  _handleLoginOutPopUp(){
    Alert(
      context: context,
      type: AlertType.info,
      title: "Login Out",
      desc: "Usted está por cerrar sesión",
      buttons: [
        DialogButton(
          onPressed: () => Navigator.pop(context),
          width: 120,
          child: const Text(
            "No",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
        DialogButton(
          onPressed: _handleSignOut,
          width: 120,
          child: const Text(
            "Si",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        )
      ],
    ).show();
  }
  Future<Null> _handleSignOut() async{
    setState(() {
      isLoading = true;
    });
    await FirebaseAuth.instance.signOut();
    await googleSignIn.signOut();
    setState(() {
      isLoading = false;
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=> const MyApp()), (Route<dynamic> route) => false);
    });
    
 
     
    
  }
}