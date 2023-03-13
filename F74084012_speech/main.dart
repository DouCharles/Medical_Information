import 'dart:io';
import 'socket_tts.dart';
import 'sound_player.dart';
import 'sound_recorder.dart';
import 'flutter_tts.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'socket_stt.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Speech',
      theme: ThemeData(
        backgroundColor: Colors.black,
      ),
      home: const MainPage(title: 'Speech'),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MainPage> createState() => MainPageState();
}

class MainPageState extends State<MainPage> {
  // get SoundRecorder
  final recorder = SoundRecorder();

  // get soundPlayer
  final player = SoundPlayer();
  List movieList = [];

  // Declare TextEditingController to get the value in TextField
  TextEditingController taiwanessController = TextEditingController();
  TextEditingController chineseController = TextEditingController();
  TextEditingController recognitionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    recorder.init();
    player.init();
  }

  @override
  void dispose() {
    recorder.dispose();
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        // 設定不讓鍵盤技壓頁面
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
            title: const Text('餐廳'), backgroundColor: Colors.black),
        // set background color
        backgroundColor: Colors.black,
        body: Column(
          children: [
            /* const Flexible(
              child: Center(
                child: Text(
                  // content of text
                  "Speech Synthesis",
                  // Setup size and color of Text
                  style: TextStyle(fontSize: 30, color: Colors.blue),
                ),
              ),
            ),
            Flexible(
                child: Center(
              child: buildTaiwaneseField("Taiwanese"),
            )),
            Flexible(
              child: Center(child: buildChineseField("Chinese")),
            ),*/
            const Flexible(
                child: Center(
              child: Text(
                "Speech Recognition",
                style: TextStyle(fontSize: 30, color: Colors.blue),
              ),
            )),
            Flexible(
              flex:1,
              child: Center(child: buildRadio()),
            ),
            Flexible(
              flex:1,
              child: Center(child: buildOutputField()),
            ),
            Flexible(
              flex:1,
              child: Center(child: buildRecord()),
            ),
            Flexible(
              flex:2,
              child: Center(
                  child: MovieCard(
                      image: movieList.isEmpty? "none":movieList[0][1],
                      title: movieList.isEmpty? "none":movieList[0][2],
                      plot: movieList.isEmpty? "none":movieList[0][3],
                      address: movieList.isEmpty? "none":movieList[0][5])),
            ),
          ],
        ),
      );

  // build the button of recorder
  Widget buildRecord() {
    // whether is recording
    final isRecording = recorder.isRecording;
    // if recording => icon is Icons.stop
    // else => icon is Icons.mic
    final icon = isRecording ? Icons.stop : Icons.mic;
    // if recording => color of button is red
    // else => color of button is white
    final primary = isRecording ? Colors.red : Colors.white;
    // if recording => text in button is STOP
    // else => text in button is START
    final text = isRecording ? 'STOP' : 'START';
    // if recording => text in button is white
    // else => color of button is black
    final onPrimary = isRecording ? Colors.white : Colors.black;

    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        // 設定 Icon 大小及屬性
        minimumSize: const Size(175, 50),
        primary: primary,
        onPrimary: onPrimary,
      ),
      icon: Icon(icon),
      label: Text(
        text,
        // 設定字體大小及字體粗細（bold粗體，normal正常體）
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      // 當 Iicon 被點擊時執行的動作
      onPressed: () async {
        // getTemporaryDirectory(): 取得暫存資料夾，這個資料夾隨時可能被系統或使用者操作清除
        Directory tempDir = await path_provider.getTemporaryDirectory();
        // define file directory
        String path = '${tempDir.path}/SpeechRecognition.wav';
        // 控制開始錄音或停止錄音
        await recorder.toggleRecording(path);
        // When stop recording, pass wave file to socket
        if (!recorder.isRecording) {
          if (recognitionLanguage == "Taiwanese") {
            // if recognitionLanguage == "Taiwanese" => use Minnan model
            // setTxt is call back function
            // parameter: wav file path, call back function, model
            await Speech2Text().connect(path, setTxt, "Minnan");
            // getMovies(recognitionController.text);
            // glSocket.listen(dataHandler, cancelOnError: false);
          } else {
            // if recognitionLanguage == "Chinese" => use MTK_ch model
            await Speech2Text().connect(path, setTxt, "MTK_ch");

          }

        }
        // set state is recording or stop
        setState(() {
          recorder.isRecording;
        });
      },
    );
  }

  // set recognitionController.text function
  void setTxt(taiTxt) {
    setState(() {
      recognitionController.text = taiTxt;
    });
    getMovies(taiTxt);
  }

  void getMovies(String? plot) async {
    Map body = {
      'sql': '',
      'opt': 'DQL',
    };
    body['sql'] = '''
        SELECT *
        FROM restaurant WHERE plot = "$plot"
      ''';
    // if (title== "All") {
    //   body['sql'] = '''
    //     SELECT *
    //     FROM restaurant
    //   ''';
    // } else if (title == "veg") {
    //   body['sql'] = '''
    //     SELECT *
    //     FROM restaurant
    //     WHERE category = "$title"
    //   ''';
    // } else if (title == "meat") {
    //   body['sql'] = '''
    //   SELECT * FROM restaurant WHERE category = "$title"
    //   ''';
    // }

    String jsonString = json.encode(body);
    // String response = await fetchData('http://localhost/mysql', jsonString); // state 1
    String response = await fetchData(
        'http://140.116.115.63:5000/mysql', jsonString); // state 2
    var receiveData = json.decode(response);
    if (receiveData['status'] == 'success') {
      print("555555555555555555555");
      print(receiveData['result']); // state 1
      setState(() {
        movieList = receiveData['result'];
      }); // state 2
    } else {
      print("78979879789");
      print(receiveData['result']); // state 1
      //showSnackBar(receiveData['result']); // state 3
    }
  }

  Widget buildTaiwaneseField(txt) {
    return Padding(
      padding: const EdgeInsets.only(left: 40, right: 40),
      child: TextField(
        controller: taiwanessController, // 為了獲得TextField中的value
        decoration: InputDecoration(
          fillColor: Colors.white,
          // 背景顏色，必須結合filled: true,才有效
          filled: true,
          // 重點，必須設定為true，fillColor才有效
          enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)), // 設定邊框圓角弧度
            borderSide: BorderSide(
              color: Colors.black87, // 設定邊框的顏色
              width: 2.0, // 設定邊框的粗細
            ),
          ),
          // when user choose the TextField
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(
            color: Colors.red, // 設定邊框的顏色
            width: 2, // 設定邊框的粗細
          )),
          hintText: txt,
          // 提示文字
          suffixIcon: IconButton(
            // TextField 中最後可以選擇放入 Icon
            icon: const Icon(
              Icons.search, // Flutter 內建的搜尋 icon
              color: Colors.grey, // 設定 icon 顏色
            ),
            // 當 Iicon 被點擊時執行的動作
            onPressed: () async {
              // 得到 TextField 中輸入的 value
              String strings = taiwanessController.text;
              // 如果為空則 return
              if (strings.isEmpty) return;
              // connect to text2speech socket
              // The default is man voice.
              // If you want a female's voice, put "female" into the parameter.
              // parameter: call back function, speech synthesized text, (female)
              await Text2Speech().connect(play, strings, "female");
              // player.init();
              setState(() {
                // player.isPlaying;
              });
            },
          ),
        ),
      ),
    );
  }

  Future play(String pathToReadAudio) async {
    await player.play(pathToReadAudio);
    setState(() {
      player.init();
      player.isPlaying;
    });
  }

  Widget buildChineseField(txt) {
    return Padding(
      padding: const EdgeInsets.only(left: 40, right: 40),
      child: TextField(
        controller: chineseController,
        decoration: InputDecoration(
          filled: true,
          //重點，必須設定為true，fillColor才有效
          fillColor: Colors.white,
          //背景顏色，必須結合filled: true,才有效
          enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(
              color: Colors.black87, // 設定邊框的顏色
              width: 2.0, // 設定邊框的粗細
            ),
          ),
          // when user choose the TextField
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(
            color: Colors.red, // 設定邊框的顏色
            width: 2, // 設定邊框的粗細
          )),
          hintText: txt,
          suffixIcon: IconButton(
            icon: const Icon(
              Icons.search,
              color: Colors.grey,
            ),
            onPressed: () async {
              String strings = chineseController.text;
              if (strings.isEmpty) return;
              print(strings);
              await Text2SpeechFlutter().speak(strings);
            },
          ),
        ),
      ),
    );
  }

  Widget buildOutputField() {
    return Padding(
      padding: const EdgeInsets.only(left: 40, right: 40),
      child: TextField(
        controller: recognitionController, // 設定 controller
        enabled: false, // 設定不能接受輸入
        decoration: const InputDecoration(
          fillColor: Colors.white, // 背景顏色，必須結合filled: true,才有效
          filled: true, // 重點，必須設定為true，fillColor才有效
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)), // 設定邊框圓角弧度
            borderSide: BorderSide(
              color: Colors.black87, // 設定邊框的顏色
              width: 2.0, // 設定邊框的粗細
            ),
          ),
        ),
      ),
    );
  }

  // Use to choose language of speech recognition
  String recognitionLanguage = "Taiwanese";

  Widget buildRadio() {
    return Row(children: <Widget>[
      // Flexible(
      //   child: RadioListTile<String>(
      //     // 設定此選項 value
      //     value: 'Taiwanese',
      //     // Set option name、color
      //     title: const Text(
      //       'Taiwanese',
      //       style: TextStyle(color: Colors.white),
      //     ),
      //     //  如果Radio的value和groupValu一樣就是此 Radio 選中其他設置為不選中
      //     groupValue: recognitionLanguage,
      //     // 設定選種顏色
      //     activeColor: Colors.red,
      //     onChanged: (value) {
      //       setState(() {
      //         // 將 recognitionLanguage 設為 Taiwanese
      //         recognitionLanguage = "Taiwanese";
      //       });
      //     },
      //   ),
      // ),
      Flexible(
        child: RadioListTile<String>(
          // 設定此選項 value
          value: 'Chinese',
          // Set option name、color
          title: const Text(
            'Chinese',
            style: TextStyle(color: Colors.white),
          ),
          //  如果Radio的value和groupValu一樣就是此 Radio 選中其他設置為不選中
          groupValue: recognitionLanguage,
          // 設定選種顏色
          activeColor: Colors.red,
          onChanged: (value) {
            setState(() {
              // 將 recognitionLanguage 設為 Taiwanese
              recognitionLanguage = "Chinese";
            });
          },
        ),
      ),
    ]);
  }
}

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

class MovieCard extends StatelessWidget {
  const MovieCard(
      {Key? key,
      required this.image,
      required this.title,
      required this.plot,
      required this.address})
      : super(key: key);
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
                  Flexible(flex: 1, child: Text(address)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
