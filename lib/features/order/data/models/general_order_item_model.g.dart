// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'general_order_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GeneralOrderItemModel _$GeneralOrderItemModelFromJson(
    Map<String, dynamic> json) {
  return GeneralOrderItemModel(
    id: json['id'] as int?,
    user_id: json['user_id'] as int?,
    total: json['total'] as int?,
    discount: json['discount'] as int?,
    status: json['status'] as String?,
    city: json['city'] == null
        ? null
        : CityOrderModel.fromJson(json['city'] as Map<String, dynamic>),
    orderimage: json['orderimage'] as String?,
    statusint: json['statusint'] as int?,
    billing_name: json['billing_name'] as String?,
    coupon_id: json['coupon_id'] as int?,
    delivery_address: json['delivery_address'] as String?,
    delivery_city: json['delivery_city'] as String?,
    delivery_phone: json['delivery_phone'] as String?,
    delivery_state: json['delivery_state'] as String?,
    paymentmehtod: json['paymentmehtod'] as String?,
    delivery_zipcode: json['delivery_zipcode'] as String?,
    note: json['note'] as String?,
    order_items: (json['order_items'] as List<dynamic>?)
        ?.map((e) => OrderItemModel.fromJson(e as Map<String, dynamic>))
        .toList(),
    order_number: json['order_number'] as String?,
    orginal_price: (json['orginal_price'] as num?)?.toDouble(),
    payment_id: json['payment_id'] as int?,
    point_map: json['point_map'] as String?,
    price_discount: json['price_discount'] as int?,
    shipping_fee: json['shipping_fee'] as int?,
    shipping_id: json['shipping_id'] as int?,
    shippingcarrier: json['shippingcarrier'] == null
        ? null
        : ItemModel.fromJson(json['shippingcarrier'] as Map<String, dynamic>),
    tax: json['tax'] as int?,
    uid: json['uid'] as String?,
    user_address: json['user_address'] == null
        ? null
        : UserAddressModel.fromJson(
            json['user_address'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$GeneralOrderItemModelToJson(
        GeneralOrderItemModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'uid': instance.uid,
      'order_number': instance.order_number,
      'user_id': instance.user_id,
      'payment_id': instance.payment_id,
      'coupon_id': instance.coupon_id,
      'shipping_id': instance.shipping_id,
      'shipping_fee': instance.shipping_fee,
      'note': instance.note,
      'price_discount': instance.price_discount,
      'orginal_price': instance.orginal_price,
      'tax': instance.tax,
      'discount': instance.discount,
      'total': instance.total,
      'paymentmehtod': instance.paymentmehtod,
      'delivery_address': instance.delivery_address,
      'delivery_city': instance.delivery_city,
      'delivery_state': instance.delivery_state,
      'delivery_zipcode': instance.delivery_zipcode,
      'delivery_phone': instance.delivery_phone,
      'billing_name': instance.billing_name,
      'point_map': instance.point_map,
      'status': instance.status,
      'statusint': instance.statusint,
      'orderimage': instance.orderimage,
      'shippingcarrier': instance.shippingcarrier,
      'user_address': instance.user_address,
      'order_items': instance.order_items,
      'city': instance.city,
    };
