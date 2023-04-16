import 'dart:convert';

//packages used for this screen
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:test2/data/club_model.dart';
import 'package:http/http.dart' as http;

//local files used
import './dynamic_map.dart';
import './club_details.dart';

//created a global list of clubs that any screen can access
List<ClubModel> allClubsData = [];

class AllClubs extends StatefulWidget {
  const AllClubs({Key? key, this.currentUserLat, this.currentUserLong})
      : super(key: key);
  final double? currentUserLat;
  final double? currentUserLong;
  @override
  State<AllClubs> createState() => _AllClubsState();
}

class _AllClubsState extends State<AllClubs> {
  Position? _currentUserPosition;
  double? distanceMeter = 0.0;
  final List<ClubModel> _allFectechedClubs = allClubsData;

  //This code is used to build the initial database for the clubs
  //The app was designed for a user interface only therefore the option of adding
  //in clubs would be reserved for an admin interface can be reused to add more clubs
  //another harcoded clubs data file will be required with the same name convention
  // void databaseBuilder() {
  //   final url = Uri.https(
  //       'hobbygo-1af1b-default-rtdb.europe-west1.firebasedatabase.app',
  //       'club-list.json');
  //   for (ClubModel club in allClubsData) {
  //     http.post(
  //       url,
  //       headers: {
  //         'Content-type': 'appilication/json',
  //       },
  //       body: json.encode(
  //         {
  //           'name': club.name,
  //           'image': club.image,
  //           'lat': club.lat,
  //           'long': club.long,
  //           'distance': club.distance,
  //           'address': club.address,
  //           'postcode': club.postcode,
  //           'description': club.description,
  //         },
  //       ),
  //     );
  //   }
  // }

  //this gets the club data from the database
  void _fetchClubs() async {
    final url = Uri.https(
        'hobbygo-1af1b-default-rtdb.europe-west1.firebasedatabase.app',
        'club-list.json');
    final response = await http.get(url);
    final Map<String, dynamic> clubList = json.decode(response.body);
    final List<ClubModel> _fetchedClubsData = [];
    for (final fetchedClub in clubList.entries) {
      _fetchedClubsData.add(
        ClubModel(
          name: fetchedClub.value['name'],
          image: fetchedClub.value['image'],
          address: fetchedClub.value['address'],
          postcode: fetchedClub.value['postcode'],
          description: fetchedClub.value['description'],
          lat: fetchedClub.value['lat'],
          long: fetchedClub.value['long'],
          distance: fetchedClub.value['distance'],
        ),
      );
    }
    setState(() {
      allClubsData = _fetchedClubsData;
    });

    //This calculates the distance between user and club
    _currentUserPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    for (final location in allClubsData) {
      double clubLat = location.lat;
      double clubLong = location.long;

      distanceMeter = Geolocator.distanceBetween(
        _currentUserPosition!.latitude,
        _currentUserPosition!.longitude,
        clubLat,
        clubLong,
      );

      var distance = distanceMeter?.round().toDouble();
      location.distance = (distance! / 1000);

      setState(() {});
    }
  }

  @override
  void initState() {
    //The below function used to initially generate the Global list variable in start up of the application
    _fetchClubs();
    super.initState();
  }

  //this creates the body of the screen, style choices are the main part of this
  //code and can be changed and improved
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.indigo,
        title: const Text('Hobbygo'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const DynamicMap(),
            ),
          );
        },
        backgroundColor: Colors.indigo,
        child: const Icon(Icons.map_outlined),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
          ),
          child: GridView.builder(
            itemCount: allClubsData.length,
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 200,
              childAspectRatio: 3 / 2,
              crossAxisSpacing: 15,
              mainAxisExtent: 200,
            ),
            itemBuilder: (BuildContext context, index) {
              return InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ClubDetails(
                        club: allClubsData[index],
                      ),
                    ),
                  );
                },
                child: Container(
                  height: height * 0.6,
                  width: width * 0.3,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: height * 0.12,
                        width: width,
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15),
                          ),
                          child: Image.network(
                            allClubsData[index].image,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      Container(
                        width: width,
                        color: Colors.indigo,
                        child: Text(
                          allClubsData[index].name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Container(
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(15),
                            bottomRight: Radius.circular(15),
                          ),
                          color: Colors.indigo,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.location_on),
                            Text(
                              '${allClubsData[index].distance.round()} Km',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
