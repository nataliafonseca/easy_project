import 'package:easy_projects/services/firestore.dart';
import 'package:easy_projects/services/models.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  TextEditingController descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool requiredValidator(String? value) {
    return (value == null || value.isEmpty);
  }

  @override
  Widget build(BuildContext context) {
    var tasklist = Provider.of<TaskList>(context);
    var tasks = tasklist.tasks;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromRGBO(20, 171, 236, 1),
        foregroundColor: Colors.white,
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                    scrollable: true,
                    title: const Text('Nova Tarefa'),
                    content: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                TextFormField(
                                  validator: (String? value) {
                                    return requiredValidator(value)
                                        ? 'Este campo é obrigatório'
                                        : null;
                                  },
                                  controller: descriptionController,
                                )
                              ],
                            ))),
                    actions: [
                      ElevatedButton(
                          child: const Text("Criar"),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              FirestoreService()
                                  .createTask(descriptionController.text);
                              descriptionController.clear();
                              Navigator.pop(context);
                            }
                          })
                    ],
                  ));
        },
        child: const Icon(FontAwesomeIcons.plus),
      ),
      body: ListView.separated(
        shrinkWrap: true,
        itemCount: tasks.length,
        itemBuilder: (BuildContext context, int index) {
          Task task = tasks[index];
          return InkWell(
            onTap: () {
              FirestoreService().toggleTaskDone(task);
            },
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(task.description),
                  CheckIcon(done: task.done),
                ],
              ),
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) => const Divider(),
      ),
    );
  }
}

class CheckIcon extends StatelessWidget {
  final bool done;

  const CheckIcon({super.key, required this.done});

  @override
  Widget build(BuildContext context) {
    if (done) {
      return const Icon(FontAwesomeIcons.solidCircleCheck,
          color: Color.fromRGBO(20, 171, 236, 1));
    } else {
      return const Icon(FontAwesomeIcons.solidCircle, color: Colors.grey);
    }
  }
}
