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
    String ret = await rootBundle.loadString('assets/text/dealsList.txt');

    List<Widget> list = [];

    ret.split(',').forEach((fileName) {
      fileName.replaceAll(RegExp(r'\n'), '');

      list.add(Container(
        width: scrWidth * 0.7,
        margin: const EdgeInsets.fromLTRB(10, 0, 0, 10),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(15)),
          image: DecorationImage(
            image: AssetImage('assets/images/deals/$fileName.jpg'),
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

  Future<Widget> getText() async {
    String ret = await rootBundle.loadString('assets/text/dealsDesc.txt');

    return Text(
      ret,
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontFamily: 'Arial',
        fontSize: 16,
        color: Color.fromARGB(172, 0, 0, 0),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double scrHeight = MediaQuery.of(context).size.height;
    const TextStyle cellStyle = TextStyle(
      fontFamily: 'Times New Roman',
      fontSize: 16,
      fontWeight: FontWeight.bold,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('eSuroy'),
        foregroundColor: Colors.blue,
      ),
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
                    children: [
                      const Text(
                        'Deals',
                        style: TextStyle(
                          fontFamily: 'Calibre',
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      FutureBuilder(
                          future: getText(),
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
                Container(
                  height: scrHeight * 0.45,
                  padding: const EdgeInsets.only(bottom: 5, top: 10),
                  margin: const EdgeInsets.all(5),
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
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.all(10),
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
                            '500-600',
                            textAlign: TextAlign.center,
                            style: cellStyle,
                          ),
                          Text(
                            '100-200',
                            textAlign: TextAlign.center,
                            style: cellStyle,
                          ),
                          Text(
                            '50-100',
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
                            '600-1000',
                            textAlign: TextAlign.center,
                            style: cellStyle,
                          ),
                          Text(
                            '200-500',
                            textAlign: TextAlign.center,
                            style: cellStyle,
                          ),
                          Text(
                            '50-100',
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
                            '1000-3000',
                            textAlign: TextAlign.center,
                            style: cellStyle,
                          ),
                          Text(
                            '500-1000',
                            textAlign: TextAlign.center,
                            style: cellStyle,
                          ),
                          Text(
                            '200-400',
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
