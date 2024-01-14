import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class DestinationsView extends StatefulWidget {
  const DestinationsView({super.key});

  @override
  State<DestinationsView> createState() => _DestinationsViewState();
}

class _DestinationsViewState extends State<DestinationsView> {
  Future<Widget> loadImageList() async {
    double scrWidth = MediaQuery.of(context).size.width;
    double scrHeight = MediaQuery.of(context).size.height;
    String ret = await rootBundle.loadString('assets/text/PlacesList.txt');
    List<Widget> list = [];

    ret.split(',').forEach((fileName) {
      list.add(Container(
        width: scrWidth * 0.50,
        margin: const EdgeInsets.fromLTRB(10, 0, 0, 10),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(15)),
          image: DecorationImage(
            image: AssetImage('assets/ImageList/$fileName.jpg'),
            fit: BoxFit.fill,
          ),
        ),
        child: IconButton(
          icon: const Icon(
            Icons.image_rounded,
            color: Color.fromARGB(0, 255, 255, 255),
          ),
          onPressed: () {
            debugPrint('Pressed $fileName');
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return SimpleDialog(
                    title: Text('Descriptions'),
                    children: [
                      Text(fileName),
                    ],
                  );
                });
          },
        ),
      ));
    });

    return Container(
      padding: const EdgeInsets.all(2),
      margin: const EdgeInsets.all(5),
      width: scrWidth * 0.9,
      height: scrHeight * 0.2,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: list,
      ),
    );
  }

  Future<Widget> loadImages({required String listName}) async {
    double scrWidth = MediaQuery.of(context).size.width;
    double scrHeight = MediaQuery.of(context).size.height;
    String ret = await rootBundle.loadString('assets/text/${listName}List.txt');
    List<Widget> list = [];

    ret.split(',').forEach((fileName) {
      list.add(Container(
        width: scrWidth * 0.50,
        margin: const EdgeInsets.fromLTRB(10, 0, 0, 10),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(15)),
          image: DecorationImage(
            image: AssetImage('assets/images/$listName/$fileName.jpg'),
            fit: BoxFit.fill,
          ),
        ),
        child: IconButton(
          icon: const Icon(
            Icons.image_rounded,
            color: Color.fromARGB(0, 255, 255, 255),
          ),
          onPressed: () {
            debugPrint('Pressed $fileName');
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return SimpleDialog(
                    title: const Text('Descriptions'),
                    children: [
                      Text(fileName),
                    ],
                  );
                });
          },
        ),
      ));
    });

    return Container(
      padding: const EdgeInsets.all(2),
      margin: const EdgeInsets.all(5),
      width: scrWidth * 0.9,
      height: scrHeight * 0.2,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: list,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: ListView(
          children: [
            Container(
              decoration: const BoxDecoration(
                color: Color.fromARGB(75, 5, 177, 245),
                borderRadius: BorderRadius.all(Radius.circular(25)),
              ),
              padding: const EdgeInsets.only(top: 20, bottom: 10),
              child: Column(
                children: [
                  const Text(
                    'DESTINATIONS',
                    style: TextStyle(
                      fontFamily: 'Calibre',
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(right: 100, top: 40),
                    child: Text(
                      'Famouse Places In Surigao',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontFamily: 'Arial',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  FutureBuilder(
                      future: loadImageList(),
                      builder: ((context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          return snapshot.requireData;
                        } else {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                      })),
                  const Padding(
                    padding: EdgeInsets.only(right: 100, top: 20),
                    child: Text(
                      'Hotels Recommendations',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontFamily: 'Arial',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  FutureBuilder(
                      future: loadImages(listName: 'hotels'),
                      builder: ((context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          return snapshot.requireData;
                        } else {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                      })),
                  const Padding(
                    padding: EdgeInsets.only(right: 80, top: 20),
                    child: Text(
                      'Restaurant Recommendations',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontFamily: 'Arial',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  FutureBuilder(
                      future: loadImages(listName: 'restaurants'),
                      builder: ((context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          return snapshot.requireData;
                        } else {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                      })),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
