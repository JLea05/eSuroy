import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class ReviewsView extends StatefulWidget {
  final Database db;
  const ReviewsView({required this.db, super.key});

  @override
  State<ReviewsView> createState() => _ReviewsViewState();
}

class _ReviewsViewState extends State<ReviewsView> {
  Future<Widget> getWidget() async {
    List<Widget> widgets = [];
    var queried =
        await widget.db.query('feedback', columns: ['name', 'message']);

    widgets.add(Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      child: const Text(
        'Reviews',
        style: TextStyle(
          color: Colors.black,
          fontFamily: 'Calibre',
          fontSize: 24,
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.bold,
          decoration: TextDecoration.none,
        ),
      ),
    ));

    queried.forEach(
      (element) {
        widgets.add(Container(
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: const Color.fromARGB(188, 59, 193, 208),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              Text(
                'Name: ${element['name'].toString()}',
                style: const TextStyle(
                  color: Colors.black,
                  fontFamily: 'Arial',
                  fontSize: 16,
                  fontStyle: FontStyle.normal,
                  decoration: TextDecoration.none,
                ),
              ),
              Text(
                'Message: ${element['message'].toString()}',
                style: const TextStyle(
                  color: Colors.black,
                  fontFamily: 'Arial',
                  fontSize: 16,
                  fontStyle: FontStyle.normal,
                  decoration: TextDecoration.none,
                ),
              ),
            ],
          ),
        ));
      },
    );

    return Column(
      children: widgets,
    );
  }

  @override
  Widget build(BuildContext context) {
    double scrHeight = MediaQuery.of(context).size.height;
    return ListView(
      children: [
        FutureBuilder(
          future: getWidget(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Container(
                height: scrHeight,
                color: Colors.blueAccent,
                child: snapshot.requireData,
              );
            }
            return const Text('No data');
          },
        ),
      ],
    );
  }
}
