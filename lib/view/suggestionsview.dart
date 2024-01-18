import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:map_launcher/map_launcher.dart';

class SuggestionsView extends StatefulWidget {
  final List<String> hotelNames;
  final List<String> resNames;
  final Database db;
  final int selected;
  const SuggestionsView({
    required this.hotelNames,
    required this.resNames,
    required this.db,
    required this.selected,
    super.key,
  });

  @override
  State<SuggestionsView> createState() => _SuggestionsViewState();
}

class _SuggestionsViewState extends State<SuggestionsView> {
  Future<Widget> assemblyPage(
    BuildContext context,
  ) async {
    double scrWidth = MediaQuery.of(context).size.width;
    double scrHeight = MediaQuery.of(context).size.height;
    List<Widget> widgets = [];
    widgets.add(
      Padding(
        padding: const EdgeInsets.only(
          top: 20,
          bottom: 20,
        ),
        child: Text(
          widget.selected == 1 ? 'Hotel Suggestion' : 'Restaurant Suggestion',
          style: const TextStyle(
            fontFamily: 'Calibre',
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );

    if (widget.hotelNames.isEmpty) {
      widgets.add(Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          color: Color.fromARGB(98, 63, 134, 216),
        ),
        child: Text(
          'No ${widget.selected == 1 ? 'hotels' : 'restaurant'} found for that price range',
          style: const TextStyle(
            fontFamily: 'Calibre',
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ));
    } else {
      if (widget.selected == 1) {
        for (var name in widget.hotelNames) {
          int min = 0, max = 0;
          debugPrint(name);
          var q = await widget.db.query('hotel',
              distinct: true,
              limit: 1,
              columns: ['min', 'max', 'lat', 'long'],
              where: 'hotelName = ?',
              whereArgs: [name]);

          widgets.add(
            Container(
              width: scrWidth * 0.8,
              height: scrHeight * 0.4,
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.only(top: 10, bottom: 10),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: Color.fromARGB(98, 63, 134, 216),
                      spreadRadius: 5,
                      blurRadius: 1)
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                    width: scrWidth * 0.8,
                    height: scrHeight * 0.25,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/images/hotels/$name.jpg'),
                          fit: BoxFit.fill),
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.image_rounded,
                        color: Color.fromARGB(0, 255, 255, 255),
                      ),
                      onPressed: () async {
                        debugPrint('Pressed $name');
                        final availableMaps = await MapLauncher.installedMaps;
                        await availableMaps.first.showMarker(
                          coords: Coords(
                              double.parse(q.first['lat'].toString()),
                              double.parse(q.first['long'].toString())),
                          title: name,
                        );
                      },
                    ),
                  ),
                  Text(
                    name,
                    style: const TextStyle(
                      fontFamily: 'Arial',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text('Price: P${q.first['min']} - P${q.first['max']}'),
                ],
              ),
            ),
          );
        }
      } else {
        for (var name in widget.resNames) {
          debugPrint('Creating widget for $name');
          var q = await widget.db.query(
            'restaurants',
            distinct: true,
            limit: 1,
            columns: ['min', 'max', 'lat', 'long'],
            where: 'name = ?',
            whereArgs: [name],
          );

          widgets.add(
            Container(
              width: scrWidth * 0.8,
              height: scrHeight * 0.4,
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.only(top: 10, bottom: 10),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: Color.fromARGB(98, 63, 134, 216),
                      spreadRadius: 5,
                      blurRadius: 1)
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                    width: scrWidth * 0.8,
                    height: scrHeight * 0.25,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image:
                              AssetImage('assets/images/restaurants/$name.jpg'),
                          fit: BoxFit.fill),
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.image_rounded,
                        color: Color.fromARGB(0, 255, 255, 255),
                      ),
                      onPressed: () async {
                        debugPrint('Pressed $name');
                        final availableMaps = await MapLauncher.installedMaps;
                        await availableMaps.first.showMarker(
                          coords: Coords(
                              double.parse(q.first['lat'].toString()),
                              double.parse(q.first['long'].toString())),
                          title: name,
                        );
                      },
                    ),
                  ),
                  Text(
                    name,
                    style: const TextStyle(
                      fontFamily: 'Arial',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text('Price: P${q.first['min']} - P${q.first['max']}'),
                ],
              ),
            ),
          );
          debugPrint('n: ${widgets.length}');
        }
      }
    }
    debugPrint('Count: ${widgets.length}');

    return ListView(
      children: [
        Column(
          children: widgets,
        ),
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
      body: FutureBuilder(
        future: assemblyPage(context),
        builder: ((context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return snapshot.requireData;
          }

          return const Center(child: CircularProgressIndicator());
        }),
      ),
    );
  }
}
