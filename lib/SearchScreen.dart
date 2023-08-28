import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:village.wale/Model/GetAllProductModel.dart';
import 'package:village.wale/persistance/api_repository.dart';
import 'package:village.wale/util/AppUtil.dart';

import 'CreateSubscription.dart';
import 'Model/HomeModel.dart';
import 'ProductDetail.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreen createState() => _SearchScreen();
}

class _SearchScreen extends State<SearchScreen> {
  List<Products> homeList = [];
  bool _isLoading = false;
  List<Products> _searchList = [];
  @override
  void initState() {
    print("===>CALL INIT STATE==>");
    getAllProduct();
    super.initState();
  }

  void getAllProduct() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String userId = sharedPreferences.getString("id").toString();
    String _cityName = sharedPreferences.getString("city").toString();

    setState(() {
      _isLoading = true;
    });
    print("===>ENTRY======>");

    var api = APICallRepository();
    api.getAllSearchProduct(userId, _cityName).then((value) {
      // var jsonD = parsedJson['streets'];
      // List<GetAllProductModel> _model = [
      //   GetAllProductModel.fromJson(jsonDecode(value))
      // ];
      // var model=GetAllProductModel.fromJson(jsonDecode(value));

      setState(() {
        _isLoading = false;
        // print("===>VALUE=>"+value.toString());

        List<GetAllProductModel> _model = ModelFromJson(value);
        print("===>LENGTH==>" + _model.length.toString());

        for (int i = 0; i < _model.length; i++) {
          homeList.addAll(_model[i].product!);
          _searchList.addAll(_model[i].product!);
        }
      });
    }, onError: (error) {
      setState(() {
        _isLoading = false;
      });
      showCustomToast("Data Fetch Issue");
    });
  }

  void _runFilter(String enteredKeyword) {
    List<Products> results = [];
    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all users
      results = homeList;
    } else {
      results = homeList
          .where((user) =>
              user.name
                  .toString()
                  .toLowerCase()
                  .contains(enteredKeyword.toLowerCase()) ||
              user.categoryName
                  .toString()
                  .toLowerCase()
                  .contains(enteredKeyword.toLowerCase()) ||
              user.normalPrice
                  .toString()
                  .toLowerCase()
                  .contains(enteredKeyword.toLowerCase()))
          .toList();
      // we use the toLowerCase() method to make it case-insensitive
    }

    // Refresh the UI
    setState(() {
      _searchList = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
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
                    'Search',
                    style: TextStyle(fontFamily: "Poppins", fontSize: 20),
                  ),
                ],
              ),
              Container(
                height: 60,
                margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: TextField(
                    onChanged: (value) => _runFilter(value),
                    enabled: true,
                    style: const TextStyle(
                      fontFamily: "Poppins",
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                      floatingLabelStyle: const TextStyle(
                          fontFamily: "Poppins", color: Color(0xffAAAAAA)),
                      prefixIcon:
                          const Icon(Icons.search, color: Color(0xff9D9FA1)),
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: Color(0xffAAAAAA), width: 0),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Color(0xff9D9FA1), width: 1.0),
                          borderRadius: BorderRadius.circular(10)),
                      enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Color(0xff9D9FA1), width: 1.0),
                          borderRadius: BorderRadius.circular(10)),
                      labelText: "Search products",
                      hintStyle: const TextStyle(
                        fontFamily: "Poppins",
                        color: Color(0xffAAAAAA),
                        fontSize: 13,
                      ),
                    )),
              ),
              !_isLoading
                  ? GridView.builder(
                      physics: const ScrollPhysics(),
                      padding: EdgeInsets.zero,
                      itemCount: _searchList.length,
                      shrinkWrap: true,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        childAspectRatio: (150.0 / 250.0),
                        crossAxisCount: 2,
                        mainAxisExtent: 330,
                      ),
                      itemBuilder: (context, index) => MyCustomCard(index))
                  : Center(
                      child: getProgressBar(),
                    ),
            ],
          ),
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
                type: PageTransitionType.fade,
                child: Detail(_searchList[index])));
        // Navigator.of(context).push(MaterialPageRoute(
        //     builder: (context) => Detail(_searchList[index])));
      },
      child: Card(
        margin: const EdgeInsets.fromLTRB(10, 10, 0, 0),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Visibility(
                  visible: _searchList[index].offerText == "yes" ? true : false,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        color: Colors.yellow,
                        child: Text(
                            _searchList[index].normalDiscount.toString() +
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
                      _searchList[index].image == ""
                          ? "https://upload.wikimedia.org/wikipedia/commons/thumb/d/d1/Image_not_available.png/640px-Image_not_available.png"
                          : _searchList[index].image!,
                      height: 100,
                      width: 100,
                    ),
                  ),
                ),
                Text(_searchList[index].name.toString()),
                Text(
                  _searchList[index].categoryName.toString(),
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
                        _searchList[index].normalPrice.toString() +
                        " / " +
                        _searchList[index].volume.toString()),
                    IconButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              PageTransition(
                                  type: PageTransitionType.fade,
                                  child: Detail(_searchList[index])));
                          // Navigator.of(context).push(MaterialPageRoute(
                          //     builder: (context) =>
                          //         Detail(_searchList[index])));
                        },
                        icon: Image.asset("images/Cart.png"))
                  ],
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          side: const BorderSide(color: Color(0XFF286953)),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          primary: Colors.white),
                      onPressed: () {
                        Navigator.push(
                            context,
                            PageTransition(
                                type: PageTransitionType.fade,
                                child: Detail(_searchList[index])));
                        // Navigator.of(context).push(MaterialPageRoute(
                        //     builder: (context) => Detail(_searchList[index])));
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
                                child: MySubscription(_searchList[index])));
                        // Navigator.of(context).push(MaterialPageRoute(
                        //     builder: (context) =>
                        //         MySubscription(_searchList[index])));
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

  void addFavourite(String productId) async {
    String userId = "";
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    userId = sharedPreferences.getString("id").toString();

    print("==>USERID==>" + userId.toString());
    print("==>PRODUCT ID==>" + productId.toString());
    var api = APICallRepository();
    api.addFavourite(userId, productId).then((value) {
      var json = jsonDecode(value);
      print("==> Add SEARCH Favourite SUCCESS=>" + json['messaage'].toString());
    }, onError: (error) {
      print("==> Add SEARCH Favourite ERROR=>" + error.toString());
    });
  }

  void removeFavourite(String productId) async {
    String userId = "";
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    userId = sharedPreferences.getString("id").toString();
    var api = APICallRepository();
    api.removeFavourite(userId, productId).then((value) {
      var json = jsonDecode(value);
      print("==> REMOVE SEARCH Favourite SUCCESS=>" +
          json['messaage'].toString());
    }, onError: (error) {
      print("==> REMOVE SEARCH Favourite ERROR=>" + error.toString());
    });
  }
}
