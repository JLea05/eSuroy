import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class AboutUsView extends StatefulWidget {
  const AboutUsView({super.key});

  @override
  State<AboutUsView> createState() => _AboutUsViewState();
}

class _AboutUsViewState extends State<AboutUsView> {
  Future<Widget> getText() async {
    String ret = await rootBundle.loadString('assets/text/aboutus.txt');
    return Text(
      ret,
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontFamily: 'Arial',
        fontSize: 18,
        fontWeight: FontWeight.normal,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('eSuroy'),
        foregroundColor: Colors.blue,
      ),
      body: Container(
        padding: const EdgeInsets.only(top: 10, bottom: 10),
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
        child: ListView(
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 20),
              child: Text(
                'About US',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Calibre',
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 20, left: 10),
              child: Text(
                'What is eSuroy?',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontFamily: 'Calibre',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 10,
              ),
              child: FutureBuilder(
                future: getText(),
                builder: ((context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return snapshot.requireData;
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
