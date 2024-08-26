import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rflutter_alert/rflutter_alert.dart';





Future<void>handleBackgroundMessage(RemoteMessage message) async{
      message.notification?.title ?? "Sin titulo";
      message.notification?.body ?? "Sin cuerpo";
}
class FirebaseApi{
  final _firebaseMessaging = FirebaseMessaging.instance;
  final _androidChannel = const AndroidNotificationChannel('high_importance_channel', 'High_notifications',description: 'esto es una notificacion combinada',importance: Importance.max);
  final  _localNotificationsPlugin =   FlutterLocalNotificationsPlugin();
    
Future<void> initPushNotifications() async {

  // token dHrSgBgBSVGA-v7-2zTMTf:APA91bHb68LELgSsBkRzyDyTSHAN3GCdCHmlm59dycBWb3v9LlUlJlKyohIkTH6eNnE7FiUnADGBIIh63Jx-V6IOv5Mp5z-zwW4Vu28F_-2XpjU2TIiXWZi5lG0W8lHRUFBH8MWbuefT
  
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
          alert: true,
          badge: true,
           sound: true,          
          ); 
  FirebaseMessaging.instance.getInitialMessage().then(handleMessage);
  FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
  FirebaseMessaging.onMessage.listen((message) {
  FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
    final notification = message.notification;
    if(notification ==null) return;
      showNotification(notification.hashCode,notification.title,notification.body);

  });
}
void handleMessage(RemoteMessage? message){
  if(message == null) return;
}
Future<void>initNotifications() async{
    await _firebaseMessaging.requestPermission();
 // final fCMToken = await _firebaseMessaging.getToken();
  initPushNotifications();
  initLocalNotifications();
  
}

Future<void> initLocalNotifications() async{
  const AndroidInitializationSettings initializationSettingsAndroid = 
    AndroidInitializationSettings('app_icon');
  
  const DarwinInitializationSettings initializationSettingsIOS =
    DarwinInitializationSettings();
  
  const InitializationSettings initializationSettings= InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
   );
   await _localNotificationsPlugin.initialize(initializationSettings,onDidReceiveNotificationResponse:(payload){final message = RemoteMessage.fromMap(jsonDecode(payload as String));handleBackgroundMessage(message);});
  final platform = _localNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
  await platform?.createNotificationChannel(_androidChannel);
  }
Future<void> showNotification(int code, String? title, String? body) async {
  
      _localNotificationsPlugin.show(
    code,
    title,
    body,
    NotificationDetails(
      android: AndroidNotificationDetails(
                _androidChannel.id,
                _androidChannel.name,
                channelDescription: _androidChannel.description,
                icon: 'app_icon'),
    ),
    
    );

}
}

