import 'dart:async';

import 'package:firebaseflutter/data_control.dart';
import 'package:firebaseflutter/main.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import 'notifications_service.dart';


/* 
Esta es la pagina home de mi aplicacion, se van a ver todos los datos actuales en tiempo real
*/ 
class Dashboard extends StatefulWidget {
  
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard>
     with TickerProviderStateMixin {

  bool isLoading= false;
  StreamSubscription<DatabaseEvent>? _subscription;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final databaseReference = FirebaseDatabase.instance.ref();
  late List<ExpansionItem> lista;
  late List<bool> oldExpandState;
       int data =0 ;
  late Map<dynamic, dynamic> jsonData;  // valores de sensores en tiempo real
  late Map<dynamic, dynamic> jsonDataMax; // valores Maximos permisibles de sensores. Refiere a  valores nocivos
  @override
  void initState(){
    super.initState();
     
    _getMaxValues();
  _subscription = databaseReference
      .child('Actual')
      .onValue.listen((event) {
  if(event.snapshot.exists){

  jsonData=  event.snapshot.value as Map<dynamic, dynamic>;
  setState(() {    
    if(isLoading){
        oldExpandState=[
            lista[0].isExpanded,
            lista[1].isExpanded,
            lista[2].isExpanded,
            lista[3].isExpanded,
            lista[4].isExpanded,
            lista[5].isExpanded,
            lista[6].isExpanded,
        ];
    }else{
      oldExpandState=[
        false,
        false,
        false,
        false,
        false,
        false,
        false,        
      ];
    }
    });
    lista =[
      ExpansionItem(isExpanded: oldExpandState[0],magnitud: 'Temperatura', currval: 1.0*jsonData['Temperatura'],maxvalue: 1.0*jsonDataMax['Temperatura'],unidad:'°C'),
      ExpansionItem(isExpanded: oldExpandState[1],magnitud: 'Humedad', currval: 1.0*jsonData['Humedad'], maxvalue: 1.0*jsonDataMax['Humedad'], unidad: '%'),
      
      ExpansionItem(isExpanded: oldExpandState[2],magnitud: 'Monoxido de carbono', currval: 1.0*jsonData['CO'],maxvalue: 1.0*jsonDataMax['CO'],unidad:'ppm'),
      ExpansionItem(isExpanded: oldExpandState[3],magnitud: 'Dioxido de Carbono', currval: 1.0*jsonData['CO2'], maxvalue: 1.0*jsonDataMax['CO2'], unidad: 'ppm'),
      
      ExpansionItem(isExpanded: oldExpandState[4],magnitud: 'Particulas PM10', currval: 1.0*jsonData['PM_10'],maxvalue: 1.0*jsonDataMax['PM1_0'],unidad:'ug/m3'),
      ExpansionItem(isExpanded: oldExpandState[5],magnitud: 'Particulas PM2.5', currval: 1.0*jsonData['PM2_5'], maxvalue: 1.0*jsonDataMax['PM2_5'], unidad: 'ug/m3'),
      
      ExpansionItem(isExpanded: oldExpandState[6],magnitud: 'Formalheido', currval: 1.0*jsonData['HCHO'],maxvalue: 1.0*jsonDataMax['HCHO'],unidad:'ppm'),

    ];


    isLoading = true;
    _checkState(lista);
 
  }
   });

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
                                     child:_generalstatuscont()),
                      
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
                ListView(children: [
                                  ExpansionPanelList(
                              expansionCallback: (int index, isExpanded) {
                                setState(() {
                                  
                                    lista[index].isExpanded =!lista[index].isExpanded;
                                  
                                  
                                });
                              },
                              children: lista.map((ExpansionItem item) {
                                return ExpansionPanel(
                                  headerBuilder: (BuildContext context, bool isExpanded){
                                            return tituloItem(item,_screenRotate());
                                  },
                                  isExpanded: item.isExpanded,
                                  canTapOnHeader: true,
                                  body: cuerpoItem(item),
                                   );
                              }
                            ).toList(), ),
                            ],
                            )
                            
 
            ],
        ) :const  Center(child:  Text('Cargando',
              style: TextStyle(
              fontSize: 30, fontWeight:  FontWeight.bold),
         )
     )),    
    );
  }
  Widget _generalstatuscont(){
  

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
    double ratiomax =lista.first.currval/lista.first.maxvalue;
      lista.map((e) {
        if(ratiomax<e.currval/e.maxvalue){
            ratiomax =e.currval/e.maxvalue;
        }
      },).toList();
      
    return SfRadialGauge(
      //title: const GaugeTitle(text:'Estado del aire',textStyle: TextStyle(fontWeight: FontWeight.bold,fontSize:20)),
      enableLoadingAnimation: true,
      animationDuration: 2500,
      axes: <RadialAxis>[
                  // Create primary radial axis
                  RadialAxis(
                    ranges: buildrange(),
                    minimum: 0,                  
                    maximum: 1,                      
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
                            value:ratiomax,
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
    _subscription?.cancel();
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>const DataControl()));
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
    _subscription?.cancel();
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
  
  void _checkState(List<ExpansionItem> lista) {
    int idNot=0;
    for (ExpansionItem element in lista) {
      if(element.currval > element.maxvalue){
        idNot++;
        FirebaseApi().showNotification(idNot,"Alerta por valor elevado",'El valor de ${element.magnitud} excede los ${element.maxvalue} ${element.unidad}');
      }
     }
  }
  void _getMaxValues() async{
    DatabaseEvent event = await  databaseReference.child('ValoresMaximos').once();
    if(event.snapshot.exists){
      jsonDataMax = event.snapshot.value as Map<dynamic,dynamic>;
    }
  }
}