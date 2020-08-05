import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rowwad/Pages/NewWelcom.dart';
import 'package:rowwad/Pages/QuestionPage.dart';
import 'package:intl/intl.dart' as intl;
import 'package:image_picker/image_picker.dart';

File jsonFile;
Directory dir;
bool fileExists = false;
Map<String, dynamic> fileContent;
int manyTime;
String userName;
File imageFile;
bool isPhotoSelected = false;
String _url;

class SplachScreen extends StatefulWidget {
  SplachScreen({Key key}) : super(key: key);

  @override
  _SplachScreenState createState() => _SplachScreenState();
}

TextEditingController _myController = TextEditingController();

class _SplachScreenState extends State<SplachScreen> {
  @override
  void initState() {
    super.initState();
    getApplicationDocumentsDirectory().then((Directory directory) {
      //! Remplecer SharedReferance
      dir = directory;
      jsonFile = new File(dir.path + "/" + "myFile.json");
      fileExists = jsonFile.existsSync();

      if (fileExists) {
        this.setState(
            () => fileContent = json.decode(jsonFile.readAsStringSync()));
        userName = fileContent['userName'];
        manyTime = fileContent['manyTime'];
        _url = fileContent["urlImage"];

        if (fileContent["userName"] != null) {
          Navigator.of(context).pop();
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NewWelcomPage()),
          );
        } else {
          createData();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("images/allstars.jpg"), fit: BoxFit.fill)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Container(
                padding: EdgeInsets.only(top: 30),
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                            border: Border.all(width: 3, color: Colors.white),
                            color: Colors.purple,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                bottomRight: Radius.circular(20)),
                            gradient: LinearGradient(
                              colors: [Colors.blue, Colors.green],
                            )),
                        child: FittedBox(
                          child: Text(
                            "مسابقة رواد الاغنية المغربية الاصيلة",
                            style: TextStyle(
                                color: Colors.white, fontFamily: "Cairo"),
                          ),
                        )),
                    Expanded(
                      child: Container(
                        //width: MediaQuery.of(context).size.width * 0.7,
                        // height: MediaQuery.of(context).size.width * 0.7,
                        child: Image.asset(
                          "images/logo.png",
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    Container(
                        child: Column(
                      children: <Widget>[
                        myTextField(),
                        SizedBox(
                          height: 20,
                        ),
                        Builder(
                          builder: (context) => Container(
                            width: MediaQuery.of(context).size.width / 2,
                            child: RaisedButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(18.0),
                                  side: BorderSide(color: Colors.red)),
                              color: Colors.red,
                              onPressed: () {
                                if (isPhotoSelected) {
                                  userName = _myController.text;
                                  DateTime now = DateTime.now();
                                  Random random = new Random();
                                  int randomNumber = random.nextInt(9999) + 100;
                                  String formattedDate =
                                      intl.DateFormat('d/M/y HH:mm')
                                          .format(now);
                                  writeToFile("userName",
                                      userName + randomNumber.toString());
                                  writeToFile("firstDate", formattedDate);
                                  writeToFile("imageUrl", imageFile.path);

                                  uploadImage(
                                      context, "$userName$randomNumber");

                                  // ! upload image to firestore

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => QuestionPage()),
                                  );
                                } else {
                                  Scaffold.of(context).showSnackBar(SnackBar(
                                    content: Text("إختر صورة من فضلك",textDirection: TextDirection.rtl,),
                                  ));
                                }

                                // Navigator.of(context).pop();
                              },
                              child: Text(
                                "أدخل المسابقة",
                                style: TextStyle(
                                    fontSize: 20, color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        )
                      ],
                    )), // ? اكتب اسمك من فضلك
                  ],
                ),
              ),
            )
          ],
        ),
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
      print("File does not exist!");
      createFile(content, dir, fileName);
    }
    this.setState(() => fileContent = json.decode(jsonFile.readAsStringSync()));
    print(fileContent);
  }

  @override
  void dispose() {
    super.dispose();
    _myController.dispose();
  }

  Widget myTextField() {
    return Container(
      color: Colors.white.withOpacity(0.9),
      padding: EdgeInsets.all(15),
      child: Column(
        children: <Widget>[
          Directionality(
            textDirection: TextDirection.rtl,
            child: TextField(
              textAlign: TextAlign.right,
              controller: _myController,
              decoration: InputDecoration(
                labelText: "أكتب اسمك من فضلك",
                labelStyle: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                ),
                hoverColor: Colors.black,
                fillColor: Colors.black,
                border: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(25.0),
                  borderSide: new BorderSide(),
                ),
              ),
              keyboardType: TextInputType.text,
              style: new TextStyle(
                color: Colors.black,
                fontFamily: "Poppins",
              ),
            ),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              FittedBox(child: Text("أختر صورة بضغطة او ضغطة مطولة")),
              InkWell(
                onTap: () {
                  isPhotoSelected = true;
                  pickImage(true);
                },
                onLongPress: () {
                  isPhotoSelected = true;
                  pickImage(false);
                },
                child: Container(
                  width: 60,
                  height: 60,
                  child: CircleAvatar(
                    child: isPhotoSelected ? null : Icon(Icons.camera),
                    backgroundImage:
                        imageFile == null ? null : FileImage(imageFile),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Future pickImage(bool camera) async {
    if (camera) {
      File image = await ImagePicker.pickImage(source: ImageSource.camera);
      setState(() {
        imageFile = image;
      });
    } else {
      File image = await ImagePicker.pickImage(source: ImageSource.gallery);
      setState(() {
        imageFile = image;
        isPhotoSelected = true;
      });
    }
  }

  void uploadImage(context, String photoName) async {
    try {
      FirebaseStorage firebaseStorage =
          FirebaseStorage(storageBucket: "gs://rowwad-b7c15.appspot.com");
      StorageReference storageReference =
          firebaseStorage.ref().child("$photoName.jpg");
      StorageUploadTask storageUploadTask = storageReference.putFile(imageFile);
      StorageTaskSnapshot storageTaskSnapshot =
          await storageUploadTask.onComplete;
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text("success"),
      ));
      String url = await storageTaskSnapshot.ref.getDownloadURL();
      setState(() {
        _url = url;
      });
    } catch (ex) {
      print(ex.message);
    }
    writeToFile("urlImage", "_url");
  }

  createData() {
    DocumentReference ds =
        Firestore.instance.collection('User').document("$userName");
    Map<String, dynamic> tasks = {
      "id": userName,
      "name": userName,
      "firstSingin": firstDate,
      "lastLogin": lastDate,
      "totalQuestion": 0,
      "totalGoodQuestion": 0,
      "manyTime": manyTime + 1,
      "autre2": "autre 2 vide",
    };

    ds.setData(tasks).whenComplete(() {});

    print("done done");
  }
}
