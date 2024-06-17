import 'package:fractal_challenge/models/product.dart';
import 'package:intl/intl.dart';

class Order {
  final int? id;
  final int orderNumber;
  final DateTime orderDate;
  final OrderStatus orderStatus;
  final List<OrderDetail> orderDetails;

  Order({
    this.id,
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
      orderStatus: OrderStatus.values.firstWhere((element) => element.name == json['orderStatus']),
      orderDetails: details,
    );
  }
  Map<String, dynamic> toJson(){
    // DateFormat formatter = DateFormat('yyyy-MM-dd');
    // String formattedDate = formatter.format(orderDate);

    final response = {
      "id":id ?? "",
      "orderNumber": orderNumber.toString(),
      "orderDate": orderDate.toString(),
      "orderStatus": orderStatus.name,
      "orderDetails": orderDetails.map((detail) => detail.toJson()).toList(),
    };
    print(response);
    return response;
  }
}

class OrderDetail {
  final int? id;
  final int product;
  final Product? productObject;
  int quantity;
  double totalPrice;

  OrderDetail({
    this.id,
    required this.product,
    this.productObject,
    required this.quantity,
    required this.totalPrice,
  });

  factory OrderDetail.fromJson(Map<String, dynamic> json) {
    Product product=Product.fromJson(json['product']);
    return OrderDetail(
      id: json['id'],
      product: product.id!,
      productObject: product,
      quantity: json['quantity'],
      totalPrice: json['totalPrice'].toDouble(),
    );
  }

  Map<String, dynamic> toJson(){
    return {
      "id":id??"",
      "product": productObject?.toJson(),
      "quantity":quantity.toString(),
      "totalPrice": (productObject?.price ?? 0 * quantity).toString()
    };
  }

  int get _quantity => quantity;
  set _quantity(int value){
    quantity = _quantity;
  }

  double get _totalPrice => totalPrice;
  set _totalPrice(double value){
    totalPrice = _totalPrice;
  }
}

enum OrderStatus {
  Pending,
  InProgress,
  Completed
}