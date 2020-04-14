import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

////////////////////////////////////////////////
/// GPS and location helpers
////////////////////////////////////////////////

Future<double> getDistanceBetween(LatLng firstPoint, LatLng secondPoint) async {
  double distanceInMeters = await Geolocator().distanceBetween(
      firstPoint.latitude,
      firstPoint.longitude,
      secondPoint.latitude,
      secondPoint.longitude);
  return distanceInMeters;
}

Future<Position> getCurrentLocation() async {
  Position position = await Geolocator()
      .getCurrentPosition(desiredAccuracy: LocationAccuracy.medium);
  return position;
}

////////////////////////////////////////////////
/// Page Navigation pages
////////////////////////////////////////////////

void popPage(BuildContext context) {
  Navigator.of(context).pop();
}

void pushPage(BuildContext context, Widget widget) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => widget));
}

void pushPageReplacement(BuildContext context, Widget widget) {
  Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (context) => widget));
}

////////////////////////////////////////////////
///
////////////////////////////////////////////////
