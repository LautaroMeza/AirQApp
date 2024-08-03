

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebaseflutter/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import 'main.dart';

class DataControl extends StatefulWidget{
 
  const DataControl({super.key});

  @override
  State<StatefulWidget> createState() => _DataControlState();
  
  }
  

class _DataControlState extends State<DataControl> {
  bool isLoading= false;
  bool isEmpty=false;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final databaseReference = FirebaseDatabase.instance.ref();

   //Map<dynamic, dynamic>? registros;
   List<dynamic>? registros;
   List<ExpansionRegistro>? listRegistros;
   late List<String> fechasReg;
   late List<String> horasReg;
   
   int i=0;
   int datacount =100;
@override
  void initState(){
    super.initState();
    
  /*  databaseReference
          .child('Registros/$i')
          .onValue.listen((event) {
      if(event.snapshot.exists){
            registros= event.snapshot.value as Map<dynamic, dynamic>;
          }else{
            registros= null;
          }
       }
     );*/

           databaseReference
          .child('Registros')
          .onValue.listen((event) {
      if(event.snapshot.exists){
            registros= event.snapshot.value as List?; //as Map<dynamic, dynamic>;
        setState(() { }); 
         isEmpty = _createListTimes();
          isLoading=true;
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
      body: //Center(child:isLoading?Text((registros!=null)?registros.toString():'Sin datos'):const Text('Cargando')));
            Center(child: isLoading?ListView(children: [
                                  !isEmpty?ExpansionPanelList(
                              expansionCallback: (int index, isExpanded) {
                                setState(() {
                                  
                                    listRegistros?[index].isExpanded =!listRegistros![index].isExpanded;
                                  
                                  
                                });
                              },
                              children: listRegistros!.map((ExpansionRegistro item) {
                                return ExpansionPanel(
                                  headerBuilder: (BuildContext context, bool isExpanded){
                                            return tituloRegis(item,_screenRotate());
                                  },
                                  isExpanded: item.isExpanded,
                                  body: cuerpoRegis(item),
                                   );
                              }
                            ).toList(), ):const Text('Por el momento no hay Registro'),
                            ],
                            ):const Text('Cargando'),
                            ));




   
    
   }
  bool _createListTimes(){
    if(registros!=null){
      ExpansionRegistro first= ExpansionRegistro(
                                        hora:timeFormatTime(registros?.first['TimeStamp']),
                                        fecha:timeFormatDate(registros?.first['TimeStamp']),
                                        co:1.0*registros?.first['CO'],
                                        temp:1.0*registros?.first['Temperatura'],
                                        hum:1.0*registros?.first['Humedad'],
                                        pm_10:1.0*registros?.first['PM_1'],
                                        pm_25:1.0*registros?.first['PM2_5'],
                                        hcho:1.0*registros?.first['HCHO'],
                                        co2:1.0*registros?.first['CO2'],);
    listRegistros =[first];
    registros?.forEach((dynamic element) {
      if(element!=registros?.first){
        try{        
          ExpansionRegistro item = ExpansionRegistro(
                                        hora:timeFormatTime(element['TimeStamp']),
                                        fecha:timeFormatDate(element['TimeStamp']),
                                        co:1.0*element['CO'],
                                        temp:1.0*element['Temperatura'],
                                        hum:1.0*element['Humedad'],
                                        pm_10:1.0*element['PM_1'],
                                        pm_25:1.0*element['PM2_5'],
                                        hcho:1.0*element['HCHO'],
                                        co2:1.0*element['CO2'],
                                        );
          listRegistros?.add(item);
          }catch(e){
     // print('Error al agregar registro a la lista: $e');
        }
    }
  });
  return false;
    }else{return true;}

  }
  bool _screenRotate(){
        return (MediaQuery.of(context).orientation == Orientation.portrait);
    }
  _handleHome(){
    //Navigator.of(context).pushReplacement(  
    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>const Dashboard()),ModalRoute.withName('/'),);
    }
  _handleRegistro(){
    Navigator.pop(context);
    
    /*  Alert(
        context: context,
        type:AlertType.warning,
        title:'Registro historico',
        desc: 'Pagina en construccion, FECHA ${dateTime(data)}',
        buttons: [DialogButton(
        onPressed:()=>Navigator.pop(context),
          width: 120,
          child: const Text(
            "OK",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        )]
        ).show();*/
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

String timeFormatDate(int timestamp){           
    return DateFormat('dd-MM-yyyy').format(DateTime.fromMillisecondsSinceEpoch(timestamp * 1000, isUtc: false)); 
  }
String timeFormatTime(int timestamp){   
    return DateFormat('HH:mm:ss').format(DateTime.fromMillisecondsSinceEpoch(timestamp * 1000, isUtc: false));     
  }
class ExpansionItem{
  bool isExpanded;
  final String magnitud;
  final double currval;
  final String unidad;
  final double maxvalue;
  ExpansionItem({this.isExpanded=false,required this.magnitud,required this.currval,required this.unidad, required this.maxvalue,});
}
class ExpansionRegistro{
  bool isExpanded;
  final double temp;
  final double hum;
  final double pm_10;
  final double pm_25;
  final double hcho;
  final double co;
  final double co2;
   String fecha;
   String hora;
  ExpansionRegistro({ required this.fecha, required this.hora,this.isExpanded=false,required this.co,required this.temp, required this.hum, required this.pm_10, required this.pm_25, required this.hcho, required this.co2,}); 
  }
Widget tituloItem(ExpansionItem item,bool rotate){
  Icon iconState = const Icon(Icons.abc,size: 0,);
  double status = item.currval/item.maxvalue;
  if(status>0.4 && status<0.6){ 
    iconState = const Icon(Icons.info_outlined,size: 30,color: Colors.blue,);
  }else if(status>0.6 && status<0.8){
    iconState = const Icon(Icons.warning_amber_outlined,size: 30,color: Colors.amber,);
  }else if(status>0.8){
    iconState = const Icon(Icons.dangerous_rounded,size:30,color:Colors.red,);
  }

  return  Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [ 
                  Text(item.magnitud ,style: const TextStyle(fontSize: 20),),
                  const Spacer(),
                  Container(padding: const EdgeInsets.only(right:5,bottom: 5),child: iconState),
                  Text('${item.currval} ${item.unidad}',style: const TextStyle(fontSize: 15),),
                  ]
               );
}
Widget tituloRegis(ExpansionRegistro item,bool rotate){
  return  Text(item.fecha ,style: const TextStyle(fontSize: 20),);
}
Widget cuerpoRegis(ExpansionRegistro item){
  return  Text(item.hora ,style: const TextStyle(fontSize: 20),);
}
Widget cuerpoItem(ExpansionItem item){
String path = 'assets/images/Status1.png';
double status = item.currval/item.maxvalue;
  if(status<0.2){
    path = 'assets/images/Status1.png';
  }else if(status>0.2 && status<0.4){
    path = 'assets/images/Status2.png';
  }else if(status>0.4 && status<0.6){ 
    path = 'assets/images/Status3.png';
  }else if(status>0.6 && status<0.8){
    path = 'assets/images/Status4.png';
  }else if(status>0.8){
    path = 'assets/images/Status5.png';
  }
  return  Row( 
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children:<Widget> [
                                    Column(                                      
                                      children: [
                                      const Text('Estado:', textAlign: TextAlign.center,style: TextStyle(fontSize: 15),),
                                       Image.asset(path,fit: BoxFit.contain,scale:3),
                                    ],),                                    
                                     const Spacer(flex: 2,),
                                      Text(
                                          '${item.currval}',
                                          style: const TextStyle(
                                                  fontSize: 50, fontWeight: FontWeight.bold),
                                      ),
                                       Text(
                                        item.unidad, 
                                        style: const TextStyle(
                                          fontSize: 50, fontWeight: FontWeight.bold),
                                      ),
                                       const Spacer(flex:2),
                                      Column(                                      
                                      children: [
                                      const Text('Nivel critico:', textAlign: TextAlign.center,style: TextStyle(fontSize: 15),),
                                           Text('${item.maxvalue} ${item.unidad}',style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                      ),
                                    ],), 
                                    ],
                            );
}