import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class ContactUsView extends StatefulWidget {
  final Database db;
  const ContactUsView({required this.db, super.key});

  @override
  State<ContactUsView> createState() => _ContactUsViewState();
}

class _ContactUsViewState extends State<ContactUsView> {
  final TextEditingController ctrlName = TextEditingController(),
      ctrlPhone = TextEditingController(),
      ctrlEmail = TextEditingController(),
      ctrlMessage = TextEditingController();
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
                  color: Color.fromARGB(254, 252, 252, 252),
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromARGB(255, 57, 156, 173),
                      spreadRadius: 3,
                      blurRadius: 5,
                    )
                  ],
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
              Container(
                margin: const EdgeInsets.all(15),
                padding: const EdgeInsets.all(25),
                decoration: const BoxDecoration(
                  color: Color.fromARGB(254, 252, 252, 252),
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
                      'FEEDBACK',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Calibre',
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      'We love your feedback!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Arial',
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    Container(
                      width: scrWidth * 0.8,
                      //height: scrHeight * 0.2,
                      margin: const EdgeInsets.only(top: 2, bottom: 2),
                      child: TextField(
                        keyboardType: TextInputType.name,
                        controller: ctrlName,
                        decoration: const InputDecoration(
                          labelText: 'Name',
                          hintText: 'Juan Dela Cruz',
                        ),
                      ),
                    ),
                    Container(
                      width: scrWidth * 0.8,
                      // height: scrHeight * 0.2,
                      margin: const EdgeInsets.only(top: 2, bottom: 2),
                      child: TextField(
                        keyboardType: TextInputType.phone,
                        controller: ctrlPhone,
                        decoration: const InputDecoration(
                          labelText: 'Phone',
                          hintText: '09123456789',
                        ),
                      ),
                    ),
                    Container(
                      width: scrWidth * 0.8,
                      //height: scrHeight * 0.2,
                      margin: const EdgeInsets.only(top: 2, bottom: 2),
                      child: TextField(
                        controller: ctrlEmail,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          hintText: 'juandelacruz@email.com',
                        ),
                      ),
                    ),
                    Container(
                      width: scrWidth * 0.8,
                      //height: scrHeight * 0.2,
                      margin: const EdgeInsets.only(top: 2, bottom: 2),
                      child: TextFormField(
                        controller: ctrlMessage,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        decoration: const InputDecoration(
                          labelText: 'Message',
                          hintText: 'The app is good but in need of...',
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 18.0,
                        bottom: 2,
                      ),
                      child: ElevatedButton.icon(
                        onPressed: () {
                          var insertVal = {
                            'name': ctrlName.text,
                            'phone': ctrlPhone.text,
                            'email': ctrlEmail.text,
                            'message': ctrlMessage.text,
                          };
                          widget.db.insert('feedback', insertVal);
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return const SimpleDialog(
                                  title: Text('Successs'),
                                  children: [
                                    Text('Message Received'),
                                  ],
                                );
                              });
                          ctrlName.clear();
                          ctrlPhone.clear();
                          ctrlEmail.clear();
                          ctrlMessage.clear();
                        },
                        icon: const Icon(Icons.send_sharp),
                        label: const Text('Send'),
                      ),
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
