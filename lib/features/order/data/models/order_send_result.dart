import 'dart:core';

class OrderSendResult {
  String? billing_name;
  String? confirmation_code;
  int? coupon_code;
  int? coupon_id;
  String? created_at;
  String? delivery_address;
  String? delivery_city;
  String? delivery_phone;
  String? delivery_state;
  String? delivery_zipcode;
  int? discount;
  int? id;
  String? note;
  List<OrderItem>? order_items;
  int? order_number;
  int? order_ready_status;
  int? order_ready_time;
  int? orginal_price;
  int? payment_id;
  String? point_map;
  String? shipping_carrier;
  int? shipping_fee;
  int? shipping_id;
  String? shipping_plan;
  String? shipping_tracking_number;
  String? status;
  int? tax;
  String? token;
  int? total;
  String? uid;
  User? user;
  int? user_address_id;
  int? user_id;

  OrderSendResult(
      {this.billing_name,
      this.confirmation_code,
      this.coupon_code,
      this.coupon_id,
      this.created_at,
      this.delivery_address,
      this.delivery_city,
      this.delivery_phone,
      this.delivery_state,
      this.delivery_zipcode,
      this.discount,
      this.id,
      this.note,
      this.order_items,
      this.order_number,
      this.order_ready_status,
      this.order_ready_time,
      this.orginal_price,
      this.payment_id,
      this.point_map,
      this.shipping_carrier,
      this.shipping_fee,
      this.shipping_id,
      this.shipping_plan,
      this.shipping_tracking_number,
      this.status,
      this.tax,
      this.token,
      this.total,
      this.uid,
      this.user,
      this.user_address_id,
      this.user_id});

  factory OrderSendResult.fromJson(Map<String, dynamic> json) {
    return OrderSendResult(
      billing_name: json['billing_name'],
      confirmation_code: json['confirmation_code'],
      coupon_code: json['coupon_code'],
      coupon_id: json['coupon_id'],
      created_at: json['created_at'],
      delivery_address: json['delivery_address'],
      delivery_city: json['delivery_city'],
      delivery_phone: json['delivery_phone'],
      delivery_state: json['delivery_state'],
      delivery_zipcode: json['delivery_zipcode'],
      discount: json['discount'],
      id: json['id'],
      note: json['note'],
      order_items: json['order_items'] != null
          ? (json['order_items'] as List)
              .map((i) => OrderItem.fromJson(i))
              .toList()
          : null,
      order_number: json['order_number'],
      order_ready_status: json['order_ready_status'],
      order_ready_time: json['order_ready_time'],
      orginal_price: json['orginal_price'],
      payment_id: json['payment_id'],
      point_map: json['point_map'],
      shipping_carrier: json['shipping_carrier'],
      shipping_fee: json['shipping_fee'],
      shipping_id: json['shipping_id'],
      shipping_plan: json['shipping_plan'],
      shipping_tracking_number: json['shipping_tracking_number'],
      status: json['status'],
      tax: json['tax'],
      token: json['token'],
      total: json['total'],
      uid: json['uid'],
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      user_address_id: json['user_address_id'],
      user_id: json['user_id'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['billing_name'] = this.billing_name;
    data['confirmation_code'] = this.confirmation_code;
    data['coupon_code'] = this.coupon_code;
    data['coupon_id'] = this.coupon_id;
    data['created_at'] = this.created_at;
    data['delivery_address'] = this.delivery_address;
    data['delivery_city'] = this.delivery_city;
    data['delivery_phone'] = this.delivery_phone;
    data['delivery_state'] = this.delivery_state;
    data['delivery_zipcode'] = this.delivery_zipcode;
    data['discount'] = this.discount;
    data['id'] = this.id;
    data['note'] = this.note;
    data['order_number'] = this.order_number;
    data['order_ready_status'] = this.order_ready_status;
    data['order_ready_time'] = this.order_ready_time;
    data['orginal_price'] = this.orginal_price;
    data['payment_id'] = this.payment_id;
    data['point_map'] = this.point_map;
    data['shipping_carrier'] = this.shipping_carrier;
    data['shipping_fee'] = this.shipping_fee;
    data['shipping_id'] = this.shipping_id;
    data['shipping_plan'] = this.shipping_plan;
    data['shipping_tracking_number'] = this.shipping_tracking_number;
    data['status'] = this.status;
    data['tax'] = this.tax;
    data['token'] = this.token;
    data['total'] = this.total;
    data['uid'] = this.uid;
    data['user_address_id'] = this.user_address_id;
    data['user_id'] = this.user_id;
    if (this.order_items != null) {
      data['order_items'] = this.order_items!.map((v) => v.toJson()).toList();
    }
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    return data;
  }
}

class OrderItem {
  int? aPD;
  String? created_at;
  int? iPD;
  int? id;
  int? leftAXI;
  int? leftCYL;
  int? leftNear;
  int? leftSPH;
  int? order_id;
  int? price;
  Product? product;
  int? product_id;
  int? quantity;
  int? rightAXI;
  int? rightCYL;
  int? rightNear;
  int? rightSPH;
  int? type_product;
  String? updated_at;
  int? user_id;

  OrderItem(
      {this.aPD,
      this.created_at,
      this.iPD,
      this.id,
      this.leftAXI,
      this.leftCYL,
      this.leftNear,
      this.leftSPH,
      this.order_id,
      this.price,
      this.product,
      this.product_id,
      this.quantity,
      this.rightAXI,
      this.rightCYL,
      this.rightNear,
      this.rightSPH,
      this.type_product,
      this.updated_at,
      this.user_id});

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      aPD: json['aPD'],
      created_at: json['created_at'],
      iPD: json['iPD'],
      id: json['id'],
      leftAXI: json['leftAXI'],
      leftCYL: json['leftCYL'],
      leftNear: json['leftNear'],
      leftSPH: json['leftSPH'],
      order_id: json['order_id'],
      price: json['price'],
      product:
          json['product'] != null ? Product.fromJson(json['product']) : null,
      product_id: json['product_id'],
      quantity: json['quantity'],
      rightAXI: json['rightAXI'],
      rightCYL: json['rightCYL'],
      rightNear: json['rightNear'],
      rightSPH: json['rightSPH'],
      type_product: json['type_product'],
      updated_at: json['updated_at'],
      user_id: json['user_id'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['aPD'] = this.aPD;
    data['created_at'] = this.created_at;
    data['iPD'] = this.iPD;
    data['id'] = this.id;
    data['leftAXI'] = this.leftAXI;
    data['leftCYL'] = this.leftCYL;
    data['leftNear'] = this.leftNear;
    data['leftSPH'] = this.leftSPH;
    data['order_id'] = this.order_id;
    data['price'] = this.price;
    data['product_id'] = this.product_id;
    data['quantity'] = this.quantity;
    data['rightAXI'] = this.rightAXI;
    data['rightCYL'] = this.rightCYL;
    data['rightNear'] = this.rightNear;
    data['rightSPH'] = this.rightSPH;
    data['type_product'] = this.type_product;
    data['updated_at'] = this.updated_at;
    data['user_id'] = this.user_id;
    if (this.product != null) {
      data['product'] = this.product!.toJson();
    }
    return data;
  }
}

class PhotoInfo {
  int? id;
  String? image;
  int? product_id;

  PhotoInfo({this.id, this.image, this.product_id});

  factory PhotoInfo.fromJson(Map<String, dynamic> json) {
    return PhotoInfo(
      id: json['id'],
      image: json['image'],
      product_id: json['product_id'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['image'] = this.image;
    data['product_id'] = this.product_id;
    return data;
  }
}

class ColorInfo {
  int? id;
  String? image;
  String? name;
  String? value;

  ColorInfo({this.id, this.image, this.name, this.value});

  factory ColorInfo.fromJson(Map<String, dynamic> json) {
    return ColorInfo(
      id: json['id'],
      image: json['image'],
      name: json['name'],
      value: json['value'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['image'] = this.image;
    data['name'] = this.name;
    data['value'] = this.value;
    return data;
  }
}

class Product {
  bool? avalability;
  BrandInfo? brandInfo;
  int? brand_id;
  int? category_id;
  String? description;
  int? discount_price;
  String? discount_type;
  int? discount_type_int;
  bool? featured;
  String? featuresList;
  int? frameShape;
  int? frameType;
  String? gender;
  int? gender_id;
  bool? hasCoponCode;
  int? id;
  bool? includinglenses;
  bool? isNew;
  String? lense;
  int? lenseType;
  bool? lensesFree;
  String? mainImage;
  int? markedFrames;
  int? material;
  String? name;
  List<PhotoInfo>? photoInfo;
  int? price;
  List<Productinfo>? productinfoList;
  bool? quality;
  String? rate;
  ShapeFrame? shapeFrame;
  ShopInfo? shopInfo;
  int? shop_id;
  String? status;
  int? type;
  String? type_product;

  Product(
      {this.avalability,
      this.brandInfo,
      this.brand_id,
      this.category_id,
      this.description,
      this.discount_price,
      this.discount_type,
      this.discount_type_int,
      this.featured,
      this.featuresList,
      this.frameShape,
      this.frameType,
      this.gender,
      this.gender_id,
      this.hasCoponCode,
      this.id,
      this.includinglenses,
      this.isNew,
      this.lense,
      this.lenseType,
      this.lensesFree,
      this.mainImage,
      this.markedFrames,
      this.material,
      this.name,
      this.photoInfo,
      this.price,
      this.productinfoList,
      this.quality,
      this.rate,
      this.shapeFrame,
      this.shopInfo,
      this.shop_id,
      this.status,
      this.type,
      this.type_product});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      avalability: json['avalability'],
      brandInfo: json['brandInfo'] != null
          ? BrandInfo.fromJson(json['brandInfo'])
          : null,
      brand_id: json['brand_id'],
      category_id: json['category_id'],
      description: json['description'],
      discount_price: json['discount_price'],
      discount_type: json['discount_type'],
      discount_type_int: json['discount_type_int'],
      featured: json['featured'],
      featuresList: json['featuresList'],
      frameShape: json['frameShape'],
      frameType: json['frameType'],
      gender: json['gender'],
      gender_id: json['gender_id'],
      hasCoponCode: json['hasCoponCode'],
      id: json['id'],
      includinglenses: json['includinglenses'],
      isNew: json['isNew'],
      lense: json['lense'],
      lenseType: json['lenseType'],
      lensesFree: json['lensesFree'],
      mainImage: json['mainImage'],
      markedFrames: json['markedFrames'],
      material: json['material'],
      name: json['name'],
      photoInfo: json['photoInfo'] != null
          ? (json['photoInfo'] as List)
              .map((i) => PhotoInfo.fromJson(i))
              .toList()
          : null,
      price: json['price'],
      productinfoList: json['productinfoList'] != null
          ? (json['productinfoList'] as List)
              .map((i) => Productinfo.fromJson(i))
              .toList()
          : null,
      quality: json['quality'],
      rate: json['rate'],
      shapeFrame: json['shapeFrame'] != null
          ? ShapeFrame.fromJson(json['shapeFrame'])
          : null,
      shopInfo:
          json['shopInfo'] != null ? ShopInfo.fromJson(json['shopInfo']) : null,
      shop_id: json['shop_id'],
      status: json['status'],
      type: json['type'],
      type_product: json['type_product'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['avalability'] = this.avalability;
    data['brand_id'] = this.brand_id;
    data['category_id'] = this.category_id;
    data['description'] = this.description;
    data['discount_price'] = this.discount_price;
    data['discount_type'] = this.discount_type;
    data['discount_type_int'] = this.discount_type_int;
    data['featured'] = this.featured;
    data['featuresList'] = this.featuresList;
    data['frameShape'] = this.frameShape;
    data['frameType'] = this.frameType;
    data['gender'] = this.gender;
    data['gender_id'] = this.gender_id;
    data['hasCoponCode'] = this.hasCoponCode;
    data['id'] = this.id;
    data['includinglenses'] = this.includinglenses;
    data['isNew'] = this.isNew;
    data['lense'] = this.lense;
    data['lenseType'] = this.lenseType;
    data['lensesFree'] = this.lensesFree;
    data['mainImage'] = this.mainImage;
    data['markedFrames'] = this.markedFrames;
    data['material'] = this.material;
    data['name'] = this.name;
    data['price'] = this.price;
    data['quality'] = this.quality;
    data['rate'] = this.rate;
    data['shop_id'] = this.shop_id;
    data['status'] = this.status;
    data['type'] = this.type;
    data['type_product'] = this.type_product;
    if (this.brandInfo != null) {
      data['brandInfo'] = this.brandInfo!.toJson();
    }
    if (this.photoInfo != null) {
      data['photoInfo'] = this.photoInfo!.map((v) => v.toJson()).toList();
    }
    if (this.productinfoList != null) {
      data['productinfoList'] =
          this.productinfoList!.map((v) => v.toJson()).toList();
    }
    if (this.shapeFrame != null) {
      data['shapeFrame'] = this.shapeFrame!.toJson();
    }
    if (this.shopInfo != null) {
      data['shopInfo'] = this.shopInfo!.toJson();
    }
    return data;
  }
}

class ShapeFaceInfo {
  int? id;
  String? image;
  String? name;
  String? value;

  ShapeFaceInfo({this.id, this.image, this.name, this.value});

  factory ShapeFaceInfo.fromJson(Map<String, dynamic> json) {
    return ShapeFaceInfo(
      id: json['id'],
      image: json['image'],
      name: json['name'],
      value: json['value'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['image'] = this.image;
    data['name'] = this.name;
    data['value'] = this.value;
    return data;
  }
}

class ShapeFrame {
  int? id;
  String? image;
  String? name;
  String? value;

  ShapeFrame({this.id, this.image, this.name, this.value});

  factory ShapeFrame.fromJson(Map<String, dynamic> json) {
    return ShapeFrame(
      id: json['id'],
      image: json['image'],
      name: json['name'],
      value: json['value'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['image'] = this.image;
    data['name'] = this.name;
    data['value'] = this.value;
    return data;
  }
}

class ShopInfo {
  int? id;
  String? name;

  ShopInfo({this.id, this.name});

  factory ShopInfo.fromJson(Map<String, dynamic> json) {
    return ShopInfo(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}

class BrandInfo {
  int? id;
  String? name;

  BrandInfo({this.id, this.name});

  factory BrandInfo.fromJson(Map<String, dynamic> json) {
    return BrandInfo(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}

class SizeFaceInfo {
  int? id;
  String? image;
  String? name;
  String? value;

  SizeFaceInfo({this.id, this.image, this.name, this.value});

  factory SizeFaceInfo.fromJson(Map<String, dynamic> json) {
    return SizeFaceInfo(
      id: json['id'],
      image: json['image'],
      name: json['name'],
      value: json['value'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['image'] = this.image;
    data['name'] = this.name;
    data['value'] = this.value;
    return data;
  }
}

class SizeModeInfo {
  int? id;
  String? image;
  String? name;
  String? value;

  SizeModeInfo({this.id, this.image, this.name, this.value});

  factory SizeModeInfo.fromJson(Map<String, dynamic> json) {
    return SizeModeInfo(
      id: json['id'],
      image: json['image'],
      name: json['name'],
      value: json['value'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['image'] = this.image;
    data['name'] = this.name;
    data['value'] = this.value;
    return data;
  }
}

class User {
  String? about_me;
  String? address;
  String? api_token;
  int? balance;
  Object? braintree_id;
  Object? card_brand;
  Object? card_last_four;
  String? credit;
  String? debit;
  Object? device_token;
  String? device_type;
  String? email;
  Object? email_verified_at;
  int? id;
  String? mobile;
  String? mobile_active;
  String? name;
  int? otp_code;
  Object? paypal_email;
  Object? permissions_id;
  String? phone;
  Object? photo;
  String? status;
  Object? stripe_id;
  Object? trial_ends_at;

  User(
      {this.about_me,
      this.address,
      this.api_token,
      this.balance,
      this.braintree_id,
      this.card_brand,
      this.card_last_four,
      this.credit,
      this.debit,
      this.device_token,
      this.device_type,
      this.email,
      this.email_verified_at,
      this.id,
      this.mobile,
      this.mobile_active,
      this.name,
      this.otp_code,
      this.paypal_email,
      this.permissions_id,
      this.phone,
      this.photo,
      this.status,
      this.stripe_id,
      this.trial_ends_at});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      about_me: json['about_me'],
      address: json['address'],
      api_token: json['api_token'],
      balance: json['balance'],
      braintree_id: null,
      card_brand: null,
      card_last_four: null,
      credit: json['credit'],
      debit: json['debit'],
      device_token: null,
      device_type: json['device_type'],
      email: json['email'],
      email_verified_at: null,
      id: json['id'],
      mobile: json['mobile'],
      mobile_active: json['mobile_active'],
      name: json['name'],
      otp_code: json['otp_code'],
      paypal_email: null,
      permissions_id: null,
      phone: json['phone'],
      photo: null,
      status: json['status'],
      stripe_id: null,
      trial_ends_at: null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['about_me'] = this.about_me;
    data['address'] = this.address;
    data['api_token'] = this.api_token;
    data['balance'] = this.balance;
    data['credit'] = this.credit;
    data['debit'] = this.debit;
    data['device_type'] = this.device_type;
    data['email'] = this.email;
    data['id'] = this.id;
    data['mobile'] = this.mobile;
    data['mobile_active'] = this.mobile_active;
    data['name'] = this.name;
    data['otp_code'] = this.otp_code;
    data['phone'] = this.phone;
    data['status'] = this.status;

    return data;
  }
}

class Productinfo {
  String? $180_img;
  String? $45_img;
  String? $90_img;
  int? bridgeWidth;
  int? category_id;
  ColorInfo? colorInfo;
  int? color_id;
  String? front_img;
  int? id;
  int? lensHeight;
  int? lensWidth;
  String? person_img;
  int? product_id;
  int? quantity;
  int? shapeFace;
  ShapeFaceInfo? shapeFaceInfo;
  int? sizeFace;
  SizeFaceInfo? sizeFaceInfo;
  int? sizeMode;
  SizeModeInfo? sizeModeInfo;
  int? templeLength;
  String? try_img;

  Productinfo(
      {this.$180_img,
      this.$45_img,
      this.$90_img,
      this.bridgeWidth,
      this.category_id,
      this.colorInfo,
      this.color_id,
      this.front_img,
      this.id,
      this.lensHeight,
      this.lensWidth,
      this.person_img,
      this.product_id,
      this.quantity,
      this.shapeFace,
      this.shapeFaceInfo,
      this.sizeFace,
      this.sizeFaceInfo,
      this.sizeMode,
      this.sizeModeInfo,
      this.templeLength,
      this.try_img});

  factory Productinfo.fromJson(Map<String, dynamic> json) {
    return Productinfo(
      $180_img: json['180_img'],
      $45_img: json['45_img'],
      $90_img: json['90_img'],
      bridgeWidth: json['bridgeWidth'],
      category_id: json['category_id'],
      colorInfo: json['colorInfo'] != null
          ? ColorInfo.fromJson(json['colorInfo'])
          : null,
      color_id: json['color_id'],
      front_img: json['front_img'],
      id: json['id'],
      lensHeight: json['lensHeight'],
      lensWidth: json['lensWidth'],
      person_img: json['person_img'],
      product_id: json['product_id'],
      quantity: json['quantity'],
      shapeFace: json['shapeFace'],
      shapeFaceInfo: json['shapeFaceInfo'] != null
          ? ShapeFaceInfo.fromJson(json['shapeFaceInfo'])
          : null,
      sizeFace: json['sizeFace'],
      sizeFaceInfo: json['sizeFaceInfo'] != null
          ? SizeFaceInfo.fromJson(json['sizeFaceInfo'])
          : null,
      sizeMode: json['sizeMode'],
      sizeModeInfo: json['sizeModeInfo'] != null
          ? SizeModeInfo.fromJson(json['sizeModeInfo'])
          : null,
      templeLength: json['templeLength'],
      try_img: json['try_img'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['180_img'] = this.$180_img;
    data['45_img'] = this.$45_img;
    data['90_img'] = this.$90_img;
    data['bridgeWidth'] = this.bridgeWidth;
    data['category_id'] = this.category_id;
    data['color_id'] = this.color_id;
    data['front_img'] = this.front_img;
    data['id'] = this.id;
    data['lensHeight'] = this.lensHeight;
    data['lensWidth'] = this.lensWidth;
    data['person_img'] = this.person_img;
    data['product_id'] = this.product_id;
    data['quantity'] = this.quantity;
    data['shapeFace'] = this.shapeFace;
    data['sizeFace'] = this.sizeFace;
    data['sizeMode'] = this.sizeMode;
    data['templeLength'] = this.templeLength;
    data['try_img'] = this.try_img;
    if (this.colorInfo != null) {
      data['colorInfo'] = this.colorInfo!.toJson();
    }
    if (this.shapeFaceInfo != null) {
      data['shapeFaceInfo'] = this.shapeFaceInfo!.toJson();
    }
    if (this.sizeFaceInfo != null) {
      data['sizeFaceInfo'] = this.sizeFaceInfo!.toJson();
    }
    if (this.sizeModeInfo != null) {
      data['sizeModeInfo'] = this.sizeModeInfo!.toJson();
    }
    return data;
  }
}
