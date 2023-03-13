import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => Homepage(),
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
          title: Text('Favorite Restaurant'),
        ),
        body: //Padding(
            /*padding: const EdgeInsets.all(10),
          child: AspectRatio(
            aspectRatio: 2.0,*/
            //child:
            ListView.builder(
          itemCount: RestaurantModel.like_titles.length,
          itemBuilder: (BuildContext context, int index) {
            final restaurant = RestaurantModel.getFavoriteByIndex(index);
            return card_horizontal(
                image: restaurant.imagePath,
                title: restaurant.title,
                plot: restaurant.plot);
          },
        ));
  }
}

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  String? selectedCatagory = 'All';
  static final catalog = [
    'noodle',
    'rice',
    'drinks',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Restaurant around NCKU'),
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
            Row(children: [
              Text('Catagory'),
              DropdownButton(
                  value: selectedCatagory,
                  onChanged: (String? newCatagory) {
                    setState(() {
                      selectedCatagory = newCatagory;
                    });
                  },
                  items: [
                    DropdownMenuItem(value: 'All', child: Text('All')),
                    DropdownMenuItem(value: '素食', child: Text('素食')),
                  ])
            ]),
            Expanded(
              child: ListView.builder(
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
                                        var restaurant = (selectedCatagory ==
                                                '素食')
                                            ? RestaurantModel
                                                .getVegetarianByIndex(index2)
                                            : RestaurantModel
                                                .getRestaurantByIndex(
                                                    index1, index2);

                                        /*final restaurant =
                                          RestaurantModel.getRestaurantByIndex(
                                              index1, index2);*/
                                        return card_horizontal(
                                            image: restaurant.imagePath,
                                            title: restaurant.title,
                                            plot: restaurant.plot);
                                      },
                                    ),
                                  )),
                            )
                          ],
                        ));
                  }),
            ),
          ],
        ));
    //,;
  }
}

class card_horizontal extends StatelessWidget {
  const card_horizontal({
    Key? key,
    required String this.image,
    required String this.title,
    required String this.plot,
  }) : super(key: key);
  final String image;
  final String title;
  final String plot;
  static bool taped = false;

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
                                child: Text(title),
                                //TODO:Text
                              ),
                              IconButton(
                                onPressed: () {
                                  taped
                                      ? remove_like(title, image, plot)
                                      : add_like(title, image, plot);
                                },
                                icon: Icon(Icons.favorite),
                              )
                              //Icon(Icons.favorite),
                              //TODO:Icon
                            ],
                          ),
                        ),
                        Flexible(
                          flex: 2,
                          child: Text(plot),
                          //TODO : description
                        ),
                      ],
                    ),
                  )),
            ],
          ),
        ),
      ),
      //MyListItem
    );
  }

  void add_like(title, image, description) {
    //print('user tapped on $item');
    if (!(RestaurantModel.like_titles.contains(title))) {
      RestaurantModel.add(title, image, description);
    }
    print("add");
    print(RestaurantModel.like_titles);
    taped = true;
  }

  void remove_like(title, image, description) {
    //print('user tapped on $item');
    if ((RestaurantModel.like_titles.contains(title))) {
      RestaurantModel.remove(title, image, description);
    }
    print("remove");
    print(RestaurantModel.like_titles);
    taped = false;
  }
}

class Restaurant {
  final String title;
  final String plot;
  final String imagePath;

  Restaurant(this.title, this.plot, this.imagePath);
}

class RestaurantModel {
  static final like_titles = [];
  static final like_imagepaths = [];
  static final like_plots = [];
  static final titles = [
    ['轉角關東煮', '大醬', '小茂屋'],
    ['123炒飯', '成大館', '13乾鍋'],
    ['夏沐綠野', '私藏', 'Mr.Wish']
  ];
  static final imagePaths = ['around.jpg', 'bigJohn.jpg', 'XiaoMaoWu.jpg'];
  static final Vegetariantitles = [
    '13乾鍋',
  ];
  static final VegetarianimagePaths = [
    'around.jpg',
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

  static Restaurant getVegetarianByIndex(int index) {
    return Restaurant(
      Vegetariantitles[index % Vegetariantitles.length],
      plots,
      'assets/images/' +
          VegetarianimagePaths.elementAt(index % VegetarianimagePaths.length),
    );
  }

  static void add(title, image, description) {
    like_titles.add(title);
    like_imagepaths.add(image);
    like_plots.add(description);
  }

  static void remove(title, image, description) {
    //like.add([title, image, description]);
    like_titles.remove(title);
    like_imagepaths.remove(image);
    like_plots.remove(description);
  }

  static Restaurant getFavoriteByIndex(int index) {
    return Restaurant(
      like_titles[index % like_titles.length],
      like_plots[index % like_plots.length],
      like_imagepaths.elementAt(index % like_imagepaths.length),
    );
  }
}
