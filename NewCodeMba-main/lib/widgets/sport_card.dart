import 'package:flutter/material.dart';

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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
            child: Image.asset(
              imageUrl,
              fit: BoxFit.cover,
              width: double.infinity,
              height: 150,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text('Location: $location'),
                const SizedBox(height: 5),
                Text('Distance: $distance'),
                const SizedBox(height: 5),
                Text('Date/Time: $dateTime'),
                const SizedBox(height: 5),
                Text('Price: $price'),
                const SizedBox(height: 5),
                Text('Participants: $participants'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
