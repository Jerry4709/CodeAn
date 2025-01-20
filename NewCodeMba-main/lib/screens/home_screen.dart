import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../widgets/create_room_dialog.dart';
import '../widgets/sport_search_delegate.dart';
import 'profile_page.dart';
import 'schedule_page.dart';

class HomeScreen extends StatefulWidget {
  final String token;

  const HomeScreen({super.key, required this.token});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  List<Map<String, dynamic>> _rooms = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchRoomsFromDatabase();
  }

  Future<void> _fetchRoomsFromDatabase() async {
    final url = Uri.parse('http://192.168.x.x:5001/api/rooms');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> fetchedRooms = jsonDecode(response.body);
        setState(() {
          _rooms = fetchedRooms.cast<Map<String, dynamic>>();
          _isLoading = false;
        });
      } else {
        print('Failed to load rooms: ${response.statusCode}');
        setState(() {
          _isLoading = false;
        });
      }
    } catch (error) {
      print('Error fetching rooms: $error');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _showCreateRoomDialog(BuildContext context) async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (BuildContext context) {
        return const CreateRoomDialog();
      },
    );

    if (result != null) {
      setState(() {
        _rooms.add(result);
      });
    }
  }

  Widget _buildHomePage() {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        if (_isLoading)
          const Center(child: CircularProgressIndicator())
        else if (_rooms.isEmpty)
          const Center(
            child: Text(
              'ยังไม่มีห้องที่สร้าง',
              style: TextStyle(color: Colors.grey),
            ),
          )
        else
          ..._rooms.map((room) {
            return Card(
              child: ListTile(
                title: Text(room['sportName']),
                subtitle: Text(
                  'สนาม: ${room['fieldName']}\n'
                      'เวลา: ${room['time']}\n'
                      'ราคา: ${room['pricePerPerson']} บาท/คน\n'
                      'จำนวน: ${room['maxParticipants']} คน',
                ),
              ),
            );
          }).toList(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      _buildHomePage(),
      const SchedulePage(),
      ProfilePage(token: widget.token),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _selectedIndex == 0 ? 'Home' : _selectedIndex == 1 ? 'Field' : 'Profile',
        ),
        backgroundColor: Colors.orange,
        actions: _selectedIndex == 0
            ? [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: SportSearchDelegate(),
              );
            },
          ),
        ]
            : null,
      ),
      body: pages[_selectedIndex],
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton.extended(
        onPressed: () {
          _showCreateRoomDialog(context);
        },
        label: const Text('สร้างเลย'),
        backgroundColor: Colors.orange,
      )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.sports_soccer), label: 'Field'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
