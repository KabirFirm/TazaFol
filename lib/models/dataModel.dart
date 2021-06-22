class DataModel {
  final int status;
  final int deliveryCharge;
  final String mobilePhone;
  final String msg;
  final List<Category> categories;
  final List<Product> products;
  final Profile profile;
  final List<Order> orderList;
  final AppInfo appInfo;
  final Offer offer;
  final List<Notifikation> notificationList;
  final List<OfferList> offerList;

  DataModel({
    this.status,
    this.deliveryCharge,
    this.mobilePhone,
    this.msg,
    this.categories,
    this.products,
    this.profile,
    this.orderList,
    this.appInfo,
    this.offer,
    this.notificationList,
    this.offerList,
  });

  factory DataModel.fromJson(Map<String, dynamic> parsedJson) {
    var list = parsedJson['categories'] as List;
    List<Category> categoryList =
        list.map((i) => Category.fromJson(i)).toList();
    var pList = parsedJson['products'] as List;
    List<Product> productList = pList.map((i) => Product.fromJson(i)).toList();

    var oList = parsedJson['orders'] as List;
    List<Order> orders = [];
    if (oList != null) {
      orders = oList.map((i) => Order.fromJson(i)).toList();
    }

    var notiList = parsedJson['notification'] as List;
    List<Notifikation> notifications = [];
    if (notiList != null) {
      notifications = notiList.map((i) => Notifikation.fromJson(i)).toList();
    }

    var offerList = parsedJson['offer_list'] as List;
    List<OfferList> offers = [];
    if (offerList != null) {
      offers = offerList.map((i) => OfferList.fromJson(i)).toList();
    }
    //List<Order> orders = oList.map((i) => Order.fromJson(i)).toList();
    return DataModel(
        status: parsedJson['status'],
        msg: parsedJson['msg'],
        deliveryCharge: parsedJson['delivery_charge'],
        mobilePhone: parsedJson['contact'],
        categories: categoryList,
        products: productList,
        offerList: offers,
        notificationList: notifications,
        profile: parsedJson['profile'] != null
            ? Profile.fromJson(parsedJson['profile'])
            : null,
        offer: parsedJson['offer'] != null
            ? Offer.fromJson(parsedJson['offer'])
            : null,
        appInfo: parsedJson['info'] != null
            ? AppInfo.fromJson(parsedJson['info'])
            : null,
        orderList: orders);
  }
}

class Category {
  final int id;
  final int index;
  final String nameEn;
  final String nameBn;
  final String appImage;
  bool isSelected;

  Category(
      {this.id,
      this.index,
      this.nameEn,
      this.nameBn,
      this.appImage,
      this.isSelected});

  factory Category.fromJson(Map<String, dynamic> parsedJson) {
    return Category(
        id: parsedJson['id'],
        index: parsedJson['index'],
        nameBn: parsedJson['name_bn'],
        nameEn: parsedJson['name_en'],
        appImage: parsedJson['app_image'],
        isSelected: parsedJson['is_selected']);
  }
}

class Product {
  final int productId;
  final int categoryId;
  final String header;
  final int index;
  final String nameEn;
  final String nameBn;
  final String descriptionEn;
  final String descriptionBn;
  final int price;
  final int salePrice;
  final int isDiscount;
  final int amount;
  final int isPercentage;
  final String unit;
  final String picture;
  final String image1;
  final String image2;
  final String image3;
  final int stock;
  final int status;

  Product(
      {this.productId,
      this.categoryId,
        this.header,
      this.index,
      this.nameEn,
      this.nameBn,
      this.descriptionEn,
      this.descriptionBn,
      this.price,
      this.salePrice,
      this.isDiscount,
      this.amount,
      this.isPercentage,
      this.unit,
      this.picture,
      this.image1,
      this.image2,
      this.image3,
      this.stock,
      this.status});

  factory Product.fromJson(Map<String, dynamic> parsedJson) {
    return Product(
      productId: parsedJson['product_id'],
      categoryId: parsedJson['category_id'],
      header: parsedJson['header'],
      index: parsedJson['index'],
      nameEn: parsedJson['name_en'],
      nameBn: parsedJson['name_bn'],
      descriptionEn: parsedJson['description_en'],
      descriptionBn: parsedJson['description_bn'],
      price: parsedJson['price'],
      salePrice: parsedJson['sale_price'],
      isDiscount: parsedJson['is_discount'],
      amount: parsedJson['amount'],
      isPercentage: parsedJson['is_percentage'],
      unit: parsedJson['unit'],
      picture: parsedJson['picture'],
      image1: parsedJson['image1'],
      image2: parsedJson['image2'],
      image3: parsedJson['image3'],
      stock: parsedJson['stock'],
      status: parsedJson['status'],
    );
  }
}

class Profile {
  final String name;
  final String mobile;
  final int isVerified;
  final String house;
  final String flat;
  final String road;
  final String block;
  final String area;
  final String note;

  Profile(
      {this.name,
      this.mobile,
      this.isVerified,
      this.house,
      this.flat,
      this.road,
      this.block,
      this.area,
      this.note});

  factory Profile.fromJson(Map<String, dynamic> parsedJson) {
    return Profile(
        name: parsedJson['name'],
        mobile: parsedJson['mobile'],
        isVerified: parsedJson['is_verified'],
        house: parsedJson['house'],
        flat: parsedJson['flat'],
        road: parsedJson['road'],
        block: parsedJson['block'],
        area: parsedJson['area'],
        note: parsedJson['note']);
  }
}

class Offer {
  final int isFirstInstall;
  final int isAllProduct;
  final int isCategory;
  final int categoryId;
  final int isSingleProduct;
  final int productId;
  final int amount;

  Offer(
      {this.isFirstInstall,
      this.isAllProduct,
      this.isCategory,
      this.categoryId,
      this.isSingleProduct,
      this.productId,
      this.amount});

  factory Offer.fromJson(Map<String, dynamic> parsedJson) {
    return Offer(
        isFirstInstall: parsedJson['is_first_install'],
        isAllProduct: parsedJson['is_all_product'],
        isCategory: parsedJson['is_category'],
        categoryId: parsedJson['category_id'],
        isSingleProduct: parsedJson['is_single_product'],
        productId: parsedJson['product_id'],
        amount: parsedJson['amount']);
  }
}

class AppInfo {
  final String androidAppVersion;
  final String androidAppId;
  final String iosAppVersion;
  final String iosAppId;

  AppInfo(
      {this.androidAppVersion,
      this.androidAppId,
      this.iosAppVersion,
      this.iosAppId});

  factory AppInfo.fromJson(Map<String, dynamic> parsedJson) {
    return AppInfo(
        androidAppVersion: parsedJson['android_app_version'],
        androidAppId: parsedJson['android_app_id'],
        iosAppVersion: parsedJson['ios_app_version'],
        iosAppId: parsedJson['ios_app_id']);
  }
}

class OrderedProduct {
  final int productId;
  final int productCategory;
  final String nameEn;
  final String nameBn;
  final String descriptionEn;
  final String descriptionBn;
  final int price;
  final int salePrice;
  final String unit;
  final String picture;
  final int quantity;
  final int isDelivered;

  OrderedProduct({
    this.productId,
    this.productCategory,
    this.nameEn,
    this.nameBn,
    this.descriptionEn,
    this.descriptionBn,
    this.price,
    this.salePrice,
    this.unit,
    this.picture,
    this.quantity,
    this.isDelivered,
  });

  factory OrderedProduct.fromJson(Map<String, dynamic> parsedJson) {
    return OrderedProduct(
        productId: parsedJson['product_id'],
        productCategory: parsedJson['category_id'],
        nameEn: parsedJson['name_en'],
        nameBn: parsedJson['name_bn'],
        descriptionEn: parsedJson['description_en'],
        descriptionBn: parsedJson['description_bn'],
        price: parsedJson['price'],
        salePrice: parsedJson['sale_price'],
        unit: parsedJson['unit'],
        picture: parsedJson['picture'],
        quantity: parsedJson['qty'],
        isDelivered: parsedJson['is_delivered']);
  }
}

class Order {
  final int orderId;
  final String orderDate;
  final int productPrice;
  final int deliveryCharge;
  final int totalPrice;
  final int discount;
  final int payablePrice;
  final int due;
  final int orderStatus;
  final String house;
  final String flat;
  final String road;
  final String block;
  final String area;
  final String instruction;
  final String deliveryNote;
  final String deliveryDate;
  final String cancelNote;
  final String adminMessage;
  final List<OrderedProduct> productList;

  Order({
    this.orderId,
    this.orderDate,
    this.productPrice,
    this.deliveryCharge,
    this.totalPrice,
    this.discount,
    this.payablePrice,
    this.due,
    this.orderStatus,
    this.house,
    this.flat,
    this.road,
    this.block,
    this.area,
    this.instruction,
    this.deliveryNote,
    this.deliveryDate,
    this.cancelNote,
    this.adminMessage,
    this.productList,
  });

  factory Order.fromJson(Map<String, dynamic> parsedJson) {
    var opList = parsedJson['product_list'] as List;
    List<OrderedProduct> orderProductList =
        opList.map((i) => OrderedProduct.fromJson(i)).toList();
    return Order(
        orderId: parsedJson['order_id'],
        orderDate: parsedJson['order_date'],
        productPrice: parsedJson['product_price'],
        deliveryCharge: parsedJson['delivery_charge'],
        totalPrice: parsedJson['total_price'],
        discount: parsedJson['discount'],
        payablePrice: parsedJson['payable_price'],
        due: parsedJson['due'],
        orderStatus: parsedJson['order_status'],
        house: parsedJson['house'],
        flat: parsedJson['flat'],
        road: parsedJson['road'],
        block: parsedJson['block'],
        area: parsedJson['area'],
        instruction: parsedJson['instruction'],
        deliveryDate: parsedJson['delivery_date'],
        deliveryNote: parsedJson['delivery_note'],
        cancelNote: parsedJson['cancel_note'],
        adminMessage: parsedJson['admin_msg'],
        productList: orderProductList);
  }
}

class Notifikation {
  final int notificationId;
  final String title;
  final String description;
  final String image;
  final String publishDate;

  Notifikation(
      {this.notificationId,
      this.title,
      this.description,
      this.image,
      this.publishDate});

  factory Notifikation.fromJson(Map<String, dynamic> parsedJson) {
    return Notifikation(
      notificationId: parsedJson['id'],
      title: parsedJson['title'],
      description: parsedJson['description'],
      image: parsedJson['image'],
      publishDate: parsedJson['publish_date'],
    );
  }
}

class OfferList {
  final int offerId;
  final String title;
  final String description;
  final String image;
  final String productId;
  final String categoryId;
  final String offerStart;
  final String offerEnd;
  final int amount;
  final bool isPercentage;

  OfferList(
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

  factory OfferList.fromJson(Map<String, dynamic> parsedJson) {
    return OfferList(
      offerId: parsedJson['id'],
      title: parsedJson['title'],
      description: parsedJson['description'],
      image: parsedJson['image'],
      productId: parsedJson['product_id'],
      categoryId: parsedJson['category_id'],
      offerStart: parsedJson['offer_start'],
      offerEnd: parsedJson['offer_end'],
      amount: parsedJson['amount'],
      isPercentage: parsedJson['is_percentage'],
    );
  }
}
