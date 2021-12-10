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
import 'package:ojos_app/core/res/screen/horizontal_padding.dart';
import 'package:ojos_app/core/res/screen/vertical_padding.dart';
import 'package:ojos_app/core/res/text_style.dart';
import 'package:ojos_app/core/res/width_height.dart';
import 'package:ojos_app/core/ui/dailog/add_to_cart_dialog.dart';
import 'package:ojos_app/core/ui/dailog/login_first_dialog.dart';
import 'package:ojos_app/core/ui/widget/button/custom2_dropdown_button.dart';
import 'package:ojos_app/core/ui/widget/image/image_caching.dart';
import 'package:ojos_app/core/ui/widget/text/normal_form_field.dart';
import 'package:ojos_app/core/ui/widget/title_with_view_all_widget.dart';
import 'package:ojos_app/core/validators/base_validator.dart';
import 'package:ojos_app/features/product/domin/entities/cart_entity.dart';
import 'package:ojos_app/features/product/domin/entities/general_item_entity.dart';
import 'package:ojos_app/features/product/domin/entities/image_info_entity.dart';
import 'package:ojos_app/features/product/domin/entities/product_details_entity.dart';
import 'package:ojos_app/features/product/domin/entities/product_entity.dart';
import 'package:ojos_app/features/product/domin/repositories/product_repository.dart';
import 'package:ojos_app/features/product/domin/usecases/add_remove_favorite.dart';
import 'package:ojos_app/features/product/presentation/widgets/item_color_widget.dart';
import 'package:ojos_app/features/reviews/presentation/pages/add_reviews_page.dart';
import 'package:ojos_app/features/user_management/domain/repositories/user_repository.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../../main.dart';
import '../item_product_home_widget.dart';
import '../item_product_widget.dart';
import '../lens_select_ipd_add_widget.dart';
import '../lens_select_size_widget.dart';

class LensesDetailsWidget extends StatefulWidget {
  final double width;
  final double height;
  final ProductEntity? product;
  final ProductDetailsEntity? productDetails;
  final CancelToken cancelToken;
  const LensesDetailsWidget(
      {required this.height,
      required this.width,
      this.product,
      this.productDetails,
      required this.cancelToken});

  @override
  _LensesDetailsWidgetState createState() => _LensesDetailsWidgetState();
}

class _LensesDetailsWidgetState extends State<LensesDetailsWidget> {
  PageController controller =
      PageController(initialPage: 0, keepPage: true, viewportFraction: 1);
  var currentPageValue = 0;

  // /// add parameters
  // bool _addValidation = false;
  // String _add = '';
  // final TextEditingController addEditingController =
  //     new TextEditingController();
  //
  // /// ipd parameters
  // bool _ipdWidthValidation = false;
  // String _ipd = '';
  // final TextEditingController ipdEditingController =
  //     new TextEditingController();

  GeneralItemEntity? _colorSelect;

  LensesSelectedEnum? _selectedForRightEye;
  LensesSelectedEnum? _selectedForLeftEye;
  LensesIpdAddEnum? _selectedForAddIPD;

  bool isAuth = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _colorSelect = widget.product?.colorInfo?.first;
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
                  discountPrice: widget.productDetails!.discountPrice,
                  discountType: widget.productDetails!.discountTypeInt,
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
                  companyName: widget.productDetails?.shopInfo?.name ?? ''),
              _buildLensesColorWidget(
                  context: context,
                  width: width,
                  height: height,
                  listOfColor: widget.productDetails?.colorInfo ?? []),
              _buildLensesSizeForRightEyessWidget(
                  context: context,
                  width: width,
                  height: height,
                  title: Translations.of(context)
                      .translate('lens_size_for_right_eye')),
              _buildLensesSizeForLeftEyessWidget(
                  context: context,
                  width: width,
                  height: height,
                  title: Translations.of(context)
                      .translate('lens_size_for_left_eye')),

              // _buildLensesSizeForEyessWidget(
              //     context: context,
              //     width: width,
              //     height: height,
              //     title: 'test'
              // ),
              _buildEnterDimensionsOfLensesWidget(
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
                            priceAfterDiscount: priceAfterDiscount),
                      ),
                    ],
                  )))
        ],
      ),
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

  _buildLensesColorWidget(
      {required BuildContext context,
      required double width,
      required double height,
      List<GeneralItemEntity>? listOfColor}) {
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
              flex: 4,
              child: Container(
                child: Text(
                  Translations.of(context).translate('the_color_of_the_lens'),
                  style: textStyle.smallTSBasic.copyWith(
                      fontWeight: FontWeight.w500, color: globalColor.black),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                width: widget.width * .4,
                height: 35.h,
                child: Custom2Dropdown<GeneralItemEntity>(
                  onChanged: (data) {
                    _colorSelect = data;
                    if (mounted) setState(() {});
                  },
                  value: _colorSelect,
                  borderRadius: widget.width * .4,
                  hint: '',
                  dropdownMenuItemList: listOfColor!.map((profession) {
                    return DropdownMenuItem(
                      child: Container(
                        width: widget.width,
                        decoration: BoxDecoration(
                            color: profession == _colorSelect
                                ? globalColor.primaryColor.withOpacity(0.3)
                                : globalColor.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(12.w))),
                        padding: EdgeInsets.all(EdgeMargin.small),
                        child: ItemColorWidget(
                          color: profession,
                        ),
                      ),
                      value: profession,
                    );
                  }).toList(),
                  selectedItemBuilder: (BuildContext context) {
                    return listOfColor.map<Widget>((item) {
                      return ItemColorWidget(
                        color: item,
                      );
                    }).toList();
                  },
                  isEnabled: true,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buildLensesSizeForRightEyessWidget(
      {required BuildContext context,
      required double width,
      required double height,
      String? title}) {
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
            LensSelectSizeWidget(
              onSelected: (lensesSelected) {
                _selectedForRightEye = lensesSelected;
                if (mounted) {
                  setState(() {});
                }
                print('lensesSelected is $lensesSelected');
              },
              width: width,
            )
          ],
        ),
      ),
    );
  }

  _buildLensesSizeForLeftEyessWidget({
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
            LensSelectSizeWidget(
              onSelected: (lensesSelected) {
                _selectedForLeftEye = lensesSelected;
                if (mounted) {
                  setState(() {});
                }
                print('lensesSelected is $lensesSelected');
              },
              width: width,
            )
          ],
        ),
      ),
    );
  }

  _buildEnterDimensionsOfLensesWidget(
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
              ],
            ),
          ),

          Container(
            padding: const EdgeInsets.fromLTRB(
                EdgeMargin.min, 0.0, EdgeMargin.min, 0.0),
            child: LensSelectIpdAddWidget(
              onSelected: (lensesSelected) {
                _selectedForAddIPD = lensesSelected;
                if (mounted) {
                  setState(() {});
                }
                print('lensesSelected is $lensesSelected');
              },
              width: width,
            ),
          ),
          // Container(
          //   child: Row(
          //     children: [
          //       Expanded(
          //           flex: 1,
          //           child: Padding(
          //             padding: const EdgeInsets.all(EdgeMargin.subSubMin),
          //             child: Container(
          //               child: BorderFormField(
          //                 controller: addEditingController,
          //                 validator: (value) {
          //                   return BaseValidator.validateValue(
          //                     context,
          //                     value,
          //                     [],
          //                     _addValidation,
          //                   );
          //                 },
          //                 hintText: 'ADD',
          //                 hintStyle: textStyle.smallTSBasic.copyWith(
          //                     color: globalColor.grey,
          //                     fontWeight: FontWeight.bold),
          //                 style: textStyle.smallTSBasic.copyWith(
          //                     color: globalColor.black,
          //                     fontWeight: FontWeight.bold),
          //                 filled: false,
          //                 keyboardType: TextInputType.number,
          //                 borderRadius: 12.w,
          //                 onChanged: (value) {
          //                   setState(() {
          //                     _addValidation = true;
          //                     _add = value;
          //                   });
          //                 },
          //                 textAlign: TextAlign.center,
          //                 borderColor: globalColor.grey.withOpacity(0.3),
          //                 textInputAction: TextInputAction.next,
          //                 onFieldSubmitted: (_) {
          //                   FocusScope.of(context).nextFocus();
          //                 },
          //               ),
          //             ),
          //           )),
          //       HorizontalPadding(
          //         percentage: 0.5,
          //       ),
          //       Expanded(
          //         flex: 1,
          //         child: Padding(
          //           padding: const EdgeInsets.all(EdgeMargin.subSubMin),
          //           child: Container(
          //             child: BorderFormField(
          //               controller: ipdEditingController,
          //               validator: (value) {
          //                 return BaseValidator.validateValue(
          //                   context,
          //                   value,
          //                   [],
          //                   _ipdWidthValidation,
          //                 );
          //               },
          //               hintText: 'IPD',
          //               hintStyle: textStyle.smallTSBasic.copyWith(
          //                   color: globalColor.grey,
          //                   fontWeight: FontWeight.bold),
          //               style: textStyle.smallTSBasic.copyWith(
          //                   color: globalColor.black,
          //                   fontWeight: FontWeight.bold),
          //               filled: false,
          //               keyboardType: TextInputType.number,
          //               borderRadius: 12.w,
          //               onChanged: (value) {
          //                 setState(() {
          //                   _ipdWidthValidation = true;
          //                   _ipd = value;
          //                 });
          //               },
          //               textAlign: TextAlign.center,
          //               borderColor: globalColor.grey.withOpacity(0.3),
          //               textInputAction: TextInputAction.next,
          //               onFieldSubmitted: (_) {
          //                 FocusScope.of(context).nextFocus();
          //               },
          //             ),
          //           ),
          //         ),
          //       ),
          //     ],
          //   ),
          // )
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
      bool? isAuth = false}) {
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
                    if (await UserRepository.hasToken && isAuth!) {
                      if (_checkStatus()) {
                        quizProvider.addItemToCart(CartEntity(
                          id: productEntity?.id ?? -1,
                          productEntity: productEntity,
                          isGlasses: false,
                          SizeModeId: null,
                          colorId: _colorSelect?.id,
                          lensSize: _selectedForAddIPD,
                          sizeForLeftEye: _selectedForLeftEye,
                          sizeForRightEye: _selectedForRightEye,
                          count: 1,
                          argsForGlasses: null,
                        ));
                        print('${quizProvider.getItems()?.length}');
                        showDialog(
                          context: context,
                          builder: (ctx) => AddToCartDialog(),
                        );
                      } else {
                        appConfig.showToast(
                            msg: Translations.of(context)
                                .translate('please_choose_lens_sizes'),
                            backgroundColor: globalColor.primaryColor,
                            textColor: globalColor.white);
                      }
                    } else {
                      showDialog(
                        context: context,
                        builder: (ctx) => LoginFirstDialog(),
                      );
                    }
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
          // Expanded(
          //   flex: 3,
          //   child: Container(
          //     decoration: BoxDecoration(
          //         color: globalColor.white,
          //         borderRadius: BorderRadius.circular(16.0.w),
          //         border: Border.all(
          //             width: 0.5, color: globalColor.grey.withOpacity(0.3))),
          //     height: 35.w,
          //     child: Row(
          //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //       children: [
          //         SvgPicture.asset(
          //           AppAssets.cart_nav_bar,
          //           color: globalColor.black,
          //           width: 20.w,
          //         ),
          //         Text(
          //           Translations.of(context).translate('add_to_cart'),
          //           style: textStyle.smallTSBasic.copyWith(
          //               fontWeight: FontWeight.w500,
          //               color: globalColor.primaryColor),
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  _checkStatus() {
    // print('_add ${_add}');
    // print('_ipd ${_ipd}');
    print('_selectedForLeftEye ${_selectedForLeftEye.toString()}');
    print('_selectedForAddIPD ${_selectedForAddIPD.toString()}');
    print('_selectedForRightEye ${_selectedForRightEye.toString()}');
    return _selectedForAddIPD != null &&
        _selectedForLeftEye != null &&
        _selectedForRightEye != null;
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
                                widget.productDetails?.productAsSame![index],
                          );
                        }))
              ],
            )
          : Container(),
    );
  }

  // _buildSimilarProducts({required BuildContext context, required  double width,required  double height}) {
  //   return Container(
  //     child: Column(
  //       children: [
  //         Padding(
  //           padding: const EdgeInsets.only(
  //               left: EdgeMargin.small, right: EdgeMargin.small),
  //           child: TitleWithViewAllWidget(
  //             width: width,
  //             title: Translations.of(context).translate('similar_products'),
  //             onClickView: () {},
  //             strViewAll: Translations.of(context).translate('view_all'),
  //           ),
  //         ),
  //         // Container(
  //         //   child: GridView.builder(
  //         //       physics: NeverScrollableScrollPhysics(),
  //         //       padding: const EdgeInsets.only(
  //         //           left: EdgeMargin.small, right: EdgeMargin.small),
  //         //       itemCount: listOfProduct.length,
  //         //       shrinkWrap: true,
  //         //       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
  //         //         crossAxisCount: 2,
  //         //         crossAxisSpacing: 4,
  //         //         mainAxisSpacing: 4,
  //         //         childAspectRatio: globalSize.setWidthPercentage(40, context) /
  //         //             globalSize.setWidthPercentage(55, context),
  //         //       ),
  //         //       itemBuilder: (context, index) {
  //         //         return ItemProductHomeWidget(
  //         //           product: listOfProduct[index],
  //         //           height: globalSize.setWidthPercentage(55, context),
  //         //           width: globalSize.setWidthPercentage(40, context),
  //         //         );
  //         //       }),
  //         // )
  //       ],
  //     ),
  //   );
  // }

  _divider() {
    return Divider(
      color: globalColor.grey.withOpacity(0.3),
      height: 20.h,
    );
  }
}
