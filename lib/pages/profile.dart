import 'package:flutter/material.dart';
import 'package:tazafol/components/color.dart';
import 'package:tazafol/components/url.dart';
import 'package:tazafol/main.dart';
import 'package:tazafol/models/dataModel.dart';
import 'package:tazafol/models/userModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'userValidation.dart';

class ProfilePage extends StatefulWidget {
  final Profile profile;
  final GlobalKey globalKeyBottomNavController;

  ProfilePage({this.profile, this.globalKeyBottomNavController});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final nameController = TextEditingController();
  final mobileController = TextEditingController();
  final houseController = TextEditingController();
  final flatController = TextEditingController();
  final roadController = TextEditingController();
  final blockController = TextEditingController();
  final areaController = TextEditingController();
  final instructionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _user = User();
  int _isVerified = 0;
  bool _verifiedMobile = false;
  bool _isTextFieldEnable;
  bool _isEditButtonVisible;
  bool _isShowBottomNavigation = true;
  bool _isLoader = false;
  int _userId;
  double textBoxWidth;


  @override
  void dispose() {
    nameController.dispose();
    mobileController.dispose();
    houseController.dispose();
    flatController.dispose();
    roadController.dispose();
    blockController.dispose();
    areaController.dispose();
    instructionController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _loadUserId();


    if (widget.profile != null) {
      _isTextFieldEnable = false;
      _isEditButtonVisible = true;
      nameController.text = widget.profile.name;
      mobileController.text = widget.profile.mobile;
      houseController.text = widget.profile.house;
      flatController.text = widget.profile.flat;
      roadController.text = widget.profile.road;
      blockController.text = widget.profile.block;
      areaController.text = widget.profile.area;
      instructionController.text = widget.profile.note;
      _isVerified = widget.profile.isVerified;
      if (_isVerified == 1) {
        _verifiedMobile = true;
      } else if (_isVerified == 0) _verifiedMobile = false;
    } else {
      _isTextFieldEnable = false;
      _isEditButtonVisible = false;
      _isShowBottomNavigation = false;
    }

    super.initState();
  }

  _loadUserId() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    _userId = preferences.getInt('userid') ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    textBoxWidth = MediaQuery.of(context).size.width - 50;
    return _isLoader
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('Please wait..'),
                CircularProgressIndicator(),
              ],
            ),
          )
        : WillPopScope(
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
              body: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20.0, 10, 10.0, 20.0),
                  child: ListView(
                    children: <Widget>[
                      Visibility(
                        visible: !_isShowBottomNavigation,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(5.0, 100.0, 5.0, 10.0),
                          child: Column(
                            children: <Widget>[
                              Text('Login / Signup to Add/Edit Profile Info',
                                style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 20.0,
                              ),
                              RaisedButton(
                                color: appThemeColor,
                                child: Text('Login / Signup',
                                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),),
                                  onPressed: (){
                                    Navigator.of(context).push(MaterialPageRoute(
                                        builder: (context) => UserValidation(
                                          orderData: null,
                                          rootPage: 'profile',
                                        )));
                                  }
                              )
                            ],

                          ),
                        ),
                      ),
                      // ====== Personal information section  ==========///
                      Visibility(
                        visible: _isShowBottomNavigation,
                        child: GestureDetector(
                          onTap: (){
                            //Dismiss keyboard
                            FocusScope.of(context).unfocus();
                          },
                          child: Container(
                            //width: 360.0,
                            height: 190.0,
                            decoration: BoxDecoration(
                              color: _isTextFieldEnable
                                  ? offerPageBackgroundColor
                                  : Colors.grey[400],
                              border: _isTextFieldEnable
                                  ? Border.all(color: Colors.green[900])
                                  : Border.all(color: Colors.grey[800]),
                              borderRadius: BorderRadius.all(Radius.circular(10.0)),
                            ),
                            child: Column(
                              children: <Widget>[
                                SizedBox(height: 10.0),
                                // === first row ==== //
                                Text(
                                  'Personal Information',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: offerPageTitleColor),
                                ),
                                SizedBox(height: 10.0),

                                // ==== second row ===== ///
                                SizedBox(
                                  width: textBoxWidth,
                                  height: 60.0,
                                  child: TextFormField(
                                    enabled: _isTextFieldEnable,
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
                                    onSaved: (val) =>
                                        setState(() => _user.name = val),
                                  ),
                                ),
                                SizedBox(height: 10.0),

                                // ==== third row ===== ///
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10.0),
                                      child: SizedBox(
                                        width: textBoxWidth - 50,
                                        height: 60.0,
                                        child: TextFormField(
                                          enabled: _verifiedMobile
                                              ? false
                                              : _isTextFieldEnable,
                                          controller: mobileController,
                                          keyboardType: TextInputType.number,
                                          maxLength: 11,
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
                                          onSaved: (val) =>
                                              setState(() => _user.mobile = val),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(7.0, 5.0, 0.0, 0.0),
                                      child: Icon(
                                        Icons.verified_user,
                                        color: appThemeColor,
                                        size: 30,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      SizedBox(
                        height: 20.0,
                      ),
                      // ====== Delivery address section  ==========///
                      Visibility(
                        visible: _isShowBottomNavigation,
                        child: GestureDetector(
                          onTap: (){
                            //Dismiss keyboard
                            FocusScope.of(context).unfocus();
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: _isTextFieldEnable
                                  ? offerPageBackgroundColor
                                  : Colors.grey[400],
                              border: _isTextFieldEnable
                                  ? Border.all(color: Colors.green[900])
                                  : Border.all(color: Colors.grey[800]),
                              borderRadius: BorderRadius.all(Radius.circular(10.0)),
                            ),
                            child: Column(
                              children: <Widget>[
                                // ==== first row ===== //
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Padding(
                                        padding: const EdgeInsets.only(top: 10.0),
                                        child: Text(
                                          'Delivery Address',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: offerPageTitleColor),
                                        )),
                                  ],
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                // ===== house/flat row ======== //
                                SizedBox(
                                  width: textBoxWidth,
                                  height: 40.0,
                                  child: TextFormField(
                                    enabled: _isTextFieldEnable,
                                    controller: houseController,
                                    decoration: InputDecoration(
                                      labelText: 'house no.',
                                      border: OutlineInputBorder(),
                                    ),
                                    onSaved: (val) =>
                                        setState(() => _user.house = val),
                                  ),
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),

                                SizedBox(
                                  width: textBoxWidth,
                                  height: 40.0,
                                  child: TextFormField(
                                    enabled: _isTextFieldEnable,
                                    controller: flatController,
                                    decoration: InputDecoration(
                                      labelText: 'flat/apt',
                                      border: OutlineInputBorder(),
                                    ),
                                    onSaved: (val) =>
                                        setState(() => _user.flat = val),
                                  ),
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),

                                // ===== Road row ======== //
                                SizedBox(
                                  width: textBoxWidth,
                                  height: 40.0,
                                  child: TextFormField(
                                    enabled: _isTextFieldEnable,
                                    controller: roadController,
                                    decoration: InputDecoration(
                                      labelText: 'road',
                                      border: OutlineInputBorder(),
                                    ),
                                    onSaved: (val) =>
                                        setState(() => _user.road = val),
                                  ),
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),

                                // ===== Block/Sector row ======== //
                                SizedBox(
                                  width: textBoxWidth,
                                  height: 40.0,
                                  child: TextFormField(
                                    enabled: _isTextFieldEnable,
                                    controller: blockController,
                                    decoration: InputDecoration(
                                      labelText: 'block/sector',
                                      border: OutlineInputBorder(),
                                    ),
                                    onSaved: (val) =>
                                        setState(() => _user.block = val),
                                  ),
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),

                                // ===== Area row ======== //
                                SizedBox(
                                  width: textBoxWidth,
                                  height: 40.0,
                                  child: TextFormField(
                                    enabled: _isTextFieldEnable,
                                    controller: areaController,
                                    decoration: InputDecoration(
                                      labelText: 'area',
                                      border: OutlineInputBorder(),
                                    ),
                                    onSaved: (val) =>
                                        setState(() => _user.area = val),
                                  ),
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),

                                // ===== Instruction row ======== //
                                SizedBox(
                                  width: textBoxWidth,
                                  //height: 40.0,
                                  child: TextFormField(
                                    enabled: _isTextFieldEnable,
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
                                        setState(() => _user.instruction = val),
                                  ),
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      // === Delivery address section End ========= //
                    ],
                  ),
                ),
              ),
              bottomNavigationBar: _isShowBottomNavigation ? _builBottomNavigation() : null,
            ),
        );
  }

  Widget _builBottomNavigation() {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 3.0),
      child: Container(
        height: 40.0,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            border: Border.all(),
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(30.0)),
        child: Column(
          children: <Widget>[
            Visibility(
              visible: !_isEditButtonVisible,
              child: InkWell(
                onTap: () {
                  debugPrint('hello');
                  final form = _formKey.currentState;
                  if (form.validate()) {
                    form.save();
                    //_user.save(_userId.toString());
                    _save(_userId.toString());
                    setState(() {
                      _isLoader = true;
                      _isEditButtonVisible = true;
                      _isTextFieldEnable = false;
                    });
                  }
                },
                child: Container(
                  height: 38.0,
                  child: Center(
                    child: Text(
                      'SAVE',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16.0),
                    ),
                  ),
                ),
              ),
            ),
            Visibility(
              visible: _isEditButtonVisible,
              child: InkWell(
                onTap: () {
                  setState(() {
                    _isTextFieldEnable = true;
                    _isEditButtonVisible = false;
                  });
                  _loadUserId();
                },
                child: Container(
                  //color: Colors.red,
                  height: 38.0,
                  child: Center(
                    child: Text(
                      'EDIT',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16.0),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _save(String userId) async {
    //var url = "http://tazafol.com/app-api/save_user.php";
    debugPrint('userId=${userId}');
    var url = baseUrl + "save_user.php";
    var response = await http.post(url, body: {
      "userid": userId,
      "name": _user.name,
      "mobile": _user.mobile,
      "house": _user.house,
      "flat": _user.flat,
      "road": _user.road,
      "block": _user.block,
      "area": _user.area,
      "instruction": _user.instruction
    });
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      ProfileResponse serverData = ProfileResponse.fromJson(jsonResponse);
      SharedPreferences preferences = await SharedPreferences.getInstance();
      preferences.setInt('userid', serverData.userId);
      _showDialog();
      setState(() {
        _isLoader = false;
      });
    } else {}
  }

  void _showDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Center(
                child: Text(
              "Success",
            )),
            content: Text("Profile update success"),
            actions: <Widget>[
              MaterialButton(
                //color: Colors.green[900],
                textColor: Colors.green[900],
                onPressed: () {
                  //Navigator.of(context).pop();
                  //Navigator.popUntil(context, ModalRoute.withName("/Home"));
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => HomePage()));
                  /*Navigator.of(context).push(
                      MaterialPageRoute(
                        settings: RouteSettings(name : "/Home"),
                        builder: (context) => HomePage(),
                        ));*/

                  //final BottomNavigationBar navigationBar = widget.globalKeyBottomNavController.currentWidget;
                  //navigationBar.onTap(0);
                },
                child: Text('OK'),
              )
            ],
          );
        });
  }
}
