import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:driver_rnd_app/Assistants/requestAssistant.dart';
import 'package:driver_rnd_app/DataHandler/appData.dart';
import 'package:driver_rnd_app/Models/address.dart';
import 'package:driver_rnd_app/Models/directDetails.dart';
import 'package:driver_rnd_app/configMaps.dart';

import '../Models/allUsers.dart';

class AssistantMethods {
  static Future<String> searchCoordinateAddress(
      Position position, context) async {
    String placeAddress = "";
    String st1, st2, st3, st4;
    String url =
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$mapKey";

    var response = await RequestAssistant.getRequest(url);

    if (response != "Failed") {
      String TEST = response.toString();
      print("test" + TEST);
      placeAddress = response["results"][0]["formatted_address"];
      /* st1 = response["results"][0]["address_components"][0]["long_name"];
        st2 = response["results"][0]["address_components"][1]["long_name"];
        st3 = response["results"][0]["address_components"][2]["long_name"];
        st4 = response["results"][0]["address_components"][6]["long_name"];
        placeAddress = st1+", "+st2+", "+st3+", "+st4;*/
      Address userPickUpAddress =
          new Address(placeName: '', longitude: 0.0, latitude: 0.0);
      userPickUpAddress.longitude = position.longitude;
      userPickUpAddress.latitude = position.latitude;
      userPickUpAddress.placeName = placeAddress;
      // print("testLong"+userPickUpAddress.longitude.toString());
      // print("testLong"+userPickUpAddress.latitude.toString());
      Provider.of<AppData>(context, listen: false)
          .updatePickUpLocationAddress(userPickUpAddress);
    }
    return placeAddress;
  }

  static Future<DirectionDetails> obtainPlaceDirectionDetails(
      LatLng initialPosition, LatLng finalPosition) async {
    String directionUrl =
        "https://maps.googleapis.com/maps/api/directions/json?origin=${initialPosition.latitude},${initialPosition.longitude}&destination=${finalPosition.latitude},${finalPosition.longitude}&key=$mapKey";
    print("testInitial" + initialPosition.latitude.toString());
    print("directionUrl" + directionUrl);
    var res = await RequestAssistant.getRequest(directionUrl);

    if (res == "failed") {
      return null;
    }

    DirectionDetails directionDetails = DirectionDetails();

    directionDetails.encodedPoints =
        res["routes"][0]["overview_polyline"]["points"];

    directionDetails.distanceText =
        res["routes"][0]["legs"][0]["distance"]["text"];

    directionDetails.distanceValue =
        res["routes"][0]["legs"][0]["distance"]["value"];

    directionDetails.durationText =
        res["routes"][0]["legs"][0]["duration"]["text"];

    directionDetails.durationValue =
        res["routes"][0]["legs"][0]["duration"]["value"];

    return directionDetails;
  }

  static double calculateFares(DirectionDetails directionDetails) {
    double timeTraveledfare =
        (directionDetails.durationValue ?? 0 / 60) * 0.001;
    double distancTraveledFare =
        (directionDetails.distanceValue ?? 0 / 1000) * 0.001;
    double totalFareAmount = timeTraveledfare + distancTraveledFare;

    double totalLocalAmount = (totalFareAmount * 4.45);
    String test = totalLocalAmount.toStringAsFixed(1);
    totalLocalAmount = double.parse(test);
    return totalLocalAmount;
  }

  static void getCurrentOnlineUserInfo() async {
    firebaseUser = await FirebaseAuth.instance.currentUser;
    String userId = firebaseUser.uid;
    DatabaseReference reference =
        FirebaseDatabase.instance.reference().child("users").child(userId);

    reference.once().then((DataSnapshot dataSnapShot) {
      if (dataSnapShot.value != null)
        userCurrentInfo = Users.fromSnapshot(dataSnapShot);
    });
  }
}
