import 'dart:convert';

import 'package:village.wale/Model/HomeModel.dart';

List<GetAllProductModel> ModelFromJson(String str) =>
    List<GetAllProductModel>.from(
        json.decode(str).map((x) => GetAllProductModel.fromJson(x)));

String breweryModelToJson(List<GetAllProductModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GetAllProductModel {
  String? category;
  List<Products>? product;

  GetAllProductModel({this.category, this.product});

  GetAllProductModel.fromJson(Map<String, dynamic> json) {
    category = json['category'];
    if (json['product'] != null) {
      product = <Products>[];
      json['product'].forEach((v) {
        product!.add(new Products.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['category'] = this.category;
    if (this.product != null) {
      data['product'] = this.product!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

// class Product {
//   String? id;
//   String? category;
//   String? subCategory;
//   String? city;
//   String? name;
//   String? image;
//   String? dscription;
//   String? normalPrice;
//   String? normalDiscount;
//   String? subscriptionPrice;
//   String? subscriptionDiscount;
//   String? timeZone;
//   String? offerText;
//   String? buyOnes;
//   String? subscription;
//   String? codAvailable;
//   String? status;
//   String? rattings;
//   String? date;
//
//   Product(
//       {this.id,
//         this.category,
//         this.subCategory,
//         this.city,
//         this.name,
//         this.image,
//         this.dscription,
//         this.normalPrice,
//         this.normalDiscount,
//         this.subscriptionPrice,
//         this.subscriptionDiscount,
//         this.timeZone,
//         this.offerText,
//         this.buyOnes,
//         this.subscription,
//         this.codAvailable,
//         this.status,
//         this.rattings,
//         this.date});
//
//   Product.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     category = json['category'];
//     subCategory = json['sub_category'];
//     city = json['city'];
//     name = json['name'];
//     image = json['image'];
//     dscription = json['dscription'];
//     normalPrice = json['normal_price'];
//     normalDiscount = json['normal_discount'];
//     subscriptionPrice = json['subscription_price'];
//     subscriptionDiscount = json['subscription_discount'];
//     timeZone = json['time_zone'];
//     offerText = json['offer_text'];
//     buyOnes = json['buy_ones'];
//     subscription = json['subscription'];
//     codAvailable = json['cod_available'];
//     status = json['status'];
//     rattings = json['rattings'];
//     date = json['date'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['category'] = this.category;
//     data['sub_category'] = this.subCategory;
//     data['city'] = this.city;
//     data['name'] = this.name;
//     data['image'] = this.image;
//     data['dscription'] = this.dscription;
//     data['normal_price'] = this.normalPrice;
//     data['normal_discount'] = this.normalDiscount;
//     data['subscription_price'] = this.subscriptionPrice;
//     data['subscription_discount'] = this.subscriptionDiscount;
//     data['time_zone'] = this.timeZone;
//     data['offer_text'] = this.offerText;
//     data['buy_ones'] = this.buyOnes;
//     data['subscription'] = this.subscription;
//     data['cod_available'] = this.codAvailable;
//     data['status'] = this.status;
//     data['rattings'] = this.rattings;
//     data['date'] = this.date;
//     return data;
//   }
// }
