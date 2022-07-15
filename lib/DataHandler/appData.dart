import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:driver_rnd_app/Models/address.dart';

class AppData extends ChangeNotifier {
  Address pickUpLocation =
      Address(placeName: '', longitude: 0.0, latitude: 0.0);
  Address dropOffLocation =
      Address(placeName: '', longitude: 0.0, latitude: 0.0);
  //Address pickUpLocation, dropOffLocation;

  void updatePickUpLocationAddress(Address pickUpAddress) {
    pickUpLocation = pickUpAddress;
    notifyListeners();
  }

  void updateDropOffLocationAddress(Address dropOffAddress) {
    dropOffLocation = dropOffAddress;
    notifyListeners();
  }
}
