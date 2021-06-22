import 'dart:async';
import 'package:flutter/material.dart';
import 'package:data_connection_checker/data_connection_checker.dart';

class CheckInternet{

  StreamSubscription<DataConnectionStatus> listener;
  var internetStatus = "Unknown";
  var contentMessage = "Unknown";

  checkConnection(BuildContext context) async{
    listener = DataConnectionChecker().onStatusChange.listen((status) {
      switch (status){
        case DataConnectionStatus.connected:
          internetStatus = "Connected to the Internet";
          contentMessage = "Connected to the Internet";
          //_showDialog(InternetStatus,contentmessage,context);
          break;
        case DataConnectionStatus.disconnected:
          internetStatus = "No Internet Connection !!";
          contentMessage = "Please check your internet connection";
          _showDialog(internetStatus,contentMessage,context);
          break;
      }
    });
    return await DataConnectionChecker().connectionStatus;
  }

  void _showDialog(String title,String content ,BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: new Text(title, style: TextStyle(color: Colors.red), textAlign: TextAlign.center,),
              content: new Text(content),
              actions: <Widget>[
                new FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: new Text("Close"))
              ]
          );
        }
    );
  }


}



