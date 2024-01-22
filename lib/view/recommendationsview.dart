import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/services.dart' show rootBundle;

class RecommendationsView extends StatefulWidget {
  final Database db;
  final String placeName;
  const RecommendationsView(
      {required this.db, required this.placeName, super.key});

  @override
  State<RecommendationsView> createState() => _RecommendationsViewState();
}

class _RecommendationsViewState extends State<RecommendationsView> {
  Future<Widget> generateContent() async {
    double scrWidth = MediaQuery.of(context).size.width;
    double scrHeight = MediaQuery.of(context).size.height;

    List<Widget> content = [];
    List<Widget> rescont = [];
    var q = await widget.db.query(
      'placeName',
      where: 'placeName LIKE ?',
      whereArgs: ['%${widget.placeName}%'],
      columns: ['id'],
    );
    content.add(
      Container(
        width: scrWidth * 0.7,
        margin: const EdgeInsets.only(top: 10, bottom: 10),
        child: Text(
          'Hotels in ${widget.placeName}',
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontFamily: 'Calibre',
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
    rescont.add(
      Container(
        width: scrWidth * 0.7,
        margin: const EdgeInsets.only(top: 10, bottom: 10),
        child: Text(
          'Restaurants in ${widget.placeName}',
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontFamily: 'Calibre',
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );

    const TextStyle tStyle = TextStyle(
      fontFamily: 'Arial',
      fontSize: 16,
      color: Colors.black,
      fontWeight: FontWeight.bold,
    );

    for (var place in q) {
      var hotelAssocTable = await widget.db.query(
        'hotelAssoc',
        where: 'placeId = ?',
        whereArgs: [place['id'].toString()],
        columns: ['hotelId'],
      );

      for (var hotelAssocRow in hotelAssocTable) {
        var hotelQuery = await widget.db.query(
          'hotel',
          where: 'id_hotel = ?',
          whereArgs: [hotelAssocRow['hotelId'].toString()],
          columns: ['hotelName', 'min', 'max', 'url', 'contact'],
        );

        for (var hotel in hotelQuery) {
          content.add(
            Container(
              width: scrWidth * 0.7,
              height: scrHeight * 0.3,
              margin: const EdgeInsets.only(top: 10, bottom: 10),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                border: Border.all(),
                image: DecorationImage(
                  image: AssetImage(
                      'assets/images/hotels/${hotel['hotelName'].toString()}.jpg'),
                  fit: BoxFit.fill,
                ),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.only(top: 140),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: Color.fromARGB(183, 255, 255, 255),
                    ),
                    child: Column(
                      children: [
                        Text(
                          hotel['hotelName'].toString(),
                          style: tStyle,
                        ),
                        Text(
                          'Price: ${hotel['min'].toString()} - ${hotel['max'].toString()}',
                          style: tStyle,
                        ),
                        Text(
                          'Contact: ${hotel['contact'].toString()}',
                          style: tStyle,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        }
      }

      var resAssocTable = await widget.db.query(
        'resAssoc',
        where: 'placeId = ?',
        whereArgs: [place['id'].toString()],
        columns: ['restaurantId'],
      );

      for (var resAssocRow in resAssocTable) {
        var resQuery = await widget.db.query(
          'restaurants',
          where: 'id = ?',
          whereArgs: [resAssocRow['restaurantId'].toString()],
          columns: ['name', 'min', 'max', 'url', 'contact'],
        );

        for (var res in resQuery) {
          rescont.add(
            Container(
              width: scrWidth * 0.7,
              height: scrHeight * 0.3,
              margin: const EdgeInsets.only(top: 10, bottom: 10),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                border: Border.all(),
                image: DecorationImage(
                  image: AssetImage(
                      'assets/images/restaurants/${res['name'].toString()}.jpg'),
                  fit: BoxFit.fill,
                ),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.only(top: 110),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: Color.fromARGB(183, 255, 255, 255),
                    ),
                    child: Column(
                      children: [
                        Text(
                          res['name'].toString(),
                          style: tStyle,
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          'Price: ${res['min'].toString()} - ${res['max'].toString()}',
                          style: tStyle,
                        ),
                        Text(
                          'Contact: ${res['contact'].toString()}',
                          style: tStyle,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        }
      }
    }

    return Column(
      children: [
        Container(
          margin: const EdgeInsets.all(10),
          child: Column(
            children: [
              Container(
                width: scrWidth * 0.9,
                margin: const EdgeInsets.only(top: 10),
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 255, 255, 255),
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromARGB(255, 57, 156, 173),
                      spreadRadius: 3,
                      blurRadius: 5,
                    )
                  ],
                ),
                child: Column(
                  children: content,
                ),
              ),
              Container(
                width: scrWidth * 0.9,
                margin: const EdgeInsets.only(top: 50),
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 255, 255, 255),
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromARGB(255, 57, 156, 173),
                      spreadRadius: 3,
                      blurRadius: 5,
                    )
                  ],
                ),
                child: Column(
                  children: rescont,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('eSuroy'),
        foregroundColor: Colors.blue,
      ),
      body: ListView(
        children: [
          FutureBuilder(
            future: generateContent(),
            builder: ((context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return snapshot.requireData;
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            }),
          ),
        ],
      ),
    );
  }
}
