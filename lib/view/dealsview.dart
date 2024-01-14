import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class DealsView extends StatefulWidget {
  const DealsView({super.key});

  @override
  State<DealsView> createState() => _DealsViewState();
}

class _DealsViewState extends State<DealsView> {
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
      ));
    });

    return Container(
      padding: const EdgeInsets.all(2),
      margin: const EdgeInsets.all(5),
      width: scrWidth * 0.9,
      height: scrHeight * 0.30,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: list,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const TextStyle cellStyle = TextStyle(
      fontFamily: 'Times New Roman',
      fontSize: 16,
      fontWeight: FontWeight.bold,
    );

    return Scaffold(
      body: ListView(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 20),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.only(top: 20, bottom: 20),
                  margin: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(75, 5, 177, 245),
                    borderRadius: BorderRadius.all(Radius.circular(25)),
                  ),
                  child: const Column(
                    children: [
                      Text(
                        'Deals',
                        style: TextStyle(
                          fontFamily: 'Calibre',
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      Text(
                        'Use the chart below to get an idea of how much to budget daily. Actual amounts will depend on YOUR travel style. Keep in mind these are daily averages … some days you’ll spend more, some days you’ll spend less. Prices are in Peso.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Arial',
                          fontSize: 16,
                          color: Color.fromARGB(172, 0, 0, 0),
                        ),
                      ),
                      Text(
                        'Use the chart below to get an idea of how much to budget daily. Actual amounts will depend on YOUR travel style. Keep in mind these are daily averages … some days you’ll spend more, some days you’ll spend less. Prices are in Peso.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Arial',
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(bottom: 5, top: 10),
                  margin: const EdgeInsets.all(5),
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(75, 5, 177, 245),
                    borderRadius: BorderRadius.all(Radius.circular(25)),
                  ),
                  child: FutureBuilder(
                      future: loadImageList(),
                      builder: ((context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          return snapshot.requireData;
                        } else {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                      })),
                ),
                Container(
                  padding: const EdgeInsets.only(bottom: 5, top: 10),
                  child: Table(
                    columnWidths: const <int, TableColumnWidth>{
                      0: FlexColumnWidth(),
                      1: FlexColumnWidth(),
                      2: FlexColumnWidth(),
                      3: FlexColumnWidth(),
                    },
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    border: TableBorder.all(color: Colors.black),
                    children: const [
                      TableRow(
                        children: [
                          Text(
                            'Suggested Budget',
                            textAlign: TextAlign.center,
                            style: cellStyle,
                          ),
                          Text(
                            'Accommodation',
                            textAlign: TextAlign.center,
                            style: cellStyle,
                          ),
                          Text(
                            'Food',
                            textAlign: TextAlign.center,
                            style: cellStyle,
                          ),
                          Text(
                            'Transportation',
                            textAlign: TextAlign.center,
                            style: cellStyle,
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          Text(
                            'Low Budget',
                            textAlign: TextAlign.center,
                            style: cellStyle,
                          ),
                          Text(
                            ' ',
                            textAlign: TextAlign.center,
                            style: cellStyle,
                          ),
                          Text(
                            ' ',
                            textAlign: TextAlign.center,
                            style: cellStyle,
                          ),
                          Text(
                            ' ',
                            textAlign: TextAlign.center,
                            style: cellStyle,
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          Text(
                            'Mid Range',
                            textAlign: TextAlign.center,
                            style: cellStyle,
                          ),
                          Text(
                            ' ',
                            textAlign: TextAlign.center,
                            style: cellStyle,
                          ),
                          Text(
                            ' ',
                            textAlign: TextAlign.center,
                            style: cellStyle,
                          ),
                          Text(
                            ' ',
                            textAlign: TextAlign.center,
                            style: cellStyle,
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          Text(
                            'Luxury',
                            textAlign: TextAlign.center,
                            style: cellStyle,
                          ),
                          Text(
                            ' ',
                            textAlign: TextAlign.center,
                            style: cellStyle,
                          ),
                          Text(
                            ' ',
                            textAlign: TextAlign.center,
                            style: cellStyle,
                          ),
                          Text(
                            ' ',
                            textAlign: TextAlign.center,
                            style: cellStyle,
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
