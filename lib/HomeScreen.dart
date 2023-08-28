import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_storage/get_storage.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:village.wale/LogInPage1.dart';
import 'package:village.wale/Model/BannerModel.dart' as banner;
import 'package:village.wale/ProductViewAll.dart';
import 'package:village.wale/SearchScreen.dart';
import 'package:village.wale/Suport_page.dart';
import 'package:village.wale/persistance/api_repository.dart';
import 'package:village.wale/util/AppUtil.dart';
import 'AddMoney.dart';
import 'Cart.dart';
import 'Cart2.dart';
import 'Model/BannerModel.dart';
import 'Model/CartModel.dart';
import 'Model/CategoryModel.dart';
import 'Model/HomeModel.dart';
import 'Model/ProfileModel.dart';
import 'MyOrder.dart';
import 'MyProfile.dart';
import 'MySubscription.dart';
import 'CreateSubscription.dart';
import 'Notification.dart';
import 'Offer.dart';
import 'OrederDetails.dart';
import 'ProductDetail.dart';
import 'Refer.dart';
import 'TransactionHistory.dart';
import 'Wallet.dart';
import 'package:village.wale/Model/CartModel.dart' as model;

class getColorFromHex extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  getColorFromHex(final String hexColor) : super(_getColorFromHex(hexColor));
}

class MyHomeScreen extends StatefulWidget {
  const MyHomeScreen({Key? key}) : super(key: key);

  _MyhomeState createState() => _MyhomeState();
}

String name = "";
String email = "";
String image = "";

class _MyhomeState extends State<MyHomeScreen> {
  List<model.Cart>? cartlist = [];
  List<model.SubscriptionCart> cartsubscribeList = [];

  List<Widget> items = [];
  List<Widget> bottomItems = [];

  bool _isBannerLoading = false;

  List<Categories> list = [];
  List<Products> homeList = [];

  List<Products> homelist2 = [];
  List<Products> subscribeList = [];
  String? id;
  bool _isLoading = false;
  List<banner.Banner> bannerList = [];
  List<banner.Banner> bottomBannerList = [];
  String categoryName = "";
  String _categoryId = "";
  List<String> volume = [];
  var fromIndex = 0;
  var toIndex = 3;
  String Cartid = "";
  int service_amount = 0;
  final getStorage = GetStorage();

//  void getCartDetail() async {
//     setState(() {
//       _isLoading = true;
//     });

//     List<int> total = [];
//     SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
//     Cartid = sharedPreferences.getString("Cartid").toString();

//     var api = APICallRepository();
//     api.getCart(Cartid.toString()).then((value) {
//       setState(() {
//         _isLoading = false;

//         print("==RESPONSE=>" + value.toString());
//         var model = CartModel.fromJson(jsonDecode(value));

//         list.clear();
//         list.addAll(model.cart!);

//         subscribeList.clear();

//         List<int> total = [];
//         for (int i = 0; i < list.length; i++) {
//           print("===>PRINT==>" + list[i].quantity.toString());
//           total.add(
//               int.parse(list[i].quantity!) * int.parse((list[i].price!)));
//         }

//         for (int j = 0; j < total.length; j++) {
//           _totalAmount += total[j];
//         }

//         if (subscribeList != null) {
//           subscribeList.addAll(model.subscriptionCart!);
//         }
//         for (int i = 0; i < list.length; i++) {
//           total.add(int.parse(list[i].quantity!) *
//               int.parse(list[i].price!.toString() == "null"
//                   ? "0"
//                   : list[i].price!.toString()));
//         }

//         for (int j = 0; j < total.length; j++) {
//           _totalAmount += total[j];
//         }

//         if (list.isEmpty) {
//           showCustomToast("No Product Found...");
//         }

//         if (subscribeList.isEmpty) {
//           showCustomToast("No Subscribed Product Found");
//         }
//       });
//     }, onError: (error) {
//       setState(() {
//         _isLoading = false;
//       });

//       showCustomToast(error.toString());
//     });
//   }

  void getBannerList() {
    setState(() {
      _isBannerLoading = true;
    });
    var api = APICallRepository();
    api.getBannerList().then((value) {
      setState(() {
        var model = BannerModel.fromJson(jsonDecode(value));
        bannerList.clear();
        bannerList.addAll(model.banner!);
        // print("==>BANNER=>"+bannerList[0].text.toString());
        if (bannerList.isNotEmpty) {
          for (int i = 0; i < bannerList.length; i++) {
            items.add(GestureDetector(
              onTap: () {},
              child: Image.network(
                bannerList[i].topBanner!,
                fit: BoxFit.fill,
                width: MediaQuery.of(context).size.width,
              ),
            ));
            bottomItems.add(GestureDetector(
              onTap: () {},
              child: Image.network(
                bannerList[i].bottomBanner!,
                fit: BoxFit.fill,
                width: MediaQuery.of(context).size.width,
              ),
            ));
          }
        }
      });
    }, onError: (error) {
      setState(() {
        _isBannerLoading = false;
      });
    });
  }

  void getProfile() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String id = sharedPreferences.getString("id").toString();
    setState(() {
      name = sharedPreferences.getString("name").toString();
      email = sharedPreferences.getString("email").toString();
      image = sharedPreferences.getString("image").toString();
    });
    var api = APICallRepository();
    api.getProfile(id).then((value) {
      setState(() {
        _isBannerLoading = false;
        var model = ProfileModel.fromJson(jsonDecode(value));
        name = model.name.toString();
        email = model.gmail.toString();
        image = model.image.toString();

        sharedPreferences.setString("referCode", model.userCode.toString());
        sharedPreferences.setString("address", model.address.toString());
        sharedPreferences.setString("address2", model.address2.toString());
      });
    }, onError: (error) {
      setState(() {
        _isBannerLoading = false;
      });
    });
  }

  void getCategoryList() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    id = _prefs.getString("id").toString();
    name = _prefs.getString("name").toString();
    email = _prefs.getString("email").toString();
    image = _prefs.getString("image").toString();
    print("==>ID=>" + id.toString());

    setState(() {
      _isLoading = true;
    });
    var api = APICallRepository();
    api.getAllCatergory().then((value) {
      setState(() {
        _isLoading = false;
        var model = CategoryModel.fromJson(jsonDecode(value));
        list.clear();
        list.addAll(model.categories!);

        print("RESPONSE==>" + list.toString());
        if (list.isNotEmpty) {
          getProduct(list[0].id!, list[0].catName.toString());
        }
        if (list.isEmpty) {
          showCustomToast("No Category Found");
        }
      });
    }, onError: (error) {
      setState(() {
        _isLoading = false;
      });
      showCustomToast(error.toString());
    });
  }

  String _cityName = "";
  void getProduct(String id, String name) async {
    print("==>ID" + id);
    setState(() {
      _categoryId = id;
      categoryName = name;
    });

    SharedPreferences _prefs = await SharedPreferences.getInstance();
    String userId = _prefs.getString("id").toString();
    _cityName = _prefs.getString("city").toString();

    print("======>CITY==>" + _cityName.toString());

    var api = APICallRepository();
    api.getProduct(id, userId, _cityName).then((value) {
      setState(() {
        print("==>VALUE=>" + value.toString());
        var model = HomeModel.fromJson(jsonDecode(value));

        homeList.clear();
        homeList.addAll(model.products!);

        print("My HOME LIST ISSS");

        print(homeList.length);

        print(homelist2);

        // if(model.products!.length>=4){
        //   for(int i=0;i<4;i++){
        //     homeList.add(model.products![i]);
        //   }
        // }else{
        //
        // }

        setState(() {
          _isBannerLoading = false;
        });
        if (homeList.isEmpty) {
          showCustomToast("No Product Found");
        }
      });
    }, onError: (error) {
      setState(() {
        _isBannerLoading = false;
      });
      showCustomToast(error.toString());
    });
  }

  // void getAllProduct(int index) async {
  //   print("==>ID"+id);
  //   setState(() {
  //     _categoryId=id;
  //     categoryName=name;
  //   });
  //
  //   SharedPreferences _prefs= await SharedPreferences.getInstance();
  //   String userId=_prefs.getString("id").toString();
  //   String _cityName=_prefs.getString("city").toString();
  //
  //   var api = APICallRepository();
  //   api.getProduct("All", userId, _cityName).then((value) {
  //     setState(() {
  //       var model=HomeModel.fromJson(jsonDecode(value));
  //       homeList.addAll(model.product[index]!.p);
  //     });
  //   },onError: (error){showCustomToast("Unable to load data")});
  // }

  void getMostSubscribe(String id, String name) async {
    print("==>ID" + id);
    setState(() {
      _categoryId = "Most Subscribed";
      categoryName = "Most Subscribed";
    });

    SharedPreferences _prefs = await SharedPreferences.getInstance();
    String userId = _prefs.getString("id").toString();
    String _cityName = _prefs.getString("city").toString();
    var api = APICallRepository();
    api.getProduct("Most Subscribed", userId, _cityName).then((value) {
      setState(() {
        print("==>VALUE=> MOST SUBSCRIBE==>" + value.toString());
        var model = HomeModel.fromJson(jsonDecode(value));

        subscribeList.clear();

        if (model.products!.length >= 4) {
          for (int i = 0; i < 4; i++) {
            subscribeList.add(model.products![i]);
          }
        } else {
          subscribeList.addAll(model.products!);
        }

        setState(() {
          _isBannerLoading = false;
        });
        if (subscribeList.isEmpty) {
          showCustomToast("No Most Subscribe Found");
        }
      });
    }, onError: (error) {
      setState(() {
        _isBannerLoading = false;
      });
      showCustomToast(error.toString());
    });
  }

  Future refresh() async {
    // Navigator.push(
    //     context,
    //     PageTransition(
    //         type: PageTransitionType.fade,
    //         duration: Duration(seconds: 0),
    //         child: MyHomeScreen()));
    setState(() {
      getProduct(_categoryId, categoryName);
      getMostSubscribe(_categoryId, categoryName);
      getBannerList();
      getProfile();
      getCategoryList();
    });
    // void getProduct(String id, String name) async {
    //   print("==>ID" + id);
    //   setState(() {
    //     _categoryId = id;
    //     categoryName = name;
    //   });

    //   SharedPreferences _prefs = await SharedPreferences.getInstance();
    //   String userId = _prefs.getString("id").toString();
    //   _cityName = _prefs.getString("city").toString();

    //   print("======>CITY==>" + _cityName.toString());

    //   var api = APICallRepository();
    //   api.getProduct(id, userId, _cityName).then((value) {
    //     setState(() {
    //       print("==>VALUE=>" + value.toString());
    //       var model = HomeModel.fromJson(jsonDecode(value));

    //       homeList.clear();
    //       homeList.addAll(model.products!);

    //       // if(model.products!.length>=4){
    //       //   for(int i=0;i<4;i++){
    //       //     homeList.add(model.products![i]);
    //       //   }
    //       // }else{
    //       //
    //       // }

    //       setState(() {
    //         _isBannerLoading = false;
    //       });
    //       if (homeList.isEmpty) {
    //         showCustomToast("No Product Found");
    //       }
    //     });
    //   }, onError: (error) {
    //     setState(() {
    //       _isBannerLoading = false;
    //     });
    //     showCustomToast(error.toString());
    //   });
    // }

    // setState(() {});
  }

  @override
  void initState() {
    getMostSubscribe("Most Subscribed", "Most Subscribed");
    getBannerList();
    // getBannerList();
    getCategoryList();
    // getAllProduct();
    getProfile();
    refresh();
    var service_fee = getStorage.read("d_charge");

    print(service_fee);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return Scaffold(
          // backgroundColor: Color(0xffF4F9EA),
          bottomNavigationBar: Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(30), topLeft: Radius.circular(30)),
              boxShadow: [
                BoxShadow(
                    color: Colors.black38, spreadRadius: 0, blurRadius: 10),
              ],
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30.0),
                topRight: Radius.circular(30.0),
              ),
              child: BottomNavigationBar(
                currentIndex: 0,
                elevation: 40,
                type: BottomNavigationBarType.fixed,
                selectedItemColor: const Color(0XFF286953),
                unselectedItemColor: Colors.grey,
                selectedFontSize: 0,
                unselectedFontSize: 0,
                onTap: (value) {
                  if (value == 0) {}
                  if (value == 1) {
                    Navigator.push(
                        context,
                        PageTransition(
                            type: PageTransitionType.fade, child: Wallet()));
                    // Navigator.of(context).push(MaterialPageRoute(
                    //     builder: (context) => const Wallet()));
                  }
                  if (value == 2) {
                    Navigator.push(
                        context,
                        PageTransition(
                            type: PageTransitionType.fade,
                            child: Notifications()));
                    // Navigator.of(context).push(MaterialPageRoute(
                    //     builder: (context) => const Notifications()));
                  }
                  if (value == 3) {
                    Navigator.push(
                        context,
                        PageTransition(
                            type: PageTransitionType.fade,
                            child: My_Profile()));
                    // Navigator.of(context).push(MaterialPageRoute(
                    //     builder: (context) => const My_Profile()));
                  }
                },
                items: const [
                  BottomNavigationBarItem(
                    backgroundColor: Colors.black,
                    icon: Icon(
                      Icons.home_outlined,
                    ),
                    label: "",
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(
                      Icons.account_balance_wallet_outlined,
                    ),
                    label: "",
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(
                      Icons.notifications_none_outlined,
                    ),
                    label: "",
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(
                      Icons.person_outline,
                    ),
                    label: "",
                  ),
                ],
              ),
            ),
          ),
          drawer: Drawer(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const MyHeaderDrawer(),
                  Container(
                    height: 1,
                    width: double.infinity,
                    color: Colors.black12,
                  ),
                  const MyDrawerList()
                ],
              ),
            ),
          ),
          body: _isBannerLoading
              ? Center(
                  child: Center(child: getProgressBar()),
                )
              : RefreshIndicator(
                  onRefresh: refresh,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      children: [
                        Column(
                          children: [
                            const SizedBox(
                              height: 35,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Builder(builder: (context) {
                                      return Container(
                                        margin: const EdgeInsets.fromLTRB(
                                            0, 8, 0, 0),
                                        child: IconButton(
                                            iconSize: 90,
                                            onPressed: () {
                                              Scaffold.of(context).openDrawer();
                                            },
                                            tooltip: MaterialLocalizations.of(
                                                    context)
                                                .openAppDrawerTooltip,
                                            icon: Image.asset(
                                              "images/Frame1.png",
                                            )),
                                      );
                                    }),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          "Welcome",
                                          style: TextStyle(
                                              fontFamily: "Poppins",
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400),
                                          textAlign: TextAlign.start,
                                        ),
                                        Container(
                                          alignment: Alignment.topLeft,
                                          child: Text(
                                            name.toString(),
                                            textAlign: TextAlign.start,
                                            style: const TextStyle(
                                                fontFamily: "Poppins",
                                                fontSize: 18,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                                Container(
                                  margin: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                                  child: IconButton(
                                      iconSize: 90,
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            PageTransition(
                                                type: PageTransitionType.fade,
                                                child: Cart2(cartlist,
                                                    cartsubscribeList)));
                                        // Navigator.of(context).push(
                                        //     MaterialPageRoute(
                                        //         builder: (context) => Cart2(
                                        //             cartlist,
                                        //             cartsubscribeList)));
                                      },
                                      icon: Image.asset("images/Frame2.png")),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 0,
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    PageTransition(
                                        type: PageTransitionType.fade,
                                        child: SearchScreen()));
                                // Navigator.of(context).push(MaterialPageRoute(
                                //     builder: (context) => SearchScreen()));
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 50,
                                      child: TextField(
                                          enabled: false,
                                          style: const TextStyle(
                                            fontFamily: "Poppins",
                                            color: Colors.black,
                                          ),
                                          decoration: InputDecoration(
                                            floatingLabelStyle: const TextStyle(
                                                fontFamily: "Poppins",
                                                color: Color(0xffAAAAAA)),
                                            filled: true,
                                            fillColor: const Color(0xffEFF1F4),
                                            prefixIcon:
                                                const Icon(Icons.search),
                                            border: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                  color: Color(0xffAAAAAA),
                                                  width: 0),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            labelText: "Search products",
                                            hintStyle: const TextStyle(
                                              fontFamily: "Poppins",
                                              color: Color(0xffAAAAAA),
                                              fontSize: 13,
                                            ),
                                          )),
                                    ),
                                    const SizedBox(height: 15),
                                    CarouselSlider(
                                        items: items,
                                        options: CarouselOptions(
                                          height: 145,
                                          aspectRatio: 16 / 9,
                                          viewportFraction: 1,
                                          initialPage: 0,
                                          enableInfiniteScroll: true,
                                          reverse: false,
                                          autoPlay: true,
                                          autoPlayInterval:
                                              const Duration(seconds: 3),
                                          autoPlayAnimationDuration:
                                              const Duration(milliseconds: 800),
                                          autoPlayCurve: Curves.fastOutSlowIn,
                                          enlargeCenterPage: true,
                                          scrollDirection: Axis.horizontal,
                                        )),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    const Text(
                                      "Shop by Categories",
                                      style: TextStyle(
                                          fontFamily: "Poppins",
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        children: [
                                          CustomRadioButton(
                                            spacing: 1.0,
                                            padding: 5,
                                            elevation: 0,
                                            autoWidth: true,
                                            radius: 20,
                                            enableShape: true,
                                            shapeRadius: 50,
                                            width: 0,
                                            absoluteZeroSpacing: false,
                                            unSelectedColor:
                                                getColorFromHex("#e4ecd6"),
                                            buttonLables: const [
                                              'All',
                                              'Most Subscribe Category',
                                              'My Favourite',
                                            ],
                                            buttonValues: const [
                                              'All',
                                              'Most Subscribed',
                                              'My Favourite',
                                            ],
                                            buttonTextStyle: ButtonTextStyle(
                                                selectedColor: Colors.white,
                                                unSelectedColor:
                                                    getColorFromHex("#286953"),
                                                textStyle: const TextStyle(
                                                    fontFamily: "Poppins",
                                                    fontSize: 16)),
                                            radioButtonValue: (value) {
                                              print("===>Value==>" +
                                                  value.toString());
                                              getProduct(value.toString(),
                                                  value.toString());
                                            },
                                            selectedColor:
                                                getColorFromHex("#286953"),
                                            unSelectedBorderColor:
                                                Colors.transparent,
                                            selectedBorderColor:
                                                Colors.transparent,
                                          ),
                                        ],
                                      ),
                                    ),
                                    // SingleChildScrollView(
                                    //   scrollDirection: Axis.horizontal,
                                    //   child: Row(
                                    //     children: [
                                    //       MyTextCard("All"),
                                    //       MyTextCard("Most Subscribe Category"),
                                    //       MyTextCard("My Favourate "),
                                    //       MyTextCard("All"),
                                    //       MyTextCard("Most Subscribe Category"),
                                    //       MyTextCard("My Favourate "),
                                    //     ],
                                    //   ),
                                    // ),
                                    const SizedBox(height: 10),
                                    !_isLoading
                                        ? Container(
                                            height: 80,
                                            child: ListView.builder(
                                              scrollDirection: Axis.horizontal,
                                              itemBuilder: (index, context) =>
                                                  getCategoryLayout(context),
                                              itemCount: list.length,
                                            ))
                                        : Center(child: getProgressBar()),
                                    const SizedBox(height: 10),
                                  ],
                                ),
                              ),
                            ),

                            Column(
                              children: [
                                const SizedBox(
                                  height: 0,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: Row(
                                    children: [
                                      Text(
                                        categoryName + " Products",
                                        style: const TextStyle(
                                            fontFamily: "Poppins",
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      const Spacer(),
                                      TextButton(
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                PageTransition(
                                                    type:
                                                        PageTransitionType.fade,
                                                    child: ProductViewAll(
                                                        _categoryId)));
                                            // Navigator.of(context).push(
                                            //     MaterialPageRoute(
                                            //         builder: (context) =>
                                            //             ProductViewAll(
                                            //                 _categoryId)));
                                          },
                                          child: const Text(
                                            "View all",
                                            style: TextStyle(
                                                fontFamily: "Poppins",
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400,
                                                color: Color(0xff44533C)),
                                          ))
                                    ],
                                  ),
                                ),
                                //bit Length working
                                Visibility(
                                  visible: homeList.isEmpty ? false : true,
                                  child: GridView.builder(
                                      physics: const ScrollPhysics(),
                                      padding: EdgeInsets.zero,
                                      itemCount: homeList.length.bitLength,
                                      shrinkWrap: true,
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                        childAspectRatio: (150.0 / 250.0),
                                        crossAxisCount: 2,
                                        mainAxisExtent: 330,
                                      ),
                                      itemBuilder: (context, index) =>
                                          MyCustomCard(index)),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),

                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                  child: CarouselSlider(
                                      items: bottomItems,
                                      options: CarouselOptions(
                                        height: 145,
                                        aspectRatio: 16 / 9,
                                        viewportFraction: 1,
                                        initialPage: 0,
                                        enableInfiniteScroll: true,
                                        reverse: false,
                                        autoPlay: true,
                                        autoPlayInterval:
                                            const Duration(seconds: 3),
                                        autoPlayAnimationDuration:
                                            const Duration(milliseconds: 800),
                                        autoPlayCurve: Curves.fastOutSlowIn,
                                        enlargeCenterPage: true,
                                        scrollDirection: Axis.horizontal,
                                      )),
                                ),

                                const SizedBox(
                                  height: 20,
                                ),

                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: Row(
                                    children: [
                                      const Text(
                                        "Best Subscrption" + " Products",
                                        style: TextStyle(
                                            fontFamily: "Poppins",
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      const Spacer(),
                                      TextButton(
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                PageTransition(
                                                    type:
                                                        PageTransitionType.fade,
                                                    child: ProductViewAll(
                                                        "Most Subscribed")));
                                            // Navigator.of(context).push(
                                            //     MaterialPageRoute(
                                            //         builder: (context) =>
                                            //             ProductViewAll(
                                            //                 "Most Subscribed")));
                                          },
                                          child: const Text(
                                            "View all",
                                            style: TextStyle(
                                                fontFamily: "Poppins",
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400,
                                                color: Color(0xff44533C)),
                                          ))
                                    ],
                                  ),
                                ),
                                Visibility(
                                  visible: subscribeList.isEmpty ? false : true,
                                  child: GridView.builder(
                                      physics: const ScrollPhysics(),
                                      padding: EdgeInsets.zero,
                                      itemCount: subscribeList.length,
                                      shrinkWrap: true,
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                        childAspectRatio: (150.0 / 250.0),
                                        crossAxisCount: 2,
                                        mainAxisExtent: 330,
                                      ),
                                      itemBuilder: (context, index) =>
                                          MySubscribeCard(index)),
                                ),
                                // GridView.count(crossAxisCount: 2,children: List.generate(4, (index)
                                // {
                                //   return MyCustomCard();
                                // }),),
                                // Row(
                                //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                //   children: [
                                //     MyItemCard(),
                                //     MyItemCard(),
                                //   ],
                                // ),
                                // SizedBox(
                                //   height: 20.h,
                                // )

                                const SizedBox(
                                  height: 20,
                                )
                              ],
                            ),
                            // Container(
                            //   color: Colors.white,
                            //   child: Column(
                            //     children: [
                            //       Padding(
                            //         padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            //         child: Row(
                            //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //           children: [
                            //             Text(
                            //               "Dairy Products",
                            //               style: TextStyle(
                            //                   fontSize: 18, fontWeight: FontWeight.w600),
                            //             ),
                            //             TextButton(
                            //                 onPressed: () {},
                            //                 child: Text(
                            //                   "View all",
                            //                   style: TextStyle(
                            //                       fontSize: 14,
                            //                       fontWeight: FontWeight.w400,
                            //                       color: Color(0xff44533C)),
                            //                 ))
                            //           ],
                            //         ),
                            //       ),
                            //       SizedBox(height: 10.h),
                            //       Row(
                            //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            //         children: [
                            //           MyItemCard(),
                            //           MyItemCard(),
                            //         ],
                            //       ),
                            //       SizedBox(
                            //         height: 10.h,
                            //       ),
                            //       Padding(
                            //         padding: const EdgeInsets.symmetric(horizontal: 15.0),
                            //         child: Column(
                            //           children: [
                            //             CarouselSlider(
                            //                 items: items,
                            //                 options: CarouselOptions(
                            //                   height: 145,
                            //                   aspectRatio: 16/9,
                            //                   viewportFraction: 0.8,
                            //                   initialPage: 0,
                            //                   enableInfiniteScroll: true,
                            //                   reverse: false,
                            //                   autoPlay: true,
                            //                   autoPlayInterval: Duration(seconds: 3),
                            //                   autoPlayAnimationDuration: Duration(milliseconds: 800),
                            //                   autoPlayCurve: Curves.fastOutSlowIn,
                            //                   enlargeCenterPage: true,
                            //                   scrollDirection: Axis.horizontal,
                            //                 )
                            //             ),
                            //             SizedBox(
                            //               height: 10.h,
                            //             ),
                            //             Row(
                            //               mainAxisAlignment:
                            //               MainAxisAlignment.spaceBetween,
                            //               children: [
                            //                 Text(
                            //                   "Best subscription product",
                            //                   style: TextStyle(
                            //                       fontSize: 18,
                            //                       fontWeight: FontWeight.w600),
                            //                 ),
                            //                 TextButton(
                            //                     onPressed: () {},
                            //                     child: Text(
                            //                       "View all",
                            //                       style: TextStyle(
                            //                           fontSize: 14,
                            //                           fontWeight: FontWeight.w400,
                            //                           color: Color(0XFF286953)),
                            //                     ))
                            //               ],
                            //             ),
                            //           ],
                            //         ),
                            //       ),
                            //       Container(
                            //         child: Column(
                            //           children: [
                            //             SizedBox(height: 10.h),
                            //             Row(
                            //               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            //               children: [
                            //                 MyItemCard(),
                            //                 MyItemCard(),
                            //               ],
                            //             ),
                            //             SizedBox(
                            //               height: 20.h++++++++++++++++++++++++++++++++++++++++++++++++0,
                            //             )
                            //           ],
                            //         ),
                            //       ),
                            //     ],
                            //   ),
                            // ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ));
    });
  }

  Widget getCategoryLayout(int index) {
    return InkWell(
      onTap: () {
        getProduct(list[index].id!, list[index].catName.toString());
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5.0),
        child: Container(
          child: Column(
            children: [
              Container(
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(4, 4, 4, 4),
                  child: Image.network(
                    list[index].image!,
                    width: 60,
                    height: 45,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(
                height: 7,
              ),
              Center(
                child: Text(list[index].catName.toString()),
              )
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
                type: PageTransitionType.fade, child: Detail(homeList[index])));
        // Navigator.of(context).push(
        //     MaterialPageRoute(builder: (context) => Detail(homeList[index])));
      },
      child: Card(
        margin: const EdgeInsets.fromLTRB(10, 1, 0, 0),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Visibility(
                visible: homeList[index].offerText == "yes" ? true : false,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      color: Colors.yellow,
                      child: Text(
                          homeList[index].normalDiscount.toString() + "% off"),
                    ),
                    homeList[index].isfavourite.toString() != "False"
                        ? InkWell(
                            onTap: () {
                              setState(() {
                                removeFavourite(homeList[index].id.toString());
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
                            ),
                          ),
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
              const SizedBox(
                height: 3,
              ),
              Container(
                child: Text(
                  homeList[index].name.toString(),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                alignment: Alignment.topLeft,
              ),
              Container(
                alignment: Alignment.topLeft,
                child: Text(
                  homeList[index].categoryName.toString(),
                  style: const TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Color(0xff9D9FA2)),
                ),
              ),
              // SizedBox(
              //   height: 4,
              // ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("₹ " +
                      homeList[index].normalPrice.toString() +
                      "/" +
                      homeList[index].volume.toString()),
                  IconButton(
                      onPressed: () {
                        Buyonceaddtocart(id, index);
                        // Navigator.of(context).push(MaterialPageRoute(
                        //     builder: (context) => Detail(homeList[index])));
                      },
                      icon: Image.asset(
                        "images/Cart.png",
                        height: 30,
                        width: 30,
                      ))
                ],
              ),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shadowColor: Colors.transparent,
                        side: const BorderSide(color: Color(0XFF286953)),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        primary: Colors.white),
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
                        shadowColor: Colors.transparent,
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
                      style:
                          TextStyle(fontFamily: "Poppins", color: Colors.white),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget MySubscribeCard(int index) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            PageTransition(
                type: PageTransitionType.fade,
                child: Detail(subscribeList[index])));
        // Navigator.of(context).push(MaterialPageRoute(
        //     builder: (context) => Detail(subscribeList[index])));
      },
      child: Card(
        margin: const EdgeInsets.fromLTRB(10, 1, 0, 0),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Visibility(
                visible: subscribeList[index].offerText == "yes" ? true : false,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      color: Colors.yellow,
                      child: Text(
                          subscribeList[index].normalDiscount.toString() +
                              "% off"),
                    ),
                    subscribeList[index].isfavourite.toString() != "False"
                        ? InkWell(
                            onTap: () {
                              setState(() {
                                removeFavourite(
                                    subscribeList[index].id.toString());
                                subscribeList[index].isfavourite = "False";
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
                                addFavourite(
                                    subscribeList[index].id.toString());
                                subscribeList[index].isfavourite = "True";
                              });
                            },
                            child: Image.asset(
                              "images/unselect_heart.png",
                              height: 20,
                              width: 20,
                            ))
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: Center(
                  child: Image.network(
                    subscribeList[index].image == ""
                        ? "https://upload.wikimedia.org/wikipedia/commons/thumb/d/d1/Image_not_available.png/640px-Image_not_available.png"
                        : subscribeList[index].image!,
                    height: 100,
                    width: 100,
                  ),
                ),
              ),
              Container(
                child: Text(subscribeList[index].name.toString()),
                alignment: Alignment.topLeft,
              ),
              Container(
                alignment: Alignment.topLeft,
                child: Text(
                  subscribeList[index].categoryName.toString(),
                  style: const TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Color(0xff9D9FA2)),
                ),
              ),
              const SizedBox(
                height: 4,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("₹ " +
                      subscribeList[index].normalPrice.toString() +
                      "/" +
                      subscribeList[index].volume.toString()),
                  IconButton(
                      onPressed: () {
                        SubscriptionAddedtocart(id, index);
                        // Navigator.of(context).push(MaterialPageRoute(
                        //     builder: (context) =>
                        //         Detail(subscribeList[index])));
                      },
                      icon: Image.asset("images/Cart.png"))
                ],
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shadowColor: Colors.transparent,
                        side: const BorderSide(color: Color(0XFF286953)),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        primary: Colors.white),
                    onPressed: () {
                      Navigator.push(
                          context,
                          PageTransition(
                              type: PageTransitionType.fade,
                              child: Detail(subscribeList[index])));
                      // Navigator.of(context).push(MaterialPageRoute(
                      //     builder: (context) => Detail(subscribeList[index])));
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
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        primary: const Color(0XFF286953)),
                    onPressed: () {
                      Navigator.push(
                          context,
                          PageTransition(
                              type: PageTransitionType.fade,
                              child: MySubscription(subscribeList[index])));
                      // Navigator.of(context).push(MaterialPageRoute(
                      //     builder: (context) =>
                      //         MySubscription(subscribeList[index])));
                    },
                    child: const Text(
                      "Subscribe",
                      style:
                          TextStyle(fontFamily: "Poppins", color: Colors.white),
                    )),
              ),
            ],
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

  Future<void> SubscriptionAddedtocart(String? id, int index) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    String userId = _prefs.getString("id").toString();
    var api = APICallRepository();
    var type = "Normal";
    print("bam bam bole");

    print(homeList);
    print(index);
    var volume = subscribeList[index].volume;
    var staticvolume = "1 ";
    var Pid = subscribeList[index].id;
    var bydefaultvolumeset = staticvolume + volume.toString();
    var quantity = subscribeList[index].quantityAvailable!.split(',');

    var f = quantity.first;
    print(userId);
    print("Product ID" + Pid.toString());
    print(subscribeList[index].normalPrice.toString());
    print(bydefaultvolumeset);
    print(type);
    print(f);
    print("bam bam bole");
    print(volume);

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
}

class MyimageCard extends StatefulWidget {
  var color;
  String imageurl = "";
  String title = "";

  MyimageCard(var color, String imageurl, String title) {
    this.color = color;
    this.imageurl = imageurl;
    this.title = title;
  }

  @override
  State<MyimageCard> createState() => _MyimageCardState(color, imageurl, title);
}

class _MyimageCardState extends State<MyimageCard> {
  var color;
  String imageurl = "";
  String title = "";

  _MyimageCardState(var color, String imageurl, String title) {
    this.color = color;
    this.imageurl = imageurl;
    this.title = title;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: Container(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10), color: Color(color)),
              child: Padding(
                padding: const EdgeInsets.all(7.0),
                child: Image.asset(imageurl),
              ),
            ),
            Center(
              child: Text(title),
            )
          ],
        ),
      ),
    );
  }
}

class MyTextCard extends StatefulWidget {
  String label = "";

  MyTextCard(String label) {
    this.label = label;
  }

  @override
  State<MyTextCard> createState() => _MyTextCardState(label);
}

class _MyTextCardState extends State<MyTextCard> {
  String label = "";

  _MyTextCardState(String label) {
    this.label = label;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: const Color(0XFF286953),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            label,
            style: const TextStyle(
                fontFamily: "Poppins",
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }
}

class MyDrawerList extends StatefulWidget {
  const MyDrawerList({Key? key}) : super(key: key);

  @override
  State<MyDrawerList> createState() => _MyDrawerListState();
}

class _MyDrawerListState extends State<MyDrawerList> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          PageTransition(
                              type: PageTransitionType.fade,
                              child: My_Profile()));
                      // Navigator.of(context).push(MaterialPageRoute(
                      //   builder: (context) => const My_Profile(),
                      // ));
                    },
                    child: Column(
                      children: [
                        Column(
                          children: [
                            Column(
                              children: [
                                Row(children: const [
                                  Expanded(
                                      child: Icon(
                                    Icons.person,
                                    size: 20,
                                    color: Colors.black,
                                  )),
                                  Expanded(
                                      flex: 3,
                                      child: Text(
                                        'My account',
                                        style: TextStyle(
                                            fontFamily: "Poppins",
                                            fontSize: 16),
                                      )),
                                  Expanded(
                                      child: Icon(
                                    Icons.navigate_next,
                                    size: 20,
                                    color: Colors.black,
                                  )),
                                ]),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                // Padding(padding: EdgeInsets.only(top: 15),
                //   child: GestureDetector(
                //     onTap: () {
                //       //Navigator.of(context).push(MaterialPageRoute(builder: (context)=>My_Profile(),));
                //     },
                //     child: Row(
                //         children: [
                //           Expanded(child:
                //           Icon(Icons.category_outlined,
                //             size: 20,
                //             color: Colors.black,
                //           )
                //           ),
                //           Expanded(
                //               flex: 3,
                //               child:Text(
                //                 'Shop by category',
                //                 style: TextStyle(
                //                     fontSize: 16
                //                 ),
                //               )
                //           ),
                //           Expanded(child:
                //           Icon(Icons.navigate_next,
                //             size: 20,
                //             color: Colors.black,
                //           )
                //           ),
                //
                //         ]
                //     ),
                //   ),
                //
                // ),
                Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          PageTransition(
                              type: PageTransitionType.fade,
                              child: My_subscription()));
                      // Navigator.of(context).push(MaterialPageRoute(
                      //   builder: (context) => const My_subscription(),
                      // ));
                    },
                    child: Row(children: const [
                      Expanded(
                          child: Icon(
                        Icons.subscriptions_outlined,
                        size: 20,
                        color: Colors.black,
                      )),
                      Expanded(
                          flex: 3,
                          child: Text(
                            'My subscriptions',
                            style:
                                TextStyle(fontFamily: "Poppins", fontSize: 16),
                          )),
                      Expanded(
                          child: Icon(
                        Icons.navigate_next,
                        size: 20,
                        color: Colors.black,
                      )),
                    ]),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          PageTransition(
                              type: PageTransitionType.fade, child: Refer()));
                      // Navigator.of(context).push(MaterialPageRoute(
                      //   builder: (context) => const Refer(),
                      // ));
                    },
                    child: Row(children: const [
                      Expanded(
                          child: Icon(
                        Icons.wallet_giftcard_outlined,
                        size: 20,
                        color: Colors.black,
                      )),
                      Expanded(
                          flex: 3,
                          child: Text(
                            'Refer & earn',
                            style:
                                TextStyle(fontFamily: "Poppins", fontSize: 16),
                          )),
                      Expanded(
                          child: Icon(
                        Icons.navigate_next,
                        size: 20,
                        color: Colors.black,
                      )),
                    ]),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          PageTransition(
                              type: PageTransitionType.fade,
                              child: Transaction_history()));
                      // Navigator.of(context).push(MaterialPageRoute(
                      //   builder: (context) => const Transaction_history(),
                      // ));
                    },
                    child: Row(children: const [
                      Expanded(
                          child: Icon(
                        Icons.history,
                        size: 20,
                        color: Colors.black,
                      )),
                      Expanded(
                          flex: 3,
                          child: Text(
                            'Transaction history',
                            style:
                                TextStyle(fontFamily: "Poppins", fontSize: 16),
                          )),
                      Expanded(
                          child: Icon(
                        Icons.navigate_next,
                        size: 20,
                        color: Colors.black,
                      )),
                    ]),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          PageTransition(
                              type: PageTransitionType.fade,
                              child: My_Oders()));
                      // Navigator.of(context).push(MaterialPageRoute(
                      //   builder: (context) => const My_Oders(),
                      // ));
                    },
                    child: Row(children: const [
                      Expanded(
                          child: Icon(
                        Icons.view_list_outlined,
                        size: 20,
                        color: Colors.black,
                      )),
                      Expanded(
                          flex: 3,
                          child: Text(
                            'My Order',
                            style:
                                TextStyle(fontFamily: "Poppins", fontSize: 16),
                          )),
                      Expanded(
                          child: Icon(
                        Icons.navigate_next,
                        size: 20,
                        color: Colors.black,
                      )),
                    ]),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          PageTransition(
                              type: PageTransitionType.fade, child: Offers()));
                      // Navigator.of(context).push(MaterialPageRoute(
                      //     builder: (context) => const Offers()));
                    },
                    child: Row(children: const [
                      Expanded(
                          child: Icon(
                        Icons.local_offer_outlined,
                        size: 20,
                        color: Colors.black,
                      )),
                      Expanded(
                          flex: 3,
                          child: Text(
                            'Offers',
                            style:
                                TextStyle(fontFamily: "Poppins", fontSize: 16),
                          )),
                      Expanded(
                          child: Icon(
                        Icons.navigate_next,
                        size: 20,
                        color: Colors.black,
                      )),
                    ]),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          PageTransition(
                              type: PageTransitionType.fade, child: Help()));

                      // Navigator.of(context).push(MaterialPageRoute(
                      //   builder: (context) => Help(),
                      // ));
                    },
                    child: Row(children: const [
                      Expanded(
                          child: Icon(
                        Icons.headset_mic_outlined,
                        size: 20,
                        color: Colors.black,
                      )),
                      Expanded(
                          flex: 3,
                          child: Text(
                            'Support',
                            style:
                                TextStyle(fontFamily: "Poppins", fontSize: 16),
                          )),
                      Expanded(
                          child: Icon(
                        Icons.navigate_next,
                        size: 20,
                        color: Colors.black,
                      )),
                    ]),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 100,
          ),
          const Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Divider(),
          ),
          InkWell(
            onTap: () {
              // SharedPreferences sharedPrefrences =  await SharedPreferences.getInstance();
              // sharedPrefrences.clear();
              // Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>LoginScreen1()), (route) => false);
              logout();
              print("==>LOGOUT");
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                TextButton(
                    onPressed: () {
                      logout();
                    },
                    child: Row(
                      children: const [
                        Icon(
                          Icons.logout_outlined,
                          size: 26,
                          color: Colors.black,
                        ),
                        Text(
                          "Logout",
                          style: TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 16,
                              color: Colors.black),
                        ),
                      ],
                    ))
              ]),
            ),
          )
        ],
      ),
    );
  }

  void logout() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.clear();

    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => LoginScreen1()),
        (route) => false);
  }
}

class MyHeaderDrawer extends StatefulWidget {
  const MyHeaderDrawer({Key? key}) : super(key: key);

  @override
  State<MyHeaderDrawer> createState() => _MyHeaderDrawerState();
}

class _MyHeaderDrawerState extends State<MyHeaderDrawer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xffFFFFFF),
      width: double.infinity,
      padding: const EdgeInsets.only(top: 20),
      child: Column(children: [
        const SizedBox(
          height: 35,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: Image.asset(
                "images/VillageLogo.png",
                height: 100,
                width: 200,
              ),
              margin: const EdgeInsets.fromLTRB(5, 10, 10, 0),
              alignment: Alignment.center,
            ),
            const SizedBox(
              height: 20,
            )
          ],
        ),
        Row(children: [
          GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    PageTransition(
                        type: PageTransitionType.fade, child: My_Profile()));

                // Navigator.of(context).push(MaterialPageRoute(
                //   builder: (context) => const My_Profile(),
                // ));
              },
              child: Container(
                width: 304,
                height: 90,
                decoration: ShapeDecoration(
                    color: const Color(0xffFFFFFF),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        side: const BorderSide(
                            width: 1, color: Colors.transparent))),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          height: 87,
                          width: 301.3,
                          child: Row(
                            children: [
                              Column(
                                children: [
                                  const SizedBox(
                                    height: 30,
                                  ),
                                  Row(
                                    children: [
                                      const SizedBox(
                                        width: 4,
                                      ),
                                      ClipOval(
                                        child: FadeInImage(
                                          height: 45,
                                          width: 45,
                                          image: NetworkImage(image),
                                          fit: BoxFit.cover,
                                          placeholder: const NetworkImage(
                                              "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSd7ouUaXq_gL4N44vL7zj-NcpCKQDJIoIQzM3FnHnZ5Q&s"),
                                        ),
                                      ),
                                      // ClipOval(
                                      //   child: Image.network(
                                      //     image=="" ?"https://upload.wikimedia.org/wikipedia/commons/thumb/a/ac/No_image_available.svg/1024px-No_image_available.svg.png":image,
                                      //     fit: BoxFit.cover,height: 45,width: 45,),
                                      //   //   child:  _image != null
                                      //   //       ? Image.file(File(_image!.path), fit: BoxFit.fill,)
                                      //   //       : Image.network(image_url , fit: BoxFit.fill , scale: 1.0) ,
                                      // ),
                                      const SizedBox(
                                        width: 2,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const SizedBox(
                                    height: 18,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        name.toString(),
                                        style: const TextStyle(
                                            fontFamily: "Poppins",
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      const SizedBox(
                                        width: 90,
                                      )
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    children: [
                                      const SizedBox(
                                        width: 7,
                                      ),
                                      Text(email.toString(),
                                          style: const TextStyle(
                                            fontFamily: "Poppins",
                                            fontWeight: FontWeight.w400,
                                            fontSize: 14,
                                          ))
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ))
        ]),
      ]),
    );
  }
}
