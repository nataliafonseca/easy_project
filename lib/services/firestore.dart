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

  Future<void> createTask(
      String title, String description, String category, String deadline) {
    var user = AuthService().user!;
    var ref = _db.collection('tasklist').doc(user.uid);

    var data = {
      'tasks': FieldValue.arrayUnion([
        {
          'description': description,
          'title': title,
          'category': category,
          'deadline': deadline,
          'done': false
        }
      ])
    };

    return ref.set(data, SetOptions(merge: true));
  }

  Future<TaskList> getTaskList() async {
    var user = AuthService().user!;

    var ref = _db.collection('tasklist').doc(user.uid);
    var snapshot = await ref.get();
    return TaskList.fromJson(snapshot.data() ?? {});
  }

  Future<void> toggleTaskDone(Map<String, dynamic> task) async {
    var user = AuthService().user!;
    var ref = _db.collection('tasklist').doc(user.uid);

    var snapshot = await ref.get();
    var list = TaskList.fromJson(snapshot.data() ?? {});
    var taskIndex = list.tasks
        .indexWhere((element) => element['description'] == task['description']);

    list.tasks[taskIndex] = {
      'title': task['title'],
      'category': task['category'],
      'deadline': task['deadline'],
      'description': task['description'],
      'done': !task['done']
    };

    var data = list.toJson();

    return await ref.update(data);
  }

  Future<void> removeTask(Map<String, dynamic> task) {
    var user = AuthService().user!;
    var ref = _db.collection('tasklist').doc(user.uid);

    var data = {
      'tasks': FieldValue.arrayRemove([
        {
          'title': task['title'],
          'category': task['category'],
          'deadline': task['deadline'],
          'description': task['description'],
          'done': task['done']
        }
      ])
    };

    return ref.set(data, SetOptions(merge: true));
  }
}
