import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:uas/model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<Quotes> list = [];

  Future<List<Quotes>> fetchData() async {
    var url = Uri.parse('https://katanime.vercel.app/api/getrandom');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      final parsed = jsonDecode(response.body)['result'].cast<Map<String, dynamic>>();
      List<Quotes> quotes = parsed.map<Quotes>((json) => Quotes.fromJson(json)).toList();
      return quotes;
    } else {
      print('Request failed with status: ${response.statusCode}.');
      return [];
    }
  }

  getData() async {
    List<Quotes> quotes = await fetchData();
    setState(() {
      list = quotes;
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.blueGrey,
        hintColor: Color.fromARGB(255, 14, 7, 50),
        scaffoldBackgroundColor: Colors.white,
        textTheme: const TextTheme(
          headline6: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
          headline4: TextStyle(color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Kata Kata'),
          backgroundColor: Color.fromARGB(221, 7, 12, 98),
        ),
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/background_image.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color.fromARGB(255, 16, 15, 74).withOpacity(0.2),
                    ),
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      list.isNotEmpty ? list[0].indo : "",
                      style: Theme.of(context).textTheme.headline4!.copyWith(
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                color: Colors.black.withOpacity(0.4),
                                offset: Offset(2, 2),
                                blurRadius: 2,
                              ),
                            ],
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            getData();
          },
          child: const Icon(Icons.refresh),
          backgroundColor: Color.fromARGB(221, 16, 7, 94),
        ),
      ),
    );
  }
}
