import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_rounded_progress_bar/flutter_rounded_progress_bar.dart';
import 'package:flutter_rounded_progress_bar/rounded_progress_bar_style.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart' as intl;
import 'package:path_provider/path_provider.dart';
import 'package:rowwad/Model/FireBaseCreate.dart';
import 'package:rowwad/Pages/QuestionPage.dart';

class NewWelcomPage extends StatefulWidget {
  NewWelcomPage({Key key}) : super(key: key);

  @override
  _NewWelcomPageState createState() => _NewWelcomPageState();
}

FireBaseCreate myfireStoreCommand = new FireBaseCreate();
StreamSubscription<QuerySnapshot> lesObjectifs;
String userName;
int position;
int totalBonReponce = 0;
int totalQuestions;
int wrongCal;
String stage;
int stageNumber;
double progressValue = 1;
int manyTime = 1;
double moyen;
String grade;
String firstDate;
String lastDate;
Map data;
File imageFile;
String _url;
String imageUrl;
bool isClicked = false;
final Color myColor = Color.fromRGBO(37, 39, 77, 1);

class _NewWelcomPageState extends State<NewWelcomPage> {
  @override
  void initState() {
    super.initState();
    myInitStat();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        child: Scaffold(
          backgroundColor: Color.fromRGBO(21, 24, 54, 1),
          body: SingleChildScrollView(
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.all(10),
                    color: myColor,
                    child: myHeader(
                        image: imageFile == null
                            ? FileImage(File("$imageUrl"))
                            : FileImage(imageFile),
                        name: userName),
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                            child: myColorContainer(
                                "الأجوبة الصحيحة : $totalBonReponce",
                                "الأجوبة الخاطئة : $wrongCal",
                                "اللقب : $grade ",
                                Colors.blue[800])),
                        SizedBox(width: 10),
                        Expanded(
                            child: myColorContainer(
                                " مجموع الاجوبة : $position",
                                "  مجموع الاسئلة : $totalQuestions",
                                "المرحلة : $stage",
                                Colors.green[800])),
                      ],
                    ),
                  ),
                  Container(
                      padding: EdgeInsets.all(5),
                      child: myProgressBar(progressValue)),
                  Container(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      "الإحصائيات العامة",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontFamily: "Cairo"),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: myListTile(
                        "معدل الإجابات الصحيحة",
                        myMoyenFun(position, totalBonReponce).toString() +
                            '/10',
                        "معدل الاجابات الصحيحة على مجموع الاسئلة",
                        Icon(
                          Icons.show_chart,
                          color: Colors.green,
                        )),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: myListTile(
                        "تاريخ الانضمام",
                        "$firstDate",
                        "أول يوم استعملت التطبيق",
                        Icon(
                          Icons.date_range,
                          color: Colors.green,
                        )),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: myListTile(
                        "عدد الاوسمة المحصل عليها",
                        stageNumber == null ? '0' : stageNumber.toString(),
                        "الفوز بعدد الاوسمة على حسب الاسئلة الصحيحة",
                        Icon(
                          Icons.add,
                          color: Colors.green,
                        )),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    width: 200,
                    child: RaisedButton(
                      color: Colors.blue,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          side: BorderSide(color: Colors.white)),
                      onPressed: () {
                        createData();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => QuestionPage()),
                        );
                      },
                      child: Text(
                        "ممتاز",
                        style: TextStyle(
                            fontSize: 22,
                            fontFamily: "Cairo",
                            color: Colors.white),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Row myHeader({image, String name}) {
    return Row(
      children: [
        CircleAvatar(
          backgroundImage: image,
        ),
        Text(
          "$name",
          style:
              TextStyle(fontSize: 20, fontFamily: "Cairo", color: Colors.white),
        ),
        IconButton(
            icon: Icon(
              Icons.mode_edit,
              color: Colors.white70,
            ),
            onPressed: () {
              _showDialog();
            })
      ],
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
    );
  }

  Container myColorContainer(
      String title, String descrption, String observation, Color color) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(12), color: color),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            "$title",
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          Text(
            "$descrption",
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
          Text(
            "$observation",
            style: TextStyle(fontSize: 15, color: Colors.white54),
          ),
        ],

        // mainAxisAlignment: MainAxisAlignment.spaceAround,
      ),
    );
  }

  Container myProgressBar(num value) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: myColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        textDirection: TextDirection.rtl,
        children: [
          Text("مراحل المسابقة",
              style: TextStyle(
                  color: Colors.white70, fontSize: 15, fontFamily: "Cairo")),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            textDirection: TextDirection.rtl,
            children: [
              Text("البداية",
                  style: TextStyle(
                      color: Colors.white70,
                      fontSize: 15,
                      fontFamily: "Cairo")),
              Text(" سؤال $position",
                  style: TextStyle(
                      color: Colors.white, fontSize: 20, fontFamily: "Cairo")),
              Text("النهاية",
                  style: TextStyle(
                      color: Colors.white70,
                      fontSize: 15,
                      fontFamily: "Cairo")),
            ],
          ),
          RoundedProgressBar(
              reverse: true,
              childCenter: Text(value.toStringAsFixed(0) + " %",
                  style: TextStyle(color: Colors.blue.shade900)),
              percent: value,
              theme: RoundedProgressBarTheme.green),
          SizedBox(
            height: 15,
          ),
        ],
      ),
    );
  }

  Container myListTile(
      String title, String static, String subTitle, Icon icon) {
    return Container(
      decoration: BoxDecoration(
        color: myColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: ListTile(
        title: Text("$title",
            style: TextStyle(fontSize: 20, color: Colors.white),
            textDirection: TextDirection.rtl),
        subtitle: Text(
          "$subTitle",
          style: TextStyle(color: Colors.white70),
          textDirection: TextDirection.rtl,
        ),
        dense: true,
        leading: Text(
          static,
          style: TextStyle(fontSize: 22, color: Colors.yellow.shade100),
        ),
        trailing: icon,
      ),
    );
  }

  void uploadImage(context, String photoName) async {
    //! upload image to firebase Store.
    try {
      FirebaseStorage firebaseStorage =
          FirebaseStorage(storageBucket: "gs://rowwad-b7c15.appspot.com");
      StorageReference storageReference =
          firebaseStorage.ref().child("$userName.jpg");
      StorageUploadTask storageUploadTask = storageReference.putFile(imageFile);
      StorageTaskSnapshot storageTaskSnapshot =
          await storageUploadTask.onComplete;
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text(
          "تم تغيير الصورة بنجاح",
          textDirection: TextDirection.rtl,
        ),
      ));
      String url = await storageTaskSnapshot.ref.getDownloadURL();
      setState(() {
        _url = url;
      });
    } catch (ex) {
      print(ex.message);
    }
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
      print("File does not exist!");
      createFile(content, dir, fileName);
    }
    this.setState(() => fileContent = json.decode(jsonFile.readAsStringSync()));
    print(fileContent);
  }

  void myInitStat() {
    //-------> initStat
    getApplicationDocumentsDirectory().then((Directory directory) {
      dir = directory;
      jsonFile = File(dir.path + "/" + fileName);
      fileExists = jsonFile.existsSync();

      if (fileExists) {
        this.setState(
            () => fileContent = json.decode(jsonFile.readAsStringSync()));
        userName = fileContent["userName"];
        totalBonReponce = fileContent["totalBonReponce"];
        totalBonReponce == null
            ? totalBonReponce = 0
            : totalBonReponce = fileContent["totalBonReponce"];
        firstDate = fileContent["firstDate"];
        manyTime = fileContent["manyTime"];
        stage = fileContent["stage"];
        stageNumber = fileContent['stageNumber'];
        if (stageNumber == null) stageNumber = 0;
        totalQuestions = fileContent["totalQuestions"];
        totalQuestions == null
            ? totalQuestions = 0
            : totalQuestions = fileContent["totalQuestions"];
        manyTime == null ? manyTime = 1 : manyTime = fileContent["manyTime"];
        imageUrl = fileContent["imageUrl"];
        if (fileContent["position"] == null) {
          position = 1;
        } else {
          position = fileContent["position"] + 1;
        }

        writeToFile("manyTime", manyTime + 1);
      }
      if (totalBonReponce != null && totalBonReponce != 0) {
        moyen = (totalBonReponce.toDouble() / position.toDouble()) * 10;
      }
      wrongCal = position - totalBonReponce;
      progressValue = (position / totalQuestions) * 100;
      DateTime now = DateTime.now();
      lastDate = intl.DateFormat('d/M/y HH:mm').format(now);
      myGrade(stageNumber);
      print('stageNumber $stageNumber');
    });
  }

  void myGrade(int myvalue) {
    //--------> function grade<----------//
    if (myvalue >= 0 && myvalue < 10) grade = "مبتدئ";
    if (myvalue >= 10 && myvalue < 20) grade = "لا بأس بك";
    if (myvalue >= 20 && myvalue < 30) grade = "عاصرت الجيل الذهبي";
    if (myvalue >= 30 && myvalue < 40) grade = "انت فنان";
    if (myvalue >= 40) grade = "عميد الأغينة المغربية";
    if (myvalue == null) grade = "مبتدئ";
  }

  Future pickImage(bool isCamera) async {
    //-------> pick image <---------//

    if (isCamera) {
      File image = await ImagePicker.pickImage(source: ImageSource.camera);
      if (image != null) {
        setState(() {
          imageFile = image;
        });
      }
    } else {
      File image = await ImagePicker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        setState(() {
          imageFile = image;
        });
      }
    }
  }

  void _showDialog() {
    //-------> ShowDialog<-----------//
    TextEditingController textEditingController = TextEditingController();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                InkWell(
                  onTap: () {
                    pickImage(true).then((_) {
                      uploadImage(context, userName);
                      writeToFile("imageUrl", imageFile.path);
                      imageUrl=imageFile.path;
                    });
                    setState(() {});
                  },
                  onLongPress: () {
                    pickImage(false).then((_) {
                      uploadImage(context, userName);
                      writeToFile("imageUrl", imageFile.path);
                      imageUrl=imageFile.path;
                    });
                    setState(() {});
                  },
                  child: CircleAvatar(
                    backgroundImage: FileImage(File(imageUrl)),
                  ),
                ),
                Text(
                  'تعديل المعلومات',
                  textDirection: TextDirection.rtl,
                ),
              ],
            ),
            content: Directionality(
              textDirection: TextDirection.rtl,
              child: TextField(
                controller: textEditingController,
                decoration: InputDecoration(
                    labelText: userName, hintStyle: TextStyle()),
                //hintText: userName, hintStyle: TextStyle()),
              ),
            ),
            actions: [
              RaisedButton(
                color: Colors.green,
                child: Text("حفظ"),
                onPressed: () {
                  writeToFile("imageUrl", imageFile.path);
                  writeToFile("userName", textEditingController.text);
                  userName = textEditingController.text;
                  setState(() {});
                  Navigator.of(context).pop();
                },
              ),
              RaisedButton(
                color: Colors.blue,
                child: Text("إلغاء"),
                onPressed: () {
                  setState(() {});
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  String myMoyenFun(num totalReponce, num bonReponce) {
    return ((bonReponce / totalReponce) * 10).toStringAsFixed(1);
  }

  //? function to put data to firebase
  createData() {
    DocumentReference ds =
        Firestore.instance.collection('User').document("$userName");
    Map<String, dynamic> tasks = {
      "id": userName,
      "name": userName,
      "firstSingin": firstDate,
      "lastLogin": lastDate,
      "totalQuestion": position,
      "totalGoodQuestion": totalBonReponce,
      "manyTime": manyTime + 1,
      "autre2": "autre 2 vide",
    };

    ds.setData(tasks).whenComplete(() {
      print("Saving date is done");
    });
  }
}
