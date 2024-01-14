import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  late String description;

  Future<Widget> loadImageList(BuildContext context) async {
    double scrWidth = MediaQuery.of(context).size.width;
    double scrHeight = MediaQuery.of(context).size.height;
    String ret = await rootBundle.loadString('assets/text/PlacesList.txt');
    List<Widget> list = [];

    ret.split(',').forEach((fileName) {
      list.add(Container(
        width: scrWidth * 0.5,
        height: scrHeight * 0.15,
        margin: const EdgeInsets.fromLTRB(10, 0, 0, 10),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(15)),
          image: DecorationImage(
            image: AssetImage('assets/ImageList/$fileName.jpg'),
            fit: BoxFit.fill,
          ),
        ),
      ));
    });

    return Container(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
      width: scrWidth,
      height: scrHeight * 0.30,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: list,
      ),
    );
  }

  Future<String> loadCSV({required String fileName}) async {
    return await rootBundle.loadString('assets/csv/$fileName.csv');
  }

  Future<Widget> loadExtra() async {
    String ret = await rootBundle.loadString('assets/text/Extra.txt');
    List<Widget> list = [];
    ret.split(',').forEach((str) {
      int count = 2;
      str.split('\n').forEach((element) {
        if (count % 2 == 0) {
          list.add(Text(
            element,
            textAlign: TextAlign.right,
            style: const TextStyle(
              fontFamily: 'Calibre',
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ));
        } else {
          list.add(Text(
            element,
            style: const TextStyle(
              fontFamily: 'Arial',
              fontSize: 14,
              fontWeight: FontWeight.normal,
            ),
          ));
        }
        count++;
      });
    });

    list.add(const Center(
      child: Text(
        '\nTransportations',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontFamily: 'Calibre',
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
    ));
    list.add(Container(
      padding: const EdgeInsets.only(top: 10),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Motorcycle'),
                Icon(Icons.motorcycle),
              ],
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Boat'),
              Icon(Icons.sailing),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Bus'),
              Icon(Icons.bus_alert),
            ],
          ),
        ],
      ),
    ));

    return Container(
      padding: const EdgeInsets.only(top: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: list,
      ),
    );
  }

  Future<Widget> loadDescription() async {
    String ret = await rootBundle.loadString('assets/text/Description.txt');

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        color: Color.fromARGB(98, 63, 134, 216),
      ),
      padding: const EdgeInsets.only(top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Discover Surigao City',
            textAlign: TextAlign.left,
            style: TextStyle(
              fontFamily: 'Calibre',
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            ret,
            textAlign: TextAlign.justify,
            style: const TextStyle(
              fontFamily: 'Arial',
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  void initSQL() async {
    var databasesPath = await getDatabasesPath();
    String res = await loadCSV(fileName: 'hotel');
    String deals = await loadCSV(fileName: 'deals');
    String path = join(databasesPath, 'esuroy.db');
    var db = await openDatabase(path);

    var exist =
        await db.rawQuery('SELECT * FROM sqlite_master WHERE name="hotel"');

    if (exist.isEmpty) {
      await db.execute(
          'CREATE TABLE hotel (id_hotel INTEGER, hotelName TEXT, min INTEGER, max INTEGER)');
    }
    //await db.delete('hotel');
    var count = await db.query('hotel');

    if (count.isEmpty) {
      List<Map<String, dynamic>> map = [];
      var columName = res.split('\n').first.split(',');

      res.split('\n').forEach((line) {
        int index = 0;
        debugPrint('Line: $line');
        Map<String, dynamic> l = {};
        line.split(',').forEach((str) {
          l[columName[index]] = str;
          debugPrint('Content: $str');
          debugPrint('SQL: ${columName[index]} : $str');

          index++;
        });
        map.add(l);
      });

      map.removeAt(0);

      for (var c in map) {
        await db.insert('hotel', c);
        debugPrint('INSERT: $c');
      }
      debugPrint('Insert Success!');
    } else {
      count.forEach((element) {
        debugPrint(element.toString());
      });
    }

    var t2 =
        await db.rawQuery('SELECT * FROM sqlite_master WHERE name="deals"');

    if (t2.isEmpty) {
      await db.execute(
          'CREATE TABLE deals (id_deals INTEGER, id_hotels INTEGER, id_res INTEGER, id_acts INTEGER, id_place INTEGER)');
    }

    var count2 = await db.query('deals');

    if (count2.isEmpty) {
      List<Map<String, dynamic>> map = [];
      var columName = deals.split('\n').first.split(',');

      deals.split('\n').forEach((line) {
        int index = 0;
        debugPrint('Line: $line');
        Map<String, dynamic> l = {};
        line.split(',').forEach((str) {
          l[columName[index]] = str;
          debugPrint('Content: $str');
          debugPrint('SQL: ${columName[index]} : $str');

          index++;
        });
        map.add(l);
      });

      map.removeAt(0);

      for (var c in map) {
        await db.insert('deals', c);
        debugPrint('INSERT: $c');
      }
      debugPrint('Insert Success!');
    } else {
      count.forEach((element) {
        debugPrint(element.toString());
      });
    }
  }

  @override
  void initState() {
    super.initState();

    initSQL();
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
      drawer: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text('Selections'),
            ),
            ListTile(
              title: const Text('Deals'),
              onTap: () {
                Navigator.pushNamed(context, '/dealsview');
              },
            ),
            ListTile(
              title: const Text('Destinations'),
              onTap: () {
                Navigator.pushNamed(context, '/destinationsview');
              },
            ),
            ListTile(
              title: const Text('About Us'),
              onTap: () {
                Navigator.pushNamed(context, '/aboutusview');
              },
            ),
            ListTile(
              title: const Text('Contact Us'),
              onTap: () {
                Navigator.pushNamed(context, '/contactusview');
              },
            ),
          ],
        ),
      ),
      body: ListView(
        children: [
          Column(
            children: [
              Container(
                width: scrWidth,
                height: scrHeight * 0.45,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(25)),
                  image: DecorationImage(
                    image: AssetImage('assets/mabua_splash.jpg'),
                    fit: BoxFit.fill,
                  ),
                ),
                child: Container(
                  padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                        child: const Text(
                          'eSuroy',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Arial',
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: const Text(
                          'EXPLORE THE BEAUTY\nOF SURIGAO CITY',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Arial',
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        //padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                        width: scrWidth * 0.8,
                        height: scrHeight * 0.1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            SizedBox(
                              width: scrWidth * 0.4,
                              height: scrHeight * 0.05,
                              child: const TextField(
                                textAlign: TextAlign.left,
                                textAlignVertical: TextAlignVertical.center,
                                keyboardType: TextInputType.numberWithOptions(),
                                decoration: InputDecoration(
                                  hintText: '1000',
                                  label: Text('Min'),
                                  filled: true,
                                  fillColor: Color.fromARGB(208, 255, 255, 255),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(45),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: scrWidth * 0.4,
                              height: scrHeight * 0.05,
                              child: const TextField(
                                textAlign: TextAlign.left,
                                textAlignVertical: TextAlignVertical.center,
                                keyboardType: TextInputType.numberWithOptions(),
                                decoration: InputDecoration(
                                  hintText: '3500',
                                  label: Text('Max'),
                                  filled: true,
                                  fillColor: Color.fromARGB(208, 255, 255, 255),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(45),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(top: 2),
                        child: IconButton.filled(
                          onPressed: () {},
                          icon: const Icon(Icons.search),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(0, 25, 30, 10),
                child: const Text(
                  'Surigao City Attractions',
                  textAlign: TextAlign.left,
                  maxLines: 1,
                  style: TextStyle(
                      color: Colors.blue,
                      fontFamily: 'Arial',
                      fontSize: 28,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          FutureBuilder(
              future: loadImageList(context),
              builder: ((context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return snapshot.requireData;
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              })),
          Container(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
            child: FutureBuilder(
                future: loadDescription(),
                builder: ((context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return snapshot.requireData;
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                })),
          ),
          FutureBuilder(
              future: loadExtra(),
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
