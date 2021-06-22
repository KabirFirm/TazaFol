import 'package:flutter/material.dart';
import '../components/color.dart';
import '../models/dataModel.dart';
import '../pages/orderDetails.dart';

class OrderPage extends StatefulWidget {
  final List<Order> orderList;
  OrderPage({this.orderList});

  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  @override
  Widget build(BuildContext context) {
    return widget.orderList.length >0 ? ListView.builder(
      itemCount: widget.orderList.length,
      itemBuilder: (BuildContext context, int index) {
        return SingleOrder(
          singleOrderId: widget.orderList[index].orderId,
          singleOrderDate: widget.orderList[index].orderDate,
          singleOrderStatus: widget.orderList[index].orderStatus,
          singleTotalBill: widget.orderList[index].payablePrice,
          singleDue: widget.orderList[index].due,
          singleDeliveryDate: widget.orderList[index].deliveryDate,
          singleCustomerInstruction: widget.orderList[index].instruction,
          singleDeliveryCharge: widget.orderList[index].deliveryCharge,
          singleProductList: widget.orderList[index].productList,
          fullOrder: widget.orderList[index],
        );
      },
    ) : Center(child: Text('You have no order to show', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0, color: appThemeColor),),);
  }
}

class SingleOrder extends StatelessWidget {
  final singleOrderId;
  final singleOrderDate;
  final singleOrderStatus;
  final singleTotalBill;
  final singleDue;
  final singleDeliveryDate;
  final singleCustomerInstruction;
  final singleDeliveryCharge;
  final Order fullOrder;
  final List<OrderedProduct> singleProductList;
  //Color deliveredColor = Color(0xFF006400);

  SingleOrder({
    this.singleOrderId,
    this.singleOrderDate,
    this.singleOrderStatus,
    this.singleTotalBill,
    this.singleDue,
    this.singleDeliveryDate,
    this.singleCustomerInstruction,
    this.singleDeliveryCharge,
    this.fullOrder,
    this.singleProductList,
  });

  @override
  Widget build(BuildContext context) {
    var adminMessage = fullOrder.adminMessage ?? "";
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
      child: Card(
        elevation: 2.0,
        color: Colors.indigo[100],
        child: Hero(
          tag: singleOrderId,
          child: Material(
            child: InkWell(
              onTap: () {
                //SingleOrder temp = SingleOrder();
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => OrderDetails(order: fullOrder)));
              },
              child: ListTile(
                  isThreeLine: true,
                  //dense: true,
                  contentPadding: EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 0.0),
                  leading: Container(
                    height: 50.0,
                    width: 50.0,
                    color: getStatusColor(singleOrderStatus),
                    child: Center(
                      child: Text(
                        '$singleOrderDate',
                        style: TextStyle(color: Colors.white, fontSize: 13.0),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  title: Container(
                    //color: Colors.yellow,
                    child: Row(
                      children: <Widget>[
                        Text(
                          'Bill: $singleTotalBill tk',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: singleDue != 0 ? Text(
                            'DUE: $singleDue tk',
                            style: TextStyle(
                                color: Colors.red, fontWeight: FontWeight.bold),
                          )

                          : Text(
                            getStatus(singleOrderStatus),
                            style: TextStyle(
                                color: getStatusColor(singleOrderStatus), fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                  subtitle: Container(
                      //color: Colors.yellow[200],
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(_getProductString(singleProductList)),
                          Container(
                            color: Colors.yellow,
                            child: Text('$adminMessage', style: TextStyle( color: appThemeColor, fontWeight: FontWeight.bold),)),
                        ],
                      )),
                  trailing: Padding(
                    padding: const EdgeInsets.only(top: 0),
                    child: Icon(
                      Icons.keyboard_arrow_right,
                      size: 25.0,
                    ),
                  )),
            ),
          ),
        ),
      ),
    );
  }

  Color getStatusColor(int status) {
    switch (status) {
      case 0:
        return pendingColor;
      case 11:
        return processingColor;
      case 12:
        return shippingColor;
      case 41:
        return cancelColor;
      case 42:
        return cancelColor;
      case 21:
        return partiallyDeliveredColor;
      case 22:
        return deliveredColor;
      default:
        return deliveredColor;
        break;
    }
  }

  String getStatus(int status) {
    switch (status) {
      case 0:
        return 'Pending';
      case 11:
        return 'Processing';
      case 12:
        return 'Shipping';
      case 41:
        return 'Cancelled';
      case 42:
        return 'Cancelled';
      case 21:
        return 'Partially Delivered';
      case 22:
        return 'Delivered';
      default:
        return 'Delivered';
        break;
    }
  }

  String _getProductString(List<OrderedProduct> productList) {
    var tempString = "";
    for (var temp in productList) {
      tempString += temp.nameBn;
      tempString += ', ';
    }
    if (tempString.length > 35) {
      tempString = tempString.substring(0, 32);
      tempString += '...';
    }
    return tempString;
  }
}
