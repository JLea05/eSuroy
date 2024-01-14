import 'package:flutter/material.dart';

class ContactUsView extends StatefulWidget {
  const ContactUsView({super.key});

  @override
  State<ContactUsView> createState() => _ContactUsViewState();
}

class _ContactUsViewState extends State<ContactUsView> {
  @override
  Widget build(BuildContext context) {
    double scrWidth = MediaQuery.of(context).size.width;
    double scrHeight = MediaQuery.of(context).size.height;
    var tStyle = const TextStyle(
      fontFamily: 'Arial',
      fontSize: 14,
    );
    return Scaffold(
      body: ListView(
        children: [
          Column(
            children: [
              Container(
                padding: const EdgeInsets.only(top: 8.0),
                child: const Text(
                  'Contact Us',
                  style: TextStyle(
                    fontFamily: 'Calibre',
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                width: scrWidth * 0.8,
                height: scrHeight * 0.6,
                margin: const EdgeInsets.all(15),
                decoration: const BoxDecoration(
                  color: Color.fromARGB(75, 5, 177, 245),
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                padding: const EdgeInsets.all(25),
                child: Column(
                  children: [
                    const Image(
                      image: AssetImage(
                        'assets/images/dev/lea.jpg',
                      ),
                      fit: BoxFit.fill,
                    ),
                    Text(
                      'Name: Lea June Almazan',
                      style: tStyle,
                    ),
                    Text(
                      'Gender: Unknown',
                      style: tStyle,
                    ),
                    Text(
                      'Contact Number: 09123456789',
                      style: tStyle,
                    ),
                    Text(
                      'email: leajune@gmail.com',
                      style: tStyle,
                    ),
                  ],
                ),
              ),
              Container(
                width: scrWidth * 0.8,
                height: scrHeight * 0.45,
                margin: const EdgeInsets.all(15),
                decoration: const BoxDecoration(
                  color: Color.fromARGB(75, 5, 177, 245),
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                padding: const EdgeInsets.all(25),
                child: Column(
                  children: [
                    const Image(
                      image: AssetImage(
                        'assets/images/dev/cherry.jpg',
                      ),
                      fit: BoxFit.fill,
                    ),
                    Text(
                      'Name: Cherry Fe Pilan',
                      style: tStyle,
                    ),
                    Text(
                      'Gender: Unknown',
                      style: tStyle,
                    ),
                    Text(
                      'Contact Number: 09123456789',
                      style: tStyle,
                    ),
                    Text(
                      'email: cherryfepilan@gmail.com',
                      style: tStyle,
                    ),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
