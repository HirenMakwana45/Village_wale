import 'api_base_helper.dart';
import 'api_utils.dart';

class APICallRepository {
  final ApiBaseHelper _helper = ApiBaseHelper();

  headers(String token) => {
        "Accept": "application/json",
        "Authorization": "Bearer " + token,
        "Content-Type": "application/x-www-form-urlencoded"
      };

  Future<dynamic> signUp(String name, String number, String email,
      String referCode, String token) async {
    final response = await _helper.post(
      APIUtils().BASE_URL + APIUtils().registration,
      headers(""),
      body: {
        "name": name,
        "number": number,
        "email": email,
        "refercode": referCode,
        "token": token
      },
    );
    return response;
  }

  Future<dynamic> verifyCoupan(
    String couponCode,
    String userId,
  ) async {
    final response = await _helper.post(
      APIUtils().BASE_URL + APIUtils().coupenVerify,
      headers(""),
      body: {
        "coupon_code": couponCode,
        "user_id": userId,
        // "product_id": productId
      },
    );
    return response;
  }

  Future<dynamic> addUserTransation(String userId, String amount,
      String productId, String transction_status, String type) async {
    final response = await _helper.post(
      APIUtils().BASE_URL + APIUtils().addUserTransction,
      headers(""),
      body: {
        "user_id": userId,
        "amount": amount,
        "product_id": productId,
        "transaction_status": transction_status,
        "transaction_type": type,
      },
    );
    return response;
  }

  Future<String> editProfile(
    String id,
    String name,
    String phoneNumber,
    String email,
    String personal_image,
  ) async {
    final response = await _helper.UploadWithMedia(
        "image", personal_image, APIUtils().BASE_URL + APIUtils().editProfile, {
      "name": name,
      "email": email,
      "mobile_no": phoneNumber,
      "user_id": id
    });
    return response;
  }

  Future<dynamic> login(String number, String token) async {
    final response = await _helper.post(
      APIUtils().BASE_URL + APIUtils().login,
      headers(""),
      body: {"number": number, "token": token},
    );
    return response;
  }

  Future<dynamic> deleteSubscription(String id) async {
    final response = await _helper.post(
      APIUtils().BASE_URL + APIUtils().deleteSubscrption,
      headers(""),
      body: {"subscription_id": id},
    );
    return response;
  }

  Future<dynamic> addFavourite(String userId, String productId) async {
    final response = await _helper.post(
      APIUtils().BASE_URL + APIUtils().addFavourite,
      headers(""),
      body: {"user_id": userId, "product_id": productId},
    );
    return response;
  }

  Future<dynamic> removeFavourite(String userId, String productId) async {
    final response = await _helper.post(
      APIUtils().BASE_URL + APIUtils().removeFavourite,
      headers(""),
      body: {"user_id": userId, "product_id": productId},
    );
    return response;
  }

  Future<dynamic> updateAddress(String address, String userId) async {
    final response = await _helper.post(
      APIUtils().BASE_URL + APIUtils().addUserAddress,
      headers(""),
      body: {
        "address": address,
        "user_id": userId,
      },
    );
    return response;
  }

  Future<dynamic> addSecondAddress(
    String userId,
    String address,
  ) async {
    final response = await _helper.post(
      APIUtils().BASE_URL + APIUtils().addSecondAddress,
      headers(""),
      body: {
        "user_id": userId,
        "address": address,
      },
    );
    return response;
  }

  Future<dynamic> updateSubscription(String id, String productQty, String sdate,
      String repet_date, String sub_type, String status) async {
    final response = await _helper.post(
      APIUtils().BASE_URL + APIUtils().updateSubscrption,
      headers(""),
      body: {
        "subscription_id": id,
        "product_qty": productQty,
        "start_date": sdate,
        "repeat_days": repet_date,
        "subscription_type": sub_type,
        "status": status
      },
    );
    return response;
  }

  Future<dynamic> cityList() async {
    final response = await _helper.get(
      APIUtils().BASE_URL + APIUtils().cityList,
    );
    return response;
  }

  Future<dynamic> getOfers() async {
    final response = await _helper.get(
      APIUtils().BASE_URL + APIUtils().getCoupen,
    );
    return response;
  }

  Future<dynamic> getAllProduct() async {
    final response = await _helper.get(
      APIUtils().BASE_URL + APIUtils().getSearchAllProduct,
    );
    return response;
  }

  Future<dynamic> getBannerList() async {
    final response = await _helper.get(
      APIUtils().BASE_URL + APIUtils().getBannerList,
    );
    return response;
  }

  Future<dynamic> getProfile(String id) async {
    final response = await _helper.post(
      APIUtils().BASE_URL + APIUtils().getProfile,
      headers(""),
      body: {"user_id": id},
    );
    return response;
  }

  Future<dynamic> removeCart(String cartId) async {
    final response = await _helper.post(
      APIUtils().BASE_URL + APIUtils().removeCartList,
      headers(""),
      body: {"cart_id": cartId},
    );
    return response;
  }

  Future<dynamic> getAllSearchProduct(String id, String city) async {
    final response = await _helper.post(
      APIUtils().BASE_URL + APIUtils().getSearchAllProduct,
      headers(""),
      body: {"user_id": id, "city": city},
    );
    return response;
  }

  Future<dynamic> getNotificationList(String userId) async {
    final response = await _helper.post(
      APIUtils().BASE_URL + APIUtils().getNotificationList,
      headers(""),
      body: {"user_id": userId},
    );
    return response;
  }

  Future<dynamic> setAddress(String id, String city, String latitude,
      String longtitude, String address) async {
    final response = await _helper.post(
      APIUtils().BASE_URL + APIUtils().setAddress,
      headers(""),
      body: {
        "user_id": id,
        "city": city,
        "latitude": latitude,
        "longitude": longtitude,
        "address": address
      },
    );
    return response;
  }

  Future<dynamic> getCart(String id) async {
    final response = await _helper.post(
      APIUtils().BASE_URL + APIUtils().getCart,
      headers(""),
      body: {
        "user_id": id,
      },
    );
    return response;
  }

  Future<dynamic> updateCart(String cartid, String quantity) async {
    final response = await _helper.post(
      APIUtils().BASE_URL + APIUtils().updateCart,
      headers(""),
      body: {"cart_id": cartid, "quantity": quantity},
    );
    return response;
  }

  Future<dynamic> cancelUserOrder(String id) async {
    final response = await _helper.post(
      APIUtils().BASE_URL + APIUtils().cancelOrder,
      headers(""),
      body: {
        "order_id": id,
      },
    );
    return response;
  }

  Future<dynamic> getAllCatergory() async {
    final response = await _helper.get(
      APIUtils().BASE_URL + APIUtils().getCategoryList,
    );
    return response;
  }

  Future<dynamic> getProduct(String id, String userId, String city) async {
    final response = await _helper.post(
      APIUtils().BASE_URL + APIUtils().getAllProduct,
      headers(""),
      body: {"catedory_id": id, "user_id": userId, "city": city},
    );
    return response;
  }

  Future<dynamic> addToCart(
      String userId,
      String productId,
      String quentity,
      String volume,
      String type,
      String start_date,
      String end_date,
      String subscription_type,
      String days) async {
    final response = await _helper.post(
      APIUtils().BASE_URL + APIUtils().addToCart,
      headers(""),
      body: {
        "user_id": userId,
        "product_id": productId,
        "quantity": quentity,
        "volume": volume,
        "type": type,
        "start_date": start_date,
        "end_date": end_date,
        "subscription_type": subscription_type,
        "days": days
      },
    );
    return response;
  }

  Future<dynamic> getAllScbscrption(String userId) async {
    final response = await _helper.post(
      APIUtils().BASE_URL + APIUtils().getAllSubscrption,
      headers(""),
      body: {
        "user_id": userId,
      },
    );
    return response;
  }

  Future<dynamic> addOrder(String userId, String timeZone, String C_Id) async {
    final response = await _helper.post(
      APIUtils().BASE_URL + APIUtils().addOrder,
      headers(""),
      body: {"user_id": userId, "timezone": timeZone, "coupon_id": C_Id},
    );
    return response;
  }

  Future<dynamic> addSubscrption(
      String userId,
      String productId,
      String quentity,
      String startDate,
      String repetDay,
      String subscrptionType,
      String endDate,
      String productPrice,
      String volume) async {
    final response = await _helper.post(
      APIUtils().BASE_URL + APIUtils().addSubscrption,
      headers(""),
      body: {
        "user_id": userId,
        "product_id": productId,
        "product_qty": quentity,
        "start_date": startDate,
        "repeat_days": repetDay,
        "subscription_type": subscrptionType,
        "end_date": endDate,
        "product_price": productPrice,
        "volume": volume
      },
    );
    print("========>DATE==>" + startDate.toString());
    return response;
  }

  Future<dynamic> getMyOrder(String id, String filter) async {
    final response = await _helper.post(
      APIUtils().BASE_URL + APIUtils().getMyorder,
      headers(""),
      body: {"user_id": id, "filter_string": filter},
    );
    return response;
  }

  Future<dynamic> getTransactionHistory(String id, String date) async {
    final response = await _helper.post(
      APIUtils().BASE_URL + APIUtils().getTranctionHistory,
      headers(""),
      body: {"user_id": id, "date": date},
    );
    return response;
  }
}
