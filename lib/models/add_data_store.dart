import 'dart:math';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreSnippets {
  final FirebaseFirestore db;

  FirestoreSnippets(this.db);

  void runAll(dynamic massage) {
    getStarted_addData(massage);
  }

  void getStarted_addData(dynamic massages) {
    final massage = <String, dynamic>{"massage": massages};

    db
        .collection("massage")
        .add(massage);

   }
}
