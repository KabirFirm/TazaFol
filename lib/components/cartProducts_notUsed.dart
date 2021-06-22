import 'package:flutter/material.dart';


class CartProducts extends StatelessWidget {
  final cartProductList = [
    {
      "productName": "পাহাড়ি পেঁপে",
      "productPicture": "images/products/blazer1.jpeg",
      "productOldPrice": 100,
      "productPrice": 130,
      "unit": "kg",
      "productQty": 1,
    },
    {
      "productName": "পাহাড়ি বাংলা কলা",
      "productPicture": "images/products/blazer2.jpeg",
      "productOldPrice": 100,
      "productPrice": 100,
      "unit": "kg",
      "productQty": 3,
    },
    {
      "productName": "পাহাড়ি চাঁপা কলা",
      "productPicture": "images/products/dress1.jpeg",
      "productOldPrice": 100,
      "productPrice": 100,
      "unit": "kg",
      "productQty": 3,
    },
    {
      "productName": "সবরি কলা",
      "productPicture": "images/products/dress2.jpeg",
      "productOldPrice": 100,
      "productPrice": 100,
      "unit": "kg",
      "productQty": 3,
    },
  ];
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: cartProductList.length,
      itemBuilder: (BuildContext context, int index) {
        return CartSingleProduct(
          cartProductName: cartProductList[index]['productName'],
          cartProductPicture: cartProductList[index]['productPicture'],
          cartProductOldPrice: cartProductList[index]['productOldPrice'],
          cartProductPrice: cartProductList[index]['productPrice'],
          cartProductunit: cartProductList[index]['unit'],
          cartProductQty: cartProductList[index]['productQty'],
        );
      },
    );
  }
}

class CartSingleProduct extends StatefulWidget {
  final cartProductName;
  final cartProductPicture;
  final cartProductOldPrice;
  final cartProductPrice;
  final cartProductunit;
  final cartProductQty;

  CartSingleProduct({
    this.cartProductName,
    this.cartProductPicture,
    this.cartProductOldPrice,
    this.cartProductPrice,
    this.cartProductunit,
    this.cartProductQty,
  });

  _CartSingleProductState createState() => _CartSingleProductState();

}

class _CartSingleProductState extends State<CartSingleProduct> {

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      color: Colors.indigo[100],
      child: Hero(
        tag: widget.cartProductName,
        child: Material(
          child: ListTile(
            leading: Image.asset(
              widget.cartProductPicture,
              fit: BoxFit.cover,
              height: 70.0,
              width: 50.0,
            ),
            title: Row(
              children: <Widget>[
                Text(widget.cartProductName),
              ],
            ),
            subtitle: Text("${widget.cartProductPrice} টাকা / ${widget.cartProductunit}"),
            trailing: Container(
              //color: Colors.teal[100],
              width: 150.0,
              height: 70.0,
              //child: Icon(Icons.add_shopping_cart, color: Colors.white,size: 18.0,),
              child: Row(
                children: <Widget>[
                  Container(
                    //color: Colors.yellow,
                    width: 70.0,
                    //decoration: BoxDecoration(border: Border.all(width: 1.0)),
                    child: Padding(
                        padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                        child: Text(
                          '${widget.cartProductQty * widget.cartProductPrice} tk',
                          style: TextStyle(
                              color: Colors.red, fontWeight: FontWeight.bold),
                        )),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
        // ==== minus button section  ========== //
                      InkWell(
                        onTap: () {
                          setState(() {
                            //widget.cartProductQty -= 1;
                            //Cart.totalPrice = 0;
                            if(widget.cartProductQty < 1) {
                            }
                          });
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
                        '${widget.cartProductQty}',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
        // ==== plus button section  ========== //
                      InkWell(
                        onTap: () {
                          setState(() {
                            //widget.cartProductQty += 1;
                          });
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
      ),
    );
  }
}
