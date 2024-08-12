


import 'dart:io';
import 'package:firebaseflutter/dashboard.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:another_flushbar/flushbar.dart';



void main() async {
   WidgetsFlutterBinding.ensureInitialized();
   //for web
  if(kIsWeb){
    await Firebase.initializeApp(
      options: const FirebaseOptions(
         apiKey: "AIzaSyDtHvpkrqijGy5m5vRHeYZtNwfkveRsgxo",
         appId: "1:892165958267:web:4933db1de1a56d05e610de",
         messagingSenderId: "892165958267",
         projectId: "esp32-flutter-48c5b",
         storageBucket: "esp32-flutter-48c5b.appspot.com",
         databaseURL: "https://esp32-flutter-48c5b-default-rtdb.asia-southeast1.firebasedatabase.app",
        
        
         ));
   }else if(Platform.isAndroid){
    await Firebase.initializeApp(
      options: const FirebaseOptions(
         apiKey: "AIzaSyDtHvpkrqijGy5m5vRHeYZtNwfkveRsgxo",
         appId: "1:892165958267:android:4933db1de1a56d05e610de",
         messagingSenderId: "892165958267",
         projectId: "esp32-flutter-48c5b",
         storageBucket: "esp32-flutter-48c5b.appspot.com",
         databaseURL: "https://esp32-flutter-48c5b-default-rtdb.asia-southeast1.firebasedatabase.app",

         ));
   }else {
    await Firebase.initializeApp();
  }
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
       home: const LoginScreen(title: 'Inicio de Sesion'),
  
      routes: {
        '/home':(context) => const MyHomePage(title: 'Flutter Demo Home Page'),
              },
    );
  }

}


class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});



  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var _counter ="val";
  final DatabaseReference database = FirebaseDatabase.instance.ref();

  void _incrementCounter() {
    
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      //_counter++;
      database.child('/Sensores/1715205356/Gas/CO').onValue.listen((event) {
        DataSnapshot snapshot = event.snapshot;
        _counter = snapshot.value.toString();
        });
        setState(() {    });

  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body:Center( 
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              _counter,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                 MaterialPageRoute(builder: (context) => const LoginScreen(title: 'Login')),
                
                );
              },
              child: const Text('Go to Login Page'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}


class LoginScreen extends StatefulWidget {
  final String title;
  const LoginScreen({super.key,required this.title});  

  @override 
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn =  GoogleSignIn(
    scopes: <String>['email'],  
    serverClientId: "892165958267-6hkhlfcnvstdjdcshrmp8gphctsb5npg.apps.googleusercontent.com",
    clientId: "892165958267-nfu7pjudc526m3tf094ucbfh3irdfpml.apps.googleusercontent.com"
    

  );
  GoogleSignInAccount? _currentUser;
  User? firebaseuser;
  
 
  @override
  void initState() {
   
    super.initState();
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account)async {
      setState(() {
         _currentUser = account;         
     });
    if(_currentUser != null){
        Flushbar(
          title: 'Inicio de sesion correcto',
          message: '${_currentUser?.email} has iniciado sesion',
          flushbarPosition: FlushbarPosition.TOP,
          margin: const EdgeInsets.all(8),
          borderRadius: BorderRadius.circular(8),
          flushbarStyle: FlushbarStyle.FLOATING,
          duration: const Duration(seconds: 4),
        ).show(context);
      _handleFirebase();
      }
  
      } );
      _googleSignIn.signInSilently();
  }
 void _handleFirebase() async{
    GoogleSignInAuthentication? googleAuth = await _currentUser?.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      idToken: googleAuth?.idToken , accessToken: googleAuth?.accessToken
    );
    final UserCredential credUser = await firebaseAuth.signInWithCredential(credential);
    if(credUser.user != null){
        firebaseuser = credUser.user!;
        setState(() {
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>const Dashboard()));
        });
         
    }
    
  }
Future<void> _handleSignIn() async {
    try {
      
      await _googleSignIn.signIn();
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading:Container(
          height: (MediaQuery.of(context).orientation == Orientation.portrait)? MediaQuery.of(context).size.height*0.15 : MediaQuery.of(context).size.height*0.1, // maximum item width
          width:  (MediaQuery.of(context).orientation == Orientation.portrait)? MediaQuery.of(context).size.width*0.2: MediaQuery.of(context).size.height*0.1, // maximum item width
           decoration:const BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/UTNLOGO.png'),fit: BoxFit.contain),shape: BoxShape.rectangle),),
           title: const Text('Google Sign in'),),
      body: Center(
         child:Column(
          mainAxisAlignment: (MediaQuery.of(context).orientation == Orientation.portrait)?MainAxisAlignment.center:MainAxisAlignment.start,
            children:[ 
             Container(
          height: (MediaQuery.of(context).orientation == Orientation.portrait)? MediaQuery.of(context).size.height*0.35 : MediaQuery.of(context).size.height*0.52, // maximum item width
          width:  (MediaQuery.of(context).orientation == Orientation.portrait)? MediaQuery.of(context).size.width*0.94: MediaQuery.of(context).size.height*0.85, // maximum item width
          decoration:const BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/UTNLOGO.png'),fit: BoxFit.fill),shape: BoxShape.rectangle),
        ),
          SizedBox(
            height: 50,
            width: 150,
            child: FloatingActionButton(
              onPressed:_handleSignIn,
              backgroundColor: Colors.white60,
              elevation: 10,
              child: const Text('Iniciar Sesion'),
            ),
            ),
            
          
            
          
         ])
        ),
        bottomSheet: const Text('Meza Lautaro & Ré Boris',style: TextStyle(fontSize: 20,fontStyle: FontStyle.italic,fontFamily: 'Times New Roman'),),
      );
  }
}





