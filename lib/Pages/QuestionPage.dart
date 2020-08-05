import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_rounded_progress_bar/flutter_rounded_progress_bar.dart';
import 'package:flutter_rounded_progress_bar/rounded_progress_bar_style.dart';
import 'package:rowwad/Model/QuestionModel.dart';
import 'package:rowwad/Pages/NewWelcom.dart';
import 'package:rowwad/Widgets/QuestionZone.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:path_provider/path_provider.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';

int position = 0;
bool playMp3 = true;
String userNameTxt = "";
String userName = "";
String positionGlobale = "0";
String firstVisite = "";
int stageNumber=0;
// parametre
File jsonFile;
Directory dir;
String fileName = "myFile.json";
bool fileExists = false;
Map<String, dynamic> fileContent;
String imageUrl = "";

//! end parametre

//containerAnimation
double _width1=300 ;
double _width2= 300;
double _width3 = 300;
double _width4 = 300;
//end containerAnimation
class QuestionPage extends StatefulWidget {
  QuestionPage({Key key}) : super(key: key);
  @override
  _QuestionPageState createState() => _QuestionPageState();
}

AudioPlayer audioPlayer = AudioPlayer();
AudioCache audioCache = AudioCache(fixedPlayer: audioPlayer);

Color newColor = Colors.transparent;

int totalBonReponce = 0;


Color _newColor1 = Colors.transparent;
Color _newColor2 = Colors.transparent;
Color _newColor3 = Colors.transparent;
Color _newColor4 = Colors.transparent;
final assetsAudioPlayer = AssetsAudioPlayer();

class _QuestionPageState extends State<QuestionPage> {
  @override
  void initState() {
    super.initState();
    getApplicationDocumentsDirectory().then((Directory directory) {
      dir = directory;
      jsonFile = File(dir.path + "/" + fileName);
      fileExists = jsonFile.existsSync();

      if (fileExists) {
        this.setState(
            () => fileContent = json.decode(jsonFile.readAsStringSync()));
        if (fileContent["position"] == null) {
          fileContent["position"] = 0;
          imageUrl = fileContent["imageUrl"];

        } else {
          setState(() {
            position = fileContent["position"]+1 ;
            totalBonReponce = fileContent["totalBonReponce"];
            imageUrl = fileContent["imageUrl"];
          });
        }
      } else {
        position = 0;
      }
    });
  }

  List data = [];
  List<Questions> questions = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: DefaultAssetBundle.of(context)
              .loadString("Myjson/Questions.json"),
          builder: (context, snapshot) {
            if (snapshot.data == null)
              return Center(child: CircularProgressIndicator());
            if (imageUrl == null)
              return Center(child: CircularProgressIndicator());
            questions = parseJson(snapshot.data.toString());

            return SafeArea(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 5),
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("images/background.png"),
                        fit: BoxFit.cover)),
                child: Column(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Expanded(
                            flex:1,
                            child: Container(
                              height: 55,
                              child: RoundedProgressBar(
                                height: 40,
                                  childCenter: Text("الاسئلة المجابة : ${position } من اصل ${questions.length}",
                                      style: TextStyle(fontSize:20,color: Colors.black)),
                                  percent: position/questions.length*100,
                                  theme: RoundedProgressBarTheme.blue),
                            ),
                          ),
                          SizedBox(width: 5),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => NewWelcomPage()),
                              );
                            },
                            child: Container(
                                height: 60,
                                width: 60,
                                child: CircleAvatar(
                                    backgroundImage: imageUrl == null
                                        ? null
                                        : FileImage(File("$imageUrl")))

                                // child: myProgressBarCircle(myProvider.counter,myProvider.counter),
                                ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Expanded(
                      flex: 3,
                      child: Container(child: questionType()),
                    ),
                    Expanded(
                      flex: 4,
                      child: Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            myBotton1(
                              titre: questions[position].reponce1,
                            ),
                            myBotton2(
                              titre: questions[position].reponce2,
                            ),
                            myBotton3(
                              titre: questions[position].reponce3,
                            ),
                            myBotton4(
                              titre: questions[position].reponce4,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }

  Widget myBotton1({String titre}) {

    return AnimatedContainer(
      duration: Duration(milliseconds: 100),
        curve: Curves.easeIn,
        width: _width1,
        child: RaisedButton(
          textColor: Colors.white,
          color: _newColor1,
          child: Container(
              width: _width1,
              child: Center(
                  child: Text(
                "$titre",
                style: TextStyle(fontSize: 25),
              ))),
          onPressed: () {
            assetsAudioPlayer.stop();
            animateContainer(1);
            writeValues();
            if (questions[position].goodReponce == "1") {
              _newColor1 = Colors.green[200];
              setState(() {});
              Timer(Duration(seconds: 2), () {
                myDialogGood();
                reSetColor();
              });
            } else {
              _newColor1 = Colors.green[200];
              setState(() {});
              Timer(Duration(seconds: 2), () {
                myDialogWrong();
                reSetColor();
              });
            }
            playMp3 = false;
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
        ));

  }

  Widget myBotton2({String titre}) {
    return AnimatedContainer (
      duration: Duration(milliseconds: 100),
        curve: Curves.easeIn,
        width: _width2,
        child: RaisedButton(
          textColor: Colors.white,
          color: _newColor2,
          child: Container(
              margin: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.1),
              child: Center(
                  child: Text(
                "$titre",
                style: TextStyle(fontSize: 25),
              ))),
          onPressed: () {
            assetsAudioPlayer.stop();
            animateContainer(2);
            writeValues();
            if (questions[position].goodReponce == "2") {
              _newColor2 = Colors.green[200];
              setState(() {});

              Timer(Duration(seconds: 2), () {
                myDialogGood();
                reSetColor();
              });
            } else {
              _newColor2 = Colors.green[200];
              setState(() {});

              Timer(Duration(seconds: 2), () {
                myDialogWrong();
                reSetColor();
              });
            }
            playMp3 = false;
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
        ));
  }

  Widget myBotton3({String titre}) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 100),
        curve: Curves.easeIn,
        width: _width3,
        child: RaisedButton(
          textColor: Colors.white,
          color: _newColor3,
          child: Container(
              margin: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.1),
              child: Center(
                  child: Text(
                "$titre",
                style: TextStyle(fontSize: 25),
              ))),
          onPressed: () {
            assetsAudioPlayer.stop();
            animateContainer(3);
            writeValues();
            if (questions[position].goodReponce == "3") {
              _newColor3 = Colors.green[200];
              setState(() {});

              Timer(Duration(seconds: 2), () {
                myDialogGood();
                reSetColor();
              });
            } else {
              _newColor3 = Colors.green[200];
              setState(() {});

              Timer(Duration(seconds: 2), () {
                myDialogWrong();
                reSetColor();
              });
            }
            playMp3 = false;
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
        ));
  }

  Widget myBotton4({String titre}) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 100),
        curve: Curves.easeIn,
        width: _width4,
        child: RaisedButton(
          textColor: Colors.white,
          color: _newColor4,
          child: Container(
              margin: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.1),
              child: Center(
                  child: Text(
                "$titre",
                style: TextStyle(fontSize: 25),
              ))),
          onPressed: () {
            assetsAudioPlayer.stop();
            animateContainer(4);
            writeValues();
            if (questions[position].goodReponce == "4") {
              _newColor4 = Colors.green[200];
              setState(() {});
              Timer(Duration(seconds: 2), () {
                myDialogGood();
                reSetColor();
              });
            } else {
              _newColor4 = Colors.green[200];
              setState(() {});
              Timer(Duration(seconds: 2), () {
                myDialogWrong();
                reSetColor();
              });
            }
            playMp3 = false;
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
        ));
  }

  List<Questions> parseJson(String response) {
    if (response == null) {
      return [];
    }
    final parsed =
        json.decode(response.toString()).cast<Map<String, dynamic>>();
    return parsed
        .map<Questions>((json) => new Questions.fromJson(json))
        .toList();
  }

  void reSetColor() {
    setState(() {
      _newColor1 = Colors.transparent;
      _newColor2 = Colors.transparent;
      _newColor3 = Colors.transparent;
      _newColor4 = Colors.transparent;

      _width1=300;
      _width2=300;
      _width3=300;
      _width4=300;
    });
  }
  void writeValues(){
  writeToFile('position', position);
  writeToFile('totalBonReponce', totalBonReponce);
  }

  Widget questionType() {
    switch (questions[position].type) {
      case "question":
        return myQuestionText("${questions[position].question}");
        break;
      case "image":
        return myQuestionImage(
            "${questions[position].question}", "${questions[position].image}");
        break;
      case "sound":
        {
          if (playMp3) {
            return myQuestionAudio(
                questions[position].question, questions[position].file, true);
          }
          if (!playMp3) {
            return myQuestionAudio(
                questions[position].question, questions[position].file, false);
          }
        }
        break;
    }
    return null;
  }

  void myDialogGood() {
    assetsAudioPlayer.stop();
    assetsAudioPlayer.open(
      Audio("assets/winning.mp3"),
    );
    assetsAudioPlayer.play();
    setState(() {
      totalBonReponce++;
    });

    showDialog(
      context: context,
      builder: (_) => AssetGiffyDialog(
        image: Image.asset(
          "${questions[position].image}",
          fit: BoxFit.cover,
        ),
        title: Text(
          "ممتاز",
          style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),
        ),
        description: Text(
          questions[position].info,
          style: TextStyle(fontSize: 18),
          textDirection: TextDirection.rtl,
        ),
        onlyOkButton: true,
        buttonOkText: Text("لنستمر",style: TextStyle(color: Colors.white),),
        onOkButtonPressed: () {
          assetsAudioPlayer.stop();
          playMp3 = true;
          writeToFile("totalQuestions", questions.length);
          Navigator.of(context).pop();
          addCounter();
        },
      ),
    );
  }

  void myDialogWrong() {
    assetsAudioPlayer.stop();
    assetsAudioPlayer.open(
      Audio("assets/wrong.mp3"),
    );
    assetsAudioPlayer.play();



    showDialog(
        context: context,
        builder: (_) => AssetGiffyDialog(
              image: Image.asset(
                "${questions[position].image}",
                fit: BoxFit.cover,
              ),
              title: Text(
                "الجواب خطئ",
                style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),
              ),
              description: Text(
                questions[position].info,
                style: TextStyle(fontSize: 18),
                textDirection: TextDirection.rtl,
              ),
              onOkButtonPressed: () {
                assetsAudioPlayer.stop();
                playMp3 = true;
                writeToFile("totalQuestions", questions.length);
                Navigator.of(context).pop();
                addCounter();
              },
              onlyOkButton: true,
          buttonOkText: Text("لا بأس",style: TextStyle(color: Colors.white),),
            ));
  }

  void myDialogWinning({String image, subtitle}) {
    assetsAudioPlayer.stop();
    assetsAudioPlayer.open(
      Audio("assets/winning.mp3"),
    );


    assetsAudioPlayer.play();
    showDialog(
      context: context,
      builder: (_) => AssetGiffyDialog(
        image: Image.asset(
          "$image",
          fit: BoxFit.fill,
        ),
        title: Text(
          "ممتاز",
          style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),
        ),
        description: Text(
          "$subtitle",
          style: TextStyle(fontSize: 18),
          textDirection: TextDirection.rtl,
        ),
        onlyOkButton: true,
        onOkButtonPressed: () {
          
          Navigator.of(context).pop();
        },
      ),
    );
  }

  void createFile(
      Map<String, dynamic> content, Directory dir, String fileName) {
    print("Creating file!");
    File file = new File(dir.path + "/" + fileName);
    file.createSync();
    fileExists = true;
    file.writeAsStringSync(json.encode(content));
  }

  void writeToFile(String key, dynamic value) {
    print("Writing to file!");
    Map<String, dynamic> content = {key: value};
    if (fileExists) {
      print("File exists");
      Map<String, dynamic> jsonFileContent =
          json.decode(jsonFile.readAsStringSync());
      jsonFileContent.addAll(content);
      jsonFile.writeAsStringSync(json.encode(jsonFileContent));
    } else {
      createFile(content, dir, fileName);
    }
    this.setState(() => fileContent = json.decode(jsonFile.readAsStringSync()));
    print(fileContent);
  }

  void addCounter() {
    winnerFun();
    assetsAudioPlayer.stop();
    writeToFile("position", position);
    writeToFile("totalBonReponce", totalBonReponce);
    writeToFile("stage", questions[position].stage);
    setState(() {
      position++;
    });
  }

  void winnerFun() {

    switch (totalBonReponce) {
      case 10:
        myDialogWinning(
            image: "images/cup_winner1.jpg",
            subtitle: "لقد فزت بوسام المرحلة الاولى..مبروك");
        writeToFile('stageNumber', 10);
        break;
      case 20:
        myDialogWinning(
            image: "images/cup_winner2.jpg",
            subtitle: "لقد فزت بوسام المرحلة الثانية..مبروك");
        writeToFile('stageNumber', 20);
        break;
      case 30:
        myDialogWinning(
            image: "images/cup_winner3.jpg",
            subtitle: "لقد فزت بوسام المرحلة الثالثة..مبروك");
        writeToFile('stageNumber', 30);
        break;
      case 40:
        myDialogWinning(
            image: "images/cup_winner4.jpg",
            subtitle: "لقد فزت بوسام المرحلة الرابعة..مبروك");
        writeToFile('stageNumber', 40);
        break;
      case 50:
        myDialogWinning(
            image: "images/cup_winner5.jpg",
            subtitle: "لقد فزت بوسام المرحلة الخامسة..مبروك");
        writeToFile('stageNumber', 50);
        break;

      default:
    }
  }

  Future stopMyMp3() async {
    await assetsAudioPlayer.stop();
  }

  Widget myQuestionAudio(String question, String audio, bool playMp3) {
    if (playMp3) {
      assetsAudioPlayer.open(
        Audio("assets/$audio"),
      );
      assetsAudioPlayer.play();
    } else {
      assetsAudioPlayer.stop();
    }
    return Stack(
      children: <Widget>[
        Container(
          child: Image.asset("images/k7.gif"),
        ),
        Positioned(
          top: 25,
          left: 10,
          right: 10,
          child: Container(
            child: Center(
                child: Text(
              question,
              style: TextStyle(fontSize: 25, color: Colors.black),
              textAlign: TextAlign.center,
            )),
          ),
        ),
        Align(
          alignment: Alignment(0.75, -0.2),
          child: IconButton(
            onPressed: () {
              assetsAudioPlayer.stop();
              assetsAudioPlayer.open(
                Audio("assets/$audio"),
              );
              assetsAudioPlayer.play();
            },
            color: Colors.transparent,
            icon: Icon(
              Icons.replay,
              size: 40,
              color: Colors.blue,
            ),
          ),
        ),
        Align(
          alignment: Alignment(-0.75, -0.2),
          child: IconButton(
            onPressed: () {
              assetsAudioPlayer.playOrPause();
            },
            color: Colors.transparent,
            icon: Icon(
              Icons.play_arrow,
              size: 40,
              color: Colors.blue,
            ),
          ),
        ),
      ],
    );
  }

  animateContainer(int bottonNumber) {
    switch(bottonNumber){
      case 1:
        setState(() {
          _width1=MediaQuery.of(context).size.width;
        });
        break;
      case 2:
        setState(() {
          _width2=MediaQuery.of(context).size.width;
        });
        break;
      case 3:
        setState(() {
          _width3=MediaQuery.of(context).size.width;
        });
        break;
      case 4:
        setState(() {
          _width4=MediaQuery.of(context).size.width;
        });
        break;

    }

  }

}

// Class Custom dialog //
