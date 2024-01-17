import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter/services.dart' show rootBundle;

class ReviewsView extends StatefulWidget {
  final Database db;
  const ReviewsView({required this.db, super.key});

  @override
  State<ReviewsView> createState() => _ReviewsViewState();
}

class _ReviewsViewState extends State<ReviewsView> {
  final TextEditingController ctrlName = TextEditingController(),
      ctrlPhone = TextEditingController(),
      ctrlEmail = TextEditingController(),
      ctrlMessage = TextEditingController();
  double rating = 1.0;
  List<DropdownMenuItem> hotelList = [];
  String selected = '';
  void dropDownList() async {
    String ret = await rootBundle.loadString('assets/text/hotelsList.txt');

    setState(() {
      ret.split(',').forEach((item) {
        hotelList.add(DropdownMenuItem(
          value: item,
          child: Text(item),
        ));
      });
      String selected = ret.split(',').first;
      debugPrint('Seleced: $selected');
    });
  }

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

  Future<Widget> constructReviews() async {
    double scrWidth = MediaQuery.of(context).size.width;
    double scrHeight = MediaQuery.of(context).size.height;
    var queried = await widget.db.query('rating');
    List<Widget> content = [];
    const TextStyle ts = TextStyle(
      fontFamily: 'Arial',
      fontSize: 16,
    );
    content.add(Container(
      margin: const EdgeInsets.only(
        top: 10,
        bottom: 10,
      ),
      child: const Text(
        'Community Reviews',
        style: TextStyle(
          fontFamily: 'Calibre',
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    ));
    for (var row in queried) {
      content.add(
        Container(
          width: scrWidth * 0.9,
          margin: const EdgeInsets.only(bottom: 25, top: 25),
          decoration: BoxDecoration(
            color: const Color.fromARGB(187, 255, 255, 255),
            borderRadius: const BorderRadius.all(Radius.circular(15)),
            border: Border.all(width: 1),
            boxShadow: const [
              BoxShadow(
                color: Color.fromARGB(255, 57, 156, 173),
                spreadRadius: 3,
                blurRadius: 5,
              )
            ],
          ),
          child: Column(
            children: [
              Text(
                'Name: ${row['name'].toString()}',
                style: ts,
              ),
              Text(
                'Phone: ${row['phone'].toString()}',
                style: ts,
              ),
              Text(
                'Email: ${row['email'].toString()}',
                style: ts,
                textAlign: TextAlign.center,
              ),
              Text(
                'Message: ${row['message'].toString()}',
                style: ts,
              ),
              RatingBarIndicator(
                rating: double.parse(row['rating'].toString()),
                itemBuilder: (context, index) => const Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                itemCount: 5,
                itemSize: 50.0,
                direction: Axis.horizontal,
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: content,
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dropDownList();
  }

  @override
  Widget build(BuildContext context) {
    double scrWidth = MediaQuery.of(context).size.width;
    double scrHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text('eSuroy'),
        foregroundColor: Colors.blue,
      ),
      body: ListView(
        children: [
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
                  'Ratings',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Calibre',
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'Please rate honestly',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Arial',
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                Container(
                  width: scrWidth,
                  //height: scrHeight * 0.2,
                  margin: const EdgeInsets.only(top: 20, bottom: 20),
                  //padding: const EdgeInsets.only(left: 20),
                  child: Column(
                    children: [
                      DropdownButton(
                        items: hotelList,
                        isExpanded: true,
                        onChanged: (val) {
                          selected = val.toString();
                        },
                        value: selected,
                      ),
                      Container(
                        width: scrWidth,
                        height: scrHeight * 0.4,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(
                                'assets/images/hotels/$selected.jpg'),
                            fit: BoxFit.fill,
                          ),
                          border: Border.all(width: 1.2),
                        ),
                      ),
                    ],
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
                RatingBar.builder(
                  initialRating: 1,
                  minRating: 0,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder: (context, _) => const Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (rating) {
                    this.rating = rating;
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 18.0,
                    bottom: 2,
                  ),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        var insertVal = {
                          'name': ctrlName.text,
                          'phone': ctrlPhone.text,
                          'email': ctrlEmail.text,
                          'message': ctrlMessage.text,
                          'rating': rating,
                        };
                        widget.db.insert('rating', insertVal);
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
                      });
                    },
                    icon: const Icon(Icons.send_sharp),
                    label: const Text('Send'),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.all(15),
            padding: const EdgeInsets.all(12),
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
            child: FutureBuilder(
                future: constructReviews(),
                builder: ((context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return snapshot.requireData;
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                })),
          )
        ],
      ),
    );
  }
}
