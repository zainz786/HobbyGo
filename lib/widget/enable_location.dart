//Packages Used
import 'package:flutter/material.dart';
import 'package:location/location.dart';

//Local Files used
import 'package:test2/widget/all_clubs.dart';

class EnableLocation extends StatefulWidget {
  @override
  State<EnableLocation> createState() {
    // TODO: implement createState
    return _EnableLocationState();
  }
}

class _EnableLocationState extends State<EnableLocation> {
  //Requests users permission to use location once
  void _getUserLocation() async {
    Location location = Location();
    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;
    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }
    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    locationData = await location.getLocation();

    //Will push to all_clubs screen after the button is pressed
    Navigator.of(context).push(MaterialPageRoute(
      builder: ((context) => AllClubs(
            currentUserLat: locationData.latitude,
            currentUserLong: locationData.longitude,
          )),
    ));
  }

  //Screen builder
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HobbyGo'),
        centerTitle: true,
        backgroundColor: Colors.indigo,
      ),
      body: Center(
        child: Container(
          color: Colors.indigo,
          child: TextButton.icon(
            icon: const Icon(Icons.location_on),
            label: const Text(
              'Enable Location',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              _getUserLocation();
              Navigator.of(context).push(MaterialPageRoute(
                builder: ((context) => AllClubs()),
              ));
            },
          ),
        ),
      ),
    );
  }
}
