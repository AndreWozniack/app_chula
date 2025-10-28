import 'package:flutter/material.dart';
import 'package:app_chula/features/sequences/sequencesView.dart';
import 'package:app_chula/features/passos/passos_view.dart';
import 'package:app_chula/features/festivals/fastivalsView.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 1;

  final List<Widget> _pages = const [
    SequencesView(),
    PassosView(),
    FastivalsView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) => setState(() => _currentIndex = index),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.article),
            label: 'Sequências',
          ),
          NavigationDestination(
            icon: Icon(Icons.directions_run),
            label: 'Passos',
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_month),
            label: 'Festivais',
          ),
        ],
      ),
    );
  }
}