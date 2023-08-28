import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:village.wale/persistance/api_repository.dart';
import 'package:village.wale/util/AppUtil.dart';

import 'CreateSubscription.dart';
import 'HomeScreen.dart';
import 'Model/HomeModel.dart';
import 'ProductDetail.dart';

class ProductViewAll extends StatefulWidget {
  String _id;
  ProductViewAll(this._id);

  @override
  _ProductViewAll createState() => _ProductViewAll();
}

class _ProductViewAll extends State<ProductViewAll> {
  List<Products> homeList = [];

  bool _isLoading = false;
  String? id;

  @override
  void initState() {
    getProduct(widget._id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: !_isLoading
            ? SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.arrow_back_ios),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            const Text(
                              'View All',
                              style: TextStyle(
                                  fontFamily: "Poppins", fontSize: 20),
                            ),
                          ],
                        ),
                      ],
                    ),
                    GridView.builder(
                        physics: const ScrollPhysics(),
                        padding: EdgeInsets.zero,
                        itemCount: homeList.length,
                        shrinkWrap: true,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          childAspectRatio: (150.0 / 250.0),
                          crossAxisCount: 2,
                          mainAxisExtent: 330,
                        ),
                        itemBuilder: (context, index) => MyCustomCard(index)),
                  ],
                ),
              )
            : Center(
                child: getProgressBar(),
              ),
      ),
    );
  }

  Widget MyCustomCard(int index) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            PageTransition(
                type: PageTransitionType.fade, child: Detail(homeList[index])));
        // Navigator.of(context).push(
        //     MaterialPageRoute(builder: (context) => Detail(homeList[index])));
      },
      child: Card(
        margin: const EdgeInsets.fromLTRB(10, 10, 0, 0),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Visibility(
                  visible: homeList[index].offerText == "yes" ? true : false,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        color: Colors.yellow,
                        child: Text(homeList[index].normalDiscount.toString() +
                            "% off"),
                      ),
                      homeList[index].isfavourite.toString() != "False"
                          ? InkWell(
                              onTap: () {
                                setState(() {
                                  removeFavourite(
                                      homeList[index].id.toString());
                                  homeList[index].isfavourite = "False";
                                });
                              },
                              child: Image.asset(
                                "images/select_heart.png",
                                height: 20,
                                width: 20,
                              ))
                          : InkWell(
                              onTap: () {
                                setState(() {
                                  addFavourite(homeList[index].id.toString());
                                  homeList[index].isfavourite = "True";
                                });
                              },
                              child: Image.asset(
                                "images/unselect_heart.png",
                                height: 20,
                                width: 20,
                              ))
                      // IconButton(onPressed: () {}, icon: Icon(Icons.favorite_border_outlined,color: Colors.red,))
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: Center(
                    child: Image.network(
                      homeList[index].image == ""
                          ? "https://upload.wikimedia.org/wikipedia/commons/thumb/d/d1/Image_not_available.png/640px-Image_not_available.png"
                          : homeList[index].image!,
                      height: 100,
                      width: 100,
                    ),
                  ),
                ),
                Text(homeList[index].name.toString()),
                Text(
                  homeList[index].categoryName.toString(),
                  style: const TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Color(0xff9D9FA2)),
                ),
                const SizedBox(
                  height: 4,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("₹ " +
                        homeList[index].normalPrice.toString() +
                        " / " +
                        homeList[index].volume.toString()),
                    IconButton(
                        onPressed: () {
                          Buyonceaddtocart(id, index);
                          // Navigator.of(context).push(MaterialPageRoute(
                          //     builder: (context) => Detail(homeList[index])));
                        },
                        icon: Image.asset("images/Cart.png"))
                  ],
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          side: const BorderSide(color: Color(0XFF286953)),
                          primary: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10))),
                      onPressed: () {
                        Navigator.push(
                            context,
                            PageTransition(
                                type: PageTransitionType.fade,
                                child: Detail(homeList[index])));
                        // Navigator.of(context).push(MaterialPageRoute(
                        //     builder: (context) => Detail(homeList[index])));
                      },
                      child: const Text(
                        "Buy Once",
                        style: TextStyle(
                            fontFamily: "Poppins", color: Color(0XFF286953)),
                      )),
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          primary: const Color(0XFF286953)),
                      onPressed: () {
                        Navigator.push(
                            context,
                            PageTransition(
                                type: PageTransitionType.fade,
                                child: MySubscription(homeList[index])));
                        // Navigator.of(context).push(MaterialPageRoute(
                        //     builder: (context) =>
                        //         MySubscription(homeList[index])));
                      },
                      child: const Text(
                        "Subscribe",
                        style: TextStyle(
                            fontFamily: "Poppins", color: Colors.white),
                      )),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> Buyonceaddtocart(String? id, int index) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    String userId = _prefs.getString("id").toString();
    var api = APICallRepository();
    var type = "Normal";

    var volume = homeList[index].volume;
    var staticvolume = "1 ";
    var Pid = homeList[index].id;
    var bydefaultvolumeset = staticvolume + volume.toString();
    var quantity = homeList[index].quantityAvailable!.split(',');

    var f = quantity.first;
    print(userId);
    print("Product ID" + Pid.toString());
    print(homeList[index].normalPrice.toString());
    print(bydefaultvolumeset);
    print(type);
    print(f);

    api
        .addToCart(
            userId,
            Pid.toString(),
            f.toString(),
            bydefaultvolumeset.toString(),
            type.toString(),
            f.toString(),
            null.toString(),
            null.toString(),
            null.toString())
        .then((value) {
      print(value);
      var json = jsonDecode(value);
      var message = json["message"];
      // Navigator.of(context).push(
      //   MaterialPageRoute(
      //       builder: (BuildContext context) =>
      //           Cart2(cartlist, cartsubscribeList)),
      // );

      showCustomToast(message.toString());
    }, onError: (error) {
      showCustomToast(error.toString());
    });
  }

  void getProduct(String id) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String userId = sharedPreferences.getString("id").toString();
    String _cityName = sharedPreferences.getString("city").toString();

    setState(() {
      _isLoading = true;
    });
    var api = APICallRepository();
    api.getProduct(id, userId, _cityName).then((value) {
      setState(() {
        print("==>VALUE=>" + value.toString());
        var model = HomeModel.fromJson(jsonDecode(value));
        homeList.clear();
        homeList.addAll(model.products!);

        setState(() {
          _isLoading = false;
        });
        if (homeList.isEmpty) {
          showCustomToast("No Product Found");
        }
      });
    }, onError: (error) {
      setState(() {
        _isLoading = false;
      });
      showCustomToast(error.toString());
    });
  }

  void addFavourite(String productId) async {
    String userId = "";
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    userId = sharedPreferences.getString("id").toString();

    print("==>USERID==>" + userId.toString());
    print("==>PRODUCT ID==>" + productId.toString());
    var api = APICallRepository();
    api.addFavourite(userId, productId).then((value) {
      var json = jsonDecode(value);
      print("==> Add Favourite SUCCESS=>" + json['messaage'].toString());
    }, onError: (error) {
      print("==> Add Favourite ERROR=>" + error.toString());
    });
  }

  void removeFavourite(String productId) async {
    String userId = "";
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    userId = sharedPreferences.getString("id").toString();
    var api = APICallRepository();
    api.removeFavourite(userId, productId).then((value) {
      var json = jsonDecode(value);
      print("==> REMOVE Favourite SUCCESS=>" + json['messaage'].toString());
    }, onError: (error) {
      print("==> REMOVE Favourite ERROR=>" + error.toString());
    });
  }
}
