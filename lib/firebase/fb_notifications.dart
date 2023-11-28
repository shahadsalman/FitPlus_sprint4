import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fitplus/notification/notification.dart';
import 'package:fitplus/src/controller/splash_screens_controller.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import '../screens/home/mainUser.dart';
import "dart:convert";
import 'package:flutter/material.dart';

late FlutterLocalNotificationsPlugin localNotificationsPlugin;

mixin FbNotifications {
  static Future<String> getFcm() async {
    var fcmToken = await FirebaseMessaging.instance.getToken();
    String token = fcmToken.toString();
    print(token);
    return token;
  }

  static Future<void> initNotifications() async {
    localNotificationsPlugin = FlutterLocalNotificationsPlugin();
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/logo');
    const InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid);
    await localNotificationsPlugin.initialize(initializationSettings,);
    getFcm();
    /// foreground notification
    FirebaseMessaging.onMessage.listen((event) async {
      showNotification(event);
      // if(AppController.to.loginMap.isNotEmpty ){
      //  if( AppController.to.loginMap['typeAccount'] ==2){
      //    Get.offAll(()=>const NotificationScreen());
      //  }
      //  else if (event.data.containsKey('gymId')) {
      //    String gymId = event.data['gymId'];
      //    Get.offAll(() => MainUser(key: GlobalKey(), gymId: gymId));
      //  }
     // }

      if(event.data['data'] != null && event.data['data'].isNotEmpty){
      }
    });

    /// after click notification run this code
   // FirebaseMessaging.onMessageOpenedApp.listen((event) {

     // showNotification(event);
     // if(event.data['keyname'].isNotEmpty){
    //  }
   // });
   FirebaseMessaging.onMessageOpenedApp.listen((event) {
    //   showNotification(event);
      if(event.data['data'] != null && event.data['data'].isNotEmpty){
        Get.to(()=>const NotificationScreen());
        print(event.data['data']);
        print('onMessageOpendApp');
        //NotificationScreen()
      }
      else if (event.data.containsKey('gymId')) {
        String gymId = event.data['gymId'];
        print(gymId);
        Get.offAll(() => MainUser(key: GlobalKey(), gymId: gymId));
      }
    });
    /// background notification
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  }
}

void showNotification(RemoteMessage event) {
  /// init local Notification
  var androiInit =
  const AndroidInitializationSettings('@mipmap/logo'); //for logo
  var iosInit = const DarwinInitializationSettings();
  var initSetting = InitializationSettings(android: androiInit, iOS: iosInit);
  localNotificationsPlugin = FlutterLocalNotificationsPlugin();
  localNotificationsPlugin.initialize(initSetting);

  var androidDetails = const AndroidNotificationDetails('1', 'channelName');
  var iosDetails = const DarwinNotificationDetails();
  var generalNotificationDetails =
  NotificationDetails(android: androidDetails, iOS: iosDetails);

  RemoteNotification? notification = event.notification;
  AndroidNotification? android = event.notification?.android;
  if (notification != null && android != null) {
    localNotificationsPlugin.show(notification.hashCode, notification.title,
        notification.body, generalNotificationDetails, payload: jsonEncode(event.data),);
  }
}

Future<void> firebaseMessagingBackgroundHandler(
    RemoteMessage remoteMessage) async {
  print(remoteMessage.data);
  print('firebaseMessagingBackgroundHandler');
}
