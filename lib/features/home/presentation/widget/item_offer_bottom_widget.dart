import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart' as Get;
import 'package:ojos_app/core/entities/offer_item_entity.dart';
import 'package:ojos_app/core/res/edge_margin.dart';
import 'package:ojos_app/core/ui/widget/image/image_caching.dart';
import 'package:ojos_app/features/product/domin/entities/product_entity.dart';
import 'package:ojos_app/features/product/presentation/args/product_details_args.dart';
import 'package:ojos_app/features/product/presentation/pages/lenses_details_page.dart';
import 'package:ojos_app/features/product/presentation/pages/product_details_page.dart';

class ItemOfferBottomWidget extends StatelessWidget {
  final OfferItemEntity? offerItem;
  final double width;
  final double height;
  const ItemOfferBottomWidget(
      {this.offerItem, required this.width, required this.height});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (offerItem?.is_glasses != null && (offerItem?.is_glasses ?? false))
          Get.Get.toNamed(ProductDetailsPage.routeName,
              preventDuplicates: false,
              arguments: ProductDetailsArguments(
                  product: ProductEntity(
                      categoryId: null,
                      name: offerItem?.name,
                      id: offerItem?.productId,
                      gender: null,
                      discountPrice: null,
                      discountTypeInt: null,
                      discountType: null,
                      type: null,
                      frameShape: null,
                      price: null,
                      description: null,
                      availability: null,
                      brandId: null,
                      productReviews: null,
                      brandInfo: null,
                      featured: null,
                      genderId: null,
                      isReview: null,
                      hasCouponCode: null,
                      isNew: false,
                      lensesFree: null,
                      mainImage: null,
                      colorInfo: null,
                      rate: null,
                      isGlasses: null,
                      sizeModeInfo: null,
                      sizeFaceInfo: null,
                      shapeFaceInfo: null,
                      shapeframeinfo: null,
                      shopId: null,
                      shopInfo: null,
                      typeProduct: null,
                      photoInfo: null,
                      isFavorite: null,
                      priceAfterDiscount: null)));
        else
          Get.Get.toNamed(LensesDetailsPage.routeName,
              preventDuplicates: false,
              arguments: ProductDetailsArguments(
                  product: ProductEntity(
                      categoryId: null,
                      name: offerItem?.name,
                      id: offerItem?.productId,
                      gender: null,
                      discountPrice: null,
                      discountTypeInt: null,
                      discountType: null,
                      type: null,
                      frameShape: null,
                      price: null,
                      description: null,
                      availability: null,
                      brandId: null,
                      productReviews: null,
                      brandInfo: null,
                      featured: null,
                      genderId: null,
                      isReview: null,
                      hasCouponCode: null,
                      isNew: false,
                      lensesFree: null,
                      mainImage: null,
                      colorInfo: null,
                      rate: null,
                      isGlasses: null,
                      sizeModeInfo: null,
                      sizeFaceInfo: null,
                      shapeFaceInfo: null,
                      shapeframeinfo: null,
                      shopId: null,
                      shopInfo: null,
                      typeProduct: null,
                      photoInfo: null,
                      isFavorite: null,
                      priceAfterDiscount: null)));
      },
      child: Container(
          child: Padding(
        padding: const EdgeInsets.fromLTRB(
            EdgeMargin.small, EdgeMargin.sub, EdgeMargin.small, EdgeMargin.sub),
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(12.0.w)),
          child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0.w),
              ),
              height: 90.h,
              child: ImageCacheWidget(
                imageUrl: offerItem?.image ?? '',
                imageWidth: width,
                imageHeight: 90.h,
                boxFit: BoxFit.fill,
                imageBorderRadius: 0.0,
              )),
        ),
      )),
    );
  }
}
