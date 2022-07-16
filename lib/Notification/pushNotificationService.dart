import 'package:driver_rnd_app/configMaps.dart';
import 'package:driver_rnd_app/main.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class PushNotificationService
{
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging();

  Future initialize() async
  {
    firebaseMessaging . configure(
        onMessage: (Map<String, dynamic> message) async {
      print(" onMessage: $message");

    },

      onLaunch: (Map<String, dynamic> message ) async {
        print("onLaunch: Smessage");

      },
      onResume : (Map<String, dynamic> message ) async {
  print("onResume: Smessage" ) ;

  },
    );
  }

  Future<String> getToken() async
  {
    String token = await firebaseMessaging.getToken();
    databaseReference.child(currentfirebaseUser.uid).child("token").set(token);
    print("This is token : "+token.toString());

    firebaseMessaging.subscribeToTopic("alldrivers");
    firebaseMessaging.subscribeToTopic("allusers");
  }
}