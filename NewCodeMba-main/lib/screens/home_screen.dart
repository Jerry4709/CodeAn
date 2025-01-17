import 'package:flutter/material.dart';
import 'profile_page.dart'; // นำเข้า ProfilePage
import 'schedule_page.dart'; // นำเข้า SchedulePage

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0; // เก็บสถานะ tab ที่เลือก

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      // หน้าแรก - แสดงรายการกีฬา
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
      // ตารางเล่น
      const SchedulePage(),
      // บัญชี
      const ProfilePage(),
    ];
  }

  // ฟังก์ชันเปลี่ยนแท็บ
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
      body: _pages[_selectedIndex], // แสดงหน้าจอตามแท็บที่เลือก
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'หน้าแรก', // Home
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'ตารางเล่น', // Schedule
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'บัญชี', // Profile
          ),
        ],
        currentIndex: _selectedIndex, // แสดงสถานะแท็บที่เลือก
        selectedItemColor: Colors.orange, // สีของแท็บที่เลือก
        unselectedItemColor: Colors.grey, // สีของแท็บที่ไม่ได้เลือก
        onTap: _onItemTapped, // ฟังก์ชันเปลี่ยนแท็บ
      ),
    );
  }
}

class SportCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String location;
  final String distance;
  final String dateTime;
  final String price;
  final String participants;

  const SportCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.location,
    required this.distance,
    required this.dateTime,
    required this.price,
    required this.participants,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ภาพกีฬา
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
            child: Image.asset(
              imageUrl,
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ชื่อกิจกรรม
                Text(
                  title,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                // รายละเอียดกิจกรรม
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 16, color: Colors.grey),
                    const SizedBox(width: 5),
                    Text(location, style: const TextStyle(color: Colors.grey)),
                  ],
                ),
                const SizedBox(height: 5),
                // ระยะทาง
                Row(
                  children: [
                    const Icon(Icons.directions_walk, size: 16, color: Colors.grey),
                    const SizedBox(width: 5),
                    Text(distance, style: const TextStyle(color: Colors.grey)),
                  ],
                ),
                const SizedBox(height: 10),
                // วันที่และเวลา
                Text(
                  dateTime,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 10),
                // ราคาและจำนวนผู้เข้าร่วม
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      price,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        participants,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
