import 'package:flutter/material.dart';
import 'package:tazafol/components/color.dart';
import 'package:tazafol/components/url.dart';
//import 'package:pg_1jan20/pages/cart.dart';
import 'package:tazafol/models/dataModel.dart';

class ProductDetails extends StatefulWidget {
  final Product product;
  ProductDetails({Key key, this.product}) : super(key: key);
  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  /*Widget imageCarousel = Container(
    height: 200.0,
    color: appThemeColor,
    child: Carousel(
      boxFit: BoxFit.cover,
      images: [
        AssetImage('images/c1.jpg'),
        AssetImage('images/m1.jpeg'),
        AssetImage('images/m2.jpg'),
        AssetImage('images/w1.jpeg'),
        AssetImage('images/w3.jpeg'),
      ],
      autoplay: false,
      dotBgColor: appThemeColor,
      dotSize: 4.0,
      indicatorBgPadding: 4.0,
    ),
  );*/

  Widget imageSection = Container();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.product.nameBn}'),
        centerTitle: true,
        /*actions: <Widget>[
          IconButton(
            onPressed: () {
              //debugPrint("${widget.product.nameBn}");
              //Navigator.of(context).push(MaterialPageRoute(builder: (context) => Cart()));
            },
            icon: Icon(Icons.shopping_cart),
          ),
        ],*/
      ),
      body: ListView(
        children: <Widget>[
          //imageCarousel,
          Container(
            height: MediaQuery.of(context).size.height * 0.45,
            //MediaQuery.of(context).size.height / 3
            child: GridTile(
              child: Container(
                color: Colors.white,
                child: FadeInImage.assetNetwork(
                  placeholder: 'images/image_loading.jpg',
                  image: baseUrl + '${widget.product.image1}',
                  fit: BoxFit.contain,
                ),
                /*child: Image.network(
                  baseUrl + '${widget.product.image1}',
                  fit: BoxFit.cover,
                ),*/
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10.0, top: 10.0, right: 30.0),
            child: Container(
              child: Row(children: <Widget>[
                Text(
                  '${widget.product.nameBn}',
                  style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
                ),
                Spacer(),
                widget.product.salePrice != 0
                    ? Text(
                        '${widget.product.salePrice} tk/${widget.product.unit}',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: appThemeColor),
                      )
                    : Text(
                        '${widget.product.price} tk/${widget.product.unit}',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: appThemeColor),
                      ),
              ]),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.32,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.green[900]),
                color: Colors.lightGreen[100],
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
              ),
              child: Scrollbar(
                child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                  '${widget.product.descriptionBn}',
                  style: TextStyle(
                      color: Colors.black,
                  ),
                ),
                    )),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
