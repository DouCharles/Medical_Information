import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // state 1

void main() {
  runApp(const MyApp());
}

_launchURL() async {
  const url = 'tel:+886 905 505 827';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => HomePage(),
        '/page_contact': (context) => Page_contact(),
        '/page_record': (context) => Page_record(),
        '/page_record/show': (context) => Page_record_show(),
        '/page_notice': (context) => Page_notice(),
        '/page_notice/med1': (context) => Page_notice_med1(),
        '/page_notice/med2': (context) => Page_notice_med2(),
        '/page_introduce': (context) => Page_introduce(),
      },
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

//==================================== PAGE CONTACT ====================================//
class Page_contact extends StatefulWidget {
  const Page_contact({Key? key}) : super(key: key);

  @override
  State<Page_contact> createState() => _Page_contactState();
}

class _Page_contactState extends State<Page_contact> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.cyan[600],
          title: const Text("Page contact"),
          leading: const Icon(Icons.pageview_outlined),
        ),
    );
  }

}
//==================================== PAGE CONTACT ====================================//

//==================================== PAGE RECORD ====================================//
class Page_record extends StatefulWidget {
  const Page_record({Key? key}) : super(key: key);

  @override
  State<Page_record> createState() => _Page_recordState();
}

class _Page_recordState extends State<Page_record> {
  String now_med = "Pirfenidone";
  DateTime now = DateTime.now();
  final TextEditingController Input_1 = new TextEditingController();
  final TextEditingController Input_2 = new TextEditingController();
  final TextEditingController Input_3 = new TextEditingController();
  final TextEditingController Input_4 = new TextEditingController();
  final TextEditingController Input_5 = new TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      //resizeToAvoidBottomInset: true,
      backgroundColor: Colors.orange[100],
      appBar: AppBar(
        backgroundColor: Colors.cyan[600],
        title: const Text("用藥紀錄"),
        leading: const Icon(Icons.receipt_long_outlined),
      ),
      body:Column(
        children:[
          SizedBox(height: 10,),
          Flexible(
              flex: 1,
                child:buildRadio()
          ),
          SizedBox(height: 20,),
          Flexible(
              flex:1,
              child: TextField(
                controller: Input_1,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(),
                  hintText: '年 Year'
                ),
              )),
          SizedBox(height: 3,),
          Flexible(
              flex:1,
              child: TextField(
                controller: Input_2,
                decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(),
                    hintText: '月 Month'
                ),
              )),
          SizedBox(height: 3,),
          Flexible(
              flex:1,
              child: TextField(
                controller: Input_3,
                decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(),
                    hintText: '日 day'
                ),
              )),
          SizedBox(height: 3,),
          Flexible(
              flex:1,
              child: TextField(
                controller: Input_4,
                decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(),
                    hintText: '時 hour'
                ),
              )),
          SizedBox(height: 3,),
          Flexible(
              flex:1,
              child: TextField(
                controller: Input_5,
                decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(),
                    hintText: '分 Minute'
                ),
              )),
          SizedBox(height: 20,),
          Flexible(
              child: Row(
                children: [
                  SizedBox(width: 20,),
                  Flexible(
                    flex: 1,
                      child: MaterialButton(
                        color: Colors.blue[100],
                        minWidth: 150,
                        child: Text("紀錄",textScaleFactor: 1.5,),
                        onPressed:()=>{
                          smart_record()
                        },
                      )),
                  SizedBox(width: 20,),
                  Flexible(
                      flex: 1,
                      child: MaterialButton(
                        color: Colors.blue[100],
                        minWidth: 150,
                        child: Text("查看",textScaleFactor: 1.5,),
                        onPressed: ()=>{
                          Navigator.pushNamed(context, '/page_record/show')
                        },
                      )),
                ],
              ))
        ]
      )
    );
  }

  void smart_record()
  {
      if(Input_1.text == "" && Input_2.text == "" && Input_3.text == "" && Input_4.text == "" && Input_5.text == "")
        quick_record();
      else
        input_record();
  }

  void input_record()
  {
    print("select = "+ now_med);
    print(Input_1.text.toString());
    print(Input_2.text.toString());
    print(Input_3.text.toString());
    print(Input_4.text.toString());
    print(Input_5.text.toString());
    //record('789','2021','03','07','05','26');
    record(now_med, int.parse(Input_1.text.toString()), int.parse(Input_2.text.toString()), int.parse(Input_3.text.toString()), int.parse(Input_4.text.toString()), int.parse(Input_5.text.toString()));
    Input_1.text = "";
    Input_2.text = "";
    Input_3.text = "";
    Input_4.text = "";
    Input_5.text = "";
  }

  void quick_record()
  {
    now = DateTime.now();
    print("year = "+now.year.toString());
    print("month = "+now.month.toString());
    print("day = "+now.day.toString());
    print("hour = "+now.hour.toString());
    print("minute = "+now.minute.toString());
    Input_1.text = now.year.toString();
    Input_2.text = now.month.toString();
    Input_3.text = now.day.toString();
    Input_4.text = now.hour.toString();
    Input_5.text = now.minute.toString();
  }

  void record(name, year, month, day, hour, min)async{
    print("in the record");
    Map body = {
      'sql':'',
      'opt':'DQL',
    };
    body['sql'] = 'INSERT INTO android.medicine (name, year, month, day, hour, min) VALUES ("$name", $year, $month, $day, $hour, $min)';

    String jsonString = json.encode(body);
    String response = await fetchData('https://b262-140-116-247-248.ngrok.io/mysql',jsonString);
    var receiveData = json.decode(response);
    if(receiveData['status'] == 'success'){
      print(receiveData['result']);
      //setState((){
      // movieList = receiveData['result'];
      //})
    }
    else{
      print("failll");

    }
  }

  Widget buildRadio() {
    return Row(children: <Widget>[
      SizedBox(width: 5,),
      Flexible(
        child: RadioListTile<String>(
          // 設定此選項 value
          tileColor: Colors.cyan[100],
          value: 'Pirfenidone',
          title: const Text(
            'Pirfenidone',
            style: TextStyle(color: Colors.black),
            textScaleFactor: 1,
          ),
          groupValue: now_med,
          activeColor: Colors.red,
          onChanged: (value) {
            setState(() {
              now_med = "Pirfenidone";
            });
          },
        ),
      ),
      SizedBox(width: 5,),
      Flexible(
        child: RadioListTile<String>(
          // 設定此選項 value
          tileColor: Colors.cyan[100],
          value: 'Nintedanib',
          // Set option name、color
          title: const Text(
            'Nintedanib',
            style: TextStyle(color: Colors.black),
            textScaleFactor: 1,
          ),
          //  如果Radio的value和groupValu一樣就是此 Radio 選中其他設置為不選中
          groupValue: now_med,
          activeColor: Colors.red,
          onChanged: (value) {
            setState(() {
              now_med = "Nintedanib";
            });
          },
        ),
      ),
      SizedBox(width: 5,),
    ]);
  }
}
//==================================== PAGE RECORD ====================================//

//==================================== PAGE RECORD SHOW ====================================//
class Page_record_show extends StatefulWidget {
  const Page_record_show({Key? key}) : super(key: key);

  @override
  State<Page_record_show> createState() => _Page_record_show_State();
}

class _Page_record_show_State extends State<Page_record_show> {
  List receive = [];
  @override
  void initState() {
    super.initState();
    getRecord();
  }

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
        backgroundColor: Colors.orange[100],
      appBar: AppBar(
        backgroundColor: Colors.cyan[600],
        title: const Text("用藥紀錄查詢"),
        leading: const Icon(Icons.find_in_page),
      ),
      body: ListView.builder(
          itemCount: receive.length,
          itemBuilder: (BuildContext context, int index)
          {
            return Padding(
                padding: EdgeInsets.all(3),
                child: Card(
                  elevation: 3,
                  color: Colors.blue[50],
                  child: Text("使用藥物 : "+receive[index][1]+"\n日期 : "
                              +receive[index][2].toString()+"/"
                              +receive[index][3].toString()+"/"
                              +receive[index][4].toString()+"\n時間 : "
                              +receive[index][5].toString()+" 時 "
                              +receive[index][6].toString()+" 分"
                              ,textScaleFactor: 1.8,),
                ),
            );
          })
    );
  }

  void getRecord()async{
    Map body = {
      'sql':'',
      'opt':'DQL',
    };
    body['sql'] = 'SELECT * FROM android.medicine';
    String jsonString = json.encode(body);
    String response = await fetchData('https://b262-140-116-247-248.ngrok.io/mysql',jsonString);
    var receiveData = json.decode(response);
    if(receiveData['status'] == 'success'){
      setState(() {
        receive = receiveData['result'];
      });
      print(receiveData['result']);
      print("success");
      //setState((){
      // movieList = receiveData['result'];
      //})
    }
    else{
      print("failll");

    }
  }
}
//==================================== PAGE RECORD SHOW ====================================//

//==================================== PAGE NOTICE ====================================//
class Page_notice extends StatefulWidget {
  const Page_notice({Key? key}) : super(key: key);

  @override
  State<Page_notice> createState() => _Page_noticeState();
}

class _Page_noticeState extends State<Page_notice> {
  @override
  void initState() {
    super.initState();
  }

  AudioPlayer player = AudioPlayer();

  static final Title =
  [
    '這個藥物的作用',
    '這個藥物的使用方法',
    '忘記服藥怎麼辦?',
    '發生副作用怎麼辦?',
    '藥品的儲存',
    '敬請特別注意',
    '您所使用的藥物是?',
  ];

  static final audio_link =
  [
    //'這個藥物的作用',
    '藥物作用.wav',
    '藥品使用方法.wav',
    '忘記用藥.wav',
    '副作用發生.wav',
    '藥品儲存.wav',
    '特別注意.wav',
  ];

  static final introduction =
  [
    '這是用來治療特發性肺纖維化的藥品。',
    '1. 請依照醫師與藥師的指示來服用這個藥品(詳見藥袋上的用法用量處)，並請每天大約在同一時間服用。\n2. 請勿隨意增加、減少，或停用此藥品。\n3. 此藥請勿咬碎與剝半，請整顆與溫開水併服。\n4. 此藥建議『隨餐』或是『飯後』服用。\t隨餐: 吃完藥立刻吃飯，或是吃第一口飯時吃藥。\t飯後: 吃飯後一個小時以內吃藥，也就是趁肚子裡面還有食物的時候。',
    '如果您錯過了一劑，請跳過錯過的劑量並繼續您的常規服用方式；請不要服用雙倍劑量來彌補錯過的一劑。',
    '服藥後若出現相關副作用，請立即與醫師或藥師聯絡，請勿擅自停藥。',
    '請將藥品以原包裝保存在室溫下，遠離太陽直射、過熱和潮濕(勿放在浴室中)，並遠離兒童可拿到的地方。',
    '吸煙可能會降低這種藥品的有效性，您應該在開始服用此種藥品之前停止吸煙，並在治療期間避免吸煙。',
  ];

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      backgroundColor: Colors.orange[100],
      appBar: AppBar(
        backgroundColor: Colors.cyan[600],
        title: const Text("用藥注意事項"),
        leading: const Icon(Icons.pageview_outlined),
      ),
      body: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 7,
          itemBuilder: (BuildContext context, int index)
          {
            if(index < 6)
            return
              Padding(
                  padding: EdgeInsets.all(20),
                  child:
                  Card(
                      color: Colors.blue[50],
                      elevation: 5,
                      child:
                      Column(
                          children:[
                            Flexible(
                                flex: 1,
                                child:SizedBox(
                                  width: 320,
                                  child: Text(Title[index],textScaleFactor: 2,),
                                )
                            ),
                            SizedBox(height: 10,),
                            Flexible(
                                flex: 5,
                                child:
                                Padding(
                                  padding: EdgeInsets.all(2.0),
                                  child: SizedBox(
                                    width: 310,
                                    //height: 200,
                                    child: Column(
                                      children: [
                                        Text(introduction[index],textScaleFactor: 1.5,),
                                      ],
                                    ),
                                  ),
                                )
                            ),
                            SizedBox(
                              child: IconButton(
                                  onPressed: ()=>{
                                    playLocal(audio_link[index]),
                                  },
                                  icon : Icon(Icons.volume_up_rounded)
                              ),
                            ),
                          ]
                      )
                  )
              );
            else
              return Padding(
                  padding: EdgeInsets.all(20),
                  child:
                  Card(
                      color: Colors.blue[50],
                      elevation: 5,
                      child:
                      Column(
                          children:[
                            Flexible(
                                flex: 1,
                                child:SizedBox(
                                  width: 320,
                                  child: Text(Title[index],textScaleFactor: 2,),
                                )
                            ),
                            SizedBox(height: 20,),
                            Flexible(
                                flex: 1,
                                child:
                                MaterialButton(
                                  elevation: 8,
                                  height:60 ,
                                  color: Colors.amber[50],
                                  child: Text("Pirfenidone\n(比樂舒活/Pirespa®)",textScaleFactor: 2),
                                  onPressed: () => {
                                    Navigator.pushNamed(context, '/page_notice/med1')
                                  },
                                )
                            ),
                            SizedBox(height: 30,),
                            Flexible(
                                flex: 1,
                                child:
                                MaterialButton(
                                  elevation: 8,
                                  height:60 ,
                                  color: Colors.amber[50],
                                  child: Text("Nintedanib\n(抑肺纖/Ofev®)",textScaleFactor: 2),
                                  onPressed: () => {
                                    Navigator.pushNamed(context, '/page_notice/med2')
                                  },
                                )
                            ),
                          ]
                      )
                  )
              );
          }
      ),
    );
  }
  playLocal(filename) async {
    String path_prefix = "assets/audio/";
    String path = path_prefix + filename;
    ByteData bytes = await rootBundle.load(path);
    Uint8List soundbytes = bytes.buffer.asUint8List(
        bytes.offsetInBytes, bytes.lengthInBytes);
    int res = await player.playBytes(soundbytes);
    if (res == 1) {
      print("playing");
    }
    else {
      print("not playing");
    }
  }
}
//==================================== PAGE NOTICE ====================================//

//==================================== PAGE MED1 ====================================//
class Page_notice_med1 extends StatefulWidget {
  const Page_notice_med1({Key? key}) : super(key: key);

  @override
  State<Page_notice_med1> createState() => _Page_noticeMED1State();
}

class _Page_noticeMED1State extends State<Page_notice_med1> {
  @override
  void initState() {
    super.initState();
  }
  AudioPlayer player = AudioPlayer();
  static final Title =
  [
    '常見副作用',
    '藥物交互作用',
    '注意事項',
    '注意事項',
    '注意事項',
    '若有以下事項請立即與醫師或藥師聯絡',
  ];

  static final introduction =
  [
    '厭食、噁心、味覺改變、胃痛、胸口灼熱感、肝功能下降、關節疼痛、倦怠、嗜睡、頭暈、光敏感性。',
    '如果您正在服用或計劃服用以下任何一項藥品，請務必告知醫師或藥師\n1.抗癲癇藥: carbamazepine。\n2.抗生素: ciprofloxacin、rifampin。\n3. 胃酸抑制劑: cimetidine。\n4. 心衰竭用藥: digoxin。\n5. 抗憂鬱藥: fluvoxamine。',
    '1. 如果有以下事項，請務必告知醫師或藥師\n    > 有或曾經有肝臟或腎臟疾病。\n    > 懷孕、計劃懷孕或可能懷孕，或是正在哺乳。',
    '2. 可能出現頭暈、輕微嗜睡、步履不穩等情形，服用此藥品期間請勿從事駕駛或有危險性的機械操作。',
    '3. 此藥會使您的皮膚對陽光敏感，請避免不必要或長時間暴露在陽光下，並穿戴防護服、太陽鏡和防曬係數(SPF) 50 以上的防曬乳液。',
    '1. 如果您的皮膚變紅、腫脹或起水泡，如曬傷。\n2.如果您有不明原因的皮膚或眼白部分發黃(黃疸)、尿液呈黑色或棕色(茶色)、胃部(腹部)右上方疼痛、比平常更容易出血或瘀傷或感到疲倦；這可能是肝臟問題的症狀。',
  ];
  static final audio_link =
  [
    'Pirespa/副作用.wav',
    'Pirespa/藥物交互作用.wav',
    'Pirespa/注意事項1.wav',
    'Pirespa/注意事項2.wav',
    'Pirespa/注意事項3.wav',
    'Pirespa/與醫師聯絡.wav',
  ];


  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      backgroundColor: Colors.orange[100],
      appBar: AppBar(
        backgroundColor: Colors.cyan[600],
        title: const Text("Pirfenidone 介紹"),
        leading: const Icon(Icons.pageview_outlined),
      ),
      body: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 6,
          itemBuilder: (BuildContext context, int index)
          {
            return
              Padding(
                  padding: EdgeInsets.all(20),
                  child:
                  Card(
                      color: Colors.blue[50],
                      elevation: 5,
                      child:
                      Column(
                          children:[
                            Flexible(
                                flex: 1,
                                child:SizedBox(
                                  width: 320,
                                  child: Text(Title[index],textScaleFactor: 2,),
                                )
                            ),
                            SizedBox(height: 10,),
                            Flexible(
                                flex: 5,
                                child:
                                Padding(
                                  padding: EdgeInsets.all(2.0),
                                  child: SizedBox(
                                    width: 310,
                                    //height: 200,
                                    child: Column(
                                      children: [
                                        Text(introduction[index],textScaleFactor: 1.5,),
                                      ],
                                    ),
                                  ),
                                )
                            ),
                            SizedBox(
                              child: IconButton(
                                  onPressed: ()=>{
                                    playLocal(audio_link[index]),
                                  },
                                  icon : Icon(Icons.volume_up_rounded)
                              ),
                            )
                          ]
                      )
                  )
              );
          }
      ),
    );
  }

  playLocal(filename) async {
    String path_prefix = "assets/audio/";
    String path = path_prefix + filename;
    ByteData bytes = await rootBundle.load(path);
    Uint8List soundbytes = bytes.buffer.asUint8List(
        bytes.offsetInBytes, bytes.lengthInBytes);
    int res = await player.playBytes(soundbytes);
    if (res == 1) {
      print("playing");
    }
    else {
      print("not playing");
    }
  }
}
//==================================== PAGE MED1 ====================================//

//==================================== PAGE MED2 ====================================//
class Page_notice_med2 extends StatefulWidget {
  const Page_notice_med2({Key? key}) : super(key: key);

  @override
  State<Page_notice_med2> createState() => _Page_noticeMED2State();
}

class _Page_noticeMED2State extends State<Page_notice_med2> {
  @override
  void initState() {
    super.initState();
  }
  AudioPlayer player = AudioPlayer();
  static final Title =
  [
    '常見副作用',
    '藥物交互作用',
    '藥物交互作用',
    '注意事項',
    '注意事項',
    '若有以下事項請立即與醫師或藥師聯絡',
  ];

  static final introduction =
  [
    '厭食、腹瀉、噁心、嘔吐、體重下降、腸胃不適、肝功能下降、高血壓、尿道感染。',
    '如果您正在服用或計劃服用以下任何一項藥品，請務必告知醫師或藥師\n1. 抗凝血劑: 如warfarin、aspirin等。\n2. 非類固醇抗發炎藥: 如ibuprofen、naproxen等。\n3. 抗癲癇藥: carbamazepine、phenytoin。',
    '4. 抗生素: erythromycin、rifampin。\n5. 抗黴菌藥: ketoconazole。\n6. 口服類固醇: 如dexamethasone、prednisone等。\n7. 緩瀉與軟便劑: 如氧化鎂、bisacodyl、sennoside等。',
    '1. 如果有以下事項，請務必告知醫師或藥師\n    > 您或您的家人有過出血或血栓問題。\n    > 有或曾經有肝臟疾病、心臟病、憩室病(憩室炎；大腸內壁可能發炎的小囊)\n    > 您最近做過腹部手術\n    > 懷孕、計劃懷孕或可能懷孕，或是正在哺乳。',
    '2. 此藥會降低避孕藥的效果，也可能傷害胎兒，因此請在治療期間到服用最後一劑後 3 個月內都須避免懷孕。',
    '如果您有不明原因的皮膚或眼白部分發黃(黃疸)、尿液呈黑色或棕色(茶色)、胃部(腹部)右上方疼痛、比平常更容易出血或瘀傷或感到疲倦；這可能是肝臟問題的症狀。',
  ];

  static final audio_link =
  [
    'Nintedanib/副作用.wav',
    'Nintedanib/交互作用.wav',
    'Nintedanib/交互作用.wav',
    'Nintedanib/注意事項1.wav',
    'Nintedanib/注意事項2.wav',
    'Nintedanib/與醫師聯絡.wav',
  ];


  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      backgroundColor: Colors.orange[100],
      appBar: AppBar(
        backgroundColor: Colors.cyan[600],
        title: const Text("Nintedanib 介紹"),
        leading: const Icon(Icons.pageview_outlined),
      ),
      body: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 6,
        itemBuilder: (BuildContext context, int index)
        {
          return
            Padding(
                padding: EdgeInsets.all(20),
                child:
                Card(
                    color: Colors.blue[50],
                    elevation: 5,
                    child:
                    Column(
                        children:[
                          Flexible(
                              flex: 1,
                              child:SizedBox(
                                width: 320,
                                child: Text(Title[index],textScaleFactor: 2,),
                              )
                          ),
                          SizedBox(height: 10,),
                          Flexible(
                              flex: 5,
                              child:
                              Padding(
                                padding: EdgeInsets.all(2.0),
                                child: SizedBox(
                                  width: 310,
                                  //height: 200,
                                  child: Column(
                                    children: [
                                      Text(introduction[index],textScaleFactor: 1.5,),
                                    ],
                                  ),
                                ),
                              )
                          ),
                          SizedBox(
                            child: IconButton(
                                onPressed: ()=>{
                                  playLocal(audio_link[index]),
                                },
                                icon : Icon(Icons.volume_up_rounded)
                            ),
                          )
                        ]
                    )
                )
            );
        }
    ),
    );
  }
  playLocal(filename) async {
    String path_prefix = "assets/audio/";
    String path = path_prefix + filename;
    ByteData bytes = await rootBundle.load(path);
    Uint8List soundbytes = bytes.buffer.asUint8List(
        bytes.offsetInBytes, bytes.lengthInBytes);
    int res = await player.playBytes(soundbytes);
    if (res == 1) {
      print("playing");
    }
    else {
      print("not playing");
    }
  }
}
//==================================== PAGE MED2 ====================================//

//==================================== PAGE INTRODUCE ====================================//
class Page_introduce extends StatefulWidget {
  const Page_introduce({Key? key}) : super(key: key);

  @override
  State<Page_introduce> createState() => _Page_introduceState();
}

class _Page_introduceState extends State<Page_introduce> {
  @override
  void initState() {
    super.initState();
  }

  AudioPlayer player = AudioPlayer();

  static final Title =
  [
    '甚麼是特發性肺纖維化?',
    '發生特發性肺纖維化的原因?',
    '發生特發性肺纖維化的危險因子?',
    '非藥物治療',
    '藥物治療',
    '常見共病與症狀治療',
    '肺臟移植',
    '安寧緩和療護',
  ];

  static final audio_link =
  [
    '什麼是特發性肺纖維化.wav',
    '肺纖維化原因.wav',
    '危險因子.wav',
    '非藥物治療.wav',
    '藥物治療.wav',
    '常見共病與治療.wav',
    '肺臟移植.wav',
    //'肺臟移植.wav',
    '安寧緩和療護.wav',
  ];

  static final introduction =
  [
    '特發性肺纖維化(idiopathic pulmonary fibrosis，IPF)，又名「菜瓜布肺」，是一種肺泡或肺間質纖維化的疾病。典型症狀為乾咳、呼吸困難、杵狀指、心衰竭，在出現症狀數年後逐漸惡化，進而發展至末期呼吸衰竭或死亡',
    'IPF的病因目前尚不明，病毒、真菌、污染、毒性物質均可能影響。由於上述原因引起肺部發炎反應、組織損傷，而後上皮細胞缺損，肺泡塌陷，修復時產生纖維化，當擴及大量肺泡時，便形成塊狀的痂痕。',
    '根據過去的研究，危險因子包括吸菸、環境暴露(金屬粉塵、木屑、耕作、養鳥、美髮、石材切割/ 拋光以及接觸植物性或動物性粉塵)、感染、胃食道逆流，與遺傳。',
    '1. 氧氣補充: 治療時機為休息時血氧過低時。\n2. 肺部復健: 內容包括有氧、肌力和柔軟度訓練、衛教課程、營養介入，以及心理社會支持。IPF病人接受肺部復健可改善行走距離以及症狀或生活品質。',
    '1. 抗纖維化藥物: 共兩種，Nintedanib(抑肺纖/Ofev®)及Pirfenidone(比樂舒活/Pirespa®)\n2. 急性發作: 皮質性類固醇',
    '1. 胃食道逆流: 組織胺阻斷劑(H2-receptor antagonist)、質子幫浦抑制劑(proton pump inhibitor，PPI)\n2. 肺動脈高壓: 常見的有sildenafil(肺紓解/Relung®)、bosentan(全可立/Tracleer®)、epoprostenol(服療能/Flolan®)',
    'IPF 患者接受肺臟移植後的5年存活率約為50-56%。在開始出現疾病惡化徵象，即可與醫師進行肺臟移植的討論。',
    '著重於緩解病人生理及心理上的不適，並且給予病人及照護者精神及心理上的支持。',
  ];

  static final img_link =
  [
    'https://i.imgur.com/wA4cxX7.png',
    'https://i.imgur.com/W95bF3i.png',
    'https://i.imgur.com/xtKeZdx.png',
  ];

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      backgroundColor: Colors.orange[100],
      appBar: AppBar(
        backgroundColor: Colors.cyan[600],
        title: const Text("疾病介紹"),
        leading: const Icon(Icons.pageview_outlined),
      ),
      body: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 8,
          itemBuilder: (BuildContext context, int index)
          {
            return
              Padding(
                padding: EdgeInsets.all(20),
              child:
              Card(
                color: Colors.blue[50],
              elevation: 5,
              child:
              Column(
              children:[
                Flexible(
                  flex: 1,
                  child:SizedBox(
                        width: 320,
                        child: Text(Title[index],textScaleFactor: 2,),
                        )
                ),
                SizedBox(height: 10,),
                Flexible(
                  flex: 5,
                  child:
                    Padding(
                      padding: EdgeInsets.all(2.0),
                      child: SizedBox(
                        width: 310,
                        //height: 200,
                        child: Column(
                          children: [
                            Text(introduction[index],textScaleFactor: 1.5,),
                            if(index < 3)
                            SizedBox(
                              height: 100,
                              child: Image.network(img_link[index]),
                            ),
                          ],
                        ),
                        ),
                  )
                ),
                SizedBox(
                  child: IconButton(
                      onPressed: ()=>{
                        playLocal(audio_link[index]),
                      },
                      icon : Icon(Icons.volume_up_rounded)
                    ),
                )
              ]
            )
            )
            );
          }
      ),
    );
  }
  playLocal(filename) async {
    String path_prefix = "assets/audio/";
    String path = path_prefix + filename;
    ByteData bytes = await rootBundle.load(path);
    Uint8List soundbytes = bytes.buffer.asUint8List(
        bytes.offsetInBytes, bytes.lengthInBytes);
    int res = await player.playBytes(soundbytes);
    if (res == 1) {
      print("playing");
    }
    else {
      print("not playing");
    }
  }
}
//==================================== PAGE INTRODUCE ====================================//

//==================================== HOME PAGE ====================================//
class _HomePageState extends State<HomePage> {
  AudioPlayer player = AudioPlayer();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange[100],
      //resizeToAvoidBottomInset : false,
      appBar: AppBar(
        backgroundColor: Colors.cyan[600],
        title: Text('肺纖維化衛教'),
      ),
      body:
          Column(
            children:[
            //Padding(
            //  padding: EdgeInsets.all(2),
              SizedBox(
                height: 540,
              child:
              AspectRatio(
                aspectRatio: 2.0,
                child:
                    Column(
                      children: [
                        SizedBox(
                          height: 40,
                        ),
                        Flexible(
                          flex: 2,
                          child: MaterialButton(
                            //minWidth: double.infinity,
                            height:150 ,
                            //color: Colors.red[200],
                            child: Image.asset("assets/emergency.png"),//Text("緊急聯絡",textScaleFactor: 2),
                            onPressed: () => {
                              _launchURL()
                              //Navigator.pushNamed(context, '/page_contact')
                          },
                          ),
                        ),
                        SizedBox(
                          height: 70,
                        ),
                        Flexible(
                          flex: 1,
                          child: MaterialButton(
                            height:60 ,
                            color: Colors.blue[100],
                            child: Text("用藥紀錄",textScaleFactor: 2),
                            onPressed: () => {
                              Navigator.pushNamed(context, '/page_record')
                            },
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Flexible(
                          flex: 1,
                          child: MaterialButton(
                            height:60 ,
                            color: Colors.blue[100],
                            child: Text("用藥須知",textScaleFactor: 2),
                            onPressed: () => {
                              Navigator.pushNamed(context, '/page_notice')
                            },
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Flexible(
                          flex: 1,
                          child: MaterialButton(
                            height:60 ,
                            color: Colors.blue[100],
                            child: Text("疾病介紹",textScaleFactor: 2),
                            onPressed: () => {
                              Navigator.pushNamed(context, '/page_introduce')
                            },
                          ),
                        ),
                      ]
                    )
              ),
            ),

              //================================================================

              //================================================================
          ])
    );

  }
  playLocal(filename) async {
    String path_prefix = "assets/audio/";
    String path = path_prefix + filename;
    ByteData bytes = await rootBundle.load(path);
    Uint8List soundbytes = bytes.buffer.asUint8List(
        bytes.offsetInBytes, bytes.lengthInBytes);
    int res = await player.playBytes(soundbytes);
    if (res == 1) {
      print("playing");
    }
    else {
      print("not playing");
    }
  }
}
//==================================== HOME PAGE ====================================//

Future<String> fetchData(String url, String jsonString) async{
  try{
    print("fetch");
    http.Response response = await http.post(Uri.parse(url),headers:{'Content-Type':'application/json; charset=UTF-8'},body:jsonString);
    return response.body;
  }catch(error){
    return '{"status":"fail", "result":\"${error.toString()}\"}';
  }

}