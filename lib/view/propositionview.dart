import 'package:esuroy/util/Util.dart';
import 'package:flutter/material.dart';

class PropositionView extends StatefulWidget {
  final List<String> selected;
  const PropositionView({required this.selected, super.key});

  @override
  State<PropositionView> createState() => _PropositionViewState();
}

class _PropositionViewState extends State<PropositionView> {
  Future<Widget> _content(double scrWidth, double scrHeight) async {
    List<Widget> ret = [];
    List<String> placeNames = [];
    ret.add(Container(
      margin: const EdgeInsets.only(top: 10, bottom: 20),
      child: const Text(
        'Places with the activities selected',
        style: TextStyle(
          fontFamily: 'Calibre',
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    ));
    debugPrint('selected Count ${widget.selected.length}');
    for (var name in widget.selected) {
      var queryActIDs = await Utility.db!.query(
        'activities',
        columns: ['id'],
        where: 'actName = ?',
        whereArgs: [name],
      );

      for (var actIDs in queryActIDs) {
        var queryPlaceIds = await Utility.db!.query(
          'ids',
          columns: ['placeId'],
          where: 'actId = ?',
          whereArgs: [actIDs['id'].toString()],
        );

        for (var placeId in queryPlaceIds) {
          var queryPlaceName = await Utility.db!.query(
            'placeName',
            columns: ['placeName'],
            where: 'id = ?',
            whereArgs: [placeId['placeId'].toString()],
          );

          if (!placeNames
              .contains(queryPlaceName.first['placeName'].toString())) {
            debugPrint(
                'added: ${queryPlaceName.first['placeName'].toString()}');

            placeNames.add(queryPlaceName.first['placeName'].toString());
          }
        }
      }
    }

    for (var placeName in placeNames) {
      String fileName = placeName.substring(0, placeName.length - 1);
      debugPrint('Filename: $fileName');
      ret.add(
        Container(
          width: scrWidth * 0.8,
          height: scrHeight * 0.25,
          margin: const EdgeInsets.only(top: 10, bottom: 10),
          padding: const EdgeInsets.only(top: 10),
          decoration: BoxDecoration(
            border: Border.all(),
            color: const Color.fromARGB(188, 255, 255, 255),
            borderRadius: BorderRadius.circular(15),
            image: DecorationImage(
              image: AssetImage('assets/ImageList/$fileName.jpg'),
              fit: BoxFit.fill,
            ),
          ),
          child: Text(
            placeName,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'Arial',
              fontSize: 14,
              fontWeight: FontWeight.bold,
              backgroundColor: Color.fromARGB(173, 255, 255, 255),
            ),
          ),
        ),
      );
    }

    debugPrint('Lenght: ${ret.length}');

    return Container(
      width: scrWidth * 0.85,
      margin: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
        color: Color.fromARGB(253, 252, 252, 252),
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
        children: ret,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double scrWidth = MediaQuery.of(context).size.width;
    double scrHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text('eSuroy'),
        foregroundColor: Colors.blue,
      ),
      body: ListView(
        children: [
          FutureBuilder(
              future: _content(scrWidth, scrHeight),
              builder: ((context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return snapshot.requireData;
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              })),
        ],
      ),
    );
  }
}
