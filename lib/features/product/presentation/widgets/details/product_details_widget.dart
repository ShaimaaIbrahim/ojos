import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart' as Get;
import 'package:ojos_app/core/appConfig.dart';
import 'package:ojos_app/core/bloc/application_bloc.dart';
import 'package:ojos_app/core/localization/translations.dart';
import 'package:ojos_app/core/providers/cart_provider.dart';
import 'package:ojos_app/core/res/app_assets.dart';
import 'package:ojos_app/core/res/edge_margin.dart';
import 'package:ojos_app/core/res/global_color.dart';
import 'package:ojos_app/core/res/hex_color.dart';
import 'package:ojos_app/core/res/screen/horizontal_padding.dart';
import 'package:ojos_app/core/res/screen/vertical_padding.dart';
import 'package:ojos_app/core/res/text_style.dart';
import 'package:ojos_app/core/res/utils.dart';
import 'package:ojos_app/core/res/width_height.dart';
import 'package:ojos_app/core/ui/dailog/add_to_cart_dialog.dart';
import 'package:ojos_app/core/ui/dailog/login_first_dialog.dart';
import 'package:ojos_app/core/ui/dailog/soon_dailog.dart';
import 'package:ojos_app/core/ui/widget/image/image_caching.dart';
import 'package:ojos_app/core/ui/widget/text/normal_form_field.dart';
import 'package:ojos_app/core/ui/widget/title_with_view_all_widget.dart';
import 'package:ojos_app/core/validators/base_validator.dart';
import 'package:ojos_app/features/product/domin/entities/cart_entity.dart';
import 'package:ojos_app/features/product/domin/entities/image_info_entity.dart';
import 'package:ojos_app/features/product/domin/entities/product_details_entity.dart';
import 'package:ojos_app/features/product/domin/entities/product_entity.dart';
import 'package:ojos_app/features/product/domin/repositories/product_repository.dart';
import 'package:ojos_app/features/product/domin/usecases/add_remove_favorite.dart';
import 'package:ojos_app/features/product/presentation/args/product_details_args.dart';
import 'package:ojos_app/features/product/presentation/args/select_lenses_args.dart';
import 'package:ojos_app/features/product/presentation/widgets/item_color_product.dart';
import 'package:ojos_app/features/product/presentation/widgets/item_product_widget.dart';
import 'package:ojos_app/features/product/presentation/widgets/item_size_product.dart';
import 'package:ojos_app/features/product/presentation/widgets/select_lenses_page.dart';
import 'package:ojos_app/features/reviews/presentation/pages/add_reviews_page.dart';
import 'package:ojos_app/features/search/presentation/widgets/item_size_filter.dart';
import 'package:ojos_app/features/user_management/domain/repositories/user_repository.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../../core/ui/widget/title_with_view_all_widget.dart';
import '../../../../../main.dart';
import '../../../domin/entities/general_item_entity.dart';
import '../item_color_product_details.dart';
import '../item_product_home_widget.dart';
import '../item_size_product_details.dart';

class ProductDetailsWidget extends StatefulWidget {
  final double width;
  final double height;
  final ProductEntity? product;
  final ProductDetailsEntity? productDetails;
  final CancelToken cancelToken;

  const ProductDetailsWidget(
      {required this.height,
      required this.width,
      this.product,
      this.productDetails,
      required this.cancelToken});

  @override
  _ProductDetailsWidgetState createState() => _ProductDetailsWidgetState();
}

class _ProductDetailsWidgetState extends State<ProductDetailsWidget> {
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
  bool isAuth = false;
  late SelectLensesArgs selectLensesArgs;

  bool _isDisplaySizeList = true;

  List<int> listOfColorSelected = [];
  GeneralItemEntity? color;
  List<int> listOfSizeMode = [];
  int? SizeModeId;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    listOfColorSelected = [];
    listOfSizeMode = [];
    color = null;
  }

  @override
  Widget build(BuildContext context) {
    final width = widget.width;
    final height = widget.height;

    isAuth =
        BlocProvider.of<ApplicationBloc>(context).state.isUserAuthenticated ||
            BlocProvider.of<ApplicationBloc>(context).state.isUserVerified;
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
                  discountPrice: widget.productDetails?.discountPrice,
                  discountType: widget.productDetails?.discountTypeInt,
                  product: widget.productDetails),
              _buildTitleAndPriceWidget(
                  context: context,
                  width: width,
                  height: height,
                  price: widget.productDetails?.price,
                  priceAfterDiscount: widget.productDetails?.priceAfterDiscount,
                  discountPrice: widget.productDetails?.discountPrice,
                  discountType: widget.productDetails?.discountTypeInt,
                  name: widget.productDetails?.name,
                  isFree: widget.productDetails?.lensesFree),
              _divider(),
              _buildAvailableSizeWidget(
                  context: context,
                  width: width,
                  height: height,
                  list: widget.productDetails?.sizeModeInfo),
              _divider(),
              _buildAvailableGlassesColors(
                  context: context,
                  width: width,
                  height: height,
                  list: widget.product?.colorInfo),

              // _divider(),
              //
              /*   _buildEnterDimensionsOfGlassesWidget(
                  context: context, width: width, height: height),*/

              VerticalPadding(
                percentage: 2.0,
              ),

              _buildTryChooseWidget(
                  context: context, width: width, height: height),

              VerticalPadding(
                percentage: 2.0,
              ),

              _buildGuaranteedRefundWidget(
                  context: context, width: width, height: height),

              _divider(),

              _buildAddToCartAndFavoriteWidget(
                  context: context,
                  width: width,
                  height: height,
                  productEntity: widget.productDetails,
                  isAuth: isAuth),

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

  _buildTopWidget(
      {required BuildContext context,
      required double width,
      required double height,
      int? discountType,
      double? discountPrice,
      ProductDetailsEntity? product}) {
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
                          // Get.Get.toNamed(AddReviewPage.routeName,arguments: widget.productDetails);
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
                          SvgPicture.asset(
                            AppAssets.user,
                            width: 16,
                          ),
                          SizedBox(
                            width: 4,
                          ),
                          Text(
                            product?.genderId == 38
                                ? '${Translations.of(context).translate('men')}'
                                : '${Translations.of(context).translate('women')}',
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

  _buildPageIndicator2({required double width, List<ImageInfoEntity>? list}) {
    return Container(
      alignment: AlignmentDirectional.center,
      width: width,
      child: SmoothPageIndicator(
          controller: controller, //// PageController
          count: list?.length ?? 0,
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
      bool? isFree}) {
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
                          isFree != null && isFree
                              ? Container(
                                  width: 15.w,
                                  height: 15.w,
                                  decoration: BoxDecoration(
                                      color: globalColor.goldColor,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          width: 1.0,
                                          color: globalColor.primaryColor)),
                                  child: Icon(
                                    Icons.check,
                                    color: globalColor.black,
                                    size: 10.w,
                                  ),
                                )
                              : Container(
                                  width: 15.w,
                                  height: 15.w,
                                  decoration: BoxDecoration(
                                      color: globalColor.grey,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          width: 1.0,
                                          color: globalColor.grey
                                              .withOpacity(0.3))),
                                  child: Center(
                                    child: Text(''),
                                  ),
                                ),
                          Container(
                              padding: const EdgeInsets.only(
                                  left: EdgeMargin.sub, right: EdgeMargin.sub),
                              child: Text(
                                '${Translations.of(context).translate('free_lenses')}',
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
                            priceAfterDiscount: priceAfterDiscount),
                      ),
                    ],
                  )))
        ],
      ),
    );
  }

  // _buildAvailableSizeWidget(
  //     {required BuildContext context,
  //   required   double width,
  //  required   double height,
  //     List<GeneralItemEntity> list}) {
  //   if (list != null && list.isNotEmpty) {
  //     return Container(
  //       width: width,
  //       padding:
  //           const EdgeInsets.fromLTRB(0.0, EdgeMargin.sub, 0.0, EdgeMargin.sub),
  //       child: Column(
  //         mainAxisAlignment: MainAxisAlignment.start,
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Container(
  //             padding: const EdgeInsets.fromLTRB(
  //                 EdgeMargin.min, 0.0, EdgeMargin.min, 0.0),
  //             child: Row(
  //               crossAxisAlignment: CrossAxisAlignment.center,
  //               children: [
  //                 Expanded(
  //                   flex: 1,
  //                   child: Container(
  //                     child: Text(
  //                       Translations.of(context).translate('available_sizes') ??
  //                           '',
  //                       style: textStyle.middleTSBasic.copyWith(
  //                         color: globalColor.black,
  //                         fontWeight: FontWeight.w600,
  //                       ),
  //                       overflow: TextOverflow.ellipsis,
  //                       maxLines: 1,
  //                     ),
  //                   ),
  //                 ),
  //                 Container(
  //                   decoration: BoxDecoration(
  //                       shape: BoxShape.circle,
  //                       color: globalColor.grey.withOpacity(0.5)),
  //                   child: Center(
  //                     child: Icon(
  //                       MaterialIcons.keyboard_arrow_down,
  //                       color: globalColor.black,
  //                     ),
  //                   ),
  //                 )
  //               ],
  //             ),
  //           ),
  //           VerticalPadding(
  //             percentage: .5,
  //           ),
  //           Container(
  //             child: ListView.builder(
  //                 shrinkWrap: true,
  //                 itemCount: list.length,
  //                 physics: NeverScrollableScrollPhysics(),
  //                 itemBuilder: (context, index) {
  //                   return _buildSizeItem(
  //                       width: width,
  //                       image: AppAssets.glasses_svg,
  //                       context: context,
  //                       height: height,
  //                       isAvailable: true,
  //                       label: list[index].name ?? '',
  //                       size: list[index].value ?? '',
  //                       imageSize: 42.w);
  //                 }),
  //           ),
  //           // Container(
  //           //   child: Column(
  //           //     children: [
  //           //       _buildSizeItem(
  //           //           width: width,
  //           //           image: AppAssets.glasses_svg,
  //           //           context: context,
  //           //           height: height,
  //           //           isAvailable: true,
  //           //           label: 'SMALL'.toUpperCase(),
  //           //           size: '40-48',
  //           //           imageSize: 42.w),
  //           //       VerticalPadding(
  //           //         percentage: 1.0,
  //           //       ),
  //           //       _buildSizeItem(
  //           //           width: width,
  //           //           image: AppAssets.glasses_svg,
  //           //           context: context,
  //           //           height: height,
  //           //           isAvailable: false,
  //           //           label: 'Medium'.toUpperCase(),
  //           //           size: '49-54',
  //           //           imageSize: 55.w),
  //           //       VerticalPadding(
  //           //         percentage: 1.0,
  //           //       ),
  //           //       _buildSizeItem(
  //           //           width: width,
  //           //           image: AppAssets.glasses_svg,
  //           //           context: context,
  //           //           height: height,
  //           //           isAvailable: true,
  //           //           label: 'Large'.toUpperCase(),
  //           //           size: '55-58',
  //           //           imageSize: 65.w),
  //           //       VerticalPadding(
  //           //         percentage: 1.0,
  //           //       ),
  //           //       _buildSizeItem(
  //           //           width: width,
  //           //           image: AppAssets.glasses_svg,
  //           //           context: context,
  //           //           height: height,
  //           //           isAvailable: false,
  //           //           label: 'E-Large'.toUpperCase(),
  //           //           size: 'above 58',
  //           //           imageSize: 80.w),
  //           //     ],
  //           //   ),
  //           // )
  //         ],
  //       ),
  //     );
  //   }
  //   return Container();
  // }

  _buildAvailableSizeWidget(
      {required BuildContext context,
      required double width,
      required double height,
      List<GeneralItemEntity>? list}) {
    if (list != null && list.isNotEmpty) {
      return Container(
        width: width,
        padding:
            const EdgeInsets.fromLTRB(0.0, EdgeMargin.sub, 0.0, EdgeMargin.sub),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: () {
                if (mounted)
                  setState(() {
                    _isDisplaySizeList = !_isDisplaySizeList;
                  });
              },
              child: Container(
                padding: const EdgeInsets.fromLTRB(
                    EdgeMargin.min, 0.0, EdgeMargin.min, 0.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                        child: Text(
                          Translations.of(context).translate('available_sizes'),
                          style: textStyle.middleTSBasic.copyWith(
                            color: globalColor.black,
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: globalColor.grey.withOpacity(0.5)),
                      child: Center(
                        child: Icon(
                          !_isDisplaySizeList
                              ? Icons.keyboard_arrow_down
                              : Icons.keyboard_arrow_up,
                          color: globalColor.black,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            VerticalPadding(
              percentage: .5,
            ),
            _isDisplaySizeList
                ? Container(
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: list.length,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return ItemSizeProductDetails(
                            width: width,
                            item: list[index],
                            isSelected: SizeModeId == list[index].id,
                            onSelect: _onSelectSize,
                          );
                        }),
                  )
                : Container(),
            // Container(
            //   child: Column(
            //     children: [
            //       _buildSizeItem(
            //           width: width,
            //           image: AppAssets.glasses_svg,
            //           context: context,
            //           height: height,
            //           isAvailable: true,
            //           label: 'SMALL'.toUpperCase(),
            //           size: '40-48',
            //           imageSize: 42.w),
            //       VerticalPadding(
            //         percentage: 1.0,
            //       ),
            //       _buildSizeItem(
            //           width: width,
            //           image: AppAssets.glasses_svg,
            //           context: context,
            //           height: height,
            //           isAvailable: false,
            //           label: 'Medium'.toUpperCase(),
            //           size: '49-54',
            //           imageSize: 55.w),
            //       VerticalPadding(
            //         percentage: 1.0,
            //       ),
            //       _buildSizeItem(
            //           width: width,
            //           image: AppAssets.glasses_svg,
            //           context: context,
            //           height: height,
            //           isAvailable: true,
            //           label: 'Large'.toUpperCase(),
            //           size: '55-58',
            //           imageSize: 65.w),
            //       VerticalPadding(
            //         percentage: 1.0,
            //       ),
            //       _buildSizeItem(
            //           width: width,
            //           image: AppAssets.glasses_svg,
            //           context: context,
            //           height: height,
            //           isAvailable: false,
            //           label: 'E-Large'.toUpperCase(),
            //           size: 'above 58',
            //           imageSize: 80.w),
            //     ],
            //   ),
            // )
          ],
        ),
      );
    }
    return Container();
  }

  _onSelectSize(GeneralItemEntity size, bool isSelected) {
    if (isSelected) {
      if (mounted) {
        setState(() {
          SizeModeId = size.id;
          //  listOfSizeMode.add(size.id);
        });
      }
    } else {
      if (mounted)
        setState(() {
          //  listOfSizeMode.removeWhere((element) => element == size.id);
        });
    }

    // print('listOfSizeMode ${listOfSizeMode.toString()}');
  }

  _buildAvailableGlassesColors(
      {required BuildContext context,
      required double width,
      required double height,
      List<GeneralItemEntity>? list}) {
    if (list != null && list.isNotEmpty) {
      Wrap body = Wrap(
          // alignment: WrapAlignment.start,
          // runAlignment: WrapAlignment.start,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(
                  EdgeMargin.sub, 0.0, EdgeMargin.sub, 0.0),
              child: Row(
                children: [
                  Container(
                    child: Text(
                      Translations.of(context).translate('available_colors'),
                      style: textStyle.middleTSBasic.copyWith(
                        color: globalColor.black,
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
            ),
          ]);

      body.children.addAll(list.map((item) {
        return ItemColorProductDetails(
          onSelect: _onSelectColors,
          item: item,
          isSelected: color?.id == item.id,
        );
      }));
      return Container(
          width: width,
          padding: const EdgeInsets.fromLTRB(
              EdgeMargin.min, 0.0, EdgeMargin.min, 0.0),
          child: body);
    }

    return Container();
  }

  _onSelectColors(GeneralItemEntity colors, bool isSelected) {
    if (isSelected) {
      if (mounted) {
        setState(() {
          color = colors;
          // listOfColorSelected.add(colors.id);
        });
      }
    } else {
      if (mounted)
        setState(() {
          // listOfColorSelected.removeWhere((element) => element == colors.id);
        });
    }

    //  print('listOfYourSelected ${listOfColorSelected.toString()}');
  }
  // _buildAvailableGlassesColors(
  //     {required BuildContext context,
  //   required   double width,
  //  required   double height,
  //     List<GeneralItemEntity> list}) {
  //   if (list != null && list.isNotEmpty) {
  //     Wrap body = Wrap(
  //         // alignment: WrapAlignment.start,
  //         // runAlignment: WrapAlignment.start,
  //         crossAxisAlignment: WrapCrossAlignment.center,
  //         children: [
  //           Container(
  //             padding: const EdgeInsets.fromLTRB(
  //                 EdgeMargin.sub, 0.0, EdgeMargin.sub, 0.0),
  //             child: Row(
  //               children: [
  //                 Container(
  //                   child: Text(
  //                     Translations.of(context).translate('available_colors') ??
  //                         '',
  //                     style: textStyle.middleTSBasic.copyWith(
  //                       color: globalColor.black,
  //                       fontWeight: FontWeight.w600,
  //                     ),
  //                     overflow: TextOverflow.ellipsis,
  //                     maxLines: 1,
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ]);
  //
  //     body.children.addAll(list.map((item) {
  //       return Container(
  //         decoration: BoxDecoration(
  //           color: globalColor.white.withOpacity(0.5),
  //           borderRadius: BorderRadius.all(Radius.circular(10.w)),
  //           border: Border.all(
  //               color: globalColor.grey.withOpacity(0.3), width: 0.5),
  //         ),
  //         height: 35.h,
  //         width: 65.w,
  //         margin: const EdgeInsets.only(
  //             left: EdgeMargin.verySub,
  //             right: EdgeMargin.verySub,
  //             bottom: EdgeMargin.verySub),
  //         child: Padding(
  //           padding: const EdgeInsets.all(EdgeMargin.sub),
  //           child: SvgPicture.asset(
  //             AppAssets.availbale_galsses_color_svg ?? '',
  //             width: 25.w,
  //             color: HexColor(item.value),
  //           ),
  //         ),
  //       );
  //     }));
  //     return Container(
  //         width: width,
  //         padding: const EdgeInsets.fromLTRB(
  //             EdgeMargin.min, 0.0, EdgeMargin.min, 0.0),
  //         child: body);
  //   }
  //
  //   return Container();
  // }

  _buildEnterDimensionsOfGlassesWidget(
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
                      Translations.of(context)
                          .translate('enter_the_dimensions_of_the_glasses'),
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
          Container(
            child: Row(
              children: [
                Expanded(
                    flex: 1,
                    child: _buildDimensionsInputWidget(
                      context: context,
                      controller: frameHeightEditingController,
                      height: height,
                      width: width,
                      text: _frameHeight,
                      textValidation: _frameHeightValidation,
                      image: AppAssets.frame_height_png,
                      imageSize: 65.w,
                      widgetSubTitle: 'Frame Height',
                      widgetTitle: 'ارتفاع الاطار',
                    )),
                HorizontalPadding(
                  percentage: 0.5,
                ),
                Expanded(
                    flex: 1,
                    child: _buildDimensionsInputWidget(
                      context: context,
                      controller: frameWidthEditingController,
                      height: height,
                      width: width,
                      text: _frameWidth,
                      textValidation: _frameWidthValidation,
                      image: AppAssets.frame_width_png,
                      imageSize: 65.w,
                      widgetSubTitle: 'Frame Width',
                      widgetTitle: 'عرض الاطار',
                    )),
                HorizontalPadding(
                  percentage: 0.5,
                ),
                Expanded(
                    flex: 1,
                    child: _buildDimensionsInputWidget(
                      context: context,
                      controller: frameLengthEditingController,
                      height: height,
                      width: width,
                      text: _frameLength,
                      textValidation: _frameLengthValidation,
                      image: AppAssets.frame_length_png,
                      imageSize: 65.w,
                      widgetSubTitle: 'Frame Length',
                      widgetTitle: 'طول الاطار',
                    )),
              ],
            ),
          )
        ],
      ),
    );
  }

  _buildDimensionsInputWidget({
    required BuildContext context,
    required double width,
    required double height,
    TextEditingController? controller,
    bool? textValidation,
    String? text,
    String? widgetTitle,
    String? image,
    double? imageSize,
    String? widgetSubTitle,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: globalColor.white.withOpacity(0.5),
        borderRadius: BorderRadius.all(Radius.circular(12.w)),
        border:
            Border.all(color: globalColor.grey.withOpacity(0.3), width: 0.5),
      ),
      //   margin: const EdgeInsets.only(left: EdgeMargin.verySub,),
      child: Column(
        children: [
          VerticalPadding(
            percentage: 1.0,
          ),
          Container(
            child: Text(
              widgetTitle ?? '',
              style: textStyle.minTSBasic.copyWith(color: globalColor.black),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(EdgeMargin.subSubMin),
            child: Container(
              decoration: BoxDecoration(
                color: globalColor.white.withOpacity(0.5),
                borderRadius: BorderRadius.all(Radius.circular(12.w)),
                border: Border.all(
                    color: globalColor.grey.withOpacity(0.3), width: 0.5),
              ),
              padding: const EdgeInsets.all(EdgeMargin.sub),
              child: Center(
                child: Column(
                  children: [
                    VerticalPadding(
                      percentage: 1.0,
                    ),
                    Container(
                      child: Image.asset(
                        image ?? AppAssets.frame_height_png,
                        width: imageSize ?? 55.w,
                        fit: BoxFit.fill,
                      ),
                    ),
                    VerticalPadding(
                      percentage: 2.0,
                    ),
                    Container(
                      child: Text(
                        widgetSubTitle ?? '',
                        style: textStyle.sub2MinTSBasic
                            .copyWith(color: globalColor.black),
                      ),
                    ),
                    VerticalPadding(
                      percentage: 1.0,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(EdgeMargin.subSubMin),
            child: Container(
              child: BorderFormField(
                controller: controller,
                validator: (value) {
                  return BaseValidator.validateValue(
                    context,
                    value!,
                    [],
                    textValidation ?? false,
                  );
                },
                hintText: '48mm',
                hintStyle: textStyle.minTSBasic.copyWith(
                    color: globalColor.grey, fontWeight: FontWeight.bold),
                style: textStyle.minTSBasic.copyWith(
                    color: globalColor.black, fontWeight: FontWeight.bold),
                filled: false,
                keyboardType: TextInputType.number,
                borderRadius: 12.w,
                onChanged: (value) {
                  setState(() {
                    textValidation = true;
                    text = value;
                  });
                },
                textAlign: TextAlign.center,
                borderColor: globalColor.grey.withOpacity(0.3),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).nextFocus();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  _buildTryChooseWidget(
      {required BuildContext context,
      required double width,
      required double height}) {
    return Container(
      height: 43.h,
      width: width,
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: InkWell(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (ctx) => SoonDialog(),
                );
              },
              child: Container(
                height: 43.h,
                decoration: BoxDecoration(
                    border: Border(
                        top: BorderSide(
                            color: globalColor.grey.withOpacity(0.3),
                            width: 0.5),
                        bottom: BorderSide(
                            color: globalColor.grey.withOpacity(0.3),
                            width: 0.5))),
                child: Container(
                  padding: const EdgeInsets.fromLTRB(
                      EdgeMargin.min, 0.0, EdgeMargin.min, 0.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        child: SvgPicture.asset(
                          AppAssets.camera,
                          width: 18.w,
                        ),
                      ),
                      HorizontalPadding(
                        percentage: 1.0,
                      ),
                      Container(
                        child: Text(
                          Translations.of(context)
                              .translate('try_the_glasses_before_buying'),
                          style: textStyle.minTSBasic
                              .copyWith(color: globalColor.black),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: InkWell(
              onTap: () async {
                final result = await Get.Get.toNamed(SelectLensesPage.routeName,
                    arguments:
                        ProductDetailsArguments(product: widget.product));
                if (result != null) {
                  if (mounted)
                    setState(() {
                      selectLensesArgs = result;
                    });
                }
              },
              child: Container(
                color: globalColor.goldColor,
                height: 43.h,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      child: SvgPicture.asset(
                        AppAssets.lenses_svg,
                        width: 18.w,
                      ),
                    ),
                    HorizontalPadding(
                      percentage: 1.0,
                    ),
                    Container(
                      child: Text(
                        Translations.of(context).translate('choose_lenses'),
                        style: textStyle.smallTSBasic
                            .copyWith(color: globalColor.black),
                      ),
                    ),
                    HorizontalPadding(
                      percentage: 1.0,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: globalColor.white),
                      child: Center(
                        child: Icon(
                          utils.getLang() == 'ar'
                              ? Icons.keyboard_arrow_left
                              : Icons.keyboard_arrow_right,
                          color: globalColor.black,
                          size: 18.w,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
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
      required double height,
      ProductDetailsEntity? productEntity,
      bool isAuth = false}) {
    return Container(
      padding:
          const EdgeInsets.fromLTRB(EdgeMargin.min, 0.0, EdgeMargin.min, 0.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 3,
            child: InkWell(
              onTap: () async {
                final result =
                    await AddOrRemoveFavorite(locator<ProductRepository>())(
                  AddOrRemoveFavoriteParams(
                      cancelToken: widget.cancelToken,
                      productId: widget.product?.id ?? -1),
                );
                if (result.hasDataOnly) {
                  if (mounted)
                    setState(() {
                      // isRemoveFromFavorite = true;
                      //
                      // BlocProvider.of<ApplicationBloc>(context)
                      //     .state
                      //     .setRefreshFavoritePath(true);
                      widget.productDetails?.isFavorite =
                          !(widget.productDetails?.isFavorite ?? true);
                      // widget.path.setIsFav(!widget.path.isFav);
                    });
                } else if (result.hasErrorOnly || result.hasDataAndError)
                  Fluttertoast.showToast(
                      msg: Translations.of(context)
                          .translate('something_went_wrong_try_again'));
              },
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
                      widget.productDetails?.isFavorite ?? false
                          ? AppAssets.love_fill
                          : AppAssets.love,
                      //color: globalColor.black,
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
          ),
          HorizontalPadding(
            percentage: 2.0,
          ),
          Consumer<CartProvider>(
            builder: (BuildContext context, CartProvider quizProvider,
                Widget? child) {
              return Expanded(
                flex: 3,
                child: InkWell(
                  onTap: () async {
                    if (await UserRepository.hasToken && isAuth) {
                      if ((color != null && color?.id != null) &&
                          SizeModeId != null) {
                        quizProvider.addItemToCart(CartEntity(
                            id: productEntity?.id,
                            productEntity: productEntity,
                            isGlasses: productEntity?.isGlasses,
                            colorId: color?.id,
                            lensSize: null,
                            sizeForLeftEye: null,
                            SizeModeId: SizeModeId,
                            sizeForRightEye: null,
                            argsForGlasses: selectLensesArgs,
                            count: 1));
                        print('${quizProvider.getItems()?.length}');
                        showDialog(
                          context: context,
                          builder: (ctx) => AddToCartDialog(),
                        );
                      } else {
                        appConfig.showToast(
                            msg: Translations.of(context)
                                .translate('you_must_choose_size_and_color'));
                      }
                    } else {
                      showDialog(
                        context: context,
                        builder: (ctx) => LoginFirstDialog(),
                      );
                    }

                    // quizProvider.addItemToCart(CartEntity(
                    //     id: productEntity.id,
                    //     productEntity: productEntity,
                    //     isGlasses: productEntity.isGlasses,
                    //     addSize: null,
                    //     ipdSize: null,
                    //     sizeForLeftEye: null,
                    //     sizeForRightEye: null,
                    //     count: 1));
                    // print('${quizProvider.getItems().length}');
                    // showDialog(
                    //   context: context,
                    //   builder: (ctx) => AddToCartDialog(),
                    // );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: globalColor.white,
                        borderRadius: BorderRadius.circular(16.0.w),
                        border: Border.all(
                            width: 0.5,
                            color: globalColor.grey.withOpacity(0.3))),
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
              );
            },
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
      child: widget.productDetails?.productAsSame != null &&
              (widget.productDetails?.productAsSame?.isNotEmpty ?? false)
          ? Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      left: EdgeMargin.small, right: EdgeMargin.small),
                  child: TitleWithViewAllWidget(
                    width: width,
                    title:
                        Translations.of(context).translate('similar_products'),
                    onClickView: () {},
                    strViewAll: Translations.of(context).translate('view_all'),
                  ),
                ),
                Container(
                    child: GridView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: widget.productDetails?.productAsSame?.length,
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
                          return ItemProductHomeWidget(
                            height: globalSize.setWidthPercentage(60, context),
                            width: globalSize.setWidthPercentage(47, context),
                            product:
                                widget.productDetails?.productAsSame?[index],
                          );
                        }))
              ],
            )
          : Container(),
    );
  }

  _divider() {
    return Divider(
      color: globalColor.grey.withOpacity(0.3),
      height: 8.h,
    );
  }

  _buildPriceWidget(
      {double? price, double? discountPrice, String? priceAfterDiscount}) {
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
                      text: price?.toString() ?? '',
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
}
