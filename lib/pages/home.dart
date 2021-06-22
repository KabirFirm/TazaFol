import 'package:flutter/material.dart';
import 'package:tazafol/components/color.dart';
import 'package:tazafol/components/horizontalList.dart';
import 'package:tazafol/models/cartProductModel.dart';
import 'package:tazafol/models/dataModel.dart';
import 'package:tazafol/pages/products.dart';

class Home extends StatefulWidget {
  final void Function(CartProductModel product, String changer) updateCart;
  final List<Category> categories;
  final List<Product> products;
  final List<CartProductModel> cartProducts;

  Home({Key key, this.updateCart, this.cartProducts, this.categories, this.products})
      : super(key: key);
  @override
  _HomeState createState() => _HomeState();
}

class ParentProvider extends InheritedWidget {
  final int categoryId;
  final Widget child;

  ParentProvider({this.categoryId, this.child});

  @override
  bool updateShouldNotify(ParentProvider oldWidget) {
    return true;
  }

  static ParentProvider of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<ParentProvider>();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  int categoryFromParent;

  updateCategory(int categoryId) {
    setState(() {
      categoryFromParent = categoryId;
    });
  }


  @override
  Widget build(BuildContext context) {
    return ParentProvider(
      categoryId: categoryFromParent,
      child: Column(
        //mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          /*Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 2.0, 0.0, 2.0),
            child: Container(
              height: 18.0,
              //color: Colors.greenAccent,
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Icon(Icons.arrow_left),
                  Text(
                    'CATEGORY',
                    style: TextStyle(fontWeight: FontWeight.bold,),

                  ),
                  Icon(Icons.arrow_right),
                ],
              ),
            ),
          ),*/
          Container(
            color: tabBarBackgroundColor,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(3.0,3.0,0.0,0.0),
              child: HorizontalList(
                categories: widget.categories,
                selectedCategoryChange: updateCategory,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 3.0, 0.0, 0.0),
            child: Container(
              color: appThemeColor,
              height: 3.0,
            ),
          ),
          Expanded(
            child: SizedBox(
              child: Scrollbar(
                child: Products(
                    updateCart: widget.updateCart, products: widget.products, cartProducts: widget.cartProducts,)
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/*class Home extends StatelessWidget {

  final void Function(CartProductModel product, String changer) updateCart;
  final List<Category> categories;
  final List<Product> products;

  Home({Key key, this.updateCart, this.categories, this.products}) : super (key : key);


  @override
  Widget build(BuildContext context) {
    return Column(
      //mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("Category"),
        ),
        HorizontalList(categories: categories,),  
        
        Expanded(
          child: SizedBox(
            child: Scrollbar(
              child: Products(updateCart: updateCart, products: products),              
            ),
          ),
        ),
      ],
    );
  }
}*/
