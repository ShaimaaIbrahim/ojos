// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderRequest _$OrderRequestFromJson(Map<String, dynamic> json) {
  return OrderRequest(
    tax: json['tax'] as int?,
    total: json['total'] as int?,
    shipping_fee: json['shipping_fee'] as int?,
    orginal_price: json['orginal_price'] as int?,
    price_discount: json['price_discount'] as int?,
    coupon_id: json['coupon_id'] as int?,
    note: json['note'] as String?,
    point_map: json['point_map'] as String?,
    city_id: json['city_id'] as int?,
    couponcode: json['couponcode'] as String?,
    listorder: (json['listorder'] as List<dynamic>?)
        ?.map((e) => ProductOrderRequest.fromJson(e as Map<String, dynamic>))
        .toList(),
    method_id: json['method_id'] as int?,
    user_address_id: json['user_address_id'] as int?,
    card: json['card'] == null
        ? null
        : CardOrderRequest.fromJson(json['card'] as Map<String, dynamic>),
    delivery: json['delivery'] == null
        ? null
        : DeliveryOrderRequest.fromJson(
            json['delivery'] as Map<String, dynamic>),
    shipping_id: json['shipping_id'] as int?, lenses_img: json['lenses_img'],
  );
}

Map<String, dynamic> _$OrderRequestToJson(OrderRequest instance) =>
    <String, dynamic>{
      'user_address_id': instance.user_address_id,
      'shipping_id': instance.shipping_id,
      'method_id': instance.method_id,
      'city_id': instance.city_id,
      'orginal_price': instance.orginal_price,
      'price_discount': instance.price_discount,
      'tax': instance.tax,
      'shipping_fee': instance.shipping_fee,
      'total': instance.total,
      'point_map': instance.point_map,
      'note': instance.note,
      'coupon_id': instance.coupon_id,
      'couponcode': instance.couponcode,
      'listorder': instance.listorder,
      'card': instance.card,
      'delivery': instance.delivery,
      'lenses_img': instance.lenses_img
    };

ProductOrderRequest _$ProductOrderRequestFromJson(Map<String, dynamic> json) {
  return ProductOrderRequest(
      price: (json['price'] as num?)?.toDouble(),
      type_product: json['type_product'] as int?,
      product_id: json['product_id'] as int?,
      Is_Glasses: json['Is_Glasses'] as int?,
      color_id: json['color_id'] as int?,
      brand_id: json['brand_id'] as int?,
      quantity: json['quantity'] as int?,
      RightSPH: json['RightSPH'] as int?,
      RightCYL: json['RightCYL'] as int?,
      RightAXI: json['RightAXI'] as int?,
      LeftSPH: json['LeftSPH'] as int?,
      LeftCYL: json['LeftCYL'] as int?,
      LeftAXI: json['LeftAXI'] as int?,
      APD: json['APD'] as int?,
      IPD: json['IPD'] as int?);
}

Map<String, dynamic> _$ProductOrderRequestToJson(
        ProductOrderRequest instance) =>
    <String, dynamic>{
      'product_id': instance.product_id,
      'type_product': instance.type_product,
      'quantity': instance.quantity,
      'Is_Glasses': instance.Is_Glasses,
      'color_id': instance.color_id,
      'brand_id': instance.brand_id,
      'price': instance.price,
      'RightSPH': instance.RightSPH,
      'RightCYL': instance.RightCYL,
      'RightAXI': instance.RightAXI,
      'LeftSPH': instance.LeftSPH,
      'LeftCYL': instance.LeftCYL,
      'LeftAXI': instance.LeftAXI,
      'APD': instance.APD,
      'IPD': instance.IPD
    };

DeliveryOrderRequest _$DeliveryOrderRequestFromJson(Map<String, dynamic> json) {
  return DeliveryOrderRequest(
    delivery_address: json['delivery_address'] as String?,
    delivery_city: json['delivery_city'] as String?,
    delivery_phone: json['delivery_phone'] as String?,
    delivery_state: json['delivery_state'] as String?,
    delivery_zipcode: json['delivery_zipcode'] as String?,
  );
}

Map<String, dynamic> _$DeliveryOrderRequestToJson(
        DeliveryOrderRequest instance) =>
    <String, dynamic>{
      'delivery_address': instance.delivery_address,
      'delivery_city': instance.delivery_city,
      'delivery_state': instance.delivery_state,
      'delivery_zipcode': instance.delivery_zipcode,
      'delivery_phone': instance.delivery_phone,
    };

CardOrderRequest _$CardOrderRequestFromJson(Map<String, dynamic> json) {
  return CardOrderRequest(
    number: json['number'] as String?,
    cvc: json['cvc'] as String?,
    exp_month: json['exp_month'] as String?,
    exp_year: json['exp_year'] as String?,
  );
}

Map<String, dynamic> _$CardOrderRequestToJson(CardOrderRequest instance) =>
    <String, dynamic>{
      'number': instance.number,
      'exp_month': instance.exp_month,
      'exp_year': instance.exp_year,
      'cvc': instance.cvc,
    };
