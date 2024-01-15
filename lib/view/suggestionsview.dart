import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class SuggestionsView extends StatefulWidget {
  final List<String> hotelNames;
  final Database db;
  const SuggestionsView({
    required this.hotelNames,
    required this.db,
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
      const Text(
        'Hotel Suggestion',
        style: TextStyle(
          fontFamily: 'Calibre',
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    );

    widget.hotelNames.forEach((name) async {
      int min = 0, max = 0;
      var q = await widget.db.query('hotel',
          distinct: true,
          limit: 1,
          columns: ['min', 'max'],
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
            color: Color.fromARGB(98, 63, 134, 216),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                child: SizedBox(
                  width: scrWidth * 0.8,
                  height: scrHeight * 0.25,
                  child: Image(
                    image: AssetImage('assets/images/hotels/$name.jpg'),
                    fit: BoxFit.fill,
                  ),
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
    });

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
        body: FutureBuilder(
            future: assemblyPage(context),
            builder: ((context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return snapshot.requireData;
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            })));
  }
}
