import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:tazafol/components/url.dart';
import 'dart:io';

//import 'dart:io' show Platform;
import 'package:launch_review/launch_review.dart';
import 'package:tazafol/pages/offer.dart';
import 'package:url_launcher/url_launcher.dart';
//import 'dart:math';
//local imports

import 'components/color.dart';
import 'components/checkInternet.dart';
import 'models/cartProductModel.dart';
import 'models/dataModel.dart';

import 'pages/home.dart';
import 'pages/profile.dart';
import 'pages/cart.dart';
import 'pages/order.dart';
import 'pages/message.dart';


void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(primarySwatch: appThemeColor, accentColor: appThemeColor, highlightColor: highLightColor),
    home: Scaffold(body: HomePage()),
  ));
}

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  int _selectedPage = 0;
  int _userId;
  String _title;
  bool _isVisible;
  bool _isShopIconVisible;
  int _totalBill = 0;
  int dc = 0;
  int _os = 0;
  String _pushToken = "";
  DataModel serverData;
  bool isLoading = true;
  String mobilePhone = "";

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  //String _message = '';

  List<Category> localCategories;
  List<Product> localProducts;
  List<Order> localOrders;
  List<OfferList> localOffers;
  List<Notifikation> localNotifications;
  Profile localProfile;
  Offer localOffer;
  AppInfo serverAppInfo;
  GlobalKey globalKeyBottomNavController =
      new GlobalKey(debugLabel: 'btm_app_bar');
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  List<CartProductModel> cartProducts = [];

  List pageOptions() => [
        Home(
            updateCart: _updateCart,
            products: localProducts,
            cartProducts: cartProducts,
            categories: localCategories),
        OrderPage(orderList: localOrders),
        OfferPage(offers: localOffers, notifications: localNotifications,),
        MessagePage(os: _os,),
        ProfilePage(
            profile: localProfile,
            globalKeyBottomNavController: globalKeyBottomNavController),
      ];

  @override
  void initState() {
    super.initState();

    //Navigator.popUntil(context, ModalRoute.withName("/Home"));
//    _firebaseMessaging.onTokenRefresh.listen((newToken) {
//      print('token update hocce = $newToken');
//    });
    CheckInternet().checkConnection(context);
        getPushMessage();
        _title = "Product List";
        _isVisible = true;
        _isShopIconVisible = true;
        //serverData = fetchData();
        localProfile = Profile();
        _getAllData();


        //localOrders = Order()
        //_loadTotalBill();
  }

  //check operating system
  void _checkOS(){
    //String ab = Platform.operatingSystem;
    if(Platform.isIOS){
      _os = 2;

      var serverAppVersion = double.parse(serverAppInfo.iosAppVersion);
      if(serverAppVersion > appVersion){
        //print(serverAppInfo.iosAppUrl);
        _showDialog('App Store', appStoreColor);
      }
    }else if(Platform.isAndroid){
      _os = 1;
      var serverAppVersion = double.parse(serverAppInfo.androidAppVersion);
      if(serverAppVersion > appVersion){
        //print(serverAppInfo.androidAppUrl);
        _showDialog('Play Store', appStoreColor);
      }
    }else{
      _os = 0;
    }
  }
// this function is to show dialog-alert
  void _showDialog(String msg, Color appColor) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Update Required!!'),
            content: Text('This app version has expired. Please update'),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop();
                },
                child: Text('SKIP'),
              ),
              MaterialButton(
                color: appColor,
                textColor: Colors.white,
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop();
                  LaunchReview.launch(androidAppId: serverAppInfo.androidAppId, iOSAppId: serverAppInfo.iosAppId, writeReview: false);
                },
                child: Text('$msg', style: TextStyle(color: Colors.white),),
              ),

            ],
          );
        });
  }

  // fetch data from internet
  Future<DataModel> fetchData() async {
    final response = await http.get('http://tazafol.com/app-api/data.php');
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return DataModel.fromJson(jsonResponse);
    } else {
      throw Exception('Failed to load data');
    }
  }

  void getPushMessage() {
    _firebaseMessaging.configure(
        onMessage: (Map<String, dynamic> message) async {
      print('on message $message');
      //print("${message['data']['img']}");
      //setState(() => _message = message["notification"]["title"]);
    }, onResume: (Map<String, dynamic> message) async {
      print('on resume $message');
      //setState(() => _message = message["notification"]["title"]);
    }, onLaunch: (Map<String, dynamic> message) async {
      print('on launch $message');
      //setState(() => _message = message["notification"]["title"]);
    });

    //_firebaseMessaging.requestNotificationPermissions();
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });

    _firebaseMessaging.getToken().then((String token) {
      assert(token != null);
      print('Push Messaging token: $token');
      _pushToken = token;
    });

  }

  _getAllData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("token", _pushToken);
    _userId = preferences.getInt("userid") ?? 0;
    //print('userID= $_userId');
    API.getAllData(_userId.toString()).then((response) {
      isLoading = false;
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        serverData = DataModel.fromJson(jsonResponse);
        localCategories = serverData.categories;
        localProducts = serverData.products;
        localOrders = serverData.orderList;
        localProfile = serverData.profile;
        localOffer = serverData.offer;
        localNotifications = serverData.notificationList;
        localOffers = serverData.offerList;
        serverAppInfo = serverData.appInfo;
        dc = serverData.deliveryCharge;
        mobilePhone = serverData.mobilePhone;
        _checkOS();

        setState(() {
          isLoading = false;
        });
        preferences.setInt('categoryId', localCategories[0].id);
        //debugPrint(data1.products[3].nameBn);
      } else {
        throw Exception('Failed to load data');
      }
    });
  }

// change totalBill function

  _updateCart(CartProductModel selectedProduct, String changer) {
    int _price = 0;
    _price = selectedProduct.cartProductSalePrice != 0 ? selectedProduct.cartProductSalePrice : selectedProduct.cartProductPrice;
    setState(() {
      int index = -1;
      for (int i = 0; i < cartProducts.length; i++) {
        if (cartProducts[i].cartProductId == selectedProduct.cartProductId) {
          index = i;
          break;
        }
      }
      if (index >= 0) {
        if (changer == 'plus') {
          _totalBill += _price;
          cartProducts[index].cartProductQty += 1;
        } else {
          _totalBill -= _price;
          cartProducts[index].cartProductQty > 1
              ? cartProducts[index].cartProductQty -= 1
              : cartProducts.removeAt(index);
        }
      } else {
        _totalBill += _price;
        cartProducts.add(selectedProduct);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final List _pageOptions = pageOptions();
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Loadings..'),
        ),
        body: Center(
          child: CircularProgressIndicator(
            valueColor: new AlwaysStoppedAnimation<Color>(appThemeColor),
          ),
        ),
      );
    } else {
      return WillPopScope(
        onWillPop: () async => showDialog<bool>(
          context: context,
          builder: (c) => AlertDialog(
            title: Text('Warning !!', textAlign: TextAlign.center, style: TextStyle(color: Colors.red),),
            content: Text('Back is disabled', textAlign: TextAlign.center,),
            actions: <Widget>[
              FlatButton(
                child: Text('Close', style: TextStyle(color: Colors.red),),
                onPressed: () => Navigator.pop(c, false),
              ),
            ],
          ),
        ),
        child: Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(

            centerTitle: true,
            automaticallyImplyLeading: false,
            title: Text('$_title'),
            actions: <Widget>[
              Visibility(
                visible: _isShopIconVisible,
                child: Container(
                    width: 60.0,
                    //height: 40.0,
                    //color: Colors.green,
                    child: Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: Text(
                          '$_totalBill TK',
                          textAlign: TextAlign.center,
                        ))),
              ),
              Visibility(
                visible: _isVisible,
                child: IconButton(
                  icon: Icon(
                    Icons.call,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    //debugPrint('button tapped');
                    launch("tel://$mobilePhone");

                    //Navigator.of(context).push(MaterialPageRoute(builder: (context) => Cart(cartProducts: cartProducts, totalBill: _totalBill,)));
                  },
                ),
              ),
            ],
          ),
          body: _pageOptions[_selectedPage],
          bottomNavigationBar: SafeArea(child: _buildBottomNavigationBar()),
          floatingActionButton: Visibility(
            visible: _isShopIconVisible,
            child: Padding(
              padding: const EdgeInsets.only(right: 55.0),
              child: FloatingActionButton(
                backgroundColor: (_totalBill > 0 ? appThemeColor : tabBarBackgroundColor),
                onPressed: () {
                  _totalBill > 0 ? _navigateToCart(context)
                      : _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("Empty cart! no products added", textAlign: TextAlign.center,), ));
                },
                child: Icon(
                    Icons.shopping_cart,
                  color: (_totalBill > 0 ? Colors.white : Colors.black45),
                ),
                tooltip: 'call TazaFol',
              ),
            ),
          ),
        ),
      );
    }
  }

  Widget _buildBottomNavigationBar() {
    return SizedBox(
      height: 55.0,
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        key: globalKeyBottomNavController,
        currentIndex: _selectedPage,
        //fixedColor: appThemeColor,
        backgroundColor: tabBarBackgroundColor,
        selectedItemColor: appThemeColor,
        unselectedItemColor: Colors.black45,
        items: [
          _buildItem(icon: Icons.view_list, title: 'Home'),
          _buildItem(icon: Icons.shop, title: 'My Order'),
          _buildItem(icon: Icons.local_offer, title: 'Offer'),
          _buildItem(icon: Icons.message, title: 'Message'),
          _buildItem(icon: Icons.perm_identity, title: 'Profile'),
        ],
        onTap: _onSelectTab,
      ),
    );
  }

  void _onSelectTab(int index) {
    setState(() {
      _selectedPage = index;
      switch (index) {
        case 0:
          {
            _title = "Product List";
            _isVisible = true;
            _isShopIconVisible = true;

          }
          break;
        case 1:
          {
            _title = "Order List";
            _isVisible = true;
            _isShopIconVisible = false;

          }
          break;
        case 2:
          {
            _title = "Offers & Notifications";
            _isVisible = false;
            _isShopIconVisible = false;

          }
          break;
        case 3:
          {
            _title = "Message";
            _isVisible = false;
            _isShopIconVisible = false;

          }
          break;
        case 4:
          {
            _title = "My Profile";
            _isVisible = true;
            _isShopIconVisible = false;

          }
          break;
      }
    });
  }

  _navigateToCart(BuildContext context) async {
    bool _showBottomNavigationBar = true;
    if (cartProducts.length <= 0) {
      _showBottomNavigationBar = false;
    }
    cartProducts = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Cart(
                  cartProducts: cartProducts,
                  totalBill: _totalBill,
                  deliveryCharge: dc,
                  userId: _userId,
                  os: _os,
                  pushToken: _pushToken,
                  localOffer: localOffer,
                  showBar: _showBottomNavigationBar,
                  localProfile: localProfile,
                )));

    //debugPrint('result=${cartProducts[0].cartProductQty},${cartProducts[0].cartProductName}');
    _updateHomeView(cartProducts);
  }

  _updateHomeView(List<CartProductModel> cartProductsBack) {
    var bill = 0;
    for (var temp in cartProductsBack) {
      if(temp.cartProductSalePrice != 0){
        bill += temp.cartProductSalePrice * temp.cartProductQty;
      }else{
        bill += temp.cartProductPrice * temp.cartProductQty;
      }
    }
    var temp = pageOptions()[0];
    debugPrint("$temp");
    setState(() {
      _totalBill = bill;
    });
  }

  BottomNavigationBarItem _buildItem({IconData icon, String title}) {
    return BottomNavigationBarItem(
      icon: Icon(icon),
      title: Text(title),
    );
  }
}

class API {
  static Future getAllData(String userId) {
    var url = baseUrl + "data.php";
    return http.post(url, body: {"userid": userId});
    //return http.get(url);
  }
}
