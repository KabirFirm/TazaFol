import 'package:flutter/material.dart';
import 'package:tazafol/components/color.dart';
import 'package:tazafol/components/url.dart';
import 'package:tazafol/models/cartProductModel.dart';
import 'package:tazafol/pages/checkout.dart';
import 'package:tazafol/models/dataModel.dart';
import 'package:tazafol/pages/userValidation.dart';

class Cart extends StatefulWidget {
  final List<CartProductModel> cartProducts;
  final int totalBill;
  final int userId;
  final int os;
  final String pushToken;
  final int deliveryCharge;
  final bool showBar;
  final Profile localProfile;
  final Offer localOffer;

  Cart(
      {Key key,
      this.cartProducts,
      this.totalBill,
      this.userId,
      this.os,
      this.pushToken,
      this.deliveryCharge,
      this.showBar,
      this.localProfile,
      this.localOffer})
      : super(key: key);

  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  int _totalBill;
  int _deliveryCharge;
  int _discount = 0;

  OrderSendToServer orderData = OrderSendToServer();
  bool _showBottomNavigationBar;

  @override
  void initState() {
    super.initState();
    _totalBill = widget.totalBill ?? 0;
    _calculateDiscount();
    _deliveryCharge = widget.deliveryCharge ?? 0;
    _showBottomNavigationBar = widget.showBar;
  }

  _calculateDiscount() {
    _discount = 0;
    for (int i = 0; i < widget.cartProducts.length; i++) {
      var tempProduct = widget.cartProducts[i];
      debugPrint('isDiscount = ${tempProduct.cartProductIsDiscount}');
      if(tempProduct.cartProductIsDiscount == 1){
        debugPrint('discount ace');
        int _productBill = 0;
        var tempDiscountAmount = tempProduct.cartProductAmount;
        if(tempProduct.cartProductIsPercentage == 1){
          _productBill += tempProduct.cartProductPrice * tempProduct.cartProductQty;
          _discount += (_productBill * tempDiscountAmount * 0.01).floor();
        }else{
          _discount += (tempProduct.cartProductQty * tempDiscountAmount).floor();
        }
      }
    }
    /*int isFirstInstall,
        isAllProduct,
        isCategory,
        categoryId,
        isSingleProduct,
        productId,
        amount = 0;
    //int isAllProduct = 0;
    if (widget.localOffer != null) {
      isFirstInstall = widget.localOffer.isFirstInstall;
      isAllProduct = widget.localOffer.isAllProduct;
      isCategory = widget.localOffer.isCategory;
      categoryId = widget.localOffer.categoryId;
      isSingleProduct = widget.localOffer.isSingleProduct;
      productId = widget.localOffer.productId;
      amount = widget.localOffer.amount;
    }
    //print('userId=${widget.userId}');

    if (isFirstInstall == 1 && widget.userId == 0) {
      _discount = (_totalBill * amount * 0.01).floor();
    } else if (isAllProduct == 1) {
      _discount = (_totalBill * amount * 0.01).floor();
    } else if (isCategory == 1) {
      int _discountBill = 0;
      for (int i = 0; i < widget.cartProducts.length; i++) {
        if (categoryId == widget.cartProducts[i].cartProductCategory) {
          _discountBill += widget.cartProducts[i].cartProductPrice *
              widget.cartProducts[i].cartProductQty;
        }
      }
      _discount = (_discountBill * amount * 0.01).floor();
    } else if (isSingleProduct == 1) {
      int _discountBill = 0;
      for (int i = 0; i < widget.cartProducts.length; i++) {
        if (productId == widget.cartProducts[i].cartProductId) {
          _discountBill += widget.cartProducts[i].cartProductPrice *
              widget.cartProducts[i].cartProductQty;
        }
      }
      _discount = (_discountBill * amount * 0.01).floor();
    } else {
      print('no offer ');
      _discount = 0;
    }*/
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context, widget.cartProducts);
              print('total price = $_totalBill');
            },
            icon: Icon(
              Icons.keyboard_arrow_left,
              size: 35.0,
            )),
        title: Text('Shopping Cart'),
        /*actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.call,
              color: Colors.white,
            ),
            onPressed: () {
              debugPrint('button tapped');
            },
          ),
        ],*/
      ),
      body: ListView.separated(
        itemBuilder: (BuildContext context, int index) {
          return Card(
            elevation: 2.0,
            color: Colors.indigo[100],
            child: Material(
              child: ListTile(
                dense: true,
                contentPadding: const EdgeInsets.only(left: 5.0, right: 0.0),
                leading: FadeInImage.assetNetwork(
                  placeholder: 'images/image_loading.jpg',
                  image: "$baseUrl" +
                      widget.cartProducts[index].cartProductPicture,
                  height: 70.0,
                  width: 45.0,
                  fit: BoxFit.fitWidth,
                ),
                /*Image.network(
                  "$baseUrl" + widget.cartProducts[index].cartProductPicture,
                  fit: BoxFit.cover,
                  height: 70.0,
                  width: 50.0,
                ),*/
                title: Align(
                    child: Text(
                      widget.cartProducts[index].cartProductName,
                      style: TextStyle(
                          fontSize: 15.0, fontWeight: FontWeight.bold),
                    ),
                  alignment: Alignment(-1.0,0),
                ),
                subtitle: widget.cartProducts[index].cartProductSalePrice != 0
                    ? Text(
                        "${widget.cartProducts[index].cartProductSalePrice} টাকা /${widget.cartProducts[index].cartProductUnit}",
                        style: TextStyle(
                            fontSize: 13.0,
                            color: appThemeColor,
                            fontWeight: FontWeight.bold),
                      )
                    : Text(
                        "${widget.cartProducts[index].cartProductPrice} টাকা /${widget.cartProducts[index].cartProductUnit}",
                        style: TextStyle(fontSize: 13.0),
                      ),

                /*Text(
                  "${widget.cartProducts[index].cartProductPrice} টাকা /${widget.cartProducts[index].cartProductUnit}",
                  style: TextStyle(fontSize: 13.0),
                ),*/
                trailing: Container(
                  //color: Colors.teal[100],
                  width: (MediaQuery.of(context).size.width) * 0.40,
                  height: 70.0,
                  //child: Icon(Icons.add_shopping_cart, color: Colors.white,size: 18.0,),
                  child: Row(
                    children: <Widget>[
                      Container(
                        //color: Colors.yellow,
                        width: 70.0,
                        //decoration: BoxDecoration(border: Border.all(width: 1.0)),
                        child: Padding(
                            padding:
                                const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                            child: widget.cartProducts[index]
                                        .cartProductSalePrice !=
                                    0
                                ? Text(
                                    '${widget.cartProducts[index].cartProductQty * widget.cartProducts[index].cartProductSalePrice} tk',
                                    style: TextStyle(
                                        color: appThemeColor,
                                        fontWeight: FontWeight.bold),
                                  )
                                : Text(
                                    '${widget.cartProducts[index].cartProductQty * widget.cartProducts[index].cartProductPrice} tk',
                                    style: TextStyle(
                                        color: appThemeColor,
                                        fontWeight: FontWeight.bold),
                                  )

                            /*Text(
                              '${widget.cartProducts[index].cartProductQty * widget.cartProducts[index].cartProductPrice} tk',
                              style: TextStyle(
                                  color: appThemeColor,
                                  fontWeight: FontWeight.bold),
                            )*/
                            ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          // ==== minus button section  ========== //
                          InkWell(
                            onTap: () {
                              int _price = 0;
                              _price = widget.cartProducts[index]
                                          .cartProductSalePrice !=
                                      0
                                  ? widget
                                      .cartProducts[index].cartProductSalePrice
                                  : widget.cartProducts[index].cartProductPrice;
                              setState(() {
                                widget.cartProducts[index].cartProductQty -= 1;
                                _totalBill -= _price;
                                if (widget.cartProducts[index].cartProductQty <
                                    1) {
                                  widget.cartProducts.removeAt(index);
                                }
                                if (widget.cartProducts.length <= 0) {
                                  _showBottomNavigationBar = false;
                                }
                                _calculateDiscount();
                              });
                              //debugPrint('cartProduct from minus=${widget.cartProducts[index].cartProductQty}');
                            },
                            child: Container(
                              //color: Colors.green[100],
                              height: 70.0,
                              width: 30.0,
                              child: Icon(
                                Icons.remove,
                                size: 22.0,
                              ),
                            ),
                          ),
                          Text(
                            '${widget.cartProducts[index].cartProductQty}',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          // ==== plus button section  ========== //
                          InkWell(
                            onTap: () {
                              int _price = 0;
                              _price = widget.cartProducts[index]
                                          .cartProductSalePrice !=
                                      0
                                  ? widget
                                      .cartProducts[index].cartProductSalePrice
                                  : widget.cartProducts[index].cartProductPrice;
                              setState(() {
                                widget.cartProducts[index].cartProductQty += 1;
                                _totalBill += _price;
                                _calculateDiscount();
                              });
                              //debugPrint('cartProduct from plus=${widget.cartProducts[index].cartProductQty}');
                            },
                            child: Container(
                              //color: Colors.green[100],
                              height: 70.0,
                              width: 30.0,
                              child: Icon(
                                Icons.add,
                                size: 22.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return Divider(
            height: 0.1,
          );
        },
        itemCount: widget.cartProducts.length,
      ),
      bottomNavigationBar: Visibility(
          visible: _showBottomNavigationBar, child: _buildBottomContainer()),
    );
  }

  Widget _buildBottomContainer() {
    return Container(
      //color: Colors.green[100],
      height: (MediaQuery.of(context).size.height) * 0.25,

      margin: EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'Cart Total',
                style: TextStyle(fontSize: 16.0, color: Colors.grey),
              ),
              Text(
                "$_totalBill",
                style: TextStyle(fontSize: 16.0, color: Colors.black),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'Discount',
                style: TextStyle(fontSize: 16.0, color: Colors.green),
              ),
              Text(
                "- $_discount",
                style: TextStyle(fontSize: 16.0, color: Colors.green),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'Delivery Charge',
                style: TextStyle(fontSize: 16.0, color: Colors.grey),
              ),
              Text(
                "${widget.cartProducts.length > 0 ? _deliveryCharge : 0}",
                style: TextStyle(fontSize: 16.0, color: Colors.black),
              ),
            ],
          ),
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'Total',
                style: TextStyle(
                    fontSize: 16.0,
                    color: appThemeColor,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                "${widget.cartProducts.length > 0 ? _totalBill + _deliveryCharge - _discount : _totalBill}",
                style: TextStyle(
                    fontSize: 16.0,
                    color: appThemeColor,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Container(
            margin: EdgeInsetsDirectional.only(top: 20.0),
            width: MediaQuery.of(context).size.width,
            height: 40.0,
            decoration: BoxDecoration(
              border: Border.all(),
              borderRadius: BorderRadius.circular(30.0),
              color: Theme.of(context).primaryColor,
            ),
            child: InkWell(
              onTap: () {
                _buildFromCart();
                widget.localProfile != null
                    ? Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => CheckOut(
                              orderData: orderData,
                                localProfile: widget.localProfile)))
                    : Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => UserValidation(
                        orderData: orderData,
                      rootPage: 'cart',
                    )));
              },
              child: Center(
                child: Text(
                  'Proceed to Checkout',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _buildFromCart() {
    List<ShoppingCartProduct> cartProductList = [];
    int _cartTotal = 0;
    for (int i = 0; i < widget.cartProducts.length; i++) {
      ShoppingCartProduct temp = new ShoppingCartProduct();
      int _price = 0;
      _price = widget.cartProducts[i].cartProductSalePrice != 0
          ? (widget.cartProducts[i].cartProductSalePrice)
          : (widget.cartProducts[i].cartProductPrice);

      temp.productNameBn = widget.cartProducts[i].cartProductName;
      temp.productId = widget.cartProducts[i].cartProductId;
      temp.price = _price;
      temp.productSalePrice = widget.cartProducts[i].cartProductSalePrice;
      temp.productUnit = widget.cartProducts[i].cartProductUnit;
      temp.productQty = widget.cartProducts[i].cartProductQty;
      cartProductList.add(temp);
      _cartTotal += ((widget.cartProducts[i].cartProductQty) * _price);
    }
    orderData.cartProductList = cartProductList;
    orderData.deliveryCharge = _deliveryCharge;
    orderData.productPrice = _cartTotal;
    orderData.subTotal = _cartTotal + _deliveryCharge;
    orderData.totalPrice = _cartTotal + _deliveryCharge - _discount;
    orderData.discount = _discount;
    orderData.os = widget.os;
    orderData.pushToken = widget.pushToken;
  }
}
