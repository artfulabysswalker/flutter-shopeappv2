class Item {
  final int? id;
  final String name;
  final int price;
  final String category;

  Item({
    this.id,
    required this.name,
    required this.price,
    required this.category,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'category': category,
    };
  }

  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(
      id: map['id'] as int?,
      name: map['name'] as String,
      price: map['price'] as int,
      category: map['category'] as String,
    );
  }
}
