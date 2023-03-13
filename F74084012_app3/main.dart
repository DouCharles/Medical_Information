import 'package:flutter/material.dart';
import 'dart:convert'; // state 1
import 'package:http/http.dart' as http; // state 1
// state 1 : get dependencies

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => HomePage(),
        '/favorite': (context) => FavoritePage(),
      },
    );
  }
}

class FavoritePage extends StatelessWidget {
  const FavoritePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorite Movies'),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? selectedCategory = 'All';

  /*
  List movieList = [
    ['Luca.jpg', 'Luca', '123123'],
    ['Free_Guy.jpg', 'Free Guy', '456456'],
  ]; // state 0
  */
  List movieList = []; // state 2

  // state 2
  @override
  void initState() {
    getMovies(selectedCategory);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Movie'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/favorite');
            },
            icon: Icon(Icons.favorite),
          ),
        ],
      ),
      body: Column(
        children: [
          Row(
            children: [
              Text('Category'),
              DropdownButton(
                value: selectedCategory,
                onChanged: (String? newCategory) {
                  /*
                  // state 0
                  setState(() {
                    selectedCategory = newCategory;
                  });
                  */

                  // state 2
                  setState(() {
                    selectedCategory = newCategory;
                  });
                  getMovies(selectedCategory);
                },
                items: [
                  DropdownMenuItem(
                    value: 'All',
                    child: Text('All'),
                  ),
                  DropdownMenuItem(
                    value: '葷食',
                    child: Text('葷食'),
                  ),
                  DropdownMenuItem(
                    value: '素食',
                    child: Text('素食'),
                  ),
                ],
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: movieList.length, // state 0
              itemBuilder: (BuildContext context, int index) {
                // state 0
                return Padding(
                  padding: const EdgeInsets.all(10),
                  child: AspectRatio(
                    aspectRatio: 2.0,
                    child: MovieCard(
                      image: movieList[index][1], // state 0
                      title: movieList[index][2], // state 0
                      plot: movieList[index][3],
                      address: movieList[index][5],// state 0
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // state 1
  void getMovies(String? newCategory) async {
    Map body = {
      'sql': '',
      'opt': 'DQL',
    };
    if (newCategory == "All") {
      body['sql'] = '''
        SELECT *
        FROM restaurant
      ''';
    } else if (newCategory == "葷食") {
      body['sql'] = '''
        SELECT *
        FROM restaurant
        WHERE category = "$newCategory"
      ''';
    } else if (newCategory == "素食") {
      body['sql'] = '''
      SELECT * FROM restaurant WHERE category = "$newCategory"
      ''';
    }

    String jsonString = json.encode(body);
    // String response = await fetchData('http://localhost/mysql', jsonString); // state 1
    String response = await fetchData(
        'http://140.116.115.63:5000/mysql', jsonString); // state 2
    var receiveData = json.decode(response);
    if (receiveData['status'] == 'success') {
      print(receiveData['result']); // state 1
      setState(() {
        movieList = receiveData['result'];
      }); // state 2
    } else {
      print(receiveData['result']); // state 1
      //showSnackBar(receiveData['result']); // state 3
      showSnackBar("竇賢祐 F74084012 error connected");
    }
  }

  // state 3
  void showSnackBar(String errorStr) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(errorStr),
        duration: const Duration(seconds: 10),
        backgroundColor: Colors.red[900],
        action: SnackBarAction(
          label: 'close',
          textColor: Colors.white,
          onPressed: () => print('close SnackBar ...'),
        ),
      ),
    );
  }
}

class MovieCard extends StatelessWidget {
  const MovieCard({
    Key? key,
    required this.image,
    required this.title,
    required this.plot,
    required this.address
  }) : super(key: key);
  final String image;
  final String title;
  final String plot;
  final String address;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      child: Row(
        children: [
          Flexible(
            flex: 1,
            child: Image.network(image), // state 1
          ),
          Flexible(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  Flexible(
                    flex: 1,
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(title),
                        ),
                        Icon(Icons.favorite)
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Flexible(
                    flex: 3,
                    child: Text(plot),
                  ),
                  SizedBox(height: 30),
                  Flexible(
                      flex: 1,
                      child: Text(address)
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// state 1
Future<String> fetchData(String url, String jsonString) async {
  try {
    http.Response response = await http.post(Uri.parse(url),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonString);
    return response.body;
  } catch (error) {
    return '{"status":"fail", "result":\"${error.toString()}\"}';
  }
}
