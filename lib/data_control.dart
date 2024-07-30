

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
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final databaseReference = FirebaseDatabase.instance.ref();

   //Map<dynamic, dynamic>? registros;
   List<dynamic>? registros;
     int i=1;
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
      body: Center(child:isLoading?Text((registros!=null)?registros.toString():'Sin datos'):const Text('Cargando')));
   
   
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
String dateTime(int timestamp)
{  var date =  DateTime.fromMillisecondsSinceEpoch(timestamp * 1000, isUtc: false);
    final dateFormatter = DateFormat('dd-MM-yyyy');
    final timeFormatter = DateFormat('HH:mm:ss');

    final formattedDate = dateFormatter.format(date);
    final formattedTime = timeFormatter.format(date);
           
  return '$formattedDate  $formattedTime';
}
class ExpansionItem{
  bool isExpanded;
  final String magnitud;
  final double currval;
  final String unidad;
  final double maxvalue;
  ExpansionItem({this.isExpanded=false,required this.magnitud,required this.currval,required this.unidad, required this.maxvalue,});
}
Widget titulo(ExpansionItem item,bool rotate){
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
Widget cuerpo(ExpansionItem item){
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