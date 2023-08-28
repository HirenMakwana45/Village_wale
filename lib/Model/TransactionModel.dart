class TransactionModel {
  List<Transactions>? transactions;

  TransactionModel({this.transactions});

  TransactionModel.fromJson(Map<String, dynamic> json) {
    if (json['transactions'] != null) {
      transactions = <Transactions>[];
      json['transactions'].forEach((v) {
        transactions!.add(new Transactions.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.transactions != null) {
      data['transactions'] = this.transactions!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Transactions {
  String? id;
  String? userId;
  String? transaction_id;
  String? transactionType;
  String? amount;
  String? transactionStatus;
  String? productId;
  String? date;

  Transactions(
      {this.id,
      this.userId,
      this.transaction_id,
      this.transactionType,
      this.amount,
      this.transactionStatus,
      this.productId,
      this.date});

  Transactions.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    transaction_id = json['transaction_id'];
    transactionType = json['transaction_type'];
    amount = json['amount'];
    transactionStatus = json['transaction_status'];
    productId = json['product_id'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['transaction_id'] = this.transaction_id;
    data['transaction_type'] = this.transactionType;
    data['amount'] = this.amount;
    data['transaction_status'] = this.transactionStatus;
    data['product_id'] = this.productId;
    data['date'] = this.date;
    return data;
  }
}
