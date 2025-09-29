import 'package:flutter/material.dart';
import '../../db/app_db.dart';
import 'receipt_screen.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  List<Map<String, dynamic>> transactions = [];

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  Future<void> _loadTransactions() async {
    final db = await AppDatabase.instance.database;
    final txnList = await db.query('txns', orderBy: 'created_at DESC');
    setState(() {
      transactions = txnList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Transactions')),
      body: transactions.isEmpty
          ? const Center(child: Text('No transactions yet'))
          : ListView.builder(
              itemCount: transactions.length,
              itemBuilder: (context, index) {
                final txn = transactions[index];
                return ListTile(
                  title: Text('Transaction #${txn['id']}'),
                  subtitle: Text('Total: ${txn['total']} | Date: ${txn['created_at']}'),
                  trailing: const Icon(Icons.arrow_forward),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ReceiptScreen(txnId: txn['id']),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
