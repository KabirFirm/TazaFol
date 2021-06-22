class CartProductModel{
  final cartProductId;
  final cartProductCategory;
  final cartProductName;
  final cartProductPicture;
  final cartProductPrice;
  final cartProductSalePrice;
  final cartProductIsDiscount;
  final cartProductAmount;
  final cartProductIsPercentage;
  final cartProductUnit;
  int cartProductQty;

  CartProductModel({
    this.cartProductId,
    this.cartProductCategory,
    this.cartProductName,
    this.cartProductPicture,
    this.cartProductPrice,
    this.cartProductSalePrice,
    this.cartProductIsDiscount,
    this.cartProductAmount,
    this.cartProductIsPercentage,
    this.cartProductUnit,
    this.cartProductQty,
  });
}

class OrderSendToServer{
  int userId;
  int productPrice;
  int deliveryCharge;
  int subTotal;
  int discount;
  int totalPrice;
  String name;
  String mobile;
  int os;
  String pushToken;
  String house;
  String flat;
  String road;
  String block;
  String area;
  String instruction;
  String deliveryNote;
  List<ShoppingCartProduct> cartProductList;

  OrderSendToServer({
    this.userId,
    this.productPrice,
    this.deliveryCharge,
    this.subTotal,
    this.discount,
    this.totalPrice,
    this.name,
    this.os,
    this.pushToken,
    this.mobile,
    this.house,
    this.flat,
    this.road,
    this.block,
    this.area,
    this.instruction,
    this.deliveryNote,
    this.cartProductList
  });

  Map toJson(){
    List<Map> cartProductList = this.cartProductList != null ? this.cartProductList.map((i) => i.toJson()).toList() : null ;

    return {
      'userId': userId,
      'productPrice': productPrice,
      'deliveryCharge': deliveryCharge,
      'subTotal': subTotal,
      'discount': discount,
      'totalPrice': totalPrice,
      'name': name,
      'mobile': mobile,
      'os': os,
      'pushToken': pushToken,
      'house': house,
      'flat': flat,
      'road': road,
      'block': block,
      'area': area,
      'instruction': instruction,
      'deliveryNote': deliveryNote,
      'cartProductList': cartProductList

    };
  }

}

class ShoppingCartProduct{
  int productId;
  String productNameBn;
  int price;
  int productSalePrice;
  String productUnit;
  int productQty;

  ShoppingCartProduct({
    this.productId,
    this.productNameBn,
    this.price,
    this.productSalePrice,
    this.productUnit,
    this.productQty,
  });

  Map toJson() => {
    'productId': productId,
    'price': price,
    'productNameBn': productNameBn,
    'productSalePrice': productSalePrice,
    'productUnit': productUnit,
    'productQty': productQty

  };
}