import 'package:flutter/material.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';

Widget myProgressBar(String textHaut, double value, String textBas) {
  return Stack(
    children: <Widget>[
      LiquidLinearProgressIndicator(
        borderRadius: 10,
        backgroundColor: Colors.transparent,
        borderColor: Colors.white,
        value: value,
        borderWidth: 1,
      ),
      Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Expanded(
                      child: Text(
              textHaut,
              style: TextStyle(fontSize: 17, color: Colors.white),
            ),
          ),
          Divider(
            color: Colors.white,
            endIndent: 15,
            indent: 15,
          ),
          Expanded(
                      child: Text(
              textBas,
              style: TextStyle(fontSize: 15, color: Colors.white),
            ),
          ),
        ],
      ))
    ],
  );
}

Widget myProgressBarCircle(String text, double value) {
  return Container(
    padding: EdgeInsets.all(10),
    child: Column(
      children: <Widget>[
        Expanded(
          child: Stack(
            children: <Widget>[
              LiquidCircularProgressIndicator(
                backgroundColor: Colors.transparent,
                borderColor: Colors.white,
                value: value,
                borderWidth: 1,
              ),
              Center(
                  child: Text(
                text,
                style: TextStyle(fontSize: 20, color: Colors.white),
              ))
            ],
          ),
        ),
        SizedBox(
          height: 5,
        ),
        Text(
          "جواب صحيح",
          style: TextStyle(fontSize: 14, color: Colors.white),
        )
      ],
    ),
  );
}
