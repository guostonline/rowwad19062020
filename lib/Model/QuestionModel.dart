class Questions {
  final String id;
  final String question;
  final String reponce1;
  final String reponce2;
  final String reponce3;
  final String reponce4;
  final String goodReponce;
  final String info;
  final String type;
  final String file;
  final String image;
  final String stage;

  Questions({this.id,this.question, this.reponce1, this.reponce2, this.reponce3,
      this.reponce4, this.goodReponce, this.info, this.type, this.file,
      this.image, this.stage});

  factory Questions.fromJson(Map<String, dynamic>json){
    return Questions(
      id: json['id'] as String,
      question: json['question'] as String,
      reponce1: json['reponce 1'] as String,
      reponce2: json['reponce 2'] as String,
      reponce3: json['reponce 3'] as String,
      reponce4: json['reponce 4'] as String,
      goodReponce: json['bon reponce'] as String,
      info: json['info'] as String,
      type: json['type'] as String,
      file: json['file'] as String,
      image: json['image'] as String,
      stage: json['stage'] as String

    );
  }
}



