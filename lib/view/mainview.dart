import 'package:esuroy/view/destinationsview.dart';
import 'package:esuroy/view/propositionview.dart';
import 'package:esuroy/view/recommendationsview.dart';
import 'package:esuroy/view/reviewsview.dart';
import 'package:esuroy/view/suggestionsview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:esuroy/util/Util.dart';
import 'package:multiselect/multiselect.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  Database? db; // database
  String radioVal = 'hotel'; // initial radio val
  int selectedSearch = 1; // selected search for which the
  List<String> selectedDropDown = [];
  final TextEditingController min = TextEditingController(),
      max = TextEditingController(),
      searchCtrl = TextEditingController();

  Future<Widget> _dropDownWidgetContent(
      double scrWidth, double scrHeight) async {
    var queried = await db!.query(
      'activities',
      columns: ['actName'],
    );

    List<String> actNames = [];

    for (var actName in queried) {
      actNames.add(actName['actName'].toString());
    }

    return Container(
      width: scrWidth * 0.85,
      decoration: const BoxDecoration(
        color: Color.fromARGB(159, 255, 255, 255),
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      padding: const EdgeInsets.all(10),
      child: DropDownMultiSelect(
        onChanged: (p0) {},
        options: actNames,
        selectedValues: selectedDropDown,
        whenEmpty: 'Selected Activities',
        selected_values_style: const TextStyle(
          fontFamily: 'Calibre',
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        childBuilder: (val) {
          return Text(
            '${val.length} Selected Activities',
            style: const TextStyle(
              fontFamily: 'Arial',
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          );
        },
      ),
    );
  }

  Future<Widget> loadImageList(BuildContext context) async {
    double scrWidth = MediaQuery.of(context).size.width;
    double scrHeight = MediaQuery.of(context).size.height;
    if (db == null) {
      return Container(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        width: scrWidth,
        height: scrHeight * 0.30,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: const [Text('Loading...')],
        ),
      );
    }

    List<Widget> list = [];

    var query = await db!.query('placeName', columns: ['placeName']);
    int index = 0;
    for (var col in query) {
      String str = col['placeName'].toString();
      if (index != query.length - 1) {
        str = str.substring(0, str.length - 1);
      }

      str += '.jpg';
      index++;
      list.add(Container(
        width: scrWidth * 0.5,
        height: scrHeight * 0.15,
        margin: const EdgeInsets.fromLTRB(10, 0, 0, 10),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(15)),
          image: DecorationImage(
            image: AssetImage('assets/ImageList/$str'),
            fit: BoxFit.fill,
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(156, 255, 255, 255),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  col['placeName'].toString(),
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ));
    }

    return Container(
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
      width: scrWidth,
      height: scrHeight * 0.30,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: list,
      ),
    );
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
      margin: const EdgeInsets.all(15),
      padding: const EdgeInsets.all(25),
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
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: list,
      ),
    );
  }

  Future<Widget> loadDescription() async {
    String ret = await rootBundle.loadString('assets/text/Description.txt');

    return Container(
      margin: const EdgeInsets.all(15),
      padding: const EdgeInsets.all(25),
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

  void initDatabaseInfo() async {
    db = await Utility.initDatabase();
    Utility.initTables().then((value) => {setState(() {})});
  }

  @override
  void initState() {
    super.initState();
    initDatabaseInfo();
  }

  @override
  void dispose() {
    min.dispose();
    max.dispose();
    searchCtrl.dispose();
    db!.close();
    super.dispose();
  }

  Widget _content(double scrWidth, double scrHeight, BuildContext context) {
    switch (selectedSearch) {
      case 1:
        return Container(
          width: scrWidth,
          height: scrHeight * 0.55,
          margin: const EdgeInsets.only(left: 10, right: 10),
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
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
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
                  width: scrWidth * 0.8,
                  padding: const EdgeInsets.all(5),
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    color: const Color.fromARGB(192, 238, 240, 242),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Hotel',
                        style: TextStyle(
                          fontFamily: 'Calibre',
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(219, 18, 17, 17),
                        ),
                      ),
                      Radio(
                        value: 'hotel',
                        groupValue: radioVal,
                        onChanged: (value) {
                          debugPrint('Hotel Selected!');
                          setState(() {
                            radioVal = 'hotel';
                          });
                        },
                      ),
                      const Text(
                        'Restaurant',
                        style: TextStyle(
                          fontFamily: 'Calibre',
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(219, 10, 10, 10),
                        ),
                      ),
                      Radio(
                        value: 'restaurant',
                        groupValue: radioVal,
                        onChanged: (value) {
                          debugPrint('Restaurant Selected!');
                          setState(() {
                            radioVal = 'restaurant';
                          });
                        },
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
                  margin: const EdgeInsets.only(
                    left: 10,
                    right: 10,
                  ),
                  width: scrWidth,
                  height: scrHeight * 0.1,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(193, 255, 255, 255),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(width: 2),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const Text(
                        'Budget Range: ',
                        style: TextStyle(
                          fontFamily: 'Arial',
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(
                        width: scrWidth * 0.25,
                        height: scrHeight * 0.05,
                        child: TextField(
                          controller: min,
                          textAlign: TextAlign.left,
                          textAlignVertical: TextAlignVertical.center,
                          keyboardType: const TextInputType.numberWithOptions(),
                          decoration: const InputDecoration(
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
                        width: scrWidth * 0.25,
                        height: scrHeight * 0.05,
                        child: TextField(
                          controller: max,
                          textAlign: TextAlign.left,
                          textAlignVertical: TextAlignVertical.center,
                          keyboardType: const TextInputType.numberWithOptions(),
                          decoration: const InputDecoration(
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
                  width: scrWidth * 0.4,
                  height: scrHeight * 0.07,
                  padding: const EdgeInsets.only(top: 10),
                  child: IconButton.filled(
                    style: const ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(
                        Color.fromARGB(217, 255, 255, 255),
                      ),
                      foregroundColor: MaterialStatePropertyAll(
                        Color.fromARGB(141, 0, 0, 0),
                      ),
                      shape: MaterialStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(20),
                          ),
                        ),
                      ),
                      side: MaterialStatePropertyAll(
                        BorderSide(width: 2),
                      ),
                    ),
                    onPressed: () async {
                      debugPrint('MIN: ${min.text} MAX: ${max.text}');
                      int minVal = int.parse(min.text);

                      int maxVal = int.parse(max.text);

                      var queried = await db!.query(
                          radioVal == 'hotel' ? 'hotel' : 'restaurants',
                          distinct: true,
                          columns: [radioVal == 'hotel' ? 'hotelName' : 'name'],
                          where: '(max <= ? AND max >= ?)',
                          whereArgs: [maxVal, minVal]);
                      debugPrint('Content Count: ${queried.length}');
                      debugPrint('Content: ${queried.toString()}');

                      List<String> name = [];
                      queried.forEach((val) {
                        name.add(val.values.toList().first.toString());
                      });
                      debugPrint('Array: ${name.toString()}');
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SuggestionsView(
                            hotelNames: name,
                            resNames: name,
                            db: db!,
                            selected: radioVal == 'hotel' ? 1 : 2,
                          ),
                        ),
                      );
                    },
                    icon: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          'Search',
                          style: TextStyle(
                            color: Color.fromARGB(192, 0, 0, 0),
                            fontFamily: 'Arial',
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Icon(
                          Icons.search,
                          size: 24,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
        break;

      case 2:
        return Container(
          width: scrWidth,
          height: scrHeight * 0.55,
          margin: const EdgeInsets.only(left: 10, right: 10),
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
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
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
                SizedBox(
                  width: scrWidth * 0.65,
                  height: scrHeight * 0.075,
                  child: TextField(
                    controller: searchCtrl,
                    textAlign: TextAlign.left,
                    textAlignVertical: TextAlignVertical.center,
                    keyboardType: TextInputType.name,
                    decoration: const InputDecoration(
                      hintText: 'Mabua',
                      labelText: 'Place',
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      filled: true,
                      fillColor: Color.fromARGB(208, 255, 255, 255),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  width: scrWidth * 0.35,
                  padding: const EdgeInsets.only(top: 20),
                  child: IconButton.filled(
                    style: const ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(
                        Color.fromARGB(217, 255, 255, 255),
                      ),
                      foregroundColor: MaterialStatePropertyAll(
                        Color.fromARGB(141, 0, 0, 0),
                      ),
                      shape: MaterialStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(20),
                          ),
                        ),
                      ),
                      side: MaterialStatePropertyAll(
                        BorderSide(width: 2),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RecommendationsView(
                            placeName: searchCtrl.text,
                            db: db!,
                          ),
                        ),
                      );
                    },
                    icon: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          'Search',
                          style: TextStyle(
                            color: Color.fromARGB(192, 0, 0, 0),
                            fontFamily: 'Arial',
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Icon(
                          Icons.search,
                          size: 24,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
        break;
      case 3:
        return Container(
          width: scrWidth,
          height: scrHeight * 0.55,
          margin: const EdgeInsets.only(left: 10, right: 10),
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
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
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
                FutureBuilder(
                    future: _dropDownWidgetContent(scrWidth, scrHeight),
                    builder: ((context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return snapshot.requireData;
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    })),
                Container(
                  width: scrWidth * 0.35,
                  padding: const EdgeInsets.only(top: 20),
                  child: IconButton.filled(
                    style: const ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(
                        Color.fromARGB(217, 255, 255, 255),
                      ),
                      foregroundColor: MaterialStatePropertyAll(
                        Color.fromARGB(141, 0, 0, 0),
                      ),
                      shape: MaterialStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(20),
                          ),
                        ),
                      ),
                      side: MaterialStatePropertyAll(
                        BorderSide(width: 2),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PropositionView(
                            selected: selectedDropDown,
                          ),
                        ),
                      );
                    },
                    icon: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          'Confirm',
                          style: TextStyle(
                            color: Color.fromARGB(192, 0, 0, 0),
                            fontFamily: 'Arial',
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Icon(
                          Icons.search,
                          size: 24,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
        break;
    }

    return const Center(
      child: Text('No Content'),
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
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/logo/splash.png'),
                  fit: BoxFit.fill,
                ),
                color: Colors.blue,
              ),
              child: Text('eSuroy'),
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
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DestinationsView(db: db!)));
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
            ListTile(
              title: const Text('Reviews'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ReviewsView(db: db!)));
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
                height: scrHeight * 0.07,
                margin: const EdgeInsets.fromLTRB(10, 10, 10, 8),
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 255, 255, 255),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromARGB(255, 57, 156, 173),
                      spreadRadius: 1,
                      blurRadius: 1,
                    ),
                  ],
                ),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        width: scrWidth * 0.25,
                        margin: const EdgeInsets.only(top: 5, bottom: 5),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 255, 255, 255),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                          border: Border.all(),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.hotel),
                          onPressed: () {
                            setState(() {
                              selectedSearch = 1;
                            });
                          },
                          color:
                              selectedSearch == 1 ? Colors.blue : Colors.black,
                        ),
                      ),
                      Container(
                        width: scrWidth * 0.25,
                        margin: const EdgeInsets.only(top: 5, bottom: 5),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 255, 255, 255),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                          border: Border.all(),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.place),
                          onPressed: () {
                            setState(() {
                              selectedSearch = 2;
                            });
                          },
                          color:
                              selectedSearch == 2 ? Colors.blue : Colors.black,
                        ),
                      ),
                      Container(
                        width: scrWidth * 0.25,
                        margin: const EdgeInsets.only(top: 5, bottom: 5),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 255, 255, 255),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                          border: Border.all(),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.hiking_rounded),
                          onPressed: () {
                            setState(() {
                              selectedSearch = 3;
                            });
                          },
                          color:
                              selectedSearch == 3 ? Colors.blue : Colors.black,
                        ),
                      ),
                    ]),
              ),
              _content(scrWidth, scrHeight, context),
              Container(
                padding: const EdgeInsets.only(top: 5, left: 10, right: 10),
                margin: const EdgeInsets.fromLTRB(10, 30, 10, 10),
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 207, 244, 245),
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromARGB(255, 57, 156, 173),
                      spreadRadius: 3,
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Text(
                      'Surigao City Attractions',
                      textAlign: TextAlign.left,
                      maxLines: 1,
                      style: TextStyle(
                          color: Color.fromARGB(255, 0, 0, 0),
                          fontFamily: 'Arial',
                          fontSize: 28,
                          fontWeight: FontWeight.bold),
                    ),
                    FutureBuilder(
                        future: loadImageList(context),
                        builder: ((context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            return snapshot.requireData;
                          } else {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                        })),
                  ],
                ),
              ),
            ],
          ),
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
              }),
            ),
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
