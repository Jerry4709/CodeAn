import 'package:flutter/material.dart';

class SchedulePage extends StatelessWidget {
  const SchedulePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ตารางเล่น'),
        backgroundColor: Colors.orange,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          LineupCard(
            title: 'ทีม A vs ทีม B',
            dateTime: 'วันที่: 3 มิ.ย. เวลา 17:30 - 19:30 น.',
            location: 'สนาม: Super Star Arena',
            players: ['ผู้เล่น 1', 'ผู้เล่น 2', 'ผู้เล่น 3', 'ผู้เล่น 4'],
          ),
          const SizedBox(height: 10),
          LineupCard(
            title: 'ทีม C vs ทีม D',
            dateTime: 'วันที่: 4 มิ.ย. เวลา 14:00 - 16:00 น.',
            location: 'สนาม: Flick Football Arena',
            players: ['ผู้เล่น 5', 'ผู้เล่น 6', 'ผู้เล่น 7', 'ผู้เล่น 8'],
          ),
        ],
      ),
    );
  }
}

class LineupCard extends StatelessWidget {
  final String title;
  final String dateTime;
  final String location;
  final List<String> players;

  const LineupCard({
    super.key,
    required this.title,
    required this.dateTime,
    required this.location,
    required this.players,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ชื่อทีม
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            // วันที่และเวลา
            Text(dateTime, style: const TextStyle(fontSize: 14, color: Colors.grey)),
            const SizedBox(height: 5),
            // สนาม
            Text(location, style: const TextStyle(fontSize: 14, color: Colors.grey)),
            const SizedBox(height: 10),
            // รายชื่อผู้เล่น
            const Text(
              'รายชื่อผู้เล่น:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            ...players.map(
                  (player) => Text(
                '- $player',
                style: const TextStyle(fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
