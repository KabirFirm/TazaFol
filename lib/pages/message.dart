import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class MessagePage extends StatelessWidget {
  final os;
  MessagePage({Key key, this.os}) : super(key : key);

  String fbProtocolUrl;
  String fallbackUrl = "https://www.facebook.com/699823316867350";
  //launch("http://$messengerUrl")
  @override
  Widget build(BuildContext context) {
    os == 1 ? fbProtocolUrl = "fb://page/699823316867350" : fbProtocolUrl =  "fb://profile/699823316867350";
    return Container(
        child: Center(child: Text('This section is coming in next version')),
    );
  }

  _openFB() async {
    try {
      debugPrint('hello');
      bool launched = await launch(fbProtocolUrl, forceSafariVC: false);

      if (!launched) {
        debugPrint('hi');
        await launch(fallbackUrl, forceSafariVC: false);
      }
    } catch (e) {
      debugPrint('hi again');
      await launch(fallbackUrl, forceSafariVC: false);
    }
  }
}
