
import 'package:flutter/material.dart';



Widget myQuestionText(String question) {
  return Stack(
    children: <Widget>[
      Container(
        color: Colors.transparent,
        child: Image.asset("images/tv2.jpg"),
      ),
      Center(
        child: Container(
          width: 240,
          height: 180,
          margin: EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 100),
          child: Center(
            child: Text(question,
                overflow: TextOverflow.ellipsis,
                maxLines: 4,
                style: TextStyle(
                  fontFamily: "Cairo",

                    fontSize: 25,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
                textDirection: TextDirection.rtl),
          ),
        ),
      )
    ],
  );
}

Widget myQuestionImage(String question, String image) {
  return Container(

    width: double.infinity,
    height: 250,
    alignment: Alignment.bottomCenter,
    decoration: BoxDecoration(
      image: DecorationImage(image: AssetImage(image),fit: BoxFit.fill)
    ),
    child: Text(
      question,style: TextStyle(fontSize:25,fontFamily: "Cairo",fontWeight: FontWeight.bold, color: Colors.white,backgroundColor: Colors.black54),textAlign: TextAlign.center,),

  );
}


