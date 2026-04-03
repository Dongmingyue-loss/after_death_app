import 'package:flutter/material.dart';
import 'pages/memo_page.dart';
import 'pages/will_page.dart';
import 'pages/emergency_card_page.dart';

void main() => runApp(const AfterDeathApp());

class AfterDeathApp extends StatelessWidget {
  const AfterDeathApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '死后呢？',
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.blueGrey,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF2C3E50),
          foregroundColor: Colors.white,
        ),
      ),
      home: const MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;
  final List<Widget> _pages = const [
    MemoPage(),
    WillPage(),
    EmergencyCardPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (idx) => setState(() => _currentIndex = idx),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF2C3E50),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.note), label: '备忘录'),
          BottomNavigationBarItem(icon: Icon(Icons.description), label: '遗嘱'),
          BottomNavigationBarItem(icon: Icon(Icons.health_and_safety), label: '急救卡'),
        ],
      ),
    );
  }
}