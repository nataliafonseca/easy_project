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
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController deadlineController = TextEditingController();
  TextEditingController categoryController = TextEditingController();

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
                                    decoration: const InputDecoration(
                                        hintText: 'Título'),
                                    validator: (String? value) {
                                      return requiredValidator(value)
                                          ? 'Este campo é obrigatório'
                                          : null;
                                    },
                                    controller: titleController,
                                  ),
                                  TextFormField(
                                    decoration: const InputDecoration(
                                        hintText: 'Descrição'),
                                    validator: (String? value) {
                                      return requiredValidator(value)
                                          ? 'Este campo é obrigatório'
                                          : null;
                                    },
                                    controller: descriptionController,
                                  ),
                                  TextFormField(
                                    decoration: const InputDecoration(
                                        hintText: 'Categoria'),
                                    validator: (String? value) {
                                      return requiredValidator(value)
                                          ? 'Este campo é obrigatório'
                                          : null;
                                    },
                                    controller: categoryController,
                                  ),
                                  TextFormField(
                                    decoration: const InputDecoration(
                                        hintText: 'Prazo'),
                                    validator: (String? value) {
                                      return requiredValidator(value)
                                          ? 'Este campo é obrigatório'
                                          : null;
                                    },
                                    controller: deadlineController,
                                  ),
                                ],
                              ))),
                      actions: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                              child: const Text("Criar"),
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  FirestoreService().createTask(
                                      titleController.text,
                                      descriptionController.text,
                                      categoryController.text,
                                      deadlineController.text);
                                  titleController.clear();
                                  descriptionController.clear();
                                  categoryController.clear();
                                  deadlineController.clear();
                                  Navigator.pop(context);
                                }
                              }),
                        )
                      ],
                    ));
          },
          child: const Icon(FontAwesomeIcons.plus),
        ),
        body: RenderedList(tasks: tasks));
  }
}

class CheckIcon extends StatelessWidget {
  final bool done;

  const CheckIcon({super.key, required this.done});

  @override
  Widget build(BuildContext context) {
    if (done) {
      return const Icon(FontAwesomeIcons.solidCircleCheck, color: Colors.blue);
    } else {
      return const Icon(FontAwesomeIcons.solidCircle, color: Colors.grey);
    }
  }
}

class TaskItem extends StatelessWidget {
  final Map<String, dynamic> task;
  const TaskItem({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        await FirestoreService().toggleTaskDone(task);
      },
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      task['category'],
                      style: const TextStyle(color: Colors.black54),
                    ),
                    const SizedBox(
                      width: 30,
                    ),
                    const Icon(
                      FontAwesomeIcons.clock,
                      size: 14,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(task['deadline']),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  '${task['title']}',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.black87),
                ),
                Text(
                  '${task['description']}',
                  style: const TextStyle(
                      fontWeight: FontWeight.normal, color: Colors.black87),
                ),
                const SizedBox(
                  height: 5,
                ),
              ],
            ),
            CheckIcon(done: task['done']),
          ],
        ),
      ),
    );
  }
}

class TaskListWithTasks extends StatelessWidget {
  final List<Map<String, dynamic>> tasks;
  const TaskListWithTasks({super.key, required this.tasks});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      itemCount: tasks.length,
      itemBuilder: (BuildContext context, int index) {
        Map<String, dynamic> task = tasks[index];
        return Dismissible(
            key: UniqueKey(),
            background: Container(
              color: Colors.red[800],
            ),
            onDismissed: (DismissDirection direction) {
              FirestoreService().removeTask(task);
            },
            child: TaskItem(
              task: task,
            ));
      },
      separatorBuilder: (BuildContext context, int index) => const Divider(),
    );
  }
}

class TaskListEmpty extends StatelessWidget {
  const TaskListEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(width: 150, child: Image.asset('assets/empty_list.png')),
          const SizedBox(height: 50),
          const Text(
            'Nenhuma tarefa cadastrada',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          const Text(
            'Comece adicionando uma tarefa',
          )
        ],
      ),
    );
  }
}

class RenderedList extends StatelessWidget {
  final List<Map<String, dynamic>> tasks;
  const RenderedList({super.key, required this.tasks});

  @override
  Widget build(BuildContext context) {
    if (tasks.isEmpty) {
      return const TaskListEmpty();
    }
    return TaskListWithTasks(tasks: tasks);
  }
}
