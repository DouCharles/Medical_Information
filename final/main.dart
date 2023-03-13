import 'dart:typed_data';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // state 1
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
        '/page_contact': (context) => Page_contact(),
        '/page_record': (context) => Page_record(),
        '/page_notice': (context) => Page_notice(),
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
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: AppBar(
        title: const Text("藥物使用紀錄"),
        leading: const Icon(Icons.pageview_outlined),
      ),
    );
  }
}
//==================================== PAGE RECORD ====================================//

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

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: AppBar(
        title: const Text("藥物注意事項"),
        leading: const Icon(Icons.pageview_outlined),
      ),
    );
  }
}
//==================================== PAGE NOTICE ====================================//

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

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: AppBar(
        title: const Text("疾病介紹"),
        leading: const Icon(Icons.pageview_outlined),
      ),
    );
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
                            onPressed: () => playLocal("肺纖維化原因.wav"),
                          ),
                        ),
                        SizedBox(
                          height: 70,
                        ),
                        Flexible(
                          flex: 1,
                          child: MaterialButton(
                            height:60 ,
                            color: Colors.blue[200],
                            child: Text("用藥紀錄",textScaleFactor: 2),
                            onPressed: () => record("123",2022,02,04,07,04),
                            /*{
                              Navigator.pushNamed(context, '/page_record')
                            },*/
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Flexible(
                          flex: 1,
                          child: MaterialButton(
                            height:60 ,
                            color: Colors.blue[200],
                            child: Text("用藥須知",textScaleFactor: 2),
                            onPressed: () =>getRecord(),// {
                              //Navigator.pushNamed(context, '/page_notice')
                            //},
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Flexible(
                          flex: 1,
                          child: MaterialButton(
                            height:60 ,
                            color: Colors.blue[200],
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
    String path = path_prefix+ filename;
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

  void getRecord()async{
    Map body = {
      'sql':'',
      'opt':'DQL',
    };
    body['sql'] = 'SELECT * FROM android.medicine';
    String jsonString = json.encode(body);
    String response = await fetchData('https://c5c6-140-116-115-63.ngrok.io/mysql',jsonString);
    var receiveData = json.decode(response);
    if(receiveData['status'] == 'success'){
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

  void record(name, year, month, day, hour, min)async{
    print("in the record");
    Map body = {
      'sql':'',
      'opt':'DQL',
    };
    body['sql'] = 'INSERT INTO android.medicine (name, year, month, day, hour, min) VALUES ("$name", $year, $month, $day, $hour, $min)';

    String jsonString = json.encode(body);
    String response = await fetchData('https://c5c6-140-116-115-63.ngrok.io/mysql',jsonString);
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
}

Future<String> fetchData(String url, String jsonString) async{
  try{
    print("fetch");
    http.Response response = await http.post(Uri.parse(url),headers:{'Content-Type':'application/json; charset=UTF-8'},body:jsonString);
    return response.body;
  }catch(error){
    return '{"status":"fail", "result":\"${error.toString()}\"}';
  }

}

// Future test()async{
//   //获取到插件与原生的交互通道
//   static const mNotificationBar = const MethodChannel('notification_bar.flutter.io/notificationBar');
//
// //发动数据到原生 并返回
//   String result = await mNotificationBar.invokeMethod('content', map);
// }
//==================================== HOME PAGE ====================================//
