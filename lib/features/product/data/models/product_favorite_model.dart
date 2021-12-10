import 'package:json_annotation/json_annotation.dart';
import 'package:ojos_app/core/models/base_model.dart';
import 'package:ojos_app/features/product/domin/entities/product_favorite_entity.dart';

import 'product_model.dart';

part 'product_favorite_model.g.dart';

@JsonSerializable()
class ProductFavoriteModel extends BaseModel<ProductFavoriteEntity> {
  @JsonKey(name: 'product')
  final ProductModel? product;

  ProductFavoriteModel({
    required this.product,
  });

  factory ProductFavoriteModel.fromJson(Map<String, dynamic> json) =>
      _$ProductFavoriteModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProductFavoriteModelToJson(this);

  @override
  ProductFavoriteEntity toEntity() => ProductFavoriteEntity(
        product: this.product?.toEntity(),
      );
}
