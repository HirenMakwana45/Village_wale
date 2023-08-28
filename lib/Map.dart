import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:geocoding/geocoding.dart' as coding;
import 'package:get_storage/get_storage.dart';
import 'package:location/location.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geolocator/geolocator.dart' as gol;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;
import 'package:page_transition/page_transition.dart';
import 'package:place_picker/place_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:village.wale/HomeScreen.dart';
import 'package:village.wale/persistance/api_repository.dart';
import 'package:village.wale/util/AppUtil.dart';
import 'package:flutter/gestures.dart';
import 'City.dart';
import 'LogInPage1.dart';

///Check _getdynamiclocation

class Set_delivery_locaton extends StatefulWidget {
  const Set_delivery_locaton({Key? key}) : super(key: key);

  @override
  State<Set_delivery_locaton> createState() => _Set_delivery_locatonState();
}

class _Set_delivery_locatonState extends State<Set_delivery_locaton> {
  Completer<GoogleMapController> _controller = Completer();
  String Address = 'search';
  static final CameraPosition _kGooglePlex = const CameraPosition(
    target: LatLng(21.735046, 72.136283),
    zoom: 14.4746,
  );

  LatLng _initialcameraposition = const LatLng(20.5937, 78.9629);
  GoogleMapController? _mcontroller;
  loc.Location _location = loc.Location();
  final maxLines = 3;
  String latitude = "";
  String longattitude = "";
  bool isMount = true;
  String livelocation = "";
  double? livelatitude;
  double? livelongitude;
  String? Secondlocation;
  final emailController = TextEditingController();
  final addressController = TextEditingController();
  final newarbyController = TextEditingController();
  final pincodeController = TextEditingController();
  String address = "";
  bool _isLoading = true;
  final getStorage = GetStorage();
  bool showProgress = false;

  static const String _kLocationServicesDisabledMessage =
      'Location services are disabled.';
  static const String _kPermissionDeniedMessage = 'Permission denied.';
  static const String _kPermissionDeniedForeverMessage =
      'Permission denied forever.';
  static const String _kPermissionGrantedMessage = 'Permission granted.';

  final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;

  StreamSubscription<Position>? _positionStreamSubscription;
  StreamSubscription<ServiceStatus>? _serviceStatusStreamSubscription;
  bool positionStreamStarted = false;

  void _toggleServiceStatusStream() {
    setState(() {
      print("Pass 2");
    });
    if (_serviceStatusStreamSubscription == null) {
      final serviceStatusStream = _geolocatorPlatform.getServiceStatusStream();
      _serviceStatusStreamSubscription =
          serviceStatusStream.handleError((error) {
        _serviceStatusStreamSubscription?.cancel();
        _serviceStatusStreamSubscription = null;
      }).listen((serviceStatus) {
        String serviceStatusValue;
        if (serviceStatus == ServiceStatus.enabled) {
          // setState(() {
          //   getLocation();
          // });
          serviceStatusValue = 'enabled';
        } else {
          if (_positionStreamSubscription != null) {
            setState(() {
              _positionStreamSubscription?.cancel();
              _positionStreamSubscription = null;
              showCustomToast("Pls Enable Permission");
              // _updatePositionList(
              //     _PositionItemType.log, 'Position Stream has been canceled');
            });
          }
          serviceStatusValue = 'disabled';
        }
        showCustomToast("Unable Load Map");
        // _updatePositionList(
        //   _PositionItemType.log,
        //   'Location service has been $serviceStatusValue',
        // );
      });
    }
  }

  @override
  void initState() {
    // getCurrentAddress();
    // print("==>GET LOCATION=>"+_getGeoLocationPosition().toString());
    super.initState();
    // _handleLocationPermission();
    setState(() {
      getLocation();
    });

    // getCurrentAddress();
    // _toggleServiceStatusStream();

    // setState(() {
    //   _handleLocationPermission();
    // });

    // _getdynamiclocation();
  }

  final List<Marker> _markers = <Marker>[];

  Position? _currentPosition;
  // late Position2 _currentPosition2;
  String? markers;

  // String googleApikey = "AIzaSyBYQSRKTEs_s6PCt0BQfXQYojOzLE6HT3Y";

  // String googleApikey = "AIzaSyCdF4glrYbyCDr2pNLlJ75dpEL68xQl-Oo";

  // Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  // LatLng _center = const LatLng(21.735046, 72.136283);

  // void _add(){
  //   var markerIdVal;
  //   final MarkerId markerId = MarkerId(markerIdVal);
  //    final Marker marker = Marker(
  //     markerId: markerId,
  //     position: LatLng(
  //       center.latitude + sin(_markerIdCounter * pi / 6.0) / 20.0,
  //       center.longitude + cos(_markerIdCounter * pi / 6.0) / 20.0,
  //     ),
  //     infoWindow: InfoWindow(title: markerIdVal, snippet: '*'),
  //     onTap: () {
  //       _onMarkerTapped(markerId);
  //     },
  //   );
  // }

  void _onMapCreated(GoogleMapController _cntlr) {
    // final marker = const Marker(
    //   markerId: MarkerId('place_name'),
    //   position: const LatLng(9.669111, 80.014007),
    //   // icon: BitmapDescriptor.,
    //   infoWindow: InfoWindow(
    //     title: 'title',
    //     snippet: 'address',
    //   ),
    // );
    // setState(() {
    //   markers[const MarkerId('place_name')] = marker;
    // });
    _mcontroller = _cntlr;

    _location.onLocationChanged.listen((l) {
      _mcontroller?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
              bearing: 45.0,
              target: LatLng(l.latitude!.toDouble(), l.longitude!.toDouble()),
              zoom: 15),
        ),
      );

      _location.getLocation().then((map) {
        if (livelatitude != null && livelongitude != null) {
          if (mounted) {
            super.setState(() {
              _markers.add(Marker(
                  markerId: const MarkerId('SomeId'),
                  position: LatLng(livelatitude!, livelongitude!),
                  icon: BitmapDescriptor.defaultMarker,
                  // infoWindow: const InfoWindow(title: 'The title of the marker'),
                  draggable: true));
            });
          }
        }

        if (mounted) {
          setState(() {});
        }
        super.dispose();
        //...
      });
    });
  }

  Future<void> getLocation() async {
    try {
      setState(() {
        print("Pass");
        _toggleServiceStatusStream();
        // _getAddressFromLatLng();
        getCurrentAddress();
      });
    } catch (exception) {
      if (exception is PermissionDeniedException) {
        print("EXCEPTION");
        // Handle permission denied error
        print('Location permission denied');
        setState(() {
          _currentLocation();
        });
      } else {
        print("EROR");
        // Handle other exceptions
        print('Error getting location: $exception');
      }
    }
  }

  void getCurrentAddress() {
    setState(() {
      print("Pass 3");
      print("===>ENTRY==>");

      Geolocator.getCurrentPosition(desiredAccuracy: gol.LocationAccuracy.best)
          .timeout(const Duration(seconds: 30))
          .then((position) {
        print("====>GET CURRENT ADDRESS ENTRY==>" + position.toString());

        //  check whether the state object is in tree
        setState(() {
          _currentPosition = position;
          print("Pass 3 Current Position is" + _currentPosition.toString());
          _getAddressFromLatLng();
        });

        // setState(() {
        //    _currentPosition = position;
        //   // print(_currentPosition);

        //   _getAddressFromLatLng();
        // });
      }).catchError((erro) {
        if (mounted) {
          // check whether the state object is in tree
          setState(() {
            print("==>ERROR==>" + erro.toString());

            // _isLoading = false;
          });
        }
        setState(() {
          print("==>ERROR==>" + erro.toString());

          _isLoading = false;
        });
      });
    });
  }

  // void userAdresss() async {
  //   print("User New Address");
  //   Geolocator _geoLocator = Geolocator();

  //   Geolocator.getCurrentPosition(desiredAccuracy: gol.LocationAccuracy.best)
  //       .then((position2) {
  //     print("====>GET CURRENT ADDRESS ENTRY==>" + position2.toString());

  //     // check whether the state object is in tree
  //     setState(() {
  //       _currentPosition2 = position2;
  //      // _getdynamiclocation();
  //     });
  //   }).catchError((erro) {
  //     if (mounted) {
  //       setState(() {
  //         print("==>ERROR==>" + erro.toString());

  //         _isLoading = false;
  //       });
  //     }
  //   });
  // }

  // void dispose() {
  //   //...
  //   super.dispose();
  //   //...
  // }

  String _currentAddress = "";
  String _dynamiclocation = "";

  _getdynamiclocation() async {
    List<coding.Placemark> placemarks =
        await coding.placemarkFromCoordinates(livelatitude!, livelongitude!);

    coding.Placemark place = placemarks[0];

    if (mounted) {
      // check whether the state object is in tree

      _isLoading = false;
      _dynamiclocation =
          "${place.name},${place.locality},${place.subLocality}, ${place.country}";
      print(_dynamiclocation);

      // showCustomToast(_currentAddress.toString());
      setState(() {
        addressController.text = _dynamiclocation;
      });
    }
  }

  _getseconddynamiclocation() async {
    List<coding.Placemark> placemarks =
        await coding.placemarkFromCoordinates(livelatitude!, livelongitude!);

    coding.Placemark place = placemarks[0];

    if (!mounted) {
      // check whether the state object is in tree

      _isLoading = false;

      Secondlocation =
          "${place.name},${place.locality},${place.subLocality}, ${place.country}";
      print("Second Location is" + Secondlocation.toString());

      // showCustomToast(_currentAddress.toString());
      Secondlocation = _dynamiclocation;
      getStorage.write('Sec_Address', Secondlocation);

      print(
          "&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&");
      print(getStorage.read('Sec_Address'));
    }
  }

  _getAddressFromLatLng() async {
    print("Pass 4");
    try {
      print("Pass 4 TRY");
      // RUNTIME ERROR GENERATING HERE

      // setState(() async {
      //   List<coding.Placemark> placemarks =
      //       await coding.placemarkFromCoordinates(
      //           _currentPosition!.latitude, _currentPosition!.longitude);
      // });
      List<coding.Placemark> placemarks = await coding.placemarkFromCoordinates(
          _currentPosition!.latitude, _currentPosition!.longitude);

      coding.Placemark place = placemarks[0];

      if (mounted) {
        // check whether the state object is in tree
        setState(() {
          _currentAddress =
              "${place.name}, ${place.subLocality}, ${place.country}";
          // showCustomToast(_currentAddress.toString());
          //addressController.text = _currentAddress;
          print("HERE ==>" + _currentAddress);
        });
        _isLoading = false;
      }
    } catch (e) {
      print("Pass 4 CATCH");

      if (!mounted) {
        // check whether the state object is in tree
        setState(() {
          _isLoading = false;
        });
      }
      print("IN Catch" + e.toString());
      setState(() {
        _isLoading = false;
      });
    }
    void dispose() {
      //...
      super.dispose();
      //...
    }
  }

  // Geolocator _geolocator = Geolocator();
  // void getAddress() async {
  //
  //
  //     var placemarks = await _geolocator.placemarkFromCoordinates(double.parse(latitude),double.parse(longattitude));
  //   setState(() {
  //     addressController.text=placemarks.first.locality.toString();
  //     address=placemarks.first.locality;
  //   });
  // Future<bool> _handleLocationPermission() async {
  //   bool serviceEnabled;
  //   LocationPermission permission;

  //   serviceEnabled = await Geolocator.isLocationServiceEnabled();
  //   if (!serviceEnabled) {
  //     Geolocator.openLocationSettings();
  //     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
  //         content: Text(
  //             'Location services are disabled. Please enable the services')));
  //     return false;
  //   }
  //   permission = await Geolocator.checkPermission();
  //   if (permission == LocationPermission.denied) {
  //     permission = await Geolocator.requestPermission();
  //     if (permission == LocationPermission.denied) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //           const SnackBar(content: Text('Location permissions are denied')));
  //       return false;
  //     }
  //   }
  //   if (permission == LocationPermission.deniedForever) {
  //     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
  //         content: Text(
  //             'Location permissions are permanently denied, we cannot request permissions.')));
  //     return false;
  //   }

  //   return true;
  // }

  Future<LocationData?> _currentLocation() async {
    bool serviceEnabled = true;
    PermissionStatus permissionGranted;

    //Location location = Location();

    serviceEnabled != await _location.serviceEnabled();
    if (serviceEnabled) {
      serviceEnabled = await _location.requestService();
      if (serviceEnabled) {
        return null;
      }
    }

    permissionGranted = await _location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        // return null;
      }
    }

    return await _location.getLocation();
  }

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  TOASTING() {
    showCustomToast("fetching your location");
  }

  @override
  Widget build(BuildContext context) => WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        // Navigator.of(context)
        //     .push(MaterialPageRoute(builder: (context) => CityPage()));
        return false;
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              backgroundColor: Colors.white,
              leading: IconButton(
                  onPressed: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => CityPage()));
                  },
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    color: Colors.black,
                  )),
              title: const Text(
                'Set delivery location',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontFamily: 'Poppins',
                ),
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          PageTransition(
                              type: PageTransitionType.fade,
                              child: const MyHomeScreen()));
                      // Navigator.of(context).push(MaterialPageRoute(
                      //     builder: (context) => const MyHomeScreen()));
                      // (route) => false);
                    },
                    child: const Text(
                      'Skip',
                      style: TextStyle(color: Color(0XFF286953), fontSize: 16),
                    ))
              ],
            ),
            body: SingleChildScrollView(
              child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) =>
                    !_isLoading
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.7,
                                child: Stack(
                                  children: [
                                    GestureDetector(
                                      onVerticalDragStart: (start) {},
                                      child: GoogleMap(
                                        onTap: (latLng) {
                                          TOASTING();

                                          livelatitude = latLng.latitude;
                                          livelongitude = latLng.longitude;
                                          print(livelatitude);
                                          print(livelongitude);
                                          print(livelocation =
                                              "Live Location is : " +
                                                  ' = ${latLng.latitude} , ${latLng.longitude}');
                                          _getdynamiclocation();
                                          _getseconddynamiclocation();
                                        },
                                        mapType: MapType.normal,
                                        initialCameraPosition: _kGooglePlex,
                                        gestureRecognizers: Set()
                                          ..add(Factory<
                                                  OneSequenceGestureRecognizer>(
                                              () => EagerGestureRecognizer()))
                                          ..add(Factory<PanGestureRecognizer>(
                                              () => PanGestureRecognizer()))
                                          ..add(Factory<ScaleGestureRecognizer>(
                                              () => ScaleGestureRecognizer()))
                                          ..add(Factory<TapGestureRecognizer>(
                                              () => TapGestureRecognizer()))
                                          ..add(Factory<
                                                  VerticalDragGestureRecognizer>(
                                              () =>
                                                  VerticalDragGestureRecognizer())),
                                        // onMapCreated:
                                        //     (GoogleMapController mapController) {
                                        //   _controller.complete(mapController);
                                        // },
                                        // markers: markers.values.toSet(),
                                        // onMapCreated: _onMapCreated,
                                        myLocationEnabled: true,
                                        myLocationButtonEnabled: true,

                                        tiltGesturesEnabled: true,
                                        rotateGesturesEnabled: true,

                                        compassEnabled: true,
                                        markers: Set<Marker>.of(_markers),
                                      ),
                                    ),
                                    // Positioned(

                                    //     //search input bar
                                    //     top: 10,
                                    //     child: InkWell(
                                    //         onTap: () async {
                                    //           var place =
                                    //               await PlacesAutocomplete.show(
                                    //                   context: context,
                                    //                   apiKey: googleApikey,
                                    //                   mode: Mode.overlay,
                                    //                   types: [],
                                    //                   strictbounds: false,
                                    //                   components: [
                                    //                     Component(
                                    //                         Component.country,
                                    //                         'np')
                                    //                   ],
                                    //                   //google_map_webservice package
                                    //                   onError: (err) {
                                    //                     print(err);
                                    //                   });

                                    //           if (place != null) {
                                    //             setState(() {
                                    //               _currentAddress = place
                                    //                   .description
                                    //                   .toString();
                                    //             });
                                    //             //form google_maps_webservice package
                                    //             final plist = GoogleMapsPlaces(
                                    //               apiKey: googleApikey,
                                    //               apiHeaders:
                                    //                   await const GoogleApiHeaders()
                                    //                       .getHeaders(),
                                    //               //from google_api_headers package
                                    //             );
                                    //             String placeid =
                                    //                 place.placeId ?? "0";
                                    //             final detail = await plist
                                    //                 .getDetailsByPlaceId(placeid);
                                    //             final geometry =
                                    //                 detail.result.geometry!;
                                    //             final lat = geometry.location.lat;
                                    //             final lang =
                                    //                 geometry.location.lng;
                                    //             var newlatlang =
                                    //                 LatLng(lat, lang);

                                    //             //move map camera to selected place with animation
                                    //             // mapController?.animateCamera(
                                    //             //     CameraUpdate
                                    //             //         .newCameraPosition(
                                    //             //             CameraPosition(
                                    //             //                 target:
                                    //             //                     newlatlang,
                                    //             //                 zoom: 17)));
                                    //           }
                                    //         },
                                    //         child: Padding(
                                    //           padding: const EdgeInsets.all(15),
                                    //           child: Card(
                                    //             child: Container(
                                    //                 padding:
                                    //                     const EdgeInsets.all(0),
                                    //                 width: MediaQuery.of(context)
                                    //                         .size
                                    //                         .width -
                                    //                     40,
                                    //                 child: ListTile(
                                    //                   // leading: Image.asset(
                                    //                   //   "assets/images/picker.png",
                                    //                   //   width: 25,
                                    //                   // ),
                                    //                   title: Text(
                                    //                     _currentAddress
                                    //                         .toString(),
                                    //                     style: const TextStyle(
                                    //                         fontSize: 18),
                                    //                   ),
                                    //                   trailing: const Icon(
                                    //                       Icons.search),
                                    //                   dense: true,
                                    //                 )),
                                    //           ),
                                    //         )))

                                    // InkWell(
                                    //   onTap: () {
                                    //     getCurrentAddress();
                                    //     // _onMapCreated(_mcontroller!);
                                    //   },
                                    //   child: Align(
                                    //     alignment: Alignment.bottomCenter,
                                    //     child: Padding(
                                    //       padding: const EdgeInsets.all(20.0),
                                    //       child: FloatingActionButton.extended(
                                    //         onPressed: () {
                                    //           _currentLocation();
                                    //           getCurrentAddress();
                                    //           _toggleServiceStatusStream();
                                    //         },
                                    //         label: Row(
                                    //           mainAxisAlignment:
                                    //               MainAxisAlignment.spaceBetween,
                                    //           children: const [
                                    //             Icon(Icons.my_location_outlined,
                                    //                 color: Color(0XFF286953)),
                                    //             Text(
                                    //               'Current Location',
                                    //               style: TextStyle(
                                    //                   color: Color(0XFF286953)),
                                    //             ),
                                    //           ],
                                    //         ),
                                    //         shape: const RoundedRectangleBorder(
                                    //             side: BorderSide(
                                    //                 color: Color(0XFF286953),
                                    //                 width: 1,
                                    //                 style: BorderStyle.solid),
                                    //             borderRadius: BorderRadius.all(
                                    //                 Radius.circular(10))),
                                    //         backgroundColor: Colors.white,
                                    //       ),
                                    //     ),
                                    //   ),
                                    // ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(6, 8, 6, 8),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(Icons.location_on_outlined),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                          child: Text(
                                            _dynamiclocation.toString(),
                                            style: const TextStyle(
                                                fontFamily: "Poppins",
                                                fontSize: 14),
                                            maxLines: 4,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        TextButton(
                                            onPressed: () {
                                              _bottomsheet(context);
                                            },
                                            child: const Text(
                                              'Change',
                                              style: TextStyle(
                                                  fontFamily: "Poppins",
                                                  color: Color(0XFF286953),
                                                  fontSize: 16),
                                            )),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    SizedBox(
                                      height: 45,
                                      width: double.infinity,
                                      child: ButtonTheme(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            primary: const Color(0XFF286953),
                                          ),
                                          onPressed: () {
                                            if (livelatitude == null &&
                                                livelongitude == null) {
                                              showCustomToast(
                                                  "Please Select Live Location");
                                            } else {
                                              _getdynamiclocation();
                                              _bottomsheet(context);
                                            }
                                            //showPlacePicker();
                                            // _getAddressFromLatLng();
                                            //getCurrentAddress();
                                          },
                                          //textColor: Colors.white,
                                          child: const Text(
                                            "Enter Full Address",
                                            style: TextStyle(
                                                fontFamily: "Poppins",
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          )
                        : Center(child: getProgressBar()),
              ),
            )),
      ));

  void _bottomsheet(BuildContext context) {
    showBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          // <-- SEE HERE
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(25.0),
          ),
        ),
        builder: (context) {
          return Container(
            margin: const EdgeInsets.fromLTRB(16, 20, 16, 15),
            width: double.infinity,
            //height: MediaQuery.of(context).size.height * 0.46,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Save Full Delivery Address',
                    style: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 18,
                        fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  // SizedBox(
                  //   height: 60,
                  //   child: TextField(
                  //       controller: emailController,
                  //       keyboardType: TextInputType.text,
                  //       style: const TextStyle(
                  //         color: Colors.black,
                  //       ),
                  //       decoration: InputDecoration(
                  //         focusedBorder: OutlineInputBorder(
                  //           borderSide: const BorderSide(color: Colors.green),
                  //           borderRadius: BorderRadius.circular(10),
                  //         ),
                  //         enabledBorder: OutlineInputBorder(
                  //           borderSide: const BorderSide(color: Colors.green),
                  //           borderRadius: BorderRadius.circular(10),
                  //         ),
                  //         floatingLabelStyle:
                  //             TextStyle(color: getColorPrimary()),
                  //         filled: true,
                  //         fillColor: const Color(0xffEFF1F4),
                  //         prefixIcon: Icon(
                  //           Icons.location_on_outlined,
                  //           color: getColorFromHex("#9D9FA2"),
                  //         ),
                  //         border: OutlineInputBorder(
                  //           borderSide:
                  //               const BorderSide(color: Color(0xffAAAAAA)),
                  //           borderRadius: BorderRadius.circular(10),
                  //         ),
                  //         labelText: "Email Address",
                  //         hintStyle: const TextStyle(
                  //           color: Color(0xffAAAAAA),
                  //           fontSize: 13,
                  //         ),
                  //       )),
                  // ),

                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: 60,
                    child: TextField(
                        controller: addressController,
                        keyboardType: TextInputType.multiline,
                        style: const TextStyle(
                          fontFamily: "Poppins",
                          color: Colors.black,
                        ),
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.green),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.green),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          floatingLabelStyle: TextStyle(
                              fontFamily: "Poppins", color: getColorPrimary()),
                          filled: true,
                          fillColor: const Color(0xffEFF1F4),
                          prefixIcon: Icon(
                            Icons.other_houses_outlined,
                            color: getColorFromHex("#9D9FA2"),
                          ),
                          border: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: Color(0xffAAAAAA)),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          labelText: "Complete Address",
                          hintStyle: const TextStyle(
                            fontFamily: "Poppins",
                            color: Color(0xffAAAAAA),
                            fontSize: 13,
                          ),
                        )),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: 60,
                    child: TextField(
                        controller: newarbyController,
                        keyboardType: TextInputType.text,
                        style: const TextStyle(
                          fontFamily: "Poppins",
                          color: Colors.black,
                        ),
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.green),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.green),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          floatingLabelStyle: TextStyle(
                              fontFamily: "Poppins", color: getColorPrimary()),
                          filled: true,
                          fillColor: const Color(0xffEFF1F4),
                          prefixIcon: Icon(
                            Icons.maps_home_work_outlined,
                            color: getColorFromHex("#9D9FA2"),
                          ),
                          border: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: Color(0xffAAAAAA)),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          labelText: "Nearby Landmark (Optional)",
                          hintStyle: const TextStyle(
                            fontFamily: "Poppins",
                            color: Color(0xffAAAAAA),
                            fontSize: 13,
                          ),
                        )),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: 60,
                    child: TextFormField(
                      maxLength: 6,
                      controller: pincodeController,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(
                        fontFamily: "Poppins",
                        color: Colors.black,
                      ),
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.green),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.green),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        floatingLabelStyle: TextStyle(
                            fontFamily: "Poppins", color: getColorPrimary()),
                        counterText: "",
                        filled: true,
                        fillColor: const Color(0xffEFF1F4),
                        prefixIcon: Icon(
                          Icons.maps_home_work_outlined,
                          color: getColorFromHex("#9D9FA2"),
                        ),
                        border: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Color(0xffAAAAAA)),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        labelText: "PIN Code",
                        hintStyle: const TextStyle(
                          fontFamily: "Poppins",
                          color: Color(0xffAAAAAA),
                          fontSize: 13,
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "password cannot be empty";
                        } else if (value.length < 6) {
                          return "password length should be atleast 6";
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  !_isLoading
                      ? SizedBox(
                          height: 45,
                          width: double.infinity,
                          child: ButtonTheme(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: const Color(0XFF286953),
                              ),
                              onPressed: () {
                                callApi();
                              },
                              //textColor: Colors.white,
                              child: const Text(
                                "Save Address",
                                style: TextStyle(
                                    fontFamily: "Poppins",
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        )
                      : Center(child: getProgressBar()),
                ],
              ),
            ),
          );
        });
  }

  // Future<Position> _getGeoLocationPosition() async {
  //   bool serviceEnabled;
  //   LocationPermission permission;
  //   // Test if location services are enabled.
  //   serviceEnabled = await Geolocator.isLocationServiceEnabled();
  //   if (!serviceEnabled) {
  //     // Location services are not enabled don't continue
  //     // accessing the position and request users of the
  //     // App to enable the location services.
  //     await Geolocator.openLocationSettings();
  //     return Future.error('Location services are disabled.');
  //   }
  //   permission = await Geolocator.checkPermission();
  //   if (permission == LocationPermission.denied) {
  //     permission = await Geolocator.requestPermission();
  //     if (permission == LocationPermission.denied) {
  //
  //       return Future.error('Location permissions are denied');
  //     }
  //   }
  //   if (permission == LocationPermission.deniedForever) {
  //     // Permissions are denied forever, handle appropriately.
  //     return Future.error(
  //         'Location permissions are permanently denied, we cannot request permissions.');
  //   }
  //   // When we reach here, permissions are granted and we can
  //   // continue accessing the position of the device.
  //   return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  // }
  //
  // Future<void> GetAddressFromLatLong(Position position)async {
  //   List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
  //
  //   print(placemarks);
  //   Placemark place = placemarks[0];
  //   Address = '${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
  //
  // }
  // bool isEmailValidate(String em) {
  //   String p =
  //       r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

  //   RegExp regExp = RegExp(p);

  //   return regExp.hasMatch(em);
  // }

  String id = "";
  void callApi() async {
    // if (emailController.text.isEmpty) {
    //   showCustomToast("Please Enter Email");
    //   return;
    // }

    if (addressController.text.isEmpty) {
      showCustomToast("Please Enter Complete Address");
      return;
    }
    if (pincodeController.text.length < 6) {
      showCustomToast("Please Enter Valid Pincode");
      return;
    }

    if (pincodeController.text.isEmpty) {
      showCustomToast("Please Enter pincode");
      return;
    }
    // if (isEmailValidate(emailController.text) == false) {
    //   showCustomToast("Please Enter Valid Email Address.");
    //   return;
    // }
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    id = sharedPreferences.getString("id").toString();
    String _cityName = sharedPreferences.getString("city").toString();

    print("===>CITY NAME==>" + _cityName.toString());
    // setState(() {
    //   _isLoading = true;
    // });
    var api = APICallRepository();
    api
        .setAddress(id, _cityName, livelatitude.toString(),
            livelongitude.toString(), addressController.text)
        .then((value) {
      if (!mounted) {
        // check whether the state object is in tree
        setState(() {
          //_isLoading = false;

          var json = jsonDecode(value);
          var message = json["message"];
          showCustomToast(message);
          Navigator.push(
              context,
              PageTransition(
                  type: PageTransitionType.fade, child: const MyHomeScreen()));
          // Navigator.of(context).push(
          //     MaterialPageRoute(builder: (context) => const MyHomeScreen()));
          // (route) => false);
        });
      }

      // setState(() {
      //   _isLoading = false;

      //   var json = jsonDecode(value);
      //   var message = json["message"];
      //   showCustomToast(message);
      //   Navigator.of(context).pushAndRemoveUntil(
      //       MaterialPageRoute(builder: (context) => const MyHomeScreen()),
      //       (route) => false);
      // });
      // void dispose() {
      //   if (mounted) {}
      //   //...
      //   super.dispose();
      //   //...
      // }
    }, onError: (error) {
      if (mounted) {
        // check whether the state object is in tree
        setState(() {
          _isLoading = false;

          // var json = jsonDecode(value);
          // var message = json["message"];
          // showCustomToast(message);
          // Navigator.of(context).pushAndRemoveUntil(
          //     MaterialPageRoute(builder: (context) => const MyHomeScreen()),
          //     (route) => false);
        });
      }
    });
    void dispose() {
      // Dispose any controller...
      super.dispose();
    }
  }
}
// Button Current Position
// InkWell(
//   onTap: () {
//     getCurrentAddress();
//     // _onMapCreated(_mcontroller!);
//   },
//   child: Align(
//     alignment: Alignment.bottomCenter,
//     child: Padding(
//       padding: const EdgeInsets.all(20.0),
//       child: FloatingActionButton.extended(
//         onPressed: () {
//           _currentLocation();
//           getCurrentAddress();
//           _toggleServiceStatusStream();
//         },
//         label: Row(
//           mainAxisAlignment:
//               MainAxisAlignment.spaceBetween,
//           children: const [
//             Icon(Icons.my_location_outlined,
//                 color: Color(0XFF286953)),
//             Text(
//               'Current Location',
//               style: TextStyle(
//                   color: Color(0XFF286953)),
//             ),
//           ],
//         ),
//         shape: const RoundedRectangleBorder(
//             side: BorderSide(
//                 color: Color(0XFF286953),
//                 width: 1,
//                 style: BorderStyle.solid),
//             borderRadius: BorderRadius.all(
//                 Radius.circular(10))),
//         backgroundColor: Colors.white,
//       ),
//     ),
//   ),
// ),
