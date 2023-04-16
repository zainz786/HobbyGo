//Packages used
import 'package:flutter/material.dart';

//Local files used
import 'package:test2/data/club_model.dart';

class ClubDetails extends StatelessWidget {
  final ClubModel club;
  ClubDetails({Key? key, required this.club}) : super(key: key);
  List<ClubModel> details = [];

  //Building the club detail page when a club object is
  //clicked on the gridview in all_clubs
  @override
  Widget build(BuildContext context) {
    var widthPage = MediaQuery.of(context).size.width;
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.arrow_back_rounded),
            ),
          ],
          title: Text(club.name),
          backgroundColor: Colors.indigo,
        ),
        body: ListView(
          padding: const EdgeInsets.all(10),
          children: [
            Container(
              width: widthPage,
              child: Text(
                club.name,
                style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(
              height: 15,
              width: 15,
            ),
            Container(
              width: widthPage * 0.9,
              child: Image.network(
                club.image,
                fit: BoxFit.fill,
              ),
            ),
            Container(
              width: widthPage,
              child: Text(
                club.address,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54,
                ),
                textAlign: TextAlign.start,
              ),
            ),
            Container(
              width: widthPage,
              child: Text(
                club.postcode,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54,
                ),
                textAlign: TextAlign.start,
              ),
            ),
            Container(
              width: widthPage,
              child: Text(
                club.description,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54,
                ),
                textAlign: TextAlign.start,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
