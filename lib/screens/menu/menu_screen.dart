//MENUEW
import 'package:flutter/material.dart';
import '../../db/app_db.dart';
import '../../models/item.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  List<Item> _allItems = [];      // all items from database
  List<Item> _filteredItems = []; // items after search filter
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadItems();
    _searchController.addListener(_filterItems);
  }

  Future<void> _loadItems() async {
    final db = await AppDatabase.instance.database;
    final res = await db.query('items');

    setState(() {
      _allItems = res.map((e) => Item.fromMap(e)).toList();
      _filteredItems = _allItems; // show all items initially
    });
  }

  void _filterItems() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredItems = _allItems.where((item) {
        return item.name.toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Menu')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Search Menu',
                prefixIcon: Icon(Icons.search),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _filteredItems.isEmpty
                  ? const Center(child: Text('No items found'))
                  : ListView.builder(
                      itemCount: _filteredItems.length,
                      itemBuilder: (context, index) {
                        final item = _filteredItems[index];
                        return ListTile(
                          title: Text(item.name),
                          subtitle: Text('Price: ${item.price}'),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
