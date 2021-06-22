import 'package:flutter/material.dart';
import 'package:tazafol/components/color.dart';
import 'package:tazafol/components/url.dart';
import 'package:tazafol/models/dataModel.dart';
import 'package:toggle_switch/toggle_switch.dart';

class OfferPage extends StatefulWidget {
  final List<Notifikation> notifications;
  final List<OfferList> offers;

  OfferPage({Key key, this.notifications, this.offers}) : super(key: key);

  @override
  _OfferPageState createState() => _OfferPageState();
}

class _OfferPageState extends State<OfferPage> {
  var _visibleController = 0;
  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Center(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 5.0),
            child: ToggleSwitch(
              minWidth: MediaQuery.of(context).size.width,
              initialLabelIndex: _visibleController,
              cornerRadius: 10.0,
              activeFgColor: Colors.white,
              inactiveBgColor: tabBarBackgroundColor,
              inactiveFgColor: Colors.black45,
              labels: ['OFFER', 'NOTIFICATION'],
              icons: [Icons.local_offer, Icons.notifications],
              activeBgColors: [appThemeColor, appThemeColor],
              onToggle: (index) {
                print('switched to: $index');
                setState(() {
                  _visibleController = index;
                });

                //_visibleController = index;
//                  setState(() {
//                    _visibleController = index;
//                  });
              },
            ),
          ),
        ),
        _visibleController == 0
            ? widget.offers.length >0 ? Expanded(
                child: Scrollbar(
                  child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: widget.offers.length,
                      controller: _scrollController,
                      itemBuilder: (BuildContext _, int index) {
                        var tempTitle = widget.offers[index].title;
                        var tempDescription = widget.offers[index].description;
                        if(tempTitle.length > 50){
                          tempTitle = tempTitle.substring(0,50);
                        }
                        if(tempDescription.length > 180){
                          tempDescription = tempDescription.substring(0,180);
                        }
                        return SingleOffer(
                          offerId: widget.offers[index].offerId,
                          title: tempTitle,
                          description: tempDescription,
                          image: widget.offers[index].image,
                          productId: widget.offers[index].productId,
                          categoryId: widget.offers[index].categoryId,
                          offerStart: widget.offers[index].offerStart,
                          offerEnd: widget.offers[index].offerEnd,
                          amount: widget.offers[index].amount,
                          isPercentage: widget.offers[index].isPercentage,
                        );
                      }),
                ),
              ) : Padding(padding: const EdgeInsets.fromLTRB(10.0, 200.0, 10.0, 0.0),
          child: Text('There is no offer right now!', style: TextStyle(color: appThemeColor, fontSize: 16.0, fontWeight: FontWeight.bold),),)
            : widget.notifications.length > 0 ? Expanded(
                child: Scrollbar(
                  child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: widget.notifications.length,
                      itemBuilder: (BuildContext _, int index) {
                        var tempTitle1 = widget.notifications[index].title;
                        var tempDescription1 = widget.notifications[index].description;
                        if(tempTitle1.length > 50){
                          tempTitle1 = tempTitle1.substring(0,50);
                        }
                        if(tempDescription1.length > 180){
                          tempDescription1 = tempDescription1.substring(0,180);
                        }
                        return SingleNotification(
                          notificationId: widget.notifications[index].notificationId,
                          title: tempTitle1,
                          description: tempDescription1,
                          image: widget.notifications[index].image,
                          publishDate: widget.notifications[index].publishDate,
                        );
                      }),
                ),
              ) : Padding(padding: const EdgeInsets.fromLTRB(10.0, 200.0, 10.0, 0.0),
          child: Text('There is no Notification right now!', style: TextStyle(color: appThemeColor, fontSize: 16.0, fontWeight: FontWeight.bold),),)
      ],
    );
  }
}

class SingleOffer extends StatelessWidget {
  final offerId;
  final title;
  final description;
  final image;
  final productId;
  final categoryId;
  final offerStart;
  final offerEnd;
  final amount;
  final isPercentage;

  SingleOffer(
      {this.offerId,
      this.title,
      this.description,
      this.image,
      this.productId,
      this.categoryId,
      this.offerStart,
      this.offerEnd,
      this.amount,
      this.isPercentage});

  @override
  Widget build(BuildContext context) {
    var _containerWidth = MediaQuery.of(context).size.width * 0.95;
    var _containerHeight = image =="" ?120.0 : 320.0;
    return Padding(
      padding: const EdgeInsets.fromLTRB(5.0,3.0,5.0,3.0),
      child: Container(
        //color: Colors.indigo[100],
        width: _containerWidth,
        height: _containerHeight,
        decoration: BoxDecoration(
          color: offerPageBackgroundColor,
          border: Border.all(color: offerPageTitleColor),
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
        ),
        child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(5.0,5.0,5.0,2.5),
                  child: Text(
                      title,
                      style: TextStyle(color: offerPageTitleColor, fontWeight: FontWeight.bold, fontSize: 15.0,),
                    ),
                ),
                Padding(
                    padding: const EdgeInsets.fromLTRB(5.0,5.0,5.0,2.5),
                    child: Text(
                        description,
                      style: TextStyle(color: offerPageDescriptionColor),
                    )),
                Padding(
                    padding: const EdgeInsets.fromLTRB(5.0,5.0,5.0,2.5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Text("Offer Start :", style: TextStyle(fontWeight: FontWeight.bold,color: offerPageTitleColor),),
                        Text(offerStart, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),),
                        Text("End :", style: TextStyle(fontWeight: FontWeight.bold, color: offerPageTitleColor)),
                        Text(offerEnd, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),),
                      ],
                    )),
                Visibility(
                  visible: image !="",
                  child: Container(
                    width: _containerWidth,
                    height: 185.0,
                    //color: Colors.yellow,
                      child: FadeInImage.assetNetwork(
                        placeholder: 'images/image_loading.jpg',
                        image: "$baseUrl" + image,
                        //height: 100,
                        //width: _containerWidth,
                        fit: BoxFit.contain,
                      )

                  ),
                ),

              ],
            ),
        ),

    );
  }
}

class SingleNotification extends StatelessWidget {
  final notificationId;
  final title;
  final description;
  final image;
  final publishDate;

  SingleNotification(
      {this.notificationId,
      this.title,
      this.description,
      this.image,
      this.publishDate});

  @override
  Widget build(BuildContext context) {
    var _containerWidth = MediaQuery.of(context).size.width * 0.95;
    var _containerHeight = image =="" ?120.0 : 320.0;
    return Padding(
      padding: const EdgeInsets.fromLTRB(5.0,3.0,5.0,3.0),
      child: Container(
        //color: Colors.indigo[100],
        width: _containerWidth,
        height: _containerHeight,
        decoration: BoxDecoration(
          color: offerPageBackgroundColor,
          border: Border.all(color: offerPageTitleColor),
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(5.0,5.0,5.0,2.5),
              child: Text(
                title,
                style: TextStyle(color: offerPageTitleColor, fontWeight: FontWeight.bold, fontSize: 15.0,),
              ),
            ),
            Padding(
                padding: const EdgeInsets.fromLTRB(5.0,5.0,5.0,2.5),
                child: Text(
                  description,
                  style: TextStyle(color: offerPageDescriptionColor),
                )),
            Padding(
                padding: const EdgeInsets.fromLTRB(5.0,5.0,5.0,2.5),
                child: Row(
                  //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text("Published :", style: TextStyle(fontWeight: FontWeight.bold,color: offerPageTitleColor),),
                    Text(publishDate, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),),
                  ],
                )),
            Visibility(
              visible: image !="",
              child: Container(
                  width: _containerWidth,
                  height: 185.0,
                  //color: Colors.yellow,
                  child: FadeInImage.assetNetwork(
                    placeholder: 'images/image_loading.jpg',
                    image: "$baseUrl" + image,
                    //height: 100,
                    //width: _containerWidth,
                    fit: BoxFit.contain,
                  )

              ),
            ),

          ],
        ),
      ),

    );
  }
}
