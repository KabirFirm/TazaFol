import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tazafol/components/color.dart';
import 'package:flutter_breadcrumb/flutter_breadcrumb.dart';
import 'package:tazafol/components/url.dart';

import '../models/userModel.dart';
import '../main.dart';
import '../models/dataModel.dart';

class OrderDetails extends StatefulWidget {
  final Order order;

  OrderDetails({this.order});
  @override
  _OrderDetailsState createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  int orderStatus;
  bool isCancelButtonVisible;
  String adminMessage;
  bool _isLoader = false;

  @override
  Widget build(BuildContext context) {
    //final width = MediaQuery.of(context).size.width;
    orderStatus = widget.order.orderStatus;
    isCancelButtonVisible = getVisibilityfromStatus(orderStatus);
    orderStatus = getStatus(orderStatus);
    adminMessage = widget.order.adminMessage ?? "";
    //adminMessage = "You will receive Saturday, 12 DEC 2020";
    return Scaffold(
        appBar: _isLoader
            ? AppBar(
                title: Text('Cancelling order...'),
              )
            : AppBar(
                title: Text('Order Id: ${widget.order.orderId}'),
              ),
        body: _isLoader
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Padding(
                padding: const EdgeInsets.fromLTRB(5, 5, 5, 0),
                child: Column(
                  children: <Widget>[
                    orderStatus < 41 ? BreadCrumb(
                      items: <BreadCrumbItem>[
                        BreadCrumbItem(
                          //disableColor: Colors.black12,
                          content: Column(
                            children: <Widget>[
                              orderStatus == 0 ? Icon(Icons.check_circle, color: breadCrumbActive) : Icon(Icons.check_circle_outline, color: breadCrumbActive),
                              orderStatus == 0 ? Text('Pending', style: TextStyle(color: breadCrumbActive, fontWeight: FontWeight.bold),) : Text('Pending', style: TextStyle(color: breadCrumbActive),)
                            ],
                          ),

                        ),
                        BreadCrumbItem(content: Column(
                          children: <Widget>[
                            orderStatus < 1 ? Icon(Icons.check_circle_outline, color: breadCrumbInActive) : (orderStatus == 1 ? Icon(Icons.check_circle, color: breadCrumbActive) : Icon(Icons.check_circle_outline, color: breadCrumbActive)),
                            orderStatus < 1 ? Text('Processing', style: TextStyle(color: breadCrumbInActive)) : (orderStatus == 1 ? Text('Processing', style: TextStyle(color: breadCrumbActive, fontWeight: FontWeight.bold)) : Text('Processing', style: TextStyle(color: breadCrumbActive)))
                          ],
                        )),
                        BreadCrumbItem(content: Column(
                          children: <Widget>[
                            orderStatus < 2 ? Icon(Icons.check_circle_outline, color: breadCrumbInActive) : (orderStatus == 2 ? Icon(Icons.check_circle, color: breadCrumbActive) : Icon(Icons.check_circle_outline, color: breadCrumbActive)),
                            orderStatus < 2 ? Text('Shipping', style: TextStyle(color: breadCrumbInActive)) : (orderStatus == 2 ? Text('Shipping', style: TextStyle(color: breadCrumbActive, fontWeight: FontWeight.bold)) : Text('Shipping', style: TextStyle(color: breadCrumbActive)))
                          ],
                        )),
                        BreadCrumbItem(content: Column(
                          children: <Widget>[
                            orderStatus < 3 ? Icon(Icons.check_circle_outline, color: breadCrumbInActive) : (orderStatus == 3 ? Icon(Icons.check_circle, color: breadCrumbActive) : Icon(Icons.check_circle_outline, color: breadCrumbActive)),
                            orderStatus < 3 ? Text('Delivered', style: TextStyle(color: breadCrumbInActive)) : (orderStatus == 3 ? Text('Delivered', style: TextStyle(color: breadCrumbActive, fontWeight: FontWeight.bold)) : Text('Delivered', style: TextStyle(color: breadCrumbActive)))
                          ],
                        )),
                      ],
                      divider: Icon(Icons.chevron_right),
                    ) : (orderStatus == 41 ? Text('You cancelled this order', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),) : Text('TazaFol cancelled this order', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),)),
                    /*Text(
                      'Order Status: ${getStatus(orderStatus)}',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 15.0),
                    ),*/
                    SizedBox(height: 7.0),
                    Container(
                        color: Colors.yellow,
                        child: Text(
                          '$adminMessage',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                    SizedBox(height: 10.0),
                    //Add/Edit products section
                    /*Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Visibility(
                          visible: isCancelButtonVisible,
                          child: InkWell(
                            onTap: (){
                              debugPrint('Add/Edit products');
                              Navigator.pushReplacement(context,
                                  MaterialPageRoute(builder: (context) => HomePage()));
                            },
                            child: Text(
                              'Add/Edit Products',
                              style: TextStyle(
                                fontSize: 14.0,
                                  color: appThemeColor,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline),
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 6.0),*/
                    Padding(
                      padding: const EdgeInsets.only(left: 5.0),
                      child: Row(
                        children: <Widget>[
                          Expanded(flex: 4, child: Text('Product')),
                          Expanded(flex: 4, child: Text('(Unit Pr.) X Qty')),
                          Expanded(flex: 2, child: Text('Price')),
                          Expanded(flex: 3, child: Text('Delivered?')),
                        ],
                      ),
                    ),
                    Divider(color: Colors.black),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.38,
                      color: Colors.grey[200],
                      child: ListView.builder(
                          itemCount: widget.order.productList.length,
                          itemBuilder: (BuildContext context, int index) {
                            int _intDelivered = widget.order.productList[index].isDelivered;
                            bool _isDelivered = false;
                            if(_intDelivered == 0){
                              _isDelivered = false;
                            }else{
                              _isDelivered = true;
                            }
                            String deliveryStatus = getDeliveryStatus(
                                widget.order.productList[index].isDelivered);
                            return Padding(
                              padding: const EdgeInsets.only(left: 5.0),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                      flex: 4,
                                      child: Text(
                                          '${widget.order.productList[index].nameBn}', style: TextStyle(decoration: _isDelivered ? TextDecoration.lineThrough: TextDecoration.none),
                                      )),
                                  Expanded(
                                      flex: 4,
                                      child: Text(
                                          '(${widget.order.productList[index].price} tk/${widget.order.productList[index].unit}) X ${widget.order.productList[index].quantity}', style: TextStyle(decoration: _isDelivered ? TextDecoration.lineThrough: TextDecoration.none))),
                                  Expanded(
                                      flex: 2,
                                      child: Text(
                                          '${widget.order.productList[index].price * widget.order.productList[index].quantity} tk', style: TextStyle(color:appThemeColor,decoration: _isDelivered ? TextDecoration.lineThrough: TextDecoration.none))),
                                  Expanded(
                                      flex: 1,
                                      child: Text(
                                        deliveryStatus,
                                        style: TextStyle(
                                            color: getDeliveryColor(widget.order
                                                .productList[index].isDelivered)),
                                      )),
                                ],
                              ),
                            );
                          }),
                    ),
                    Divider(color: Colors.black),
                    Padding(
                      padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text('Sub Total'),
                          Text('${widget.order.productPrice} tk')
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text('Discount', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green),),
                          Text('- ${widget.order.discount} tk', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green),)
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text('Delivery Charge'),
                          Text('${widget.order.deliveryCharge} tk')
                        ],
                      ),
                    ),
                    Divider(color: Colors.black),
                    Padding(
                      padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text('Total Payable', style: TextStyle(fontWeight: FontWeight.bold, color: appThemeColor),),
                          Text('${widget.order.payablePrice} tk',style: TextStyle(fontWeight: FontWeight.bold, color: appThemeColor),)
                        ],
                      ),
                    ),
                    Visibility(
                      visible: (widget.order.orderStatus == 21 || widget.order.orderStatus == 22),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 7.0, right: 7.0),
                        child: widget.order.due != 0 ? Text('DUE: ${widget.order.due} tk', style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold, color: Colors.red),)
                        : Text('Paid', style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: appThemeColor),)
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(left: 7.0, right: 7.0, top: 10.0),
                      child: Text('TazaFol Personal bKash: 01717 413031', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),),
                    ),
                    Visibility(
                      visible: isCancelButtonVisible,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
                        child: Container(
                          width: MediaQuery.of(context).size.width - 10,
                          decoration: BoxDecoration(
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(20),
                            color: cancelButtonColor,
                          ),
                          child: MaterialButton(
                            onPressed: () {
                              _showDialog(
                                  'Alert!',
                                  'Are you sure want to  cancel this order?',
                                  widget.order.orderId);
                            },
                            child: Text(
                              'Cancel Order',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ));
  }

  String getDeliveryStatus(int value) {
    switch (value) {
      case 0:
        return 'NO';
        break;
      case 1:
        return 'YES';
        break;
      default:
        return 'NO';
        break;
    }
  }

  Color getDeliveryColor(int value) {
    switch (value) {
      case 0:
        return Colors.redAccent[700];
        break;
      case 1:
        return appThemeColor;
        break;
      default:
        return Colors.redAccent[700];
        break;
    }
  }

  bool getVisibilityfromStatus(int status) {
    switch (status) {
      case 0:
        return true;
      case 11:
        return true;
      case 12:
        return false;
      default:
        return false;
        break;
    }
  }

  int getStatus(int status) {
    switch (status) {
      case 0:
        //return 'Pending';
        return 0;
      case 11:
        //return 'Processing';
        return 1;
      case 12:
        //return 'Shipping';
        return 2;
      case 41:
        //return 'Cancelled by User';
        return 41;
      case 42:
        //return 'Cancelled by Admin';
        return 42;
      case 21:
        //return 'Partially Delivered';
        return 31;
      case 22:
        //return 'Delivered';
        return 3;
      default:
        return 3;
        break;
    }
  }

  void _showDialog(String title, String msg, int orderId) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Center(
                child: Text(
              title,
              style: TextStyle(color: Colors.red),
            )),
            content: Text(msg),
            actions: <Widget>[
              MaterialButton(
                //color: Colors.redAccent,
                textColor: Colors.redAccent,
                onPressed: () {
                  Navigator.of(context).pop();
                  debugPrint('orderId=$orderId');
                  setState(() {
                    _isLoader = true;
                  });
                  _cancelOrder(orderId);
                },
                child: Text('Yes'),
              ),
              MaterialButton(
                //color: Colors.green[900],
                textColor: Colors.green[900],
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('No'),
              )
            ],
          );
        });
  }

  void _cancelOrder(int orderId) async {
    //var url = "http://tazafol.com/app-api/cancel_order.php";
    var url = baseUrl + "cancel_order.php";
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var userId = preferences.getInt('userid').toString();
    var response = await http
        .post(url, body: {"userid": userId, "orderid": orderId.toString()});
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      ProfileResponse serverData = ProfileResponse.fromJson(jsonResponse);
      Navigator.of(context).pop();
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomePage()));
      setState(() {
        _isLoader = false;
      });
    } else {}
  }
}
