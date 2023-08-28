class BannerModel {
  List<Banner>? banner;

  BannerModel({this.banner});

  BannerModel.fromJson(Map<String, dynamic> json) {
    if (json['banner'] != null) {
      banner = <Banner>[];
      json['banner'].forEach((v) {
        banner!.add(new Banner.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.banner != null) {
      data['banner'] = this.banner!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Banner {
  String? id;
  String? topBanner;
  String? bottomBanner;
  String? text;
  String? description;
  String? buttonText;

  Banner(
      {this.id,
        this.topBanner,
        this.bottomBanner,
        this.text,
        this.description,
        this.buttonText});

  Banner.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    topBanner = json['top_banner'];
    bottomBanner = json['bottom_banner'];
    text = json['text'];
    description = json['description'];
    buttonText = json['button_text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['top_banner'] = this.topBanner;
    data['bottom_banner'] = this.bottomBanner;
    data['text'] = this.text;
    data['description'] = this.description;
    data['button_text'] = this.buttonText;
    return data;
  }
}
