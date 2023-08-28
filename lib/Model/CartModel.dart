class CartModel {
  List<Cart>? cart;
  List<SubscriptionCart>? subscriptionCart;

  CartModel({this.cart, this.subscriptionCart});

  CartModel.fromJson(Map<String, dynamic> json) {
    if (json['cart'] != null) {
      cart = <Cart>[];
      json['cart'].forEach((v) {
        cart!.add(new Cart.fromJson(v));
      });
    }
    if (json['subscription_cart'] != null) {
      subscriptionCart = <SubscriptionCart>[];
      json['subscription_cart'].forEach((v) {
        subscriptionCart!.add(new SubscriptionCart.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.cart != null) {
      data['cart'] = this.cart!.map((v) => v.toJson()).toList();
    }
    if (this.subscriptionCart != null) {
      data['subscription_cart'] =
          this.subscriptionCart!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Cart {
  String? id;
  String? userId;
  String? productId;
  String? quantity;
  String? volume;
  String? type;
  String? productName;
  String? productImage;
  String? price;
  String? discountPrice;
  String? discount;
  String? description;
  String? productCategory;

  Cart(
      {this.id,
      this.userId,
      this.productId,
      this.quantity,
      this.volume,
      this.type,
      this.productName,
      this.productImage,
      this.price,
      this.discountPrice,
      this.discount,
      this.description,
      this.productCategory});

  Cart.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    productId = json['product_id'];
    quantity = json['quantity'];
    volume = json['volume'];
    type = json['type'];
    productName = json['product_name'];
    productImage = json['product_image'];
    price = json['price'];
    discountPrice = json['discount_price'];
    discount = json['discount'];
    description = json['description'];
    productCategory = json['product_category'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['product_id'] = this.productId;
    data['quantity'] = this.quantity;
    data['volume'] = this.volume;
    data['type'] = this.type;
    data['product_name'] = this.productName;
    data['product_image'] = this.productImage;
    data['price'] = this.price;
    data['discount_price'] = this.discountPrice;
    data['discount'] = this.discount;
    data['description'] = this.description;
    data['product_category'] = this.productCategory;
    return data;
  }
}

class SubscriptionCart {
  String? id;
  String? userId;
  String? productName;
  String? productImage;
  String? price;
  String? discount;
  String? discountPrice;
  String? description;
  String? productCategory;
  String? productId;
  String? startDate;
  String? endDate;
  String? repeatDays;
  String? volume;
  String? quantity;
  String? subscriptionType;

  SubscriptionCart(
      {this.id,
      this.userId,
      this.productName,
      this.productImage,
      this.price,
      this.discount,
      this.discountPrice,
      this.description,
      this.productCategory,
      this.productId,
      this.startDate,
      this.endDate,
      this.repeatDays,
      this.volume,
      this.quantity,
      this.subscriptionType});

  SubscriptionCart.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    productName = json['product_name'];
    productImage = json['product_image'];
    price = json['price'];
    discount = json['discount'];
    discountPrice = json['discount_price'];
    description = json['description'];
    productCategory = json['product_category'];
    productId = json['product_id'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    repeatDays = json['repeat_days'];
    volume = json['volume'];
    quantity = json['quantity'];
    subscriptionType = json['subscription_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['product_name'] = this.productName;
    data['product_image'] = this.productImage;
    data['price'] = this.price;
    data['discount'] = this.discount;
    data['discount_price'] = this.discountPrice;
    data['description'] = this.description;
    data['product_category'] = this.productCategory;
    data['product_id'] = this.productId;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    data['repeat_days'] = this.repeatDays;
    data['volume'] = this.volume;
    data['quantity'] = this.quantity;
    data['subscription_type'] = this.subscriptionType;
    return data;
  }
}
