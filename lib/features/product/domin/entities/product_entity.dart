import 'package:ojos_app/core/entities/base_entity.dart';
import 'package:ojos_app/features/product/domin/entities/review_entity.dart';

import 'general_item_entity.dart';
import 'image_info_entity.dart';
import 'item_entity.dart';

class ProductEntity extends BaseEntity {
  final int? id;
  final String? name;

  final String? mainImage;
  final double? price;

  final String? discountType;

  final double? discountPrice;

  final String? frameShape;
  final int? type;

  final bool? isNew;

  final bool? isGlasses;

  final int? genderId;

  final int? shopId;

  final int? categoryId;

  final int? brandId;
  final String? description;

  final bool? hasCouponCode;

  final bool? availability;

  final bool? featured;

  final bool? lensesFree;
  final String? rate;

  final int? discountTypeInt;

  final String? typeProduct;

  final String? gender;

  final ItemEntity? brandInfo;

  final ItemEntity? shopInfo;

  final List<GeneralItemEntity>? shapeframeinfo;

  final List<GeneralItemEntity>? colorInfo;

  final List<GeneralItemEntity>? sizeModeInfo;

  final List<GeneralItemEntity>? sizeFaceInfo;

  final List<GeneralItemEntity>? shapeFaceInfo;

  final List<ImageInfoEntity>? photoInfo;

  final String? priceAfterDiscount;

  bool? isFavorite;
  final bool? isReview;
  final List<ReviewEntity>? productReviews;
  ProductEntity({
    required this.categoryId,
    required this.name,
    required this.id,
    required this.gender,
    required this.discountPrice,
    required this.discountTypeInt,
    required this.discountType,
    required this.type,
    required this.frameShape,
    required this.price,
    required this.description,
    required this.availability,
    required this.brandId,
    required this.productReviews,
    required this.brandInfo,
    required this.featured,
    required this.genderId,
    required this.isReview,
    required this.hasCouponCode,
    required this.isNew,
    required this.lensesFree,
    required this.mainImage,
    required this.colorInfo,
    required this.rate,
    required this.isGlasses,
    required this.sizeModeInfo,
    required this.sizeFaceInfo,
    required this.shapeFaceInfo,
    required this.shapeframeinfo,
    required this.shopId,
    required this.shopInfo,
    required this.typeProduct,
    required this.photoInfo,
    required this.isFavorite,
    required this.priceAfterDiscount,
  });

  @override
  List<Object> get props => [
        categoryId ?? '',
        name ?? '',
        id ?? '',
        gender ?? '',
        discountPrice ?? '',
        discountTypeInt ?? '',
        discountType ?? '',
        type ?? '',
        frameShape ?? '',
        productReviews ?? '',
        price ?? '',
        description ?? '',
        availability ?? '',
        brandId ?? '',
        isReview ?? '',
        brandInfo ?? '',
        featured ?? '',
        genderId ?? '',
        hasCouponCode ?? '',
        isNew ?? '',
        lensesFree ?? '',
        mainImage ?? '',
        colorInfo ?? '',
        rate ?? '',
        isGlasses ?? '',
        sizeModeInfo ?? '',
        sizeFaceInfo ?? '',
        shapeFaceInfo ?? '',
        shapeframeinfo ?? '',
        shopId ?? '',
        shopInfo ?? '',
        typeProduct ?? '',
        photoInfo ?? '',
        isFavorite ?? '',
        priceAfterDiscount ?? '',
      ];
}
