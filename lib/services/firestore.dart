import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_projects/services/auth.dart';
import 'package:easy_projects/services/models.dart';
import 'package:rxdart/rxdart.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<TaskList> streamTaskList() {
    return AuthService().userStream.switchMap((user) {
      if (user == null) {
        return Stream.fromIterable([TaskList()]);
      }

      var ref = _db.collection('tasklist').doc(user.uid);
      return ref.snapshots().map((doc) => TaskList.fromJson(doc.data()!));
    });
  }

  Future<void> createTask(String taskDescription) {
    var user = AuthService().user!;
    var ref = _db.collection('tasklist').doc(user.uid);

    var data = {
      'tasks': FieldValue.arrayUnion([
        {'description': taskDescription, 'done': false}
      ])
    };

    return ref.set(data, SetOptions(merge: true));
  }

  Future<void> toggleTaskDone(Task task) {
    var user = AuthService().user!;
    var ref = _db.collection('tasklist').doc(user.uid);

    ref.set({
      'tasks': FieldValue.arrayRemove([
        {'description': task.description, 'done': task.done}
      ])
    }, SetOptions(merge: true));

    return ref.set({
      'tasks': FieldValue.arrayUnion([
        {'description': task.description, 'done': !task.done}
      ])
    }, SetOptions(merge: true));
  }
}
