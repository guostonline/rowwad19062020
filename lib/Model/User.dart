
class User{// ! for use in fireBase
  String _id;
  String _name;
  String _firstSingin;
  String _lastLogin;
  num _totalQuestion;
  num _totalGoodQuestion;
  String _manyTime;
  String _autre2;

  User(this._id,this._name,this._firstSingin,this._lastLogin,
      this._totalQuestion,this._totalGoodQuestion,this._manyTime,this._autre2);

  User.map(dynamic user){
    this._id=user["id"];
    this._name=user["name"];
    this._firstSingin=user["firstSingin"];
    this._lastLogin=user["lastLogin"];
    this._totalQuestion=user["totalQuestion"];
    this._totalGoodQuestion=user["totalGoodQuestion"];
    this._manyTime=user["manyTime"];
    this._autre2=user["autre2"];
  }
  String get id=>_id;
  String get name=>_name;
  String get firstSingin=>_firstSingin;
  String get lastLogin=>_lastLogin;
  num get totalQuestion=>_totalQuestion;
  num get totalGoodQuestion=>_totalGoodQuestion;
  String get manyTime=>_manyTime;
  String get autre2=>_autre2;

  Map<String, dynamic> toMap(){
    var map = new Map<String, dynamic>();
    map["id"]=_id;
    map["name"]=_name;
    map["firstSingin"]=_firstSingin;
    map["lastLogin"]=_lastLogin;
    map["totalQuestion"]=_totalQuestion;
    map["totalGoodQuestion"]=_totalGoodQuestion;
    map["manyTime"]=_manyTime;
    map["autre2"]=_autre2;
    return map;
  }
  User.fromMap(Map<String, dynamic> map){
    this._id=map["id"];
    this._name=map["_name"];
    this._firstSingin=map["firstSingin"];
    this._lastLogin=map["lastLogin"];
    this._totalQuestion=map["totalQuestion"];
    this._totalGoodQuestion=map["totalGoodQuestion"];
    this._manyTime=map["manyTime"];
    this._autre2=map["autre2"];
  }
}