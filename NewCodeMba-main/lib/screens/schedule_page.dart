//sceidue
import 'package:flutter/material.dart';

class SchedulePage extends StatelessWidget {
  const SchedulePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          LineupCard(
            title: 'สนาม TNK Sport Complex',
            dateTime: 'วันที่: 4 มิ.ย. เวลา 10:00 - 14:00 น.',
            location: 'จังหวัด พะเยา อ.เมือง ต.กุดป่อง',
            players: ['Luis Suarez', 'Leonel Messi', 'Neymar Jr', 'M.Salah'],
            price: '100 บาท/คน',
            participants: '18/30',
            imageUrl: 'assets/images/TNK.jpg',
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
  final String price;
  final String participants;
  final String imageUrl;

  const LineupCard({
    super.key,
    required this.title,
    required this.dateTime,
    required this.location,
    required this.players,
    required this.price,
    required this.participants,
    required this.imageUrl,
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
            // รูปภาพสนาม
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                imageUrl,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 10),
            // ชื่อสนาม
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
            // ราคาและจำนวนผู้เล่น
            Row(
              children: [
                Text(
                  'ราคา: $price',
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(width: 10),
                Text(
                  'ผู้เล่น: $participants',
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // รายชื่อผู้เล่น
            const Text(
              'รายชื่อผู้เล่น:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            // แสดงผู้เล่น
            ...players.map(
                  (player) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 2.0),
                child: Text(
                  '- $player',
                  style: const TextStyle(fontSize: 14),
                ),
              ),
            ).toList(),
          ],
        ),
      ),
    );
  }
}