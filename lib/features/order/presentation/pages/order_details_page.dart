import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart' as Get;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ojos_app/core/appConfig.dart';
import 'package:ojos_app/core/localization/translations.dart';
import 'package:ojos_app/core/res/edge_margin.dart';
import 'package:ojos_app/core/res/global_color.dart';
import 'package:ojos_app/core/res/screen/horizontal_padding.dart';
import 'package:ojos_app/core/res/screen/vertical_padding.dart';
import 'package:ojos_app/core/res/text_style.dart';
import 'package:ojos_app/core/res/utils.dart';
import 'package:ojos_app/core/res/width_height.dart';
import 'package:ojos_app/core/ui/button/arrow_back_button_widget.dart';
import 'package:ojos_app/core/ui/widget/image/image_caching.dart';
import 'package:ojos_app/features/order/domain/entities/general_order_item_entity.dart';
import 'package:ojos_app/features/product/presentation/args/product_details_args.dart';
import 'package:ojos_app/features/product/presentation/pages/lenses_details_page.dart';
import 'package:ojos_app/features/product/presentation/pages/product_details_page.dart';

import '../../domain/entities/order_item_entity.dart';

class OrderDetailsPage extends StatefulWidget {
  static const routeName = '/order/pages/OrderDetailsPage';

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<OrderDetailsPage> {
  double? latitude;
  double? longitude;
  final args = Get.Get.arguments as GeneralOrderItemEntity;

  @override
  void initState() {
    super.initState();
    latitude = args.user_address?.latitude;
    longitude = args.user_address?.longitude;
  }

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  var _cancelToken = CancelToken();

  ///===========================================================================

  Set<Marker> markers = {};

  /// initial position
  CameraPosition _initialLocation = CameraPosition(
      target: LatLng(34.80207500000000209183781407773494720458984375,
          38.996814999999998008206603117287158966064453125),
      zoom: 13);

  ///
  Map<PolylineId, Polyline> polylines = {};
  late BitmapDescriptor? pinLocationIcon;

  ///
  GoogleMapController? mapController;

  ///===========================================================================

  @override
  Widget build(BuildContext context) {
    //=========================================================================

    AppBar appBar = AppBar(
      backgroundColor: globalColor.appBar,
      brightness: Brightness.light,
      elevation: 0,
      leading: ArrowIconButtonWidget(
        iconColor: globalColor.black,
      ),
      title: Text(
        Translations.of(context).translate('order_details'),
        style: textStyle.middleTSBasic.copyWith(color: globalColor.black),
      ),
      centerTitle: true,
    );

    double width = globalSize.setWidthPercentage(100, context);
    double height = globalSize.setHeightPercentage(100, context) -
        appBar.preferredSize.height -
        MediaQuery.of(context).viewPadding.top;

    return Scaffold(
        appBar: appBar,
        key: _scaffoldKey,
        body: Container(
            height: height,
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Container(
                child: Column(
                  children: [
                    _buildOrderInfoWidget(
                      context: context,
                      name: args.billing_name,
                      date: args.order_items?[0].created_at ?? '',
                      height: height,
                      width: width,
                      price: args.total?.toString(),
                      orderNumber: args.order_number,
                    ),
                    VerticalPadding(
                      percentage: 2.0,
                    ),
                    Container(
                      padding: const EdgeInsets.only(
                          left: EdgeMargin.min, right: EdgeMargin.min),
                      child: _buildMap(
                        width: width,
                        height: height,
                        context: context,
                      ),
                    ),
                    VerticalPadding(
                      percentage: 2.0,
                    ),
                    _buildPaymentMethodWidget(
                        width: width,
                        height: height,
                        context: context,
                        name: args.paymentmehtod ?? ''),
                    _orderStatus(
                        width: width,
                        height: height,
                        context: context,
                        status: args.statusint),
                    _buildOrderSummeryWidget(
                        width: width,
                        height: height,
                        context: context,
                        order: args),
                    _buildPriceSummeryWidget(
                        width: width,
                        height: height,
                        context: context,
                        order: args),
                    Container(
                        alignment: AlignmentDirectional.center,
                        padding: const EdgeInsets.only(
                            left: EdgeMargin.min, right: EdgeMargin.min),
                        child: Text(
                          '${Translations.of(context).translate('all_prices_include')} ${args.tax?.toString()} ${Translations.of(context).translate('from_value_tax')} \n ${Translations.of(context).translate('the_number_of_products')} ${_getCount(args.order_items ?? []) ?? ''}',
                          style: textStyle.smallTSBasic.copyWith(
                              color: globalColor.black,
                              fontWeight: FontWeight.w500),
                          textAlign: TextAlign.center,
                        )),
                    VerticalPadding(
                      percentage: 4.0,
                    ),
                  ],
                ),
              ),
            )));
  }

  _getCount(List<OrderItemEntity>? list) {
    int count = 0;
    if (list != null && list.isNotEmpty) {
      for (OrderItemEntity item in list) {
        if (item.quantity != null && item.quantity != 0) {
          count += (item.quantity ?? 0);
        }
      }
    }
    return count;
  }

  _buildOrderInfoWidget(
      {required BuildContext context,
      required double width,
      required double height,
      String? name,
      String? orderNumber,
      String? price,
      String? date}) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        EdgeMargin.subMin,
        EdgeMargin.verySub,
        EdgeMargin.subMin,
        EdgeMargin.verySub,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(12.w)),
        child: Container(
          padding: const EdgeInsets.fromLTRB(
            0,
            EdgeMargin.verySub,
            0,
            EdgeMargin.verySub,
          ),
          decoration: BoxDecoration(
            color: globalColor.white,
            borderRadius: BorderRadius.all(Radius.circular(12.w)),
            border: Border.all(
                color: globalColor.grey.withOpacity(0.3), width: 0.5),
          ),
          //   margin: const EdgeInsets.only(left: EdgeMargin.verySub,),
          width: width,

          child: Row(
            children: [
              Expanded(
                flex: 5,
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                      EdgeMargin.subMin,
                      EdgeMargin.verySub,
                      EdgeMargin.subMin,
                      EdgeMargin.verySub,
                    ),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 15.w,
                              height: 15.w,
                              decoration: BoxDecoration(
                                  color: globalColor.primaryColor,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      width: 1.0,
                                      color: globalColor.primaryColor)),
                              child: Icon(
                                Icons.check,
                                color: globalColor.white,
                                size: 10.w,
                              ),
                            ),
                            HorizontalPadding(
                              percentage: 1.0,
                            ),
                            Text(
                              name ?? '',
                              style: textStyle.middleTSBasic.copyWith(
                                  color: globalColor.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              Translations.of(context).translate('order_no') +
                                  ':',
                              style: textStyle.minTSBasic
                                  .copyWith(color: globalColor.black),
                            ),
                            HorizontalPadding(
                              percentage: 1.0,
                            ),
                            Text(
                              orderNumber ?? '',
                              style: textStyle.minTSBasic
                                  .copyWith(color: globalColor.primaryColor),
                            ),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              Translations.of(context).translate('date'),
                              style: textStyle.minTSBasic
                                  .copyWith(color: globalColor.black),
                            ),
                            HorizontalPadding(
                              percentage: 1.0,
                            ),
                            Text(
                              date ?? '',
                              style: textStyle.minTSBasic
                                  .copyWith(color: globalColor.primaryColor),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                width: 1.0,
                color: globalColor.grey.withOpacity(0.3),
              ),
              Expanded(
                flex: 3,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(
                    EdgeMargin.subMin,
                    EdgeMargin.verySub,
                    EdgeMargin.subMin,
                    EdgeMargin.verySub,
                  ),
                  alignment: AlignmentDirectional.center,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      HorizontalPadding(
                        percentage: 1.0,
                      ),
                      Text(
                        price ?? '',
                        style: textStyle.bigTSBasic.copyWith(
                            color: globalColor.primaryColor,
                            fontWeight: FontWeight.bold),
                      ),
                      HorizontalPadding(
                        percentage: 1.0,
                      ),
                      Text(
                        '${Translations.of(context).translate('rail')}',
                        style: textStyle.middleTSBasic
                            .copyWith(color: globalColor.primaryColor),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _buildMap({
    required BuildContext context,
    required double width,
    required double height,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(12.w)),
      child: Container(
        decoration: BoxDecoration(
          color: globalColor.white,
          borderRadius: BorderRadius.all(Radius.circular(12.w)),
          border:
              Border.all(color: globalColor.grey.withOpacity(0.3), width: 0.5),
        ),
        //   margin: const EdgeInsets.only(left: EdgeMargin.verySub,),
        width: width,

        child: Column(
          children: [
            VerticalPadding(
              percentage: 0.5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                      EdgeMargin.subMin,
                      EdgeMargin.verySub,
                      EdgeMargin.subMin,
                      EdgeMargin.verySub,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          Translations.of(context)
                              .translate('cart_txt_delivery_location'),
                          style: textStyle.smallTSBasic.copyWith(
                              color: globalColor.black,
                              fontWeight: FontWeight.bold),
                        ),
                        HorizontalPadding(
                          percentage: 1.0,
                        ),
                        // Text(
                        //   Translations.of(context)
                        //       .translate('cart_txt_automatic_GPS_selections'),
                        //   style: textStyle.smallTSBasic.copyWith(
                        //       color: globalColor.primaryColor,
                        //       fontWeight: FontWeight.bold),
                        // ),
                      ],
                    ),
                  ),
                ),
                Container(
                  child: Icon(
                    utils.getLang() != 'ar'
                        ? Icons.keyboard_arrow_right
                        : Icons.keyboard_arrow_left,
                    color: globalColor.black,
                  ),
                ),
              ],
            ),
            //  _buildSearchWidgetForMap(context: context, width: width),
            Container(
              height: 180,
              padding: const EdgeInsets.all(EdgeMargin.small),
              child: GoogleMap(
                initialCameraPosition: _initialLocation,
                myLocationEnabled: false,
                myLocationButtonEnabled: false,
                mapType: MapType.normal,
                zoomGesturesEnabled: true,
                zoomControlsEnabled: false,
                polylines: Set<Polyline>.of(polylines.values),
                markers: Set<Marker>.from(markers),
                onMapCreated: (GoogleMapController controller) async {
                  mapController = controller;
                  // controller.setMapStyle(_mapStyle);
                  // await  createMArker();
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  _buildPaymentMethodWidget({
    required BuildContext context,
    required double width,
    required double height,
    String? name,
  }) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        EdgeMargin.subMin,
        EdgeMargin.verySub,
        EdgeMargin.subMin,
        EdgeMargin.verySub,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(12.w)),
        child: Container(
          padding: const EdgeInsets.fromLTRB(
            EdgeMargin.min,
            EdgeMargin.min,
            EdgeMargin.min,
            EdgeMargin.min,
          ),
          decoration: BoxDecoration(
            color: globalColor.white,
            borderRadius: BorderRadius.all(Radius.circular(12.w)),
            border: Border.all(
                color: globalColor.grey.withOpacity(0.3), width: 0.5),
          ),
          //   margin: const EdgeInsets.only(left: EdgeMargin.verySub,),
          width: width,

          child: Row(
            children: [
              Text(
                Translations.of(context).translate('payment_method'),
                style: textStyle.smallTSBasic.copyWith(
                    color: globalColor.black, fontWeight: FontWeight.bold),
              ),
              HorizontalPadding(
                percentage: 3.0,
              ),
              Expanded(
                flex: 5,
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                      EdgeMargin.subMin,
                      EdgeMargin.verySub,
                      EdgeMargin.subMin,
                      EdgeMargin.verySub,
                    ),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 15.w,
                              height: 15.w,
                              decoration: BoxDecoration(
                                  color: globalColor.primaryColor,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      width: 1.0,
                                      color: globalColor.primaryColor)),
                              child: Icon(
                                Icons.check,
                                color: globalColor.white,
                                size: 10.w,
                              ),
                            ),
                            HorizontalPadding(
                              percentage: 1.0,
                            ),
                            Text(
                              name ?? '',
                              style: textStyle.middleTSBasic.copyWith(
                                  color: globalColor.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _orderStatus({
    required BuildContext context,
    required double width,
    required double height,
    int? status,
  }) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        EdgeMargin.subMin,
        EdgeMargin.verySub,
        EdgeMargin.subMin,
        EdgeMargin.verySub,
      ),
      height: 41.h,
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(12.w)),
        child: Container(
          padding: const EdgeInsets.fromLTRB(
            0,
            0,
            0,
            0,
          ),
          decoration: BoxDecoration(
            color: globalColor.white,
            borderRadius: BorderRadius.all(Radius.circular(12.w)),
            border: Border.all(
                color: globalColor.grey.withOpacity(0.3), width: 0.5),
          ),
          //   margin: const EdgeInsets.only(left: EdgeMargin.verySub,),
          width: width,
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(12.w)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.only(
                        left: EdgeMargin.subMin, right: EdgeMargin.subMin),
                    child: Text(
                      '${Translations.of(context).translate('order_status')}',
                      style: textStyle.smallTSBasic.copyWith(
                          color: globalColor.black,
                          fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                ),
                Container(
                  //margin: const EdgeInsets.only(left:EdgeMargin.min,right: EdgeMargin.min),
                  width: 148.w,
                  height: 41.h,
                  color: globalColor.scaffoldBackGroundGreyColor,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: _getColorStatus(
                                    context: context, status: status ?? 0) ??
                                globalColor.green,
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: globalColor.grey.withOpacity(0.2),
                                width: 1.0)),
                        width: 12.w,
                        height: 12.w,
                      ),
                      HorizontalPadding(
                        percentage: 1,
                      ),
                      Text(
                        //'${Translations.of(context).translate('delivery_stage')}',
                        _getStrStatus(context: context, status: status ?? 0),
                        style: textStyle.minTSBasic
                            .copyWith(color: globalColor.primaryColor),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _buildOrderSummeryWidget({
    required BuildContext context,
    required double width,
    required double height,
    GeneralOrderItemEntity? order,
  }) {
    return order?.order_items != null &&
            (order?.order_items?.isNotEmpty ?? false)
        ? Container(
            padding: const EdgeInsets.fromLTRB(
              EdgeMargin.subMin,
              EdgeMargin.verySub,
              EdgeMargin.subMin,
              EdgeMargin.verySub,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  Translations.of(context).translate('order_details'),
                  style: textStyle.smallTSBasic.copyWith(
                      color: globalColor.black, fontWeight: FontWeight.bold),
                ),
                Container(
                  child: ListView.builder(
                    itemCount: order?.order_items?.length,
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          if (order?.order_items?[index].product?.isGlasses !=
                                  null &&
                              (order?.order_items?[index].product?.isGlasses ??
                                  false))
                            Get.Get.toNamed(ProductDetailsPage.routeName,
                                preventDuplicates: false,
                                arguments: ProductDetailsArguments(
                                    product:
                                        order?.order_items?[index].product));
                          else
                            Get.Get.toNamed(LensesDetailsPage.routeName,
                                preventDuplicates: false,
                                arguments: ProductDetailsArguments(
                                    product:
                                        order?.order_items?[index].product));
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(12.w)),
                          child: Container(
                            padding: const EdgeInsets.fromLTRB(
                              EdgeMargin.min,
                              EdgeMargin.min,
                              EdgeMargin.min,
                              EdgeMargin.min,
                            ),
                            decoration: BoxDecoration(
                              color: globalColor.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12.w)),
                              border: Border.all(
                                  color: globalColor.grey.withOpacity(0.3),
                                  width: 0.5),
                            ),
                            //   margin: const EdgeInsets.only(left: EdgeMargin.verySub,),
                            width: width,

                            child: Row(
                              children: [
                                Container(
                                  height: 30,
                                  width: 30,
                                  decoration: BoxDecoration(
                                    color: globalColor.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(4)),
                                    border: Border.all(
                                        color: globalColor.primaryColor,
                                        width: 0.5),
                                  ),
                                  padding: const EdgeInsets.all(
                                    EdgeMargin.verySub,
                                  ),
                                  child: ImageCacheWidget(
                                    imageUrl: order?.order_items?[index].product
                                            ?.mainImage ??
                                        '',
                                    imageWidth: 30,
                                    imageHeight: 30,
                                    imageBorderRadius: 4,
                                  ),
                                ),
                                HorizontalPadding(
                                  percentage: 3.0,
                                ),
                                Text(
                                  order?.order_items?[index].product?.name ??
                                      '',
                                  style: textStyle.smallTSBasic.copyWith(
                                      color: globalColor.primaryColor),
                                ),
                                HorizontalPadding(
                                  percentage: 3.0,
                                ),
                                Expanded(
                                  flex: 5,
                                  child: Container(
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                        EdgeMargin.subMin,
                                        EdgeMargin.verySub,
                                        EdgeMargin.subMin,
                                        EdgeMargin.verySub,
                                      ),
                                      child: FittedBox(
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              Translations.of(context)
                                                  .translate('product_info'),
                                              style: textStyle.smallTSBasic
                                                  .copyWith(
                                                      color: globalColor.black),
                                            ),
                                            HorizontalPadding(
                                              percentage: 1.0,
                                            ),
                                            Text(
                                              appConfig.notNullOrEmpty(order
                                                      ?.order_items?[index]
                                                      .product
                                                      ?.priceAfterDiscount)
                                                  ? order!
                                                      .order_items![index]
                                                      .product!
                                                      .priceAfterDiscount!
                                                  : order?.order_items?[index]
                                                          .product?.price
                                                          ?.toString() ??
                                                      '',
                                              style: textStyle.smallTSBasic
                                                  .copyWith(
                                                      color: globalColor
                                                          .primaryColor,
                                                      fontWeight:
                                                          FontWeight.bold),
                                            ),
                                            Text(
                                              '${Translations.of(context).translate('rail')}',
                                              style: textStyle.smallTSBasic
                                                  .copyWith(
                                                      color: globalColor
                                                          .primaryColor),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          )
        : Container();
  }

  _buildPriceSummeryWidget({
    required BuildContext context,
    required double width,
    required double height,
    GeneralOrderItemEntity? order,
  }) {
    return order?.order_items != null &&
            (order?.order_items?.isNotEmpty ?? false)
        ? Container(
            padding: const EdgeInsets.fromLTRB(
              EdgeMargin.subMin,
              EdgeMargin.verySub,
              EdgeMargin.subMin,
              EdgeMargin.verySub,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  Translations.of(context).translate('price'),
                  style: textStyle.smallTSBasic.copyWith(
                      color: globalColor.black, fontWeight: FontWeight.bold),
                ),
                _buildPriceItem(
                  width: width,
                  height: height,
                  context: context,
                  title: Translations.of(context).translate('order_value'),
                  value: order?.orginal_price?.toString(),
                ),
                _buildPriceItem(
                  width: width,
                  height: height,
                  context: context,
                  title:
                      Translations.of(context).translate('order_delivery_fee'),
                  value: order?.shipping_fee?.toString(),
                ),
                _buildPriceItem(
                  width: width,
                  height: height,
                  context: context,
                  title: Translations.of(context).translate('order_discount'),
                  value: order?.discount?.toString(),
                ),
                _buildPriceItem(
                  width: width,
                  height: height,
                  context: context,
                  title: Translations.of(context).translate('order_total'),
                  value: order?.total?.toString(),
                ),
              ],
            ),
          )
        : Container();
  }

  _buildPriceItem(
      {required BuildContext context,
      required double width,
      required double height,
      String? title,
      String? value}) {
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(12.w)),
      child: Container(
        padding: const EdgeInsets.fromLTRB(
          EdgeMargin.min,
          EdgeMargin.min,
          EdgeMargin.min,
          EdgeMargin.min,
        ),
        decoration: BoxDecoration(
          color: globalColor.white,
          borderRadius: BorderRadius.all(Radius.circular(12.w)),
          border:
              Border.all(color: globalColor.grey.withOpacity(0.3), width: 0.5),
        ),
        //   margin: const EdgeInsets.only(left: EdgeMargin.verySub,),
        width: width,

        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title ?? '',
              style: textStyle.smallTSBasic.copyWith(color: globalColor.black),
            ),
            HorizontalPadding(
              percentage: 3.0,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  value ?? '',
                  style: textStyle.smallTSBasic.copyWith(
                      color: globalColor.primaryColor,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  '${Translations.of(context).translate('rail')}',
                  style: textStyle.smallTSBasic
                      .copyWith(color: globalColor.primaryColor),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  _getStrStatus({required BuildContext context, required int status}) {
    switch (status) {
      case 1:
        return Translations.of(context).translate('received');

      case 2:
        return Translations.of(context).translate('processing');

      case 3:
        return Translations.of(context).translate('shipped');

      case 4:
        return Translations.of(context).translate('delivered');

      case 5:
        return Translations.of(context).translate('canceled');

      case 6:
        return Translations.of(context).translate('cancel_requested');

      case 7:
        return Translations.of(context).translate('refunded');

      default:
        return Translations.of(context).translate('received');
    }
  }

  _getColorStatus({required BuildContext context, required int status}) {
    switch (status) {
      case 1:
        return globalColor.green;

      case 2:
        return globalColor.green;

      case 3:
        return globalColor.green;

      case 4:
        return globalColor.green;

      case 5:
        return globalColor.red;

      case 6:
        return globalColor.red;

      case 7:
        return globalColor.buttonColorOrange;

      default:
        return globalColor.green;
    }
  }

  @override
  void dispose() {
    _cancelToken.cancel();
    super.dispose();
  }
}
