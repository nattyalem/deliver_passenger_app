import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:koooly_user/constants/data_constants.dart';

class PushNotificationService {
  DatabaseReference newRideRequestRef =
      FirebaseDatabase.instance.ref('Ride Requests');

  Future initialize() async {
    FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
    firebaseMessaging.getInitialMessage();

    String? token = await firebaseMessaging.getToken();

    print('this is token' + token.toString());

    userRef.child(firebaseUser!.uid).child('token').set(token.toString());
    firebaseMessaging.subscribeToTopic('alldrivers');
    firebaseMessaging.subscribeToTopic('allusers');

    FirebaseMessaging.onMessage.listen((message) {
      handleForgroundByLocalNotification(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      handleForgroundByLocalNotification(message);
    });
  }

  void handleForgroundByLocalNotification(RemoteMessage message) {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher')));

    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
        'channel-id', 'fcm',
        visibility: NotificationVisibility.public,
        importance: Importance.max,
        priority: Priority.high);
    var iOSPlatformChannelSpecifics = const DarwinNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);
    flutterLocalNotificationsPlugin.show(
      0,
      message.notification!.title.toString(),
      message.notification!.body.toString(),
      platformChannelSpecifics,
      payload: 'fcm',
    );
  }
}
