class SubscriptionModel {
  List<Subscriptions>? subscriptions;

  SubscriptionModel({this.subscriptions});

  SubscriptionModel.fromJson(Map<String, dynamic> json) {
    if (json['subscriptions'] != null) {
      subscriptions = <Subscriptions>[];
      json['subscriptions'].forEach((v) {
        subscriptions!.add(new Subscriptions.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.subscriptions != null) {
      data['subscriptions'] =
          this.subscriptions!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Subscriptions {
  String? id;
  String? userId;
  String? productId;
  String? startDate;
  String? endDate;
  String? repeatDays;
  String? subscriptionType;
  String? productQty;
  String? volume;
  String? status;
  String? cDate;
  String? productName;
  String? productImage;
  String? productPrice;
  String? productDiscount;
  num? discountPrice;
  bool? isPause = false;

  Subscriptions(
      {this.id,
      this.userId,
      this.productId,
      this.startDate,
      this.endDate,
      this.repeatDays,
      this.subscriptionType,
      this.productQty,
      this.volume,
      this.status,
      this.cDate,
      this.productName,
      this.productImage,
      this.productPrice,
      this.productDiscount,
      this.discountPrice});

  Subscriptions.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    productId = json['product_id'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    repeatDays = json['repeat_days'];
    subscriptionType = json['subscription_type'];
    productQty = json['product_qty'];
    volume = json['volume'];
    status = json['status'];
    cDate = json['c_date'];
    productName = json['product_name'];
    productImage = json['product_image'];
    productPrice = json['product_price'];
    productDiscount = json['product_discount'];
    discountPrice = json['discount_price'];
    isPause = false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['product_id'] = this.productId;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    data['repeat_days'] = this.repeatDays;
    data['subscription_type'] = this.subscriptionType;
    data['product_qty'] = this.productQty;
    data['volume'] = this.volume;
    data['status'] = this.status;
    data['c_date'] = this.cDate;
    data['product_name'] = this.productName;
    data['product_image'] = this.productImage;
    data['product_price'] = this.productPrice;
    data['product_discount'] = this.productDiscount;
    data['discount_price'] = this.discountPrice;
    return data;
  }
}
