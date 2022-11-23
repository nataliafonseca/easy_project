import 'package:easy_projects/about/about.dart';
import 'package:easy_projects/profile/profile.dart';
import 'package:easy_projects/tasks/tasks.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tuple/tuple.dart';

class AppRouter extends StatefulWidget {
  const AppRouter({super.key});

  @override
  State<AppRouter> createState() => _AppRouterState();
}

class _AppRouterState extends State<AppRouter> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  static const List<Tuple2<String, Widget>> _pages = [
    Tuple2<String, Widget>('Tarefas', TasksScreen()),
    Tuple2<String, Widget>('Sobre', AboutScreen()),
    Tuple2<String, Widget>('Perfil', ProfileScreen()),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_pages.elementAt(_selectedIndex).item1)),
      body: SizedBox(child: _pages.elementAt(_selectedIndex).item2),
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(
                FontAwesomeIcons.listCheck,
                size: 20,
              ),
              label: 'Tarefas',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                FontAwesomeIcons.info,
                size: 20,
              ),
              label: 'Sobre',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                FontAwesomeIcons.user,
                size: 20,
              ),
              label: 'Perfil',
            ),
          ],
          fixedColor: const Color.fromRGBO(20, 171, 236, 1),
          onTap: _onItemTapped),
    );
  }
}
