import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'order_request.g.dart';

@JsonSerializable()
class OrderRequest {
  final int? user_address_id;
  final int? shipping_id;
  final int? method_id;
  final int? city_id;
  final int? orginal_price;
  final int? price_discount;
  final int? tax;
  final int? shipping_fee;
  final int? total;
  final String? point_map;
  final String? note;
  final int? coupon_id;
  final String? lenses_img;
  final String? couponcode;
  final List<ProductOrderRequest>? listorder;
  final CardOrderRequest? card;
  final DeliveryOrderRequest? delivery;

  OrderRequest(
      {required this.tax,
        required this.lenses_img,
        required this.total,
      required this.shipping_fee,
      required this.orginal_price,
      required this.price_discount,
      required this.coupon_id,
      required this.note,
      required this.point_map,
      required this.city_id,
      required this.couponcode,
      required this.listorder,
      required this.method_id,
      required this.user_address_id,
      required this.card,
      required this.delivery,
      required this.shipping_id});

  Map<String, dynamic> toJson() => _$OrderRequestToJson(this);
}

@JsonSerializable()
class ProductOrderRequest {
  int? product_id;
  int? type_product;

  int? quantity;
  double? price;

  int? Is_Glasses;
  int? color_id;

  int? brand_id;
  int? RightSPH;

  int? RightCYL;
  int? RightAXI;

  int? LeftSPH;
  int? LeftCYL;

  int? LeftAXI;

  int? APD;
  int? IPD;

  ProductOrderRequest(
      {this.product_id,
      this.type_product,
      this.quantity,
      this.price,
      this.brand_id,
      this.color_id,
      this.Is_Glasses,
      this.RightSPH,
      this.RightCYL,
      this.RightAXI,
      this.LeftSPH,
      this.LeftCYL,
      this.LeftAXI,
      this.APD,
      this.IPD});

  factory ProductOrderRequest.fromJson(Map<String, dynamic> json) =>
      _$ProductOrderRequestFromJson(json);

  Map<String, dynamic> toJson() => _$ProductOrderRequestToJson(this);
  @override
  String toString() {
    return this.toJson().toString();
  }
}

@JsonSerializable()
class DeliveryOrderRequest {
  final String? delivery_address;
  final String? delivery_city;
  final String? delivery_state;
  final String? delivery_zipcode;
  final String? delivery_phone;

  DeliveryOrderRequest({
    required this.delivery_address,
    required this.delivery_city,
    required this.delivery_phone,
    required this.delivery_state,
    required this.delivery_zipcode,
  });

  factory DeliveryOrderRequest.fromJson(Map<String, dynamic> json) =>
      _$DeliveryOrderRequestFromJson(json);

  Map<String, dynamic> toJson() => _$DeliveryOrderRequestToJson(this);

  @override
  String toString() {
    return this.toJson().toString();
  }
}

@JsonSerializable()
class CardOrderRequest {
  final String? number;
  final String? exp_month;
  final String? exp_year;
  final String? cvc;

  CardOrderRequest({
    required this.number,
    required this.cvc,
    required this.exp_month,
    required this.exp_year,
  });
  @override
  String toString() {
    return this.toJson().toString();
  }

  factory CardOrderRequest.fromJson(Map<String, dynamic> json) =>
      _$CardOrderRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CardOrderRequestToJson(this);
}
