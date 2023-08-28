class OrderModel {
  List<Orders>? orders;

  OrderModel({this.orders});

  OrderModel.fromJson(Map<String, dynamic> json) {
    if (json['orders'] != null) {
      orders = <Orders>[];
      json['orders'].forEach((v) {
        orders!.add(new Orders.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.orders != null) {
      data['orders'] = this.orders!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Orders {
  String? id;
  String? userId;
  String? productId;
  String? orderId;
  String? subscriptionId;
  String? quantity;
  String? volume;
  String? totalAmount;
  String? deliveryBoyId;
  String? status;
  String? date;
  String? paymentMethod;
  String? orderType;
  String? orderStatus;
  String? note;
  String? paymentCollection;
  String? productName;
  String? productImage;
  String? description;
  String? transactionId;
  String? product_price;
  String? discount_price;
  Orders({
    this.id,
    this.userId,
    this.productId,
    this.orderId,
    this.subscriptionId,
    this.quantity,
    this.volume,
    this.totalAmount,
    this.deliveryBoyId,
    this.status,
    this.date,
    this.paymentMethod,
    this.orderType,
    this.orderStatus,
    this.note,
    this.paymentCollection,
    this.productName,
    this.productImage,
    this.description,
    this.transactionId,
    this.product_price,
    this.discount_price,
  });

  Orders.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    productId = json['product_id'];
    orderId = json['order_id'];
    subscriptionId = json['subscription_id'];
    quantity = json['quantity'];
    volume = json['volume'];
    totalAmount = json['total_amount'];
    deliveryBoyId = json['delivery_boy_id'];
    status = json['status'];
    date = json['date'];
    paymentMethod = json['payment_method'];
    orderType = json['order_type'];
    orderStatus = json['order_status'];
    note = json['note'];
    paymentCollection = json['payment_collection'];
    productName = json['product_name'];
    productImage = json['product_image'];
    description = json['description'];
    transactionId = json['transaction_id'];
    product_price = json['product_price'];
    discount_price = json['discount_price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['product_id'] = this.productId;
    data['order_id'] = this.orderId;
    data['subscription_id'] = this.subscriptionId;
    data['quantity'] = this.quantity;
    data['volume'] = this.volume;
    data['total_amount'] = this.totalAmount;
    data['delivery_boy_id'] = this.deliveryBoyId;
    data['status'] = this.status;
    data['date'] = this.date;
    data['payment_method'] = this.paymentMethod;
    data['order_type'] = this.orderType;
    data['order_status'] = this.orderStatus;
    data['note'] = this.note;
    data['payment_collection'] = this.paymentCollection;
    data['product_name'] = this.productName;
    data['product_image'] = this.productImage;
    data['description'] = this.description;
    data['transaction_id'] = this.transactionId;
    data['product_price'] = this.product_price;
    data['discount_price'] = this.discount_price;
    return data;
  }
}
