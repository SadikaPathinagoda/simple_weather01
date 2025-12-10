// lib/features/weather/presentation/screens/record_page.dart

import 'package:flutter/material.dart';
import 'package:simple_weather01/services/database/record.dart';

class RecordPage extends StatefulWidget {
  const RecordPage({super.key});

  @override
  State<RecordPage> createState() => _RecordPageState();
}

class _RecordPageState extends State<RecordPage> {
  // for now, keep records only in memory
  final List<Record> _records = [];

  void _addDummyRecord() {
    final newRecord = Record(
      id: null,
      city: 'London, UK',
      label: 'Home',
      region: 'Europe',
      note: 'My main city',
    );
    setState(() {
      _records.add(newRecord);
    });
  }

  void _deleteRecord(int index) {
    setState(() {
      _records.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Records (Test)'),
      ),
      body: ListView.builder(
        itemCount: _records.length,
        itemBuilder: (context, index) {
          final r = _records[index];
          return ListTile(
            title: Text(r.city),
            subtitle: Text('${r.label} • ${r.region}\n${r.note}'),
            isThreeLine: true,
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => _deleteRecord(index),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addDummyRecord,
        child: const Icon(Icons.add),
      ),
    );
  }
}
