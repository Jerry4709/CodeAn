import 'package:flutter/material.dart';
class SportSearchDelegate extends SearchDelegate<String> {
  final List<String> _activities = [
    'เล่นฟุตบอล (3 ชม.) - สนาม Chom Park',
    'เล่นฟุตบอล (5 ชม.) - สนาม SV FUTSAL CLUB',
    'เล่นฟุตบอล (4 ชม.) - สนาม TNK Sport Complex',
    'เล่นฟุตบอล (2 ชม.) - สนามสองลม สเตเดี้ยม',
  ];

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = ''; // ล้างข้อความค้นหา
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, ''); // ปิดหน้าค้นหา
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = _activities
        .where((activity) => activity.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(results[index]),
          onTap: () {
            close(context, results[index]);
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = _activities
        .where((activity) => activity.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(suggestions[index]),
          onTap: () {
            query = suggestions[index];
            showResults(context);
          },
        );
      },
    );
  }
}