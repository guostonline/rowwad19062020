import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:rowwad/Model/QuestionModel.dart';

 List data=[];
List<Questions>question=[];
class ListofQuestions extends StatelessWidget {
  
  const ListofQuestions({Key key}) : super(key: key);
 
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        body: FutureBuilder(
          future:DefaultAssetBundle.of(context) 
          .loadString("Myjson/Questions.json"),
          builder: (context, snapshot) {
            if(snapshot.data==null)return Center(child: CircularProgressIndicator(),);
            question=parseJson(snapshot.data.toString());
            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, int position){
                return ListTile(
                  leading:Text(position.toString()),
                  title: Text(question[position].question),
                  subtitle: Text(question[position].goodReponce),
                );
              }
              
              );
          },
        ),
      ),
    );
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
}