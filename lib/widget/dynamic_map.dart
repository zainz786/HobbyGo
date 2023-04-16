//Packages used
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'package:geolocator/geolocator.dart';

//Local files used
import 'package:test2/data/club_model.dart';
import 'all_clubs.dart';

class DynamicMap extends StatefulWidget {
  const DynamicMap({Key? key}) : super(key: key);

  @override
  State<DynamicMap> createState() => _DynamicMap();
}

class _DynamicMap extends State<DynamicMap> {
  final Completer<GoogleMapController> _controller = Completer();
  Position? _mapUserPosition;
  late double mapInitialLat;
  late double mapInitialLong;
  double? distanceMeter = 0.0;
  List<Marker> markers = [];
  final List<ClubModel> _fetchedClubs = allClubsData;

  //function to generate markers on the google maps API
  void _createMarkers() {
    for (final club in _fetchedClubs) {
      markers.add(
        Marker(
          markerId: MarkerId(club.name),
          position: LatLng(club.lat, club.long),
          infoWindow: InfoWindow(title: club.name),
        ),
      );
    }
  }

  //Will open the map at the current users location
  Future _getLocation() async {
    _mapUserPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    setState(() {
      mapInitialLat = _mapUserPosition!.latitude;
      mapInitialLong = _mapUserPosition!.longitude;
    });
  }

  @override
  void initState() {
    _getLocation();
    _createMarkers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.indigo,
          title: const Text('Map View'),
        ),
        body: SafeArea(
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: GoogleMap(
              mapType: MapType.normal,
              myLocationButtonEnabled: true,
              myLocationEnabled: true,
              initialCameraPosition: CameraPosition(
                target: LatLng(mapInitialLat, mapInitialLong),
                zoom: 12,
              ),
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
              markers: markers.map((e) => e).toSet(),
            ),
          ),
        ));
  }
}
