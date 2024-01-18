import 'package:esuroy/view/aboutusview.dart';
import 'package:esuroy/view/contactusview.dart';
import 'package:esuroy/view/dealsview.dart';
import 'package:esuroy/view/destinationsview.dart';
import 'package:flutter/material.dart';
import 'package:esuroy/view/mainview.dart';
import 'package:sqflite/sqflite.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'eSuroy',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white30),
        useMaterial3: true,
      ),
      initialRoute: '/mainview',
      routes: {
        '/mainview': (context) => const MainView(),
        '/dealsview': (context) => const DealsView(),
        //'/destinationsview': (context) => const DestinationsView(),
        '/aboutusview': (context) => const AboutUsView(),
        '/contactusview': (context) => const ContactUsView(),
      },
    );
  }
}
