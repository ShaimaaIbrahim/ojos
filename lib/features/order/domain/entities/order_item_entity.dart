import 'package:ojos_app/core/entities/base_entity.dart';
import 'package:ojos_app/features/product/domin/entities/product_entity.dart';

class OrderItemEntity extends BaseEntity {
  final int? id;
  final int? user_id;
  final int? order_id;
  final int? product_id;
  final int? type_product;
  final int? quantity;
  final int? price;
  final int? RightSPH;
  final int? RightCYL;
  final int? RightAXI;
  final int? RightNear;
  final int? LeftSPH;
  final int? LeftCYL;
  final int? LeftAXI;
  final int? LeftNear;
  final int? APD;
  final int? IPD;
  final String? created_at;
  final String? updated_at;
  final ProductEntity? product;

  OrderItemEntity({
    required this.product,
    required this.quantity,
    required this.id,
    required this.APD,
    required this.created_at,
    required this.IPD,
    required this.LeftAXI,
    required this.LeftCYL,
    required this.LeftNear,
    required this.price,
    required this.LeftSPH,
    required this.order_id,
    required this.product_id,
    required this.RightAXI,
    required this.RightCYL,
    required this.RightNear,
    required this.RightSPH,
    required this.type_product,
    required this.updated_at,
    required this.user_id,
  });

  @override
  List<Object> get props => [
        product ?? '',
        quantity ?? '',
        id ?? '',
        APD ?? '',
        created_at ?? '',
        IPD ?? '',
        LeftAXI ?? '',
        LeftCYL ?? '',
        LeftNear ?? '',
        price ?? '',
        LeftSPH ?? '',
        order_id ?? '',
        product_id ?? '',
        RightAXI ?? '',
        RightCYL ?? '',
        RightNear ?? '',
        RightSPH ?? '',
        type_product ?? '',
        updated_at ?? '',
        user_id ?? '',
      ];
}
