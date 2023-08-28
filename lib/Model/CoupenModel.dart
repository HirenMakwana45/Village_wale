class CoupenModel {
  List<Coupons>? coupons;

  CoupenModel({this.coupons});

  CoupenModel.fromJson(Map<String, dynamic> json) {
    if (json['coupons'] != null) {
      coupons = <Coupons>[];
      json['coupons'].forEach((v) {
        coupons!.add(new Coupons.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.coupons != null) {
      data['coupons'] = this.coupons!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Coupons {
  String? id;
  String? couponCode;
  String? image;
  String? heading;
  String? description;
  String? smallDescription;
  String? discount;
  String? priceLimit;
  String? status;

  Coupons(
      {this.id,
      this.couponCode,
      this.image,
      this.heading,
      this.description,
      this.smallDescription,
      this.discount,
      this.priceLimit,
      this.status});

  Coupons.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    couponCode = json['Coupon_code'];
    image = json['image'];
    heading = json['heading'];
    description = json['description'];
    smallDescription = json['small_description'];
    discount = json['discount'];
    priceLimit = json['price_limit'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['Coupon_code'] = this.couponCode;
    data['image'] = this.image;
    data['heading'] = this.heading;
    data['description'] = this.description;
    data['small_description'] = this.smallDescription;
    data['discount'] = this.discount;
    data['price_limit'] = this.priceLimit;
    data['status'] = this.status;
    return data;
  }
}
