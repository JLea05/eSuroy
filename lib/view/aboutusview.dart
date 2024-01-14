import 'package:flutter/material.dart';

class AboutUsView extends StatefulWidget {
  const AboutUsView({super.key});

  @override
  State<AboutUsView> createState() => _AboutUsViewState();
}

class _AboutUsViewState extends State<AboutUsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: Color.fromARGB(75, 5, 177, 245),
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        child: ListView(
          children: const [
            Padding(
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
            Padding(
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
              padding: EdgeInsets.only(
                top: 10,
              ),
              child: Text(
                'eSuroy is about selling drugs like cocaine and meth which has a huge market in the philippines. The previous president has now gone and we can now continue selling drugs',
                textAlign: TextAlign.justify,
                style: TextStyle(
                  fontFamily: 'Arial',
                  fontSize: 18,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20, left: 10),
              child: Text(
                'Our Goals are to:',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontFamily: 'Calibre',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.only(
                top: 10,
              ),
              child: Text(
                '-Selling Illegal Drugs\n-Making Money-\nGain Power\n-Control The Government',
                textAlign: TextAlign.justify,
                style: TextStyle(
                  fontFamily: 'Arial',
                  fontSize: 18,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
