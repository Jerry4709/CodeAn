import 'package:flutter/material.dart';
import 'profile_page.dart';
import 'schedule_page.dart';
import 'package:team_up/widgets/sport_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          SportCard(
            imageUrl: 'assets/images/field1.jpg',
            title: 'เล่นฟุตบอล (3 ชม.)',
            location: 'สนาม C - Super Star Arena',
            distance: '9.52 กม.',
            dateTime: '3 มิ.ย. 17:30-20:30 น.',
            price: '80 บาท/คน',
            participants: '4/21',
          ),
          const SizedBox(height: 10),
          SportCard(
            imageUrl: 'assets/images/field2.jpg',
            title: 'เล่นฟุตบอล (9 ชม.)',
            location: 'สนาม A - Flick Football Arena',
            distance: '11.2 กม.',
            dateTime: '3 มิ.ย. 9:00-18:00 น.',
            price: '91 บาท/คน',
            participants: '0/40',
          ),
        ],
      ),
      const SchedulePage(),
      const ProfilePage(),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('หน้าแรก'),
        backgroundColor: Colors.orange,
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'หน้าแรก',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'ตารางเล่น',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'บัญชี',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }
}
