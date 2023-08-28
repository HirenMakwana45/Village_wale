class ProfileModel {
  String? id;
  String? name;
  String? mobileNo;
  String? gmail;
  String? city;
  String? address;
  String? latitude;
  String? longitude;
  String? image;
  String? userCode;
  String? totalRefer;
  String? wallet;
  String? token;
  String? date;
  String? address2;

  ProfileModel(
      {this.id,
        this.name,
        this.mobileNo,
        this.gmail,
        this.city,
        this.address,
        this.latitude,
        this.longitude,
        this.image,
        this.userCode,
        this.totalRefer,
        this.wallet,
        this.token,
        this.date,
        this.address2
      });

  ProfileModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    mobileNo = json['mobile_no'];
    gmail = json['gmail'];
    city = json['city'];
    address = json['address'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    image = json['image'];
    userCode = json['user_code'];
    totalRefer = json['total_refer'];
    wallet = json['wallet'];
    token = json['token'];
    date = json['date'];
    address2=json['address_2'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['mobile_no'] = this.mobileNo;
    data['gmail'] = this.gmail;
    data['city'] = this.city;
    data['address'] = this.address;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['image'] = this.image;
    data['user_code'] = this.userCode;
    data['total_refer'] = this.totalRefer;
    data['wallet'] = this.wallet;
    data['token'] = this.token;
    data['date'] = this.date;
    data['address_2']=this.address2;
    return data;
  }
}
