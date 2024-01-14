import 'package:flutter/material.dart';
import 'package:esuroy/view/mainview.dart';

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
      },
    );
  }
}
