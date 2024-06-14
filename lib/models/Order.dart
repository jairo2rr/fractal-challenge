class Order {
  final int? id;
  final int orderNumber;
  final DateTime orderDate;
  final String orderStatus;
  final List<OrderDetail> orderDetails;

  Order({
    required this.id,
    required this.orderNumber,
    required this.orderDate,
    required this.orderStatus,
    required this.orderDetails,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    List<OrderDetail> details = [];
    if (json['orderDetails'] != null) {
      details = List<OrderDetail>.from(json['orderDetails'].map((detail) => OrderDetail.fromJson(detail)));
    }

    return Order(
      id: json['id'],
      orderNumber: json['orderNumber'],
      orderDate: DateTime.parse(json['orderDate']),
      orderStatus: json['orderStatus'],
      orderDetails: details,
    );
  }
}

class OrderDetail {
  final int? id;
  final int productId;
  final String productName;
  final int quantity;
  final double unitPrice;

  OrderDetail({
    required this.id,
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.unitPrice,
  });

  factory OrderDetail.fromJson(Map<String, dynamic> json) {
    return OrderDetail(
      id: json['id'],
      productId: json['productId'],
      productName: json['productName'],
      quantity: json['quantity'],
      unitPrice: json['unitPrice'].toDouble(),
    );
  }
}