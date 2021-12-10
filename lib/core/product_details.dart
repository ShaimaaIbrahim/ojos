class ProductDetails {
  bool? avalability;
  int? brand_id;
  Brandinfo? brandinfo;
  int? category_id;
  List<Colorinfo>? colorinfo;
  String? description;
  int? discount_price;
  String? discount_type;
  int? discount_type_int;
  List<Faceshapeinfo>? faceshapeinfo;
  bool? featured;
  String? frameShape;
  int? frame_height;
  int? frame_length;
  int? frame_width;
  String? gender;
  int? gender_id;
  bool? hasCoponCode;
  int? id;
  bool? isFavorite;
  bool? isNew;
  bool? isReview;
  bool? is_Glasses;
  int? lens_height;
  int? lens_width;
  bool? lensesFree;
  String? mainImage;
  String? name;
  List<Photoinfo>? photoinfo;
  int? price;
  String? price_after_discount;
  List<ProductAsSame>? product_as_same;
  List<Object>? product_reviews;
  int? product_reviews_count;
  String? rate;
  List<Shapeframeinfo>? shapeframeinfo;
  int? shop_id;
  ShopinfoX? shopinfo;
  List<Sizefaceinfo>? sizefaceinfo;
  List<Sizesinfo>? sizesinfo;
  int? type;
  String? type_product;

  ProductDetails(
      {this.avalability,
      this.brand_id,
      this.brandinfo,
      this.category_id,
      this.colorinfo,
      this.description,
      this.discount_price,
      this.discount_type,
      this.discount_type_int,
      this.faceshapeinfo,
      this.featured,
      this.frameShape,
      this.frame_height,
      this.frame_length,
      this.frame_width,
      this.gender,
      this.gender_id,
      this.hasCoponCode,
      this.id,
      this.isFavorite,
      this.isNew,
      this.isReview,
      this.is_Glasses,
      this.lens_height,
      this.lens_width,
      this.lensesFree,
      this.mainImage,
      this.name,
      this.photoinfo,
      this.price,
      this.price_after_discount,
      this.product_as_same,
      this.product_reviews,
      this.product_reviews_count,
      this.rate,
      this.shapeframeinfo,
      this.shop_id,
      this.shopinfo,
      this.sizefaceinfo,
      this.sizesinfo,
      this.type,
      this.type_product});

  factory ProductDetails.fromJson(Map<String, dynamic> json) {
    return ProductDetails(
      avalability: json['avalability'],
      brand_id: json['brand_id'],
      brandinfo: json['brandinfo'] != null
          ? Brandinfo.fromJson(json['brandinfo'])
          : null,
      category_id: json['category_id'],
      colorinfo: json['colorinfo'] != null
          ? (json['colorinfo'] as List)
              .map((i) => Colorinfo.fromJson(i))
              .toList()
          : null,
      description: json['description'],
      discount_price: json['discount_price'],
      discount_type: json['discount_type'],
      discount_type_int: json['discount_type_int'],
      faceshapeinfo: json['faceshapeinfo'] != null
          ? (json['faceshapeinfo'] as List)
              .map((i) => Faceshapeinfo.fromJson(i))
              .toList()
          : null,
      featured: json['featured'],
      frameShape: json['frameShape'],
      frame_height: json['frame_height'],
      frame_length: json['frame_length'],
      frame_width: json['frame_width'],
      gender: json['gender'],
      gender_id: json['gender_id'],
      hasCoponCode: json['hasCoponCode'],
      id: json['id'],
      isFavorite: json['isFavorite'],
      isNew: json['isNew'],
      isReview: json['isReview'],
      is_Glasses: json['is_Glasses'],
      lens_height: json['lens_height'],
      lens_width: json['lens_width'],
      lensesFree: json['lensesFree'],
      mainImage: json['mainImage'],
      name: json['name'],
      photoinfo: json['photoinfo'] != null
          ? (json['photoinfo'] as List)
              .map((i) => Photoinfo.fromJson(i))
              .toList()
          : null,
      price: json['price'],
      price_after_discount: json['price_after_discount'],
      product_as_same: json['product_as_same'] != null
          ? (json['product_as_same'] as List)
              .map((i) => ProductAsSame.fromJson(i))
              .toList()
          : null,
      product_reviews: null,
      product_reviews_count: json['product_reviews_count'],
      rate: json['rate'],
      shapeframeinfo: json['shapeframeinfo'] != null
          ? (json['shapeframeinfo'] as List)
              .map((i) => Shapeframeinfo.fromJson(i))
              .toList()
          : null,
      shop_id: json['shop_id'],
      shopinfo: json['shopinfo'] != null
          ? ShopinfoX.fromJson(json['shopinfo'])
          : null,
      sizefaceinfo: json['sizefaceinfo'] != null
          ? (json['sizefaceinfo'] as List)
              .map((i) => Sizefaceinfo.fromJson(i))
              .toList()
          : null,
      sizesinfo: json['sizesinfo'] != null
          ? (json['sizesinfo'] as List)
              .map((i) => Sizesinfo.fromJson(i))
              .toList()
          : null,
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
    data['frameShape'] = this.frameShape;
    data['frame_height'] = this.frame_height;
    data['frame_length'] = this.frame_length;
    data['frame_width'] = this.frame_width;
    data['gender'] = this.gender;
    data['gender_id'] = this.gender_id;
    data['hasCoponCode'] = this.hasCoponCode;
    data['id'] = this.id;
    data['isFavorite'] = this.isFavorite;
    data['isNew'] = this.isNew;
    data['isReview'] = this.isReview;
    data['is_Glasses'] = this.is_Glasses;
    data['lens_height'] = this.lens_height;
    data['lens_width'] = this.lens_width;
    data['lensesFree'] = this.lensesFree;
    data['mainImage'] = this.mainImage;
    data['name'] = this.name;
    data['price'] = this.price;
    data['price_after_discount'] = this.price_after_discount;
    data['product_reviews_count'] = this.product_reviews_count;
    data['rate'] = this.rate;
    data['shop_id'] = this.shop_id;
    data['type'] = this.type;
    data['type_product'] = this.type_product;
    if (this.brandinfo != null) {
      data['brandinfo'] = this.brandinfo!.toJson();
    }
    if (this.colorinfo != null) {
      data['colorinfo'] = this.colorinfo!.map((v) => v.toJson()).toList();
    }
    if (this.faceshapeinfo != null) {
      data['faceshapeinfo'] =
          this.faceshapeinfo!.map((v) => v.toJson()).toList();
    }
    if (this.photoinfo != null) {
      data['photoinfo'] = this.photoinfo!.map((v) => v.toJson()).toList();
    }
    if (this.product_as_same != null) {
      data['product_as_same'] =
          this.product_as_same!.map((v) => v.toJson()).toList();
    }
    this.product_reviews = null;

    if (this.shapeframeinfo != null) {
      data['shapeframeinfo'] =
          this.shapeframeinfo!.map((v) => v.toJson()).toList();
    }
    if (this.shopinfo != null) {
      data['shopinfo'] = this.shopinfo!.toJson();
    }
    if (this.sizefaceinfo != null) {
      data['sizefaceinfo'] = this.sizefaceinfo!.map((v) => v.toJson()).toList();
    }
    if (this.sizesinfo != null) {
      data['sizesinfo'] = this.sizesinfo!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Colorinfo {
  int? id;
  String? image;
  String? name;
  PivotXX? pivot;
  String? value;

  Colorinfo({this.id, this.image, this.name, this.pivot, this.value});

  factory Colorinfo.fromJson(Map<String, dynamic> json) {
    return Colorinfo(
      id: json['id'],
      image: json['image'],
      name: json['name'],
      pivot: json['pivot'] != null ? PivotXX.fromJson(json['pivot']) : null,
      value: json['value'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['image'] = this.image;
    data['name'] = this.name;
    data['value'] = this.value;
    if (this.pivot != null) {
      data['pivot'] = this.pivot!.toJson();
    }
    return data;
  }
}

class SizesinfoX {
  int? id;
  String? image;
  String? name;
  PivotXXXXXX? pivot;
  String? value;

  SizesinfoX({this.id, this.image, this.name, this.pivot, this.value});

  factory SizesinfoX.fromJson(Map<String, dynamic> json) {
    return SizesinfoX(
      id: json['id'],
      image: json['image'],
      name: json['name'],
      pivot: json['pivot'] != null ? PivotXXXXXX.fromJson(json['pivot']) : null,
      value: json['value'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['image'] = this.image;
    data['name'] = this.name;
    data['value'] = this.value;
    if (this.pivot != null) {
      data['pivot'] = this.pivot!.toJson();
    }
    return data;
  }
}

class Sizesinfo {
  int? id;
  String? image;
  String? name;
  Pivot? pivot;
  String? value;

  Sizesinfo({this.id, this.image, this.name, this.pivot, this.value});

  factory Sizesinfo.fromJson(Map<String, dynamic> json) {
    return Sizesinfo(
      id: json['id'],
      image: json['image'],
      name: json['name'],
      pivot: json['pivot'] != null ? Pivot.fromJson(json['pivot']) : null,
      value: json['value'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['image'] = this.image;
    data['name'] = this.name;
    data['value'] = this.value;
    if (this.pivot != null) {
      data['pivot'] = this.pivot!.toJson();
    }
    return data;
  }
}

class SizefaceinfoX {
  int? id;
  String? image;
  String? name;
  PivotXXXXXXXXX? pivot;
  String? value;

  SizefaceinfoX({this.id, this.image, this.name, this.pivot, this.value});

  factory SizefaceinfoX.fromJson(Map<String, dynamic> json) {
    return SizefaceinfoX(
      id: json['id'],
      image: json['image'],
      name: json['name'],
      pivot:
          json['pivot'] != null ? PivotXXXXXXXXX.fromJson(json['pivot']) : null,
      value: json['value'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['image'] = this.image;
    data['name'] = this.name;
    data['value'] = this.value;
    if (this.pivot != null) {
      data['pivot'] = this.pivot!.toJson();
    }
    return data;
  }
}

class Sizefaceinfo {
  int? id;
  String? image;
  String? name;
  PivotXXX? pivot;
  String? value;

  Sizefaceinfo({this.id, this.image, this.name, this.pivot, this.value});

  factory Sizefaceinfo.fromJson(Map<String, dynamic> json) {
    return Sizefaceinfo(
      id: json['id'],
      image: json['image'],
      name: json['name'],
      pivot: json['pivot'] != null ? PivotXXX.fromJson(json['pivot']) : null,
      value: json['value'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['image'] = this.image;
    data['name'] = this.name;
    data['value'] = this.value;
    if (this.pivot != null) {
      data['pivot'] = this.pivot!.toJson();
    }
    return data;
  }
}

class ShopinfoX {
  int? id;
  String? name;

  ShopinfoX({this.id, this.name});

  factory ShopinfoX.fromJson(Map<String, dynamic> json) {
    return ShopinfoX(
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

class Shapeframeinfo {
  int? id;
  String? image;
  String? name;
  PivotX? pivot;
  String? value;

  Shapeframeinfo({this.id, this.image, this.name, this.pivot, this.value});

  factory Shapeframeinfo.fromJson(Map<String, dynamic> json) {
    return Shapeframeinfo(
      id: json['id'],
      image: json['image'],
      name: json['name'],
      pivot: json['pivot'] != null ? PivotX.fromJson(json['pivot']) : null,
      value: json['value'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['image'] = this.image;
    data['name'] = this.name;
    data['value'] = this.value;
    if (this.pivot != null) {
      data['pivot'] = this.pivot!.toJson();
    }
    return data;
  }
}

class ShapeframeinfoX {
  int? id;
  String? image;
  String? name;
  PivotXXXXX? pivot;
  String? value;

  ShapeframeinfoX({this.id, this.image, this.name, this.pivot, this.value});

  factory ShapeframeinfoX.fromJson(Map<String, dynamic> json) {
    return ShapeframeinfoX(
      id: json['id'],
      image: json['image'],
      name: json['name'],
      pivot: json['pivot'] != null ? PivotXXXXX.fromJson(json['pivot']) : null,
      value: json['value'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['image'] = this.image;
    data['name'] = this.name;
    data['value'] = this.value;
    if (this.pivot != null) {
      data['pivot'] = this.pivot!.toJson();
    }
    return data;
  }
}

class PivotXXXXXXXXX {
  String? extraglasses_id;
  String? product_id;

  PivotXXXXXXXXX({this.extraglasses_id, this.product_id});

  factory PivotXXXXXXXXX.fromJson(Map<String, dynamic> json) {
    return PivotXXXXXXXXX(
      extraglasses_id: json['extraglasses_id'],
      product_id: json['product_id'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['extraglasses_id'] = this.extraglasses_id;
    data['product_id'] = this.product_id;
    return data;
  }
}

class PivotXXXXXXXX {
  String? extraglasses_id;
  String? product_id;

  PivotXXXXXXXX({this.extraglasses_id, this.product_id});

  factory PivotXXXXXXXX.fromJson(Map<String, dynamic> json) {
    return PivotXXXXXXXX(
      extraglasses_id: json['extraglasses_id'],
      product_id: json['product_id'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['extraglasses_id'] = this.extraglasses_id;
    data['product_id'] = this.product_id;
    return data;
  }
}

class PivotXXXXXXX {
  String? extraglasses_id;
  String? product_id;

  PivotXXXXXXX({this.extraglasses_id, this.product_id});

  factory PivotXXXXXXX.fromJson(Map<String, dynamic> json) {
    return PivotXXXXXXX(
      extraglasses_id: json['extraglasses_id'],
      product_id: json['product_id'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['extraglasses_id'] = this.extraglasses_id;
    data['product_id'] = this.product_id;
    return data;
  }
}

class PivotXXXXXX {
  String? extraglasses_id;
  String? product_id;

  PivotXXXXXX({this.extraglasses_id, this.product_id});

  factory PivotXXXXXX.fromJson(Map<String, dynamic> json) {
    return PivotXXXXXX(
      extraglasses_id: json['extraglasses_id'],
      product_id: json['product_id'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['extraglasses_id'] = this.extraglasses_id;
    data['product_id'] = this.product_id;
    return data;
  }
}

class PivotXXXXX {
  String? extraglasses_id;
  String? product_id;

  PivotXXXXX({this.extraglasses_id, this.product_id});

  factory PivotXXXXX.fromJson(Map<String, dynamic> json) {
    return PivotXXXXX(
      extraglasses_id: json['extraglasses_id'],
      product_id: json['product_id'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['extraglasses_id'] = this.extraglasses_id;
    data['product_id'] = this.product_id;
    return data;
  }
}

class PivotXXXX {
  String? extraglasses_id;
  String? product_id;

  PivotXXXX({this.extraglasses_id, this.product_id});

  factory PivotXXXX.fromJson(Map<String, dynamic> json) {
    return PivotXXXX(
      extraglasses_id: json['extraglasses_id'],
      product_id: json['product_id'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['extraglasses_id'] = this.extraglasses_id;
    data['product_id'] = this.product_id;
    return data;
  }
}

class PivotXXX {
  String? extraglasses_id;
  String? product_id;

  PivotXXX({this.extraglasses_id, this.product_id});

  factory PivotXXX.fromJson(Map<String, dynamic> json) {
    return PivotXXX(
      extraglasses_id: json['extraglasses_id'],
      product_id: json['product_id'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['extraglasses_id'] = this.extraglasses_id;
    data['product_id'] = this.product_id;
    return data;
  }
}

class PivotXX {
  String? extraglasses_id;
  String? product_id;

  PivotXX({this.extraglasses_id, this.product_id});

  factory PivotXX.fromJson(Map<String, dynamic> json) {
    return PivotXX(
      extraglasses_id: json['extraglasses_id'],
      product_id: json['product_id'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['extraglasses_id'] = this.extraglasses_id;
    data['product_id'] = this.product_id;
    return data;
  }
}

class PivotX {
  String? extraglasses_id;
  String? product_id;

  PivotX({this.extraglasses_id, this.product_id});

  factory PivotX.fromJson(Map<String, dynamic> json) {
    return PivotX(
      extraglasses_id: json['extraglasses_id'],
      product_id: json['product_id'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['extraglasses_id'] = this.extraglasses_id;
    data['product_id'] = this.product_id;
    return data;
  }
}

class Pivot {
  String? extraglasses_id;
  String? product_id;

  Pivot({this.extraglasses_id, this.product_id});

  factory Pivot.fromJson(Map<String, dynamic> json) {
    return Pivot(
      extraglasses_id: json['extraglasses_id'],
      product_id: json['product_id'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['extraglasses_id'] = this.extraglasses_id;
    data['product_id'] = this.product_id;
    return data;
  }
}

class PhotoinfoX {
  int? id;
  String? image;
  String? product_id;

  PhotoinfoX({this.id, this.image, this.product_id});

  factory PhotoinfoX.fromJson(Map<String, dynamic> json) {
    return PhotoinfoX(
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

class Photoinfo {
  int? id;
  String? image;
  String? product_id;

  Photoinfo({this.id, this.image, this.product_id});

  factory Photoinfo.fromJson(Map<String, dynamic> json) {
    return Photoinfo(
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

class FaceshapeinfoX {
  int? id;
  String? image;
  String? name;
  PivotXXXXXXX? pivot;
  String? value;

  FaceshapeinfoX({this.id, this.image, this.name, this.pivot, this.value});

  factory FaceshapeinfoX.fromJson(Map<String, dynamic> json) {
    return FaceshapeinfoX(
      id: json['id'],
      image: json['image'],
      name: json['name'],
      pivot:
          json['pivot'] != null ? PivotXXXXXXX.fromJson(json['pivot']) : null,
      value: json['value'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['image'] = this.image;
    data['name'] = this.name;
    data['value'] = this.value;
    if (this.pivot != null) {
      data['pivot'] = this.pivot!.toJson();
    }
    return data;
  }
}

class Faceshapeinfo {
  int? id;
  String? image;
  String? name;
  PivotXXXX? pivot;
  String? value;

  Faceshapeinfo({this.id, this.image, this.name, this.pivot, this.value});

  factory Faceshapeinfo.fromJson(Map<String, dynamic> json) {
    return Faceshapeinfo(
      id: json['id'],
      image: json['image'],
      name: json['name'],
      pivot: json['pivot'] != null ? PivotXXXX.fromJson(json['pivot']) : null,
      value: json['value'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['image'] = this.image;
    data['name'] = this.name;
    data['value'] = this.value;
    if (this.pivot != null) {
      data['pivot'] = this.pivot!.toJson();
    }
    return data;
  }
}

class ColorinfoX {
  int? id;
  String? image;
  String? name;
  PivotXXXXXXXX? pivot;
  String? value;

  ColorinfoX({this.id, this.image, this.name, this.pivot, this.value});

  factory ColorinfoX.fromJson(Map<String, dynamic> json) {
    return ColorinfoX(
      id: json['id'],
      image: json['image'],
      name: json['name'],
      pivot:
          json['pivot'] != null ? PivotXXXXXXXX.fromJson(json['pivot']) : null,
      value: json['value'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['image'] = this.image;
    data['name'] = this.name;
    data['value'] = this.value;
    if (this.pivot != null) {
      data['pivot'] = this.pivot!.toJson();
    }
    return data;
  }
}

class BrandinfoX {
  int? id;
  String? name;

  BrandinfoX({this.id, this.name});

  factory BrandinfoX.fromJson(Map<String, dynamic> json) {
    return BrandinfoX(
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

class Brandinfo {
  int? id;
  String? name;

  Brandinfo({this.id, this.name});

  factory Brandinfo.fromJson(Map<String, dynamic> json) {
    return Brandinfo(
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

class Shopinfo {
  int? id;
  String? name;

  Shopinfo({this.id, this.name});

  factory Shopinfo.fromJson(Map<String, dynamic> json) {
    return Shopinfo(
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

class ProductAsSame {
  bool? avalability;
  int? brand_id;
  BrandinfoX? brandinfo;
  int? category_id;
  List<Colorinfo>? colorinfo;
  String? description;
  int? discount_price;
  String? discount_type;
  int? discount_type_int;
  List<Faceshapeinfo>? faceshapeinfo;
  bool? featured;
  String? featuresList;
  String? frameShape;
  String? frameType;
  int? frame_height;
  int? frame_length;
  int? frame_width;
  String? gender;
  int? gender_id;
  bool? hasCoponCode;
  int? id;
  bool? includinglenses;
  bool? isFavorite;
  bool? isNew;
  bool? isReview;
  bool? is_Glasses;
  int? lens_height;
  int? lens_width;
  String? lense;
  String? lenseType;
  bool? lensesFree;
  String? mainImage;
  String? markedFrames;
  String? material;
  String? name;
  List<PhotoinfoX>? photoinfo;
  int? price;
  String? price_after_discount;
  List<Object>? product_reviews;
  int? product_reviews_count;
  bool? quality;
  String? rate;
  List<ShapeframeinfoX>? shapeframeinfo;
  int? shop_id;
  ShopinfoX? shopinfo;
  List<Sizefaceinfo>? sizefaceinfo;
  List<SizesinfoX>? sizesinfo;
  String? status;
  int? type;
  String? type_product;

  ProductAsSame(
      {this.avalability,
      this.brand_id,
      this.brandinfo,
      this.category_id,
      this.colorinfo,
      this.description,
      this.discount_price,
      this.discount_type,
      this.discount_type_int,
      this.faceshapeinfo,
      this.featured,
      this.featuresList,
      this.frameShape,
      this.frameType,
      this.frame_height,
      this.frame_length,
      this.frame_width,
      this.gender,
      this.gender_id,
      this.hasCoponCode,
      this.id,
      this.includinglenses,
      this.isFavorite,
      this.isNew,
      this.isReview,
      this.is_Glasses,
      this.lens_height,
      this.lens_width,
      this.lense,
      this.lenseType,
      this.lensesFree,
      this.mainImage,
      this.markedFrames,
      this.material,
      this.name,
      this.photoinfo,
      this.price,
      this.price_after_discount,
      this.product_reviews,
      this.product_reviews_count,
      this.quality,
      this.rate,
      this.shapeframeinfo,
      this.shop_id,
      this.shopinfo,
      this.sizefaceinfo,
      this.sizesinfo,
      this.status,
      this.type,
      this.type_product});

  factory ProductAsSame.fromJson(Map<String, dynamic> json) {
    return ProductAsSame(
      avalability: json['avalability'],
      brand_id: json['brand_id'],
      brandinfo: json['brandinfo'] != null
          ? BrandinfoX.fromJson(json['brandinfo'])
          : null,
      category_id: json['category_id'],
      colorinfo: json['colorinfo'] != null
          ? (json['colorinfo'] as List)
              .map((i) => Colorinfo.fromJson(i))
              .toList()
          : null,
      description: json['description'],
      discount_price: json['discount_price'],
      discount_type: json['discount_type'],
      discount_type_int: json['discount_type_int'],
      faceshapeinfo: json['faceshapeinfo'] != null
          ? (json['faceshapeinfo'] as List)
              .map((i) => Faceshapeinfo.fromJson(i))
              .toList()
          : null,
      featured: json['featured'],
      featuresList: json['featuresList'],
      frameShape: json['frameShape'],
      frameType: json['frameType'],
      frame_height: json['frame_height'],
      frame_length: json['frame_length'],
      frame_width: json['frame_width'],
      gender: json['gender'],
      gender_id: json['gender_id'],
      hasCoponCode: json['hasCoponCode'],
      id: json['id'],
      includinglenses: json['includinglenses'],
      isFavorite: json['isFavorite'],
      isNew: json['isNew'],
      isReview: json['isReview'],
      is_Glasses: json['is_Glasses'],
      lens_height: json['lens_height'],
      lens_width: json['lens_width'],
      lense: json['lense'],
      lenseType: json['lenseType'],
      lensesFree: json['lensesFree'],
      mainImage: json['mainImage'],
      markedFrames: json['markedFrames'],
      material: json['material'],
      name: json['name'],
      photoinfo: json['photoinfo'] != null
          ? (json['photoinfo'] as List)
              .map((i) => PhotoinfoX.fromJson(i))
              .toList()
          : null,
      price: json['price'],
      price_after_discount: json['price_after_discount'],
      product_reviews: null,
      product_reviews_count: json['product_reviews_count'],
      quality: json['quality'],
      rate: json['rate'],
      shapeframeinfo: json['shapeframeinfo'] != null
          ? (json['shapeframeinfo'] as List)
              .map((i) => ShapeframeinfoX.fromJson(i))
              .toList()
          : null,
      shop_id: json['shop_id'],
      shopinfo: json['shopinfo'] != null
          ? ShopinfoX.fromJson(json['shopinfo'])
          : null,
      sizefaceinfo: json['sizefaceinfo'] != null
          ? (json['sizefaceinfo'] as List)
              .map((i) => Sizefaceinfo.fromJson(i))
              .toList()
          : null,
      sizesinfo: json['sizesinfo'] != null
          ? (json['sizesinfo'] as List)
              .map((i) => SizesinfoX.fromJson(i))
              .toList()
          : null,
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
    data['frame_height'] = this.frame_height;
    data['frame_length'] = this.frame_length;
    data['frame_width'] = this.frame_width;
    data['gender'] = this.gender;
    data['gender_id'] = this.gender_id;
    data['hasCoponCode'] = this.hasCoponCode;
    data['id'] = this.id;
    data['includinglenses'] = this.includinglenses;
    data['isFavorite'] = this.isFavorite;
    data['isNew'] = this.isNew;
    data['isReview'] = this.isReview;
    data['is_Glasses'] = this.is_Glasses;
    data['lens_height'] = this.lens_height;
    data['lens_width'] = this.lens_width;
    data['lense'] = this.lense;
    data['lenseType'] = this.lenseType;
    data['lensesFree'] = this.lensesFree;
    data['mainImage'] = this.mainImage;
    data['markedFrames'] = this.markedFrames;
    data['material'] = this.material;
    data['name'] = this.name;
    data['price'] = this.price;
    data['price_after_discount'] = this.price_after_discount;
    data['product_reviews_count'] = this.product_reviews_count;
    data['quality'] = this.quality;
    data['rate'] = this.rate;
    data['shop_id'] = this.shop_id;
    data['status'] = this.status;
    data['type'] = this.type;
    data['type_product'] = this.type_product;
    if (this.brandinfo != null) {
      data['brandinfo'] = this.brandinfo!.toJson();
    }
    if (this.colorinfo != null) {
      data['colorinfo'] = this.colorinfo!.map((v) => v.toJson()).toList();
    }
    if (this.faceshapeinfo != null) {
      data['faceshapeinfo'] =
          this.faceshapeinfo!.map((v) => v.toJson()).toList();
    }
    if (this.photoinfo != null) {
      data['photoinfo'] = this.photoinfo!.map((v) => v.toJson()).toList();
    }
    this.product_reviews = null;

    if (this.shapeframeinfo != null) {
      data['shapeframeinfo'] =
          this.shapeframeinfo!.map((v) => v.toJson()).toList();
    }
    if (this.shopinfo != null) {
      data['shopinfo'] = this.shopinfo!.toJson();
    }
    if (this.sizefaceinfo != null) {
      data['sizefaceinfo'] = this.sizefaceinfo!.map((v) => v.toJson()).toList();
    }
    if (this.sizesinfo != null) {
      data['sizesinfo'] = this.sizesinfo!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
