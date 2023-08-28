class NotificationModel {
  List<Notifications>? notification;

  NotificationModel({this.notification});

  NotificationModel.fromJson(Map<String, dynamic> json) {
    if (json['notification'] != null) {
      notification = <Notifications>[];
      json['notification'].forEach((v) {
        notification!.add(new Notifications.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.notification != null) {
      data['notification'] = this.notification!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Notifications {
  String? id;
  String? orderId;
  String? status;
  String? orderStatus;
  String? date;

  Notifications({this.id,this.orderId, this.status, this.orderStatus, this.date});

  Notifications.fromJson(Map<String, dynamic> json) {
    id=json['id'];
    orderId = json['order_id'];
    status = json['status'];
    orderStatus = json['order_status'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id']=this.id;
    data['order_id'] = this.orderId;
    data['status'] = this.status;
    data['order_status'] = this.orderStatus;
    data['date'] = this.date;
    return data;
  }
}
