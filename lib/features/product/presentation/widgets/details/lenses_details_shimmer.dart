import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ojos_app/core/appConfig.dart';
import 'package:ojos_app/core/localization/translations.dart';
import 'package:ojos_app/core/res/app_assets.dart';
import 'package:ojos_app/core/res/edge_margin.dart';
import 'package:ojos_app/core/res/global_color.dart';
import 'package:ojos_app/core/res/screen/horizontal_padding.dart';
import 'package:ojos_app/core/res/screen/vertical_padding.dart';
import 'package:ojos_app/core/res/text_style.dart';
import 'package:ojos_app/core/res/utils.dart';
import 'package:ojos_app/core/res/width_height.dart';
import 'package:ojos_app/core/ui/items_shimmer/base_shimmer.dart';
import 'package:ojos_app/core/ui/items_shimmer/item_general_shimmer.dart';
import 'package:ojos_app/core/ui/widget/image/image_caching.dart';
import 'package:ojos_app/core/ui/widget/text/normal_form_field.dart';
import 'package:ojos_app/core/ui/widget/title_with_view_all_widget.dart';
import 'package:ojos_app/core/validators/base_validator.dart';
import 'package:ojos_app/features/product/domin/entities/image_info_entity.dart';
import 'package:ojos_app/features/product/domin/entities/product_entity.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../lens_select_size_widget.dart';

class LensesDetailsShimmer extends StatefulWidget {
  final double width;
  final double height;
  final ProductEntity? product;

  const LensesDetailsShimmer({
    required this.height,
    required this.width,
    this.product,
  });

  @override
  _LensesDetailsShimmerState createState() => _LensesDetailsShimmerState();
}

class _LensesDetailsShimmerState extends State<LensesDetailsShimmer> {
  PageController controller =
      PageController(initialPage: 0, keepPage: true, viewportFraction: 1);
  var currentPageValue = 0;

  /// frame Height parameters
  bool _frameHeightValidation = false;
  String _frameHeight = '';
  final TextEditingController frameHeightEditingController =
      new TextEditingController();

  /// frame Width parameters
  bool _frameWidthValidation = false;
  String _frameWidth = '';
  final TextEditingController frameWidthEditingController =
      new TextEditingController();

  /// frame Length parameters
  bool _frameLengthValidation = false;
  String _frameLength = '';
  final TextEditingController frameLengthEditingController =
      new TextEditingController();

  @override
  Widget build(BuildContext context) {
    final width = widget.width;
    final height = widget.height;
    return Container(
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Container(
          decoration: BoxDecoration(
            color: globalColor.white,
            // borderRadius: BorderRadius.all(Radius.circular(12.w))
          ),
          child: Column(
            children: [
              _buildTopWidget(
                  context: context,
                  width: width,
                  height: height,
                  discountPrice: widget.product?.discountPrice,
                  discountType: widget.product?.discountTypeInt,
                  product: widget.product),
              _buildTitleAndPriceWidget(
                  context: context,
                  width: width,
                  height: height,
                  price: widget.product?.price,
                  priceAfterDiscount: widget.product?.priceAfterDiscount,
                  discountPrice: widget.product?.discountPrice,
                  discountType: widget.product?.discountTypeInt,
                  name: widget.product?.name ?? '',
                  companyName: widget.product?.shopInfo?.name ?? ''),

              _divider(),

              _buildLensesColorWidget(
                  context: context, width: width, height: height),
              _buildLensesSizeForEyessWidget(
                  context: context,
                  width: width,
                  height: height,
                  title: Translations.of(context)
                      .translate('lens_size_for_right_eye')),
              _buildLensesSizeForEyessWidget(
                  context: context,
                  width: width,
                  height: height,
                  title: Translations.of(context)
                      .translate('lens_size_for_left_eye')),

              _buildAvailableSizeWidget(
                  context: context, width: width, height: height),
              _divider(),

              // _divider(),
              //
              // _buildEnterDimensionsOfGlassesWidget(
              //     context: context, width: width, height: height),

              VerticalPadding(
                percentage: 2.0,
              ),

              _buildGuaranteedRefundWidget(
                  context: context, width: width, height: height),

              _divider(),

              _buildAddToCartAndFavoriteWidget(
                  context: context, width: width, height: height),

              _divider(),

              _buildSimilarProducts(
                  context: context, width: width, height: height),

              VerticalPadding(
                percentage: 2.5,
              )
            ],
          ),
        ),
      ),
    );
  }

  _buildLensesSizeForEyessWidget({
    required BuildContext context,
    required double width,
    required double height,
    String? title,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        EdgeMargin.small,
        EdgeMargin.min,
        EdgeMargin.small,
        EdgeMargin.min,
      ),
      child: Container(
        width: width,
        padding:
            const EdgeInsets.fromLTRB(0.0, EdgeMargin.sub, 0.0, EdgeMargin.sub),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child: Text(
                title ?? '',
                style: textStyle.middleTSBasic.copyWith(
                  color: globalColor.black,
                  fontWeight: FontWeight.w600,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
            VerticalPadding(
              percentage: 1.0,
            ),
            Row(
              children: [
                Expanded(
                  child: BaseShimmerWidget(
                    child: Container(
                      width: width,
                      height: 40.h,
                      color: Colors.white,
                    ),
                  ),
                ),
                HorizontalPadding(
                  percentage: 1,
                ),
                Expanded(
                  child: BaseShimmerWidget(
                    child: Container(
                      width: width,
                      height: 40.h,
                      color: Colors.white,
                    ),
                  ),
                ),
                HorizontalPadding(
                  percentage: 1,
                ),
                Expanded(
                  child: BaseShimmerWidget(
                    child: Container(
                      width: width,
                      height: 40.h,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  _buildLensesColorWidget(
      {required BuildContext context,
      required double width,
      required double height}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        EdgeMargin.small,
        EdgeMargin.min,
        EdgeMargin.small,
        EdgeMargin.min,
      ),
      child: Container(
        width: width,
        height: 46.h,
        decoration: BoxDecoration(
            color: globalColor.white,
            borderRadius: BorderRadius.all(Radius.circular(12.w)),
            border: Border.all(
                color: globalColor.grey.withOpacity(0.3), width: 0.5)),
        padding: const EdgeInsets.fromLTRB(
            EdgeMargin.min, EdgeMargin.sub, EdgeMargin.min, EdgeMargin.sub),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Container(
                child: Text(
                  Translations.of(context).translate('the_color_of_the_lens'),
                  style: textStyle.smallTSBasic.copyWith(
                      fontWeight: FontWeight.w500, color: globalColor.black),
                ),
              ),
            ),
            Row(
              children: [
                BaseShimmerWidget(
                  child: Container(
                    width: 60,
                    height: 40.h,
                    color: Colors.white,
                  ),
                ),
                // Container(
                //   decoration: BoxDecoration(
                //       borderRadius: BorderRadius.all(Radius.circular(12.w)),
                //       border: Border.all(
                //           width: 0.5, color: globalColor.grey.withOpacity(0.3)),
                //       color: globalColor.white.withOpacity(0.5)),
                //   width: 28.w,
                //   height: 28.w,
                //   child: Center(
                //     child: Container(
                //       width: 22.w,
                //       height: 22.w,
                //       decoration: BoxDecoration(
                //           shape: BoxShape.circle,
                //           //color: globalColor.grey.withOpacity(0.5),
                //           gradient: LinearGradient(
                //               begin: AlignmentDirectional.bottomEnd,
                //               end: AlignmentDirectional.topStart,
                //               colors: [
                //                 globalColor.primaryColor,
                //                 globalColor.primaryColor.withOpacity(0.9),
                //                 globalColor.primaryColor.withOpacity(0.8),
                //                 globalColor.primaryColor.withOpacity(0.7),
                //                 globalColor.primaryColor,
                //                 globalColor.primaryColor.withOpacity(0.9),
                //                 globalColor.primaryColor.withOpacity(0.8),
                //                 globalColor.primaryColor.withOpacity(0.7),
                //                 globalColor.primaryColor,
                //                 globalColor.primaryColor.withOpacity(0.9),
                //                 globalColor.primaryColor.withOpacity(0.8),
                //                 globalColor.primaryColor.withOpacity(0.7),
                //               ])),
                //     ),
                //   ),
                // ),
                // HorizontalPadding(
                //   percentage: 1.0,
                // ),
                // Text('أزرق',
                //     style: textStyle.minTSBasic.copyWith(
                //         color: globalColor.black, fontWeight: FontWeight.w600)),
                // Container(
                //   child: Center(
                //     child: Icon(
                //       MaterialIcons.keyboard_arrow_down,
                //       color: globalColor.globalDarkGrey,
                //     ),
                //   ),
                // )
              ],
            ),
          ],
        ),
      ),
    );
  }

  _buildTopWidget(
      {required BuildContext context,
      required double width,
      required double height,
      int? discountType,
      double? discountPrice,
      ProductEntity? product}) {
    return Container(
      width: width,
      height: 236.h,
      padding: const EdgeInsets.fromLTRB(EdgeMargin.sub, EdgeMargin.verySub,
          EdgeMargin.sub, EdgeMargin.verySub),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(12.w)),
        child: Stack(
          children: [
            Stack(
              children: [
                product?.photoInfo != null &&
                        (product?.photoInfo?.isNotEmpty ?? false)
                    ? PageView(
                        controller: controller,
                        scrollDirection: Axis.horizontal,
                        physics: BouncingScrollPhysics(),
                        children: product!.photoInfo!
                            .map((item) => Stack(
                                  children: [
                                    Container(
                                      width: width,
                                      height: 236.h,
                                      child: ImageCacheWidget(
                                        imageUrl: item.image ?? '',
                                        imageWidth: width,
                                        imageHeight: 236.h,
                                        boxFit: BoxFit.fill,
                                      ),
                                    ),
                                  ],
                                ))
                            .toList(),
                      )
                    : Container(
                        width: width,
                        height: 236.h,
                        child: ImageCacheWidget(
                          imageUrl: product?.mainImage ?? '',
                          imageWidth: width,
                          imageHeight: 236.h,
                          boxFit: BoxFit.fill,
                        ),
                      ),
                Positioned(
                  left: 4.0,
                  top: 4.0,
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () {
                          //Get.Get.toNamed(AddReviewPage.routeName);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: globalColor.white,
                            borderRadius: BorderRadius.circular(12.0.w),
                          ),
                          height: height * .035,
                          constraints: BoxConstraints(minWidth: width * .09),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: EdgeMargin.verySub,
                                right: EdgeMargin.verySub),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 2,
                                ),
                                SvgPicture.asset(
                                  AppAssets.star,
                                  width: 12,
                                ),
                                SizedBox(
                                  width: 4,
                                ),
                                Text(
                                  '${appConfig.notNullOrEmpty(product?.rate) ? product!.rate : '-'}',
                                  style: textStyle.smallTSBasic.copyWith(
                                      color: globalColor.black,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 5.0,
                      ),
                      (product?.isNew ?? false)
                          ? Container(
                              decoration: BoxDecoration(
                                color: globalColor.primaryColor,
                                borderRadius: BorderRadius.circular(12.0.w),
                              ),
                              height: height * .035,
                              constraints:
                                  BoxConstraints(minWidth: width * .15),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: EdgeMargin.verySub,
                                    right: EdgeMargin.verySub),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    // SizedBox(
                                    //   width: 2,
                                    // ),
                                    SvgPicture.asset(
                                      AppAssets.newww,
                                      width: 12,
                                    ),
                                    SizedBox(
                                      width: 4,
                                    ),
                                    Text(
                                      '${Translations.of(context).translate('new')}',
                                      style: textStyle.smallTSBasic.copyWith(
                                          color: globalColor.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : Container(
                              child: Text(''),
                            ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 4.0,
                  right: 4.0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: globalColor.white,
                      borderRadius: BorderRadius.circular(12.0.w),
                    ),
                    height: height * .035,
                    constraints: BoxConstraints(minWidth: width * .1),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 4.0, right: 4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 2,
                          ),
                          // SvgPicture.asset(
                          //   AppAssets.user,
                          //   width: 16,
                          // ),
                          // SizedBox(
                          //   width: 4,
                          // ),
                          Text(
                            '${product?.typeProduct ?? ''}',
                            style: textStyle.minTSBasic.copyWith(
                              color: globalColor.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 4.0,
                  left: 4.0,
                  child: discountType != null
                      ? Container(
                          decoration: BoxDecoration(
                              color: globalColor.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12.w)),
                              border: Border.all(
                                  color: globalColor.grey.withOpacity(0.3),
                                  width: 0.5)),
                          padding: const EdgeInsets.fromLTRB(
                              EdgeMargin.subSubMin,
                              EdgeMargin.verySub,
                              EdgeMargin.subSubMin,
                              EdgeMargin.verySub),
                          child: discountType == 1
                              ? Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      '${discountPrice ?? '-'} ${Translations.of(context).translate('rail')}',
                                      style: textStyle.smallTSBasic.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: globalColor.primaryColor),
                                    ),
                                    Text(
                                        ' ${Translations.of(context).translate('discount')}',
                                        style: textStyle.minTSBasic.copyWith(
                                            color: globalColor.black)),
                                  ],
                                )
                              : Row(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      '${discountPrice ?? '-'} %',
                                      style: textStyle.smallTSBasic.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: globalColor.primaryColor),
                                    ),
                                    Text(
                                        ' ${Translations.of(context).translate('discount')}',
                                        style: textStyle.minTSBasic.copyWith(
                                            color: globalColor.black)),
                                  ],
                                ),
                        )
                      : Container(),
                ),
              ],
            ),
            product?.photoInfo != null &&
                    (product?.photoInfo?.isNotEmpty ?? false)
                ? Positioned(
                    bottom: 10,
                    child: _buildPageIndicator2(
                        width: width, list: product!.photoInfo!))
                : Container()
          ],
        ),
      ),
    );
  }

  _buildPageIndicator2(
      {required double width, required List<ImageInfoEntity> list}) {
    return Container(
      alignment: AlignmentDirectional.center,
      width: width,
      child: SmoothPageIndicator(
          controller: controller, //// PageController
          count: list.length,
          effect: WormEffect(
            spacing: 4.0,
            radius: 10.0,
            dotWidth: 10.0,
            dotHeight: 10.0,
            dotColor: Colors.white,
            paintStyle: PaintingStyle.fill,
            strokeWidth: 2,
            activeDotColor: globalColor.primaryColor,
          ), // your preferred effect
          onDotClicked: (index) {}),
    );
  }

  _buildTitleAndPriceWidget(
      {required BuildContext context,
      required double width,
      required double height,
      double? price,
      String? priceAfterDiscount,
      double? discountPrice,
      int? discountType,
      String? name,
      String? companyName}) {
    return Container(
      width: width,
      padding:
          const EdgeInsets.fromLTRB(EdgeMargin.min, 0.0, EdgeMargin.min, 0.0),
      child: Row(
        children: [
          Expanded(
              flex: 2,
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      child: Text(
                        '${name ?? ''}',
                        style: textStyle.middleTSBasic.copyWith(
                          color: globalColor.black,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                    Container(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 15.w,
                            height: 15.w,
                            child: SvgPicture.asset(
                              AppAssets.lenses_company_svg,
                              width: 15.w,
                            ),
                          ),
                          Container(
                              padding: const EdgeInsets.only(
                                  left: EdgeMargin.sub, right: EdgeMargin.sub),
                              child: Text(
                                '${companyName ?? ''}',
                                style: textStyle.minTSBasic.copyWith(
                                    fontWeight: FontWeight.w500,
                                    color: globalColor.grey),
                              ))
                        ],
                      ),
                    ),
                  ],
                ),
              )),
          Expanded(
              flex: 2,
              child: Container(
                  alignment: AlignmentDirectional.centerEnd,
                  padding: const EdgeInsets.fromLTRB(EdgeMargin.verySub,
                      EdgeMargin.sub, EdgeMargin.verySub, EdgeMargin.sub),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        // decoration: BoxDecoration(
                        //     color: globalColor.white,
                        //     borderRadius: BorderRadius.all(Radius.circular(12.w)),
                        //     border: Border.all(
                        //         color: globalColor.grey.withOpacity(0.3),
                        //         width: 0.5)),
                        padding: const EdgeInsets.fromLTRB(
                            EdgeMargin.subSubMin,
                            EdgeMargin.verySub,
                            EdgeMargin.subSubMin,
                            EdgeMargin.verySub),
                        child: _buildPriceWidget(
                            discountPrice: discountPrice,
                            price: price,
                            priceAfterDiscount: priceAfterDiscount ?? ''),
                      ),
                    ],
                  )))
        ],
      ),
    );
  }

  _buildPriceWidget({
    double? price,
    double? discountPrice,
    String? priceAfterDiscount,
  }) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          discountPrice != null && (discountPrice != 0.0 || discountPrice != 0)
              ? Container(
                  child: FittedBox(
                  child: RichText(
                    text: TextSpan(
                      text: '${price?.toString() ?? ''}',
                      style: textStyle.middleTSBasic.copyWith(
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.lineThrough,
                          color: globalColor.grey),
                      children: <TextSpan>[
                        new TextSpan(
                            text:
                                ' ${Translations.of(context).translate('rail')}',
                            style: textStyle.smallTSBasic
                                .copyWith(color: globalColor.grey)),
                      ],
                    ),
                  ),
                ))
              : Container(
                  child: FittedBox(
                  child: RichText(
                    text: TextSpan(
                      text: price != null ? price.toString() : '',
                      style: textStyle.middleTSBasic.copyWith(
                          fontWeight: FontWeight.bold,
                          color: globalColor.primaryColor),
                      children: <TextSpan>[
                        new TextSpan(
                            text:
                                ' ${Translations.of(context).translate('rail')}',
                            style: textStyle.smallTSBasic
                                .copyWith(color: globalColor.black)),
                      ],
                    ),
                  ),
                )),
          discountPrice != null && (discountPrice != 0.0 || discountPrice != 0)
              ? Container(
                  child: FittedBox(
                  child: RichText(
                    text: TextSpan(
                      text: priceAfterDiscount ?? '',
                      style: textStyle.middleTSBasic.copyWith(
                          fontWeight: FontWeight.bold,
                          color: globalColor.primaryColor),
                      children: <TextSpan>[
                        new TextSpan(
                            text:
                                ' ${Translations.of(context).translate('rail')}',
                            style: textStyle.smallTSBasic
                                .copyWith(color: globalColor.black)),
                      ],
                    ),
                  ),
                ))
              : Container(),
        ],
      ),
    );
  }

  _buildAvailableSizeWidget(
      {required BuildContext context,
      required double width,
      required double height}) {
    return Container(
      width: width,
      padding:
          const EdgeInsets.fromLTRB(0.0, EdgeMargin.sub, 0.0, EdgeMargin.sub),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(
                EdgeMargin.min, 0.0, EdgeMargin.min, 0.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    child: Text(
                      Translations.of(context).translate('enter_the_sizes'),
                      style: textStyle.middleTSBasic.copyWith(
                        color: globalColor.black,
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                ),
                // Container(
                //   decoration: BoxDecoration(
                //       shape: BoxShape.circle,
                //       color: globalColor.grey.withOpacity(0.5)),
                //   child: Center(
                //     child: Icon(
                //       MaterialIcons.keyboard_arrow_down,
                //       color: globalColor.black,
                //     ),
                //   ),
                // )
              ],
            ),
          ),
          VerticalPadding(
            percentage: 2.0,
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(
                EdgeMargin.min, 0.0, EdgeMargin.min, 0.0),
            child: Column(
              children: [
                BaseShimmerWidget(
                  child: Container(
                    width: width,
                    height: 46.h,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  _buildGuaranteedRefundWidget(
      {required BuildContext context,
      required double width,
      required double height}) {
    return Container(
      padding:
          const EdgeInsets.fromLTRB(EdgeMargin.min, 0.0, EdgeMargin.min, 0.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 15.w,
            height: 15.w,
            decoration: BoxDecoration(
                color: globalColor.goldColor,
                shape: BoxShape.circle,
                border:
                    Border.all(width: 1.0, color: globalColor.primaryColor)),
            child: Icon(
              Icons.check,
              color: globalColor.black,
              size: 10.w,
            ),
          ),
          Container(
              padding: const EdgeInsets.only(
                  left: EdgeMargin.sub, right: EdgeMargin.sub),
              child: Text(
                Translations.of(context)
                    .translate('guarantee_refund_shipping_after_purchase'),
                style: textStyle.minTSBasic.copyWith(
                    fontWeight: FontWeight.w500, color: globalColor.black),
              ))
        ],
      ),
    );
  }

  _buildAddToCartAndFavoriteWidget(
      {required BuildContext context,
      required double width,
      required double height}) {
    return Container(
      padding:
          const EdgeInsets.fromLTRB(EdgeMargin.min, 0.0, EdgeMargin.min, 0.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 3,
            child: Container(
              decoration: BoxDecoration(
                  color: globalColor.white,
                  borderRadius: BorderRadius.circular(16.0.w),
                  border: Border.all(
                      width: 0.5, color: globalColor.grey.withOpacity(0.3))),
              height: 35.w,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SvgPicture.asset(
                    AppAssets.love,
                    color: globalColor.black,
                    width: 20.w,
                  ),
                  Text(
                    Translations.of(context).translate('favorite'),
                    style: textStyle.smallTSBasic.copyWith(
                        fontWeight: FontWeight.w500,
                        color: globalColor.primaryColor),
                  ),
                ],
              ),
            ),
          ),
          HorizontalPadding(
            percentage: 2.0,
          ),
          Expanded(
            flex: 3,
            child: Container(
              decoration: BoxDecoration(
                  color: globalColor.white,
                  borderRadius: BorderRadius.circular(16.0.w),
                  border: Border.all(
                      width: 0.5, color: globalColor.grey.withOpacity(0.3))),
              height: 35.w,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SvgPicture.asset(
                    AppAssets.cart_nav_bar,
                    color: globalColor.black,
                    width: 20.w,
                  ),
                  Text(
                    Translations.of(context).translate('add_to_cart'),
                    style: textStyle.smallTSBasic.copyWith(
                        fontWeight: FontWeight.w500,
                        color: globalColor.primaryColor),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  _buildSimilarProducts(
      {required BuildContext context,
      required double width,
      required double height}) {
    return Container(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
                left: EdgeMargin.small, right: EdgeMargin.small),
            child: TitleWithViewAllWidget(
              width: width,
              title: Translations.of(context).translate('similar_products'),
              onClickView: () {},
              strViewAll: Translations.of(context).translate('view_all'),
            ),
          ),
          Container(
              child: GridView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: 4,
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 1,
                    mainAxisSpacing: 1,
                    childAspectRatio:
                        globalSize.setWidthPercentage(47, context) /
                            globalSize.setWidthPercentage(60, context),
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    return ItemGeneralShimmer(
                      height: globalSize.setWidthPercentage(60, context),
                      width: globalSize.setWidthPercentage(47, context),
                    );
                  }))
        ],
      ),
    );
  }

  _divider() {
    return Divider(
      color: globalColor.grey.withOpacity(0.3),
      height: 20.h,
    );
  }

// _buildPriceWidget({double price, double discountPrice,String priceAfterDiscount}) {
//   return Container(
//     child: Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         discountPrice != null && discountPrice != 0.0
//             ? Container(
//             child: FittedBox(
//               child: RichText(
//                 text: TextSpan(
//                   text: '${price.toString() ?? ''}',
//                   style: textStyle.middleTSBasic.copyWith(
//                       fontWeight: FontWeight.bold,
//                       decoration: TextDecoration.lineThrough,
//                       color: globalColor.grey),
//                   children: <TextSpan>[
//                     new TextSpan(
//                         text:
//                         ' ${Translations.of(context).translate('rail')}',
//                         style: textStyle.smallTSBasic
//                             .copyWith(color: globalColor.grey)),
//                   ],
//                 ),
//               ),
//             ))
//             : Container(
//             child: FittedBox(
//               child: RichText(
//                 text: TextSpan(
//                   text: price.toString() ?? '',
//                   style: textStyle.middleTSBasic.copyWith(
//                       fontWeight: FontWeight.bold,
//                       color: globalColor.primaryColor),
//                   children: <TextSpan>[
//                     new TextSpan(
//                         text:
//                         ' ${Translations.of(context).translate('rail')}',
//                         style: textStyle.smallTSBasic
//                             .copyWith(color: globalColor.black)),
//                   ],
//                 ),
//               ),
//             )),
//         discountPrice != null && discountPrice != 0.0
//             ? Container(
//             child: FittedBox(
//               child: RichText(
//                 text: TextSpan(
//                   text: priceAfterDiscount ?? '',
//                   style: textStyle.middleTSBasic.copyWith(
//                       fontWeight: FontWeight.bold,
//                       color: globalColor.primaryColor),
//                   children: <TextSpan>[
//                     new TextSpan(
//                         text:
//                         ' ${Translations.of(context).translate('rail')}',
//                         style: textStyle.smallTSBasic
//                             .copyWith(color: globalColor.black)),
//                   ],
//                 ),
//               ),
//             ))
//             : Container(),
//       ],
//     ),
//   );
// }
}
