import 'dart:io';
import 'dart:math';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:tazafol/components/url.dart';
import 'package:tazafol/models/cartProductModel.dart';
import 'package:tazafol/models/userModel.dart';
import 'package:tazafol/models/dataModel.dart';
import 'package:tazafol/pages/checkout.dart';
import 'package:tazafol/main.dart';

class UserValidation extends StatefulWidget {
  final OrderSendToServer orderData;
  final String rootPage;
  UserValidation({Key key, this.orderData, this.rootPage}) : super(key: key);
  @override
  _UserValidationState createState() => _UserValidationState();
}

class _UserValidationState extends State<UserValidation>
    with TickerProviderStateMixin {
  AnimationController _controller;
  static const int kStartValue = 46;
  bool isCountDownVisible = false;
  bool isMobileVisible = true;
  final _formKey = GlobalKey<FormState>();
  final otpController = TextEditingController();
  final mobileController = TextEditingController();
  Profile localProfile = Profile();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  double textBoxWidth;
  double containerHeight;
  double containerWidth;
  OrderSendToServer tempOrderData;
  String mobile = '';
  var pin = 0;
  String rPinText = "";
  var randomNumber = 0;
  int _os = 0;
  String _pushToken = "";
  var _isExist = false;

  @override
  void dispose() {
    mobileController.dispose();
    super.dispose();
  }
  @override
  void initState() {
    if(widget.rootPage == 'profile'){
      _isExist = true;
      debugPrint('coming from profile page');
    }
  super.initState();
  }



  _countDownStart() {
    rPinText = "RESEND PIN IN ";
    isCountDownVisible = true;
    _controller = new AnimationController(
      vsync: this,
      duration: new Duration(seconds: kStartValue),
    );
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        print('timer ends');
        setState(() {
          rPinText = "RESEND PIN";
          isCountDownVisible = false;
        });
      }
    });
    _controller.forward(from: 0.0);
  }

  void _sendOTP(String mobile) async {
    debugPrint('OTP function calling');
    //var url = "http://tazafol.com/app-api/cancel_order.php";
    var url = baseUrl + "send_otp.php";
    //SharedPreferences preferences = await SharedPreferences.getInstance();
    //var userId = preferences.getInt('userid').toString();
    var response = await http
        .post(url, body: {"mobile": mobile, "otp": randomNumber.toString()});
    if (response.statusCode == 200) {
      debugPrint('OTP response success');
      /*final jsonResponse = json.decode(response.body);
      ProfileResponse serverData = ProfileResponse.fromJson(jsonResponse);
      Navigator.of(context).pop();
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomePage()));
      setState(() {
        _isLoader = false;
      });*/
    } else {}
  }

  Future<String> getToken () async{
    String pushToken;
    SharedPreferences preferences = await SharedPreferences.getInstance();
    pushToken = preferences.getString("token");
    return pushToken;
  }

  void _otpPass(String mobile, String pushToken, var os) async {
    //var url = "http://tazafol.com/app-api/save_user.php";

    //Dismiss Timer
    _controller.dispose();
    //Dismiss keyboard
    FocusScope.of(context).unfocus();


    var url = baseUrl + "otp_pass.php";
    var response = await http.post(url, body: {
      "mobile": mobile,
      "os": os.toString(),
      "token": pushToken
    });
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      UserValidationData serverData = UserValidationData.fromJson(jsonResponse);
        localProfile = serverData.profile;
        SharedPreferences preferences = await SharedPreferences.getInstance();
        preferences.setInt('userid', serverData.userId);
        debugPrint('userid=${serverData.userId}');

      _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("Mobile Verification Success !!", textAlign: TextAlign.center,), ));
      Timer(Duration(seconds: 1),(){
        if(_isExist){
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => HomePage()));
        }else{
          Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => CheckOut(
            orderData: widget.orderData,
            localProfile: localProfile,
            userId: serverData.userId,
            mobile: mobile,
          )));
        }
      });
      /**/




      /*_showDialog();
      setState(() {
        _isLoader = false;
      });*/
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    containerHeight = MediaQuery.of(context).size.height * 0.45;
    containerWidth = MediaQuery.of(context).size.width;
    textBoxWidth = containerWidth * 0.6;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Mobile Verification'),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 50.0),
        child: Container(
          height: containerHeight,
          width: containerWidth,
          decoration: BoxDecoration(
            color: Colors.lightGreen[100],
            border: Border.all(color: Colors.green[900]),
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          child: Form(
            key: _formKey,
            child: Padding(
              padding:
                  const EdgeInsets.only(left: 15.0, right: 15.0, top: 50.0),
              child: Column(
                //mainAxisAlignment: MainAxisAlignment.center,
                //crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  //SizedBox(height: 77.0),
                  Visibility(
                    visible: isMobileVisible,
                    child: Padding(
                        padding: const EdgeInsets.only(bottom: 15.0),
                        child: Center(
                            child: Text('Enter your mobile number to verify'))),
                  ),
                  Visibility(
                    visible: !isMobileVisible,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text('We\'ve sent a PIN number to '),
                          Text(
                            mobile,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Visibility(
                            visible: !isCountDownVisible,
                            child: InkWell(
                                onTap: () {
                                  mobileController.clear();
                                  setState(() {
                                    isMobileVisible = true;
                                  });
                                },
                                child: Icon(
                                  Icons.edit,
                                  size: 20.0,
                                  color: Colors.blue,
                                )),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Visibility(
                    visible: isMobileVisible,
                    child: SizedBox(
                      //width: textBoxWidth,
                      height: 70.0,
                      child: TextFormField(
                        //enabled:_verifiedMobile ? false : _isTextFieldEnable,
                        controller: mobileController,
                        keyboardType: TextInputType.number,
                        maxLength: 11,
                        decoration: InputDecoration(
                          labelText: 'Your Mobile',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value.isEmpty || value.length < 11) {
                            return 'Pls enter valid mobile i.e 01970413031';
                          }
                          return null;
                        },
                        onSaved: (val) => mobile = val,
                      ),
                    ),
                  ),
                  Visibility(
                    visible: !isMobileVisible,
                    child: SizedBox(
                      //width: textBoxWidth,
                      height: 70.0,
                      child: TextFormField(
                        //enabled:_verifiedMobile ? false : _isTextFieldEnable,
                        controller: otpController,
                        keyboardType: TextInputType.number,
                        maxLength: 4,
                        decoration: InputDecoration(
                          labelText: 'Enter 4 digit OTP',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          //check if otp entered is null or less than 4 digits
                          if (value.isEmpty || value.length < 4) {
                            return 'Pls enter 4 digit PIN sent to your mobile';
                          }
                          //check if entered otp is wrong
                          if(value != randomNumber.toString()){
                            return 'Opps! wrong PIN';
                          }
                          return null;
                        },
                        onSaved: (val) => pin = int.parse(val),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Visibility(
                    visible: isMobileVisible,
                    child: Container(
                      height: 40.0,
                      decoration: BoxDecoration(
                          border: Border.all(),
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(30.0)),
                      child: InkWell(
                        onTap: () {
                          int min =
                              1000; //min and max values act as your 6 digit range
                          int max = 9999;
                          var randomizer = new Random();
                          randomNumber = min + randomizer.nextInt(max - min);
                          debugPrint('random number =${randomNumber}');
                          otpController.clear();
                          final form = _formKey.currentState;
                          if (form.validate()) {
                            form.save();
                            getToken().then((String value){
                              _pushToken = value;
                            });
                            _sendOTP(mobile);
                            setState(() {
                              _countDownStart();
                              isMobileVisible = false;
                            });
                          }
                        },
                        child: Center(
                          child: Text('SEND PIN',
                              style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)),
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: !isMobileVisible,
                    child: Container(
                      height: 40.0,
                      decoration: BoxDecoration(
                          border: Border.all(),
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(30.0)),
                      child: InkWell(
                        onTap: () {
                          Platform.isAndroid == 1 ? _os = 1 : _os = 2;
                          if(Platform.isAndroid){
                            _os = 1;
                          }else if(Platform.isIOS){
                            _os = 2;
                          }else{
                            _os = 0;
                          }
                          debugPrint('os= ${_os}, pushToken = ${_pushToken}');
                          final form = _formKey.currentState;
                          if (form.validate()) {
                            form.save();
                            debugPrint(
                                'randomNumber = ${randomNumber} pin = ${pin}');
                            pin == randomNumber
                                ? _otpPass(mobile,_pushToken, _os)
                                : debugPrint('otp failed');
                          }
                        },
                        child: Center(
                          child: Text('VERIFY PIN',
                              style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)),
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: !isMobileVisible,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: Column(
                        children: <Widget>[
                          Text(
                            'Didn\'t receive any PIN ?',
                            style: TextStyle(color: Colors.red),
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Visibility(
                                visible: !isCountDownVisible,
                                child: InkWell(
                                  child: Text(
                                    rPinText,
                                    style: TextStyle(
                                        decoration: TextDecoration.underline,
                                        color: Colors.blue),
                                  ),
                                  onTap: () {
                                    int min =
                                        1000; //min and max values act as your 6 digit range
                                    int max = 9999;
                                    var randomizer = new Random();
                                    randomNumber =
                                        min + randomizer.nextInt(max - min);
                                    debugPrint(
                                        'random number =${randomNumber}');
                                    otpController.clear();
                                    _sendOTP(mobile);
                                    setState(() {
                                      _countDownStart();
                                    });
                                  },
                                ),
                              ),
                              Visibility(
                                visible: isCountDownVisible,
                                child: Text(
                                  rPinText,
                                ),
                              ),

                              //child 2
                              Visibility(
                                visible: isCountDownVisible,
                                child: Countdown(
                                  animation: new StepTween(
                                    begin: kStartValue,
                                    end: 0,
                                  ).animate(_controller),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class Countdown extends AnimatedWidget {
  Countdown({Key key, this.animation}) : super(key: key, listenable: animation);
  final Animation<int> animation;

  @override
  build(BuildContext context) {
    return new Text(
      animation.value.toString() + ' SECONDS',
    );
  }
}
