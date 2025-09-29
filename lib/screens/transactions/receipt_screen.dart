import 'package:flutter/material.dart';
import '../../db/app_db.dart';
import '../../utils/pdf_export.dart';

class ReceiptScreen extends StatefulWidget {
  final int txnId;
  const ReceiptScreen({super.key, required this.txnId});

  @override
  State<ReceiptScreen> createState() => _ReceiptScreenState();
}

class _ReceiptScreenState extends State<ReceiptScreen> {
  Map<String, dynamic>? txn;
  List<Map<String, dynamic>> items = [];

  @override
  void initState() {
    super.initState();
    _loadTransaction();
  }

  Future<void> _loadTransaction() async {
    final db = await AppDatabase.instance.database;
    final txnList = await db.query('txns', where: 'id=?', whereArgs: [widget.txnId]);
    final txnItems = await db.query('txn_items', where: 'txn_id=?', whereArgs: [widget.txnId]);

    setState(() {
      txn = txnList.first;
      items = txnItems;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (txn == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Receipt')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Transaction #${txn!['id']}'),
            Text('Date: ${txn!['created_at']}'),
            const SizedBox(height: 10),
            ...items.map((item) => Text('Item ID: ${item['item_id']} x${item['qty']} = ${item['price']}')),
            const SizedBox(height: 10),
            Text('Total: ${txn!['total']}', style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await exportReceipt(txn!, items);
              },
              child: const Text('Export PDF'),
            ),
          ],
        ),
      ),
    );
  }
}
