import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({
    Key? key,
  }) : super(key: key);
  static final catalog = [
    'noodle',
    'rice',
    'drinks',
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Restaurant around NCKU'),
        ),
        body: ListView.builder(
            itemCount: 3,
            itemBuilder: (BuildContext context, int index1) {
              return SizedBox(
                  width: 300,
                  height: 300,
                  child: Column(
                    children: [
                      Flexible(
                        flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: AspectRatio(
                              aspectRatio: 10.0,
                              child: Text(
                                catalog[index1 % catalog.length],
                                textAlign: TextAlign.left,
                                textScaleFactor: 2,
                              )),
                        ),
                      ),
                      Flexible(
                        flex: 5,
                        child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: AspectRatio(
                              aspectRatio: 2.0,
                              child: ListView.builder(
                                itemCount: 3,
                                scrollDirection: Axis.horizontal,
                                itemBuilder:
                                    (BuildContext context, int index2) {
                                  final restaurant =
                                      RestaurantModel.getRestaurantByIndex(
                                          index1, index2);
                                  return card_horizontal(
                                      image: restaurant.imagePath,
                                      title: Text(restaurant.title),
                                      plot: Text(restaurant.plot));
                                },
                              ),
                            )),
                      )
                    ],
                  ));
            }),
      ),
    );
  }
}

class card_horizontal extends StatelessWidget {
  const card_horizontal({
    Key? key,
    required String this.image,
    required Text this.title,
    required Text this.plot,
  }) : super(key: key);
  final String image;
  final Text title;
  final Text plot;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: AspectRatio(
        aspectRatio: 2.0,
        child: Card(
          elevation: 10,
          child: Row(
            children: [
              Flexible(
                flex: 1,
                child: Image.asset(image),
                //TODO : picture
              ),
              Flexible(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Flexible(
                          flex: 1,
                          child: Row(
                            children: [
                              Expanded(
                                child: title,
                                //TODO:Text
                              ),
                              Icon(Icons.favorite),
                              //TODO:Icon
                            ],
                          ),
                        ),
                        Flexible(
                          flex: 2,
                          child: plot,
                          //TODO : description
                        ),
                      ],
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

class Restaurant {
  final String title;
  final String plot;
  final String imagePath;

  Restaurant(this.title, this.plot, this.imagePath);
}

class RestaurantModel {
  static final titles = [
    ['轉角關東煮', '大醬', '小茂屋'],
    ['123炒飯', '成大館', '13乾鍋'],
    ['夏沐綠野','私藏','Mr.Wish']
  ];
  static final imagePaths = [
    'around.jpg',
    'bigJohn.jpg',
    'XiaoMaoWu.jpg'
  ];
  static final String plots = 'description';

  static Restaurant getRestaurantByIndex(int index1, int index2) {
    return Restaurant(
      //title: titles.elementAt(index % titles.length),
      titles[index1 % titles.length][index2 % titles[1].length],
      plots,
      'assets/images/' + imagePaths.elementAt(index2 % imagePaths.length),
    );
  }
}
