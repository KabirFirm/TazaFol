import 'package:flutter/material.dart';
import 'package:tazafol/components/color.dart';
import 'package:tazafol/models/cartProductModel.dart';
import 'package:tazafol/pages/home.dart';
import 'package:tazafol/pages/productDetails.dart';
import 'package:tazafol/models/dataModel.dart';
import 'dart:core';
import 'package:tazafol/components/blinkWidget.dart';

import 'package:shared_preferences/shared_preferences.dart';
//import 'package:pg_1jan20/components/cartProducts.dart';
//import 'package:pg_1jan20/main.dart' as main;

class Products extends StatefulWidget {
  final void Function(CartProductModel product, String changer) updateCart;
  final List<Product> products;
  final List<CartProductModel> cartProducts;
  Products({Key key, this.updateCart, this.products, this.cartProducts})
      : super(key: key);

  @override
  ProductsState createState() => ProductsState();
}

class ProductsState extends State<Products> {
  int selectedCategory;
  bool isProduct = false;
  final _scrollController = ScrollController();
  final _header = "";
  bool _doesShowHeader = false;

  @override
  void initState() {
    getCategoryId();
    super.initState();
  }

  @override
  void dispose(){
    super.dispose();
  }
  getCategoryId() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      selectedCategory = preferences.getInt('categoryId');
    });
  }

  @override
  Widget build(BuildContext context) {
    final parentCategory = ParentProvider.of(context).categoryId;
    selectedCategory = parentCategory ?? selectedCategory;
    // collect products from all products depending on selected category
    List<Product> _selectedProducts = [];
    for(int i =0; i<widget.products.length; i++){
      if(selectedCategory == widget.products[i].categoryId){
        _selectedProducts.add(widget.products[i]);
      }
    }

    if (selectedCategory == null) {
      return Container(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return Scrollbar(
        isAlwaysShown: true,
        controller: _scrollController,
        child: ListView.builder(
          controller: _scrollController,
          itemCount: _selectedProducts.length,
          itemBuilder: (BuildContext _, int index) {
            int cartProductQty = 0;
            for (int i = 0; i < widget.cartProducts.length; i++) {
              if (_selectedProducts[index].productId ==
                  widget.cartProducts[i].cartProductId) {
                cartProductQty = widget.cartProducts[i].cartProductQty;
              }
            }
            return SingleProduct(
              productId: _selectedProducts[index].productId,
              productName: _selectedProducts[index].nameBn,
              productPicture: _selectedProducts[index].picture,
              productPrice: _selectedProducts[index].price,
              productSalePrice: _selectedProducts[index].salePrice,
              productIsDiscount: _selectedProducts[index].isDiscount,
              productAmount: _selectedProducts[index].amount,
              productIsPercentage: _selectedProducts[index].isPercentage,
              productCategory: _selectedProducts[index].categoryId,
              productUnit: _selectedProducts[index].unit,
              cartProductQty: cartProductQty,
              product: _selectedProducts[index],
              updateCart: widget.updateCart,
            );

          }
        ),
      );
    }
  }

  /*void updateProducts(int category) {
    setState(() {
      selectedCategory = category;
    });
  }*/
}

class DoNothing extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class SingleProduct extends StatefulWidget {
  final productId;
  final productName;
  final productPicture;
  final productPrice;
  final productSalePrice;
  final productIsDiscount;
  final productAmount;
  final productIsPercentage;
  final productCategory;
  final productUnit;
  final cartProductQty;
  final Product product;
  final void Function(CartProductModel product, String changer) updateCart;

  SingleProduct({
    this.productId,
    this.productName,
    this.productPicture,
    this.productPrice,
    this.productSalePrice,
    this.productIsDiscount,
    this.productAmount,
    this.productIsPercentage,
    this.productCategory,
    this.productUnit,
    this.cartProductQty,
    this.product,
    this.updateCart,
  });

  @override
  _SingleProductState createState() => _SingleProductState();
}

class _SingleProductState extends State<SingleProduct> {
  bool _isAddShopIconVisible;
  bool _isDoneIconVisible;
  int productQty;
  var baseUrl = "http://tazafol.com/app-api/";

  @override
  void initState() {
    super.initState();
    if (widget.cartProductQty > 0) {
      _isDoneIconVisible = true;
      _isAddShopIconVisible = false;
      productQty = widget.cartProductQty;
    } else {
      _isDoneIconVisible = false;
      _isAddShopIconVisible = true;
      productQty = 1;
    }

  }

  _reBuildCartIcon(){
    if (widget.cartProductQty > 0) {
      _isDoneIconVisible = true;
      _isAddShopIconVisible = false;
      productQty = widget.cartProductQty;
    } else {
      _isDoneIconVisible = false;
      _isAddShopIconVisible = true;
      productQty = 1;
    }
  }


  @override
  Widget build(BuildContext context) {
    _reBuildCartIcon();
    return Card(
      elevation: 2.0,
      color: Colors.indigo[100],
      child: Hero(
        tag: widget.productName,
        child: Material(
          child: InkWell(
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ProductDetails(
                          product: widget.product,
                        ))),
            child: ListTile(
              contentPadding: EdgeInsets.only(left: 5.0, right: 0.0),
              leading: FadeInImage.assetNetwork(
                placeholder: 'images/image_loading.jpg',
                image: "$baseUrl" + widget.productPicture,
                height: 70.0,
                width: 50.0,
                fit: BoxFit.fitWidth,
              ),

              /*Image.network(
                "$baseUrl" + widget.productPicture,
                fit: BoxFit.cover,
                height: 70.0,
                width: 50.0,
              ),*/
              title: Align(
                child: Text(
                  widget.productName,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                alignment: Alignment(-1.0,0),
              ),
              subtitle: widget.productSalePrice != 0
                  ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
              Text("${widget.productPrice} টাকা /${widget.productUnit}", style: TextStyle(decoration: TextDecoration.lineThrough, color: Colors.red),),
                //SizedBox(width: 3.0,),
                Text("${widget.productSalePrice} টাকা /${widget.productUnit}", style: TextStyle(color: appThemeColor)),
              ],
              )
                  : Text("${widget.productPrice} টাকা /${widget.productUnit}", style: TextStyle(color: appThemeColor),),
              trailing: SizedBox(
                width: 120.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Visibility(
                      visible: widget.productIsDiscount == 1,
                      child: Container(
                        //color: Colors.greenAccent,
                        width: 40.0,
                        height: 40.0,
                        child: BlinkWidget(
                          children: <Widget>[
                            Image.asset('images/discount.gif', width: 40.0, height: 40.0,fit: BoxFit.cover,),
                            Image.asset('images/noImage.jpg', width: 40.0, height: 40.0,fit: BoxFit.cover,),
                          ],
                        ),
                      ),
                    ),

                    Container(
                      //
                      //color: Colors.black26,
                      width: 80.0,
                      height: 70.0,
                      child: Row(
                        children: <Widget>[
                          // ======= done icon, quantity add, minus section =================== //
                          Visibility(
                            visible: _isDoneIconVisible,
                            child: InkWell(
                              onTap: () {},
                              child: Container(
                                //color: Colors.deepPurple,
                                width: 80.0,
                                //height: 70.0,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    Icon(
                                      Icons.done,
                                      size: 21.0,
                                      color: appThemeColor,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        // ========= minus icon section  =========== //
                                        InkWell(
                                            onTap: () {
                                              setState(() {
                                                productQty -= 1;
                                                if (productQty < 1) {
                                                  _isDoneIconVisible = false;
                                                  _isAddShopIconVisible = true;
                                                  productQty = 1;
                                                }
                                                CartProductModel cartProduct =
                                                CartProductModel(
                                                  cartProductId: widget.productId,
                                                  cartProductCategory:
                                                  widget.productCategory,
                                                  cartProductName: widget.productName,
                                                  cartProductPicture:
                                                  widget.productPicture,
                                                  cartProductPrice:
                                                  widget.productPrice,
                                                  cartProductSalePrice:
                                                  widget.productSalePrice,
                                                  cartProductIsDiscount:
                                                  widget.productIsDiscount,
                                                  cartProductAmount:
                                                  widget.productAmount,
                                                  cartProductIsPercentage:
                                                  widget.productIsPercentage,
                                                  cartProductUnit: widget.productUnit,
                                                  cartProductQty: 1,
                                                );
                                                widget.updateCart(
                                                    cartProduct, 'minus');
                                              });

                                            },
                                            child: Container(
                                              //color: Colors.green[100],
                                                height: 35.0,
                                                width: 30.0,
                                                child: Icon(
                                                  Icons.remove,
                                                  size: 21.0,
                                                  color: appThemeColor,
                                                ))),
                                        Text(
                                          '$productQty',
                                          style:
                                          TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: appThemeColor,
                                            fontSize: 14.0,
                                          ),
                                        ),
                                        // ========= plus icon section  =========== //
                                        InkWell(
                                            onTap: () {
                                              setState(() {
                                                productQty += 1;
                                                CartProductModel cartProduct =
                                                CartProductModel(
                                                  cartProductId: widget.productId,
                                                  cartProductCategory:
                                                  widget.productCategory,
                                                  cartProductName: widget.productName,
                                                  cartProductPicture:
                                                  widget.productPicture,
                                                  cartProductPrice:
                                                  widget.productPrice,
                                                  cartProductSalePrice:
                                                  widget.productSalePrice,
                                                  cartProductIsDiscount:
                                                  widget.productIsDiscount,
                                                  cartProductAmount:
                                                  widget.productAmount,
                                                  cartProductIsPercentage:
                                                  widget.productIsPercentage,
                                                  cartProductUnit: widget.productUnit,
                                                  cartProductQty: 1,
                                                );
                                                widget.updateCart(
                                                    cartProduct, 'plus');
                                              });
                                            },
                                            child: Container(
                                              //color: Colors.green[100],
                                                height: 35.0,
                                                width: 30.0,
                                                child: Icon(
                                                  Icons.add,
                                                  size: 21.0,
                                                  color: appThemeColor,
                                                ))),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
// ======= shopping cart and ADD text section =================== //
                          Visibility(
                            visible: _isAddShopIconVisible,
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  _isAddShopIconVisible = false;
                                  _isDoneIconVisible = true;
                                  //select item price
                                  CartProductModel cartProduct = CartProductModel(
                                    cartProductId: widget.productId,
                                    cartProductCategory: widget.productCategory,
                                    cartProductName: widget.productName,
                                    cartProductPicture: widget.productPicture,
                                    cartProductPrice: widget.productPrice,
                                    cartProductSalePrice: widget.productSalePrice,
                                    cartProductIsDiscount: widget.productIsDiscount,
                                    cartProductAmount: widget.productAmount,
                                    cartProductIsPercentage: widget.productIsPercentage,
                                    cartProductUnit: widget.productUnit,
                                    cartProductQty: 1,
                                  );

                                  widget.updateCart(cartProduct, 'plus');
                                  //int price = widget.productPrice;
                                  //main.HomePageState().changeTotalBill(price);
                                  //main._HomePageState().changeTotalBill(15,'plus');
                                  //_totalBill = (preferences.getInt('totalBill') ?? 0);
                                });


                              },
                              child: Container(
                                //color: Colors.deepPurple,
                                width: 80.0,
                                //height: 70.0,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    Icon(
                                      Icons.add_shopping_cart,
                                      color: appThemeColor,
                                      //size: 21.0,
                                    ),
                                    Text('ADD', style: TextStyle(color: appThemeColor,),),
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),

                  ],
                ),
              )

            ),
          ),
        ),
      ),
    );
  }
}

