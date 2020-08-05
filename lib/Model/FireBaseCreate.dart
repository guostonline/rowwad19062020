import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rowwad/Model/User.dart';
import 'User.dart';

final CollectionReference myCollectionObjectif = Firestore.instance.collection('User');

class FireBaseCreate {

  Future<User> createTODOTask(String id, name,firstSingin,lastLogin,num totalQuestion, totalGoodQuestion,String autre1,autre2) async {
    final TransactionHandler createTransaction = (Transaction tx) async {
      final DocumentSnapshot ds = await tx.get(myCollectionObjectif.document());

      final User user = new User(id, name,firstSingin,lastLogin,totalQuestion,totalGoodQuestion,autre1,autre2);
      final Map<String, dynamic> data = user.toMap();
      await tx.set(ds.reference, data);
      return data;
    };

    return Firestore.instance.runTransaction(createTransaction).then((mapData) {
      return User.fromMap(mapData);
    }).catchError((error) {
      print('error: $error');
      return null;
    });
  }

  Stream<QuerySnapshot> getObjectifList({int offset, int limit}) {
    Stream<QuerySnapshot> snapshots = myCollectionObjectif.snapshots();

    if (offset != null) {
      snapshots = snapshots.skip(offset);
    }
    if (limit != null) {
      snapshots = snapshots.take(limit);
    }
    return snapshots;
  }


}
