import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';

void main() {
  runApp(MaterialApp(home: GeoListenPage()));
}

class GeoListenPage extends StatefulWidget {
  @override
  _GeoListenPageState createState() => _GeoListenPageState();
}

class _GeoListenPageState extends State<GeoListenPage> {
  Geolocator geolocator = Geolocator();
  int x = 0;
  Position userLocation;
  List<Position> list = [];
  double _distance;
  double _diss = 0.0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getLocation().then((position) {
      userLocation = position;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            userLocation == null
                ? CircularProgressIndicator()
                : Text("Distance mta3 si:" + _diss.toString()),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: RaisedButton(
                onPressed: () {
                  Geolocator.getPositionStream().listen((position) async {
                    setState(() {
                      userLocation = position;
                      list.add(position);
                      x++;
                    });
                    if (list.length > 2) {
                      _getDistance();
                      _diss += _distance;
                    }
                  });
                },
                color: Colors.blue,
                child: Text(
                  "Get Location",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<Position> _getLocation() async {
    var currentLocation;
    try {
      currentLocation = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);
    } catch (e) {
      currentLocation = null;
    }
    return currentLocation;
  }

  Future<double> _getDistance() async {
    var distance;
    distance = await Geolocator.distanceBetween(
        list[list.length - 1].latitude,
        list[list.length - 1].longitude,
        list[list.length - 2].latitude,
        list[list.length - 2].longitude);
    print(distance);
    setState(() {
      _distance = distance;
    });
  }
}
