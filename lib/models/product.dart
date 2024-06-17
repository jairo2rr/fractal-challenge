
class Product {
  int? id;
  String name;
  double price;
  int productStatus;

  Product({
    this.id,
    required this.name,
    required this.price,
    required this.productStatus,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      price: json['price'].toDouble(),
      productStatus: json['productStatus'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'productStatus': productStatus,
    };
  }
}
