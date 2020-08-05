import 'package:flutter/material.dart';
import 'package:rowwad/Pages/QuestionPage.dart';

Widget profileImage({ imageString, name, grade, bonReponce, question,context}) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: <Widget>[
      Container(
        height: 110,
        width: 80,
        padding: EdgeInsets.only(top: 16, bottom: 16),
        child: CircleAvatar(
          backgroundImage: imageString,
        ),
      ),

      Text(
        "$name",
        style: TextStyle(
            fontWeight: FontWeight.bold, fontSize: 30, color: Colors.white),
      ),
      Text(
        "$grade",
        style: TextStyle(
            fontWeight: FontWeight.w400, fontSize: 22, color: Colors.white),
      ),
      //SizedBox(height: 20,),
      myRowBonReponce(bonReponce: bonReponce, question: question,context: context ),
      Container(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Divider(
            height: 10,
            color: Colors.white,
          )),
    ],
  );
}

Widget myRowBonReponce({String bonReponce, question,context}) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 15),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        InkWell(
          onTap: (){
               Navigator.push(
                 context,
                  MaterialPageRoute(builder: (context) => QuestionPage()),
                  );

          },
                  child: Container(
            padding: EdgeInsets.all(16),
            child: Column(
              children: <Widget>[
                Text(
                  "الاجوبة",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
                Text(
                  "الصحيحة",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
                Text(
                  "$bonReponce",
                  style: TextStyle(fontSize: 30, color: Colors.white),
                ),
              ],
            ),
          ),
        ),
        Container(
            height: 80,
            child: VerticalDivider(
              color: Colors.white,
              width: 60,
            )),
        Container(
          padding: EdgeInsets.all(16),
          child: Column(
            children: <Widget>[
              Text(
                "الاجوبة",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
              Text(
                "المجابة",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
              Text(
                "$question",
                style: TextStyle(fontSize: 30, color: Colors.white),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget myStatic({String firstDate, moyen, classement, star}) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 15),
    child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,

      children: <Widget>[
        Text(
          "الاحصائيات",
          style: TextStyle(fontSize: 26, color: Colors.white),
        ),
        informationRow(
          icon: Icons.date_range,
          titre: "تاريخ المشاركة",
          value: "$firstDate"
        ),
        informationRow(
          icon: Icons.device_hub,
          titre: "معدل الاجوبة الصحيحة",
          value: "$moyen"
        ),
        informationRow(
          icon: Icons.show_chart,
          titre: "  ترتيبك في المسابقة وطنيا",
          value: "$classement"
        ),
        informationRow(
          icon: Icons.star,
          titre: "عدد النجوم ",
          value: "$star"
        ),
      ],
    ),
  );
}

Widget informationRow({IconData icon,String titre, value}) {
  return Card(
    
    color: Colors.transparent,
    child: Container(
      decoration: BoxDecoration(
       color: Colors.transparent),
      child: ListTile(
        title: Text(
          "$titre" ,style: TextStyle(fontSize: 15, color:Colors.white),
          textDirection: TextDirection.rtl,
        ),
        trailing: Icon(icon,color:Colors.white),
        leading: Text('$value',style: TextStyle(fontSize: 18, color:Colors.yellow)),
      ),
    ),
  );
}
