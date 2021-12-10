import 'package:ojos_app/features/cart/data/models/order_entity.dart';
import 'package:ojos_app/features/product/domin/entities/cart_entity.dart';

class CheckAndPayArgs {
  final String? totalPrice;
  final int? shipping_id;
  final int? city_id;
  final int? orginal_price;
  final int? price_discount;
  final int? tax;
  final int? shipping_fee;
  final int? total;
  final String? note;
  final String? point_map;
  final int? coupon_id;
  final int? paymentMethods;
  final String? couponcode;
  final List<CartEntity>? listOfOrder;
  final List<OrderEntity>? listOfOrderItems;

  const CheckAndPayArgs({
    this.listOfOrder,
    this.listOfOrderItems,
    this.totalPrice,
    this.couponcode,
    this.city_id,
    this.shipping_id,
    this.paymentMethods,
    this.point_map,
    this.note,
    this.coupon_id,
    this.orginal_price,
    this.shipping_fee,
    this.price_discount,
    this.total,
    this.tax,
  });
}
