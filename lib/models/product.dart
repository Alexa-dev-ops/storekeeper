class Product {
  int? id;
  String name;
  int quantity;
  double price;
  String? imagePath;
  DateTime addedOn;

  Product({
    this.id,
    required this.name,
    required this.quantity,
    required this.price,
    this.imagePath,
    DateTime? addedOn,
  }) : addedOn = addedOn ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'quantity': quantity,
      'price': price,
      'imagePath': imagePath,
      'addedOn': addedOn.toIso8601String(),
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      name: map['name'],
      quantity: map['quantity'],
      price: map['price'].toDouble(),
      imagePath: map['imagePath'],
      addedOn: DateTime.parse(map['addedOn']),
    );
  }
}
