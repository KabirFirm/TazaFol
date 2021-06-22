import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:tazafol/components/color.dart';
import 'package:tazafol/components/url.dart';
import 'package:tazafol/main.dart';
import 'package:tazafol/models/dataModel.dart';
import '../models/cartProductModel.dart';
import 'package:tazafol/models/userModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CheckOut extends StatefulWidget {
  final OrderSendToServer orderData;
  final Profile localProfile;
  final userId;
  final mobile;
  CheckOut({Key key, this.orderData, this.localProfile, this.userId, this.mobile}) : super(key: key);
  @override
  _CheckOutState createState() => _CheckOutState();
}

class _CheckOutState extends State<CheckOut> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final mobileController = TextEditingController();
  final houseController = TextEditingController();
  final flatController = TextEditingController();
  final roadController = TextEditingController();
  final blockController = TextEditingController();
  final areaController = TextEditingController();
  final instructionController = TextEditingController();
  final noteController = TextEditingController();

  int _userId;
  bool _isLoader = false;
  OrderSendToServer tempOrderData;
  double textBoxWidth;

  @override
  void initState() {
    tempOrderData = widget.orderData;
    _setInitialValue();
    _loadUserId();
    super.initState();
  }

  _loadUserId() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    _userId = preferences.getInt('userid') ?? 0;
  }

  _setInitialValue() {
    if (widget.localProfile == null) {
      debugPrint("profile null, userid=${widget.userId}");
      nameController.text = "";
      mobileController.text = widget.mobile;
      houseController.text = "";
      flatController.text = "";
      roadController.text = "";
      blockController.text = "";
      areaController.text = "";
      instructionController.text = "";
    } else {
      debugPrint("profile exist, name =${widget.localProfile.name}");
      nameController.text = widget.localProfile.name;
      mobileController.text = widget.localProfile.mobile;
      houseController.text = widget.localProfile.house;
      flatController.text = widget.localProfile.flat;
      roadController.text = widget.localProfile.road;
      blockController.text = widget.localProfile.block;
      areaController.text = widget.localProfile.area;
      instructionController.text = widget.localProfile.note;
    }
  }

  @override
  Widget build(BuildContext context) {
    textBoxWidth = MediaQuery.of(context).size.width - 50;
    return Scaffold(
      appBar: _isLoader
          ? AppBar(
              title: Text("Placing order ..."),
            )
          : AppBar(
              title: Text('CheckOut'),
            ),
      body: _isLoader
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('Please wait..'),
                  CircularProgressIndicator(),
                ],
              ),
            )
          : GestureDetector(
        onTap: (){
          //Dismiss keyboard
          FocusScope.of(context).unfocus();
        },
            child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                child: ListView(
                  children: <Widget>[
                    // ===== Delivery note row ======== //
                    Center(
                      child: Text(
                        'Your mobile ${widget.mobile == null ? widget.localProfile.mobile : widget.mobile} is verified',
                        style: TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.normal,
                            color: Colors.black),
                      ),
                    ),
                    Center(
                      child: Text(
                        'Total Bill: ${widget.orderData.totalPrice} tk',
                        style: TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                            color: appThemeColor),
                      ),
                    ),
                    SizedBox(height: 7.0),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          Center(
                            child: Text(
                              'Delivery Note ',
                              style: TextStyle(
                                  fontSize: 15.0, fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(height: 7.0),
                          Container(
                            height: 60.0,
                            decoration: BoxDecoration(
                              color: Colors.lightGreen[100],
                              border: Border.all(color: Colors.green[900]),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                            ),
                            width: MediaQuery.of(context).size.width,

                            //height: 40.0,
                            child: TextFormField(
                                //enabled: _isTextFieldEnable,
                                autofocus: false,
                                minLines: 3,
                                maxLines: 5,
                                controller: noteController,
                                decoration: InputDecoration(
                                  hintText:
                                      'i.e pls call before delivery, pls delivery after 2 pm',
                                  hintStyle: TextStyle(fontSize: 12.0),
                                  border: OutlineInputBorder(),
                                ),
                                onSaved: (val) =>
                                    tempOrderData.deliveryNote = val),
                          ),
                          SizedBox(height: 7.0),
                          Center(
                            child: Text(
                              'Delivery Adress ',
                              style: TextStyle(
                                  fontSize: 15.0, fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(height: 7.0),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: 520.0,
                            decoration: BoxDecoration(
                              color: Colors.lightGreen[100],
                              border: Border.all(color: Colors.green[900]),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                            ),
                            child: Column(
                              //mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                // ==== Name row ===== ///
                                SizedBox(height: 10.0),
                                SizedBox(
                                  width: textBoxWidth,
                                  height: 60.0,
                                  child: TextFormField(
                                    controller: nameController,
                                    decoration: InputDecoration(
                                      labelText: 'Your name',
                                      border: OutlineInputBorder(),
                                    ),
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return 'Please enter your name.';
                                      }
                                      return null;
                                    },
                                    onSaved: (val) => tempOrderData.name = val,
                                  ),
                                ),
                                SizedBox(height: 10.0),

                                // ==== Mobile row ===== ///

                                /*SizedBox(
                                  width: textBoxWidth,
                                  height: 60.0,
                                  child: TextFormField(
                                    //enabled:_verifiedMobile ? false : _isTextFieldEnable,
                                    controller: mobileController,
                                    keyboardType: TextInputType.number,
                                    maxLength: 11,
                                    enabled: false,
                                    decoration: InputDecoration(
                                      labelText: 'Your Mobile',
                                      border: OutlineInputBorder(),
                                    ),
                                    validator: (value) {
                                      if (value.isEmpty || value.length < 11) {
                                        return 'Please enter valid mobile no.';
                                      }
                                      return null;
                                    },
                                    onSaved: (val) => tempOrderData.mobile = val,
                                  ),
                                ),
                                SizedBox(height: 10.0),*/

                                // ===== house row ======== //

                                SizedBox(
                                  width: textBoxWidth,
                                  height: 40.0,
                                  child: TextFormField(
                                    //enabled: _isTextFieldEnable,
                                    controller: houseController,
                                    autofocus: false,
                                    decoration: InputDecoration(
                                      labelText: 'house no.',
                                      border: OutlineInputBorder(),
                                    ),
                                    onSaved: (val) => tempOrderData.house = val,
                                  ),
                                ),
                                SizedBox(height: 10.0),

                                // ===== flat row ======== //

                                SizedBox(
                                  width: textBoxWidth,
                                  height: 40.0,
                                  child: TextFormField(
                                    //enabled: _isTextFieldEnable,
                                    autofocus: false,
                                    controller: flatController,
                                    decoration: InputDecoration(
                                      labelText: 'flat/apt',
                                      border: OutlineInputBorder(),
                                    ),
                                    onSaved: (val) => tempOrderData.flat = val,
                                  ),
                                ),
                                SizedBox(height: 10.0),

                                // ===== Road row ======== //

                                SizedBox(
                                  width: textBoxWidth,
                                  height: 40.0,
                                  child: TextFormField(
                                    //enabled: _isTextFieldEnable,
                                    controller: roadController,
                                    autofocus: false,
                                    decoration: InputDecoration(
                                      labelText: 'road',
                                      border: OutlineInputBorder(),
                                    ),
                                    onSaved: (val) => tempOrderData.road = val,
                                  ),
                                ),
                                SizedBox(height: 10.0),

                                // ===== Block/Sector row ======== //

                                SizedBox(
                                  width: textBoxWidth,
                                  height: 40.0,
                                  child: TextFormField(
                                    //enabled: _isTextFieldEnable,
                                    autofocus: false,
                                    controller: blockController,
                                    decoration: InputDecoration(
                                      labelText: 'block/sector',
                                      border: OutlineInputBorder(),
                                    ),
                                    onSaved: (val) => tempOrderData.block = val,
                                  ),
                                ),
                                SizedBox(height: 10.0),

                                // ===== Area row ======== //

                                SizedBox(
                                  width: textBoxWidth,
                                  height: 40.0,
                                  child: TextFormField(
                                    //enabled: _isTextFieldEnable,
                                    autofocus: false,
                                    controller: areaController,
                                    decoration: InputDecoration(
                                      labelText: 'area',
                                      border: OutlineInputBorder(),
                                    ),
                                    onSaved: (val) => tempOrderData.area = val,
                                  ),
                                ),
                                SizedBox(height: 10.0),

                                // ===== Instruction row ======== //

                                SizedBox(
                                  width: textBoxWidth,
                                  //height: 40.0,
                                  child: TextFormField(
                                    //enabled: _isTextFieldEnable,
                                    autofocus: false,
                                    minLines: 3,
                                    maxLines: 5,
                                    controller: instructionController,
                                    decoration: InputDecoration(
                                      hintText:
                                          'Instructions to easily find your address',
                                      hintStyle: TextStyle(fontSize: 12.0),
                                      border: OutlineInputBorder(),
                                    ),
                                    onSaved: (val) =>
                                        tempOrderData.instruction = val,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // ======= place order now button ========= //
                        ],
                      ),
                    ),
                  ],
                ),
              ),
          ),
      bottomNavigationBar: _orderNowButton(),
    );
  }

  Widget _orderNowButton() {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 20.0),
      child: Container(
        height: 40.0,
        margin: EdgeInsets.only(top: 20.0),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            border: Border.all(),
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(30.0)),
        child: InkWell(
          onTap: () {
            final form = _formKey.currentState;
            if (form.validate()) {
              form.save();
              var mobile;
              tempOrderData.userId = _userId;
              widget.mobile != null ? mobile = widget.mobile : mobile = widget.localProfile.mobile;
              tempOrderData.mobile = mobile;
              debugPrint('userID=${_userId}');
              setState(() {
                _isLoader = true;
              });

              //var serverdata = jsonEncode(tempOrderData);
              _postRequest(tempOrderData);
            }
          },
          child: Center(
            child: Text(
              'Order Now',
              style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  _postRequest(var tempData) async {
    //var url ='https://pae.ipportalegre.pt/testes2/wsjson/api/app/ws-authenticate';
    //var url = "http://tazafol.com/app-api/save_order.php";
    var url = baseUrl + "save_order.php";
    var body = jsonEncode(tempData);

    //print("Body: " + body);

    var response = await http.post(url,
        headers: {"Content-Type": "application/json"}, body: body);
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      ProfileResponse serverData = ProfileResponse.fromJson(jsonResponse);
      //SharedPreferences preferences = await SharedPreferences.getInstance();
      //preferences.setInt('userid', serverData.userId);
      setState(() {
        _isLoader = false;
      });

      _showDialog(serverData.msg);
    }
    //print("${response.statusCode}");
    //print("${response.body}");

    /*http.post(url,
      headers: {"Content-Type": "application/json"},
      body: body
  ).then((http.Response response) {
    print("Response status: ${response.statusCode}");
    print("Response body: ${response.contentLength}");
    print(response.headers);
    print(response.request);

  });*/
  }

  void _showDialog(String msg) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(msg),
            content: Text('You will redirect to home page'),
            actions: <Widget>[
              MaterialButton(
                color: Theme.of(context).primaryColor,
                textColor: Colors.white,
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => HomePage()));
                },
                child: Text('OK'),
              )
            ],
          );
        });
  }
}
