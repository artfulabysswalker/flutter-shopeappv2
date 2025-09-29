import 'package:flutter/material.dart';
import '../../db/app_db.dart';

class SummaryScreen extends StatefulWidget {
  const SummaryScreen({super.key});

  @override
  State<SummaryScreen> createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen> {
  List<Map<String, dynamic>> _summary = [];

  @override
  void initState() {
    super.initState();
    _loadSummary();
  }

  Future<void> _loadSummary() async {
    final db = await AppDatabase.instance.database;
    final data = await db.rawQuery('''
      SELECT DATE(created_at) as day, SUM(total) as total
      FROM txns
      GROUP BY DATE(created_at)
      ORDER BY DATE(created_at) DESC
    ''');

    setState(() {
      _summary = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Daily Transaction Summary')),
      body: ListView.builder(
        itemCount: _summary.length,
        itemBuilder: (context, index) {
          final item = _summary[index];
          return ListTile(
            title: Text('Date: ${item['day']}'),
            trailing: Text('Total: ${item['total']}'),
          );
        },
      ),
    );
  }
}
