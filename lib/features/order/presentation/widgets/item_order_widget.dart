import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
 
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart' as Get;
import 'package:ojos_app/core/appConfig.dart';
import 'package:ojos_app/core/localization/translations.dart';
import 'package:ojos_app/core/res/app_assets.dart';
import 'package:ojos_app/core/res/edge_margin.dart';
import 'package:ojos_app/core/res/global_color.dart';
import 'package:ojos_app/core/res/screen/horizontal_padding.dart';
import 'package:ojos_app/core/res/text_style.dart';
import 'package:ojos_app/core/res/width_height.dart';
import 'package:ojos_app/core/ui/dailog/confirm_dialog.dart';
import 'package:ojos_app/core/ui/widget/image/image_caching.dart';
import 'package:ojos_app/features/order/domain/entities/general_order_item_entity.dart';
import 'package:ojos_app/features/order/domain/repositories/order_repository.dart';
import 'package:ojos_app/features/order/domain/usecases/delete_order.dart';
import 'package:ojos_app/features/order/presentation/pages/order_details_page.dart';

import '../../../../main.dart';

class ItemOrderWidget extends StatefulWidget {
  final GeneralOrderItemEntity? orderItem;
  final CancelToken cancelToken;
  final Function()? onUpdate;

  const ItemOrderWidget(
      {this.orderItem, this.onUpdate, required this.cancelToken});

  @override
  _ItemOrderWidgetState createState() => _ItemOrderWidgetState();
}

class _ItemOrderWidgetState extends State<ItemOrderWidget> {
  bool isDeleted = false;

  @override
  Widget build(BuildContext context) {
    double width = globalSize.setWidthPercentage(95, context);
    return isDeleted
        ? Container()
        : InkWell(
            onTap: () {
              Get.Get.toNamed(OrderDetailsPage.routeName,
                  arguments: widget.orderItem);
            },
            child: Container(
              width: width,
              padding: EdgeInsets.only(
                  left: EdgeMargin.subMin, right: EdgeMargin.subMin),
              child: Card(
                color: globalColor.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12.0.w))),
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(12.0.w)),
                  child: Container(
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.only(
                              left: EdgeMargin.subMin,
                              right: EdgeMargin.subMin,
                              bottom: EdgeMargin.subMin,
                              top: EdgeMargin.subMin),
                          width: width,
                          child: Column(
                            children: [
                              Container(
                                height: 144.h,
                                child: Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Expanded(
                                          child: Container(
                                            height: 144.h,
                                            child: ImageCacheWidget(
                                              imageUrl: widget
                                                      .orderItem?.orderimage ??
                                                  '',
                                              imageWidth: 10.w,
                                              imageHeight: 144.h,
                                              imageBorderRadius: 12.w,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Positioned(
                                      bottom: 4.0,
                                      right: 4.0,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: globalColor.white,
                                          borderRadius:
                                              BorderRadius.circular(12.0.w),
                                        ),
                                        constraints: BoxConstraints(
                                            minWidth: width * .1),
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 4.0, right: 4.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
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
                                                widget.orderItem
                                                                ?.order_items !=
                                                            null &&
                                                        (widget
                                                                .orderItem
                                                                ?.order_items
                                                                ?.isNotEmpty ??
                                                            false) &&
                                                        widget.orderItem
                                                                    ?.order_items?[
                                                                0] !=
                                                            null &&
                                                        widget
                                                                .orderItem
                                                                ?.order_items![
                                                                    0]
                                                                .product
                                                                ?.genderId ==
                                                            38
                                                    ? '${Translations.of(context).translate('men')}'
                                                    : '${Translations.of(context).translate('women')}',
                                                style: textStyle.minTSBasic
                                                    .copyWith(
                                                  color: globalColor.black,
                                                ),
                                              ),
                                              // Text(
                                              //   // product.genderId == 38
                                              //   //     ? '${Translations.of(context).translate('men')}'
                                              //   //     :
                                              //   '${widget.orderItem.id}',
                                              //   style: textStyle.minTSBasic.copyWith(
                                              //     color: globalColor.black,
                                              //   ),
                                              // ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      left: 4.0,
                                      top: 4.0,
                                      child: Row(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              color: globalColor.white,
                                              borderRadius:
                                                  BorderRadius.circular(12.0.w),
                                            ),
                                            height: 20.h,
                                            constraints: BoxConstraints(
                                                minWidth: width * .09),
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: EdgeMargin.verySub,
                                                  right: EdgeMargin.verySub),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
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
                                                    widget.orderItem?.order_items !=
                                                                null &&
                                                            (widget
                                                                    .orderItem
                                                                    ?.order_items
                                                                    ?.isNotEmpty ??
                                                                false)
                                                        ? '${appConfig.notNullOrEmpty(widget.orderItem?.order_items?[0].product?.rate) ? widget.orderItem?.order_items![0].product?.rate : '-'}'
                                                        : '-',
                                                    style: textStyle
                                                        .smallTSBasic
                                                        .copyWith(
                                                            color: globalColor
                                                                .black,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 5.0,
                                          ),
                                          widget.orderItem?.order_items !=
                                                      null &&
                                                  (widget.orderItem?.order_items
                                                          ?.isNotEmpty ??
                                                      false) &&
                                                  (widget
                                                          .orderItem
                                                          ?.order_items?[0]
                                                          .product
                                                          ?.isNew ??
                                                      false)
                                              ? Container(
                                                  decoration: BoxDecoration(
                                                    color: globalColor
                                                        .primaryColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12.0.w),
                                                  ),
                                                  height: 20.h,
                                                  constraints: BoxConstraints(
                                                      minWidth: width * .15),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: EdgeMargin
                                                                .verySub,
                                                            right: EdgeMargin
                                                                .verySub),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      mainAxisSize:
                                                          MainAxisSize.min,
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
                                                          style: textStyle
                                                              .smallTSBasic
                                                              .copyWith(
                                                                  color:
                                                                      globalColor
                                                                          .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
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
                                  ],
                                ),
                              ),
                              Row(
                                children: [
                                  Expanded(
                                      flex: 2,
                                      child: Container(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Container(
                                              child: Text(
                                                '${widget.orderItem?.billing_name ?? ''}',
                                                style: textStyle.smallTSBasic
                                                    .copyWith(
                                                  color: globalColor.black,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 2,
                                              ),
                                            ),
                                            Container(
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  widget.orderItem
                                                                  ?.order_items !=
                                                              null &&
                                                          (widget
                                                                  .orderItem
                                                                  ?.order_items
                                                                  ?.isNotEmpty ??
                                                              false) &&
                                                          widget
                                                                  .orderItem
                                                                  ?.order_items?[
                                                                      0]
                                                                  .product
                                                                  ?.lensesFree !=
                                                              null &&
                                                          (widget
                                                                  .orderItem
                                                                  ?.order_items?[
                                                                      0]
                                                                  .product
                                                                  ?.lensesFree ??
                                                              false)
                                                      ? Container(
                                                          width: 15.w,
                                                          height: 15.w,
                                                          decoration: BoxDecoration(
                                                              color: globalColor
                                                                  .goldColor,
                                                              shape: BoxShape
                                                                  .circle,
                                                              border: Border.all(
                                                                  width: 1.0,
                                                                  color: globalColor
                                                                      .primaryColor)),
                                                          child: Icon(
                                                            Icons.check,
                                                            color: globalColor
                                                                .black,
                                                            size: 10.w,
                                                          ),
                                                        )
                                                      : Container(
                                                          width: 15.w,
                                                          height: 15.w,
                                                          decoration: BoxDecoration(
                                                              color: globalColor
                                                                  .grey,
                                                              shape: BoxShape
                                                                  .circle,
                                                              border: Border.all(
                                                                  width: 1.0,
                                                                  color: globalColor
                                                                      .grey
                                                                      .withOpacity(
                                                                          0.3))),
                                                          child: Center(
                                                            child: Text(''),
                                                          ),
                                                        ),
                                                  Container(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: EdgeMargin
                                                                  .sub,
                                                              right: EdgeMargin
                                                                  .sub),
                                                      child: Text(
                                                        '${Translations.of(context).translate('free_lenses')}',
                                                        style: textStyle
                                                            .subMinTSBasic
                                                            .copyWith(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                color:
                                                                    globalColor
                                                                        .grey),
                                                      ))
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      )),
                                  Container(
                                      alignment: AlignmentDirectional.centerEnd,
                                      padding: const EdgeInsets.fromLTRB(
                                          EdgeMargin.verySub,
                                          EdgeMargin.sub,
                                          EdgeMargin.verySub,
                                          EdgeMargin.sub),
                                      child: FittedBox(
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Container(
                                              height: 25,
                                              decoration: BoxDecoration(
                                                  color: globalColor.white,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              12.w)),
                                                  border: Border.all(
                                                      color: globalColor.grey
                                                          .withOpacity(0.3),
                                                      width: 0.5)),
                                              constraints: BoxConstraints(
                                                  minWidth: width * .1),
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 4.0, right: 4.0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    SizedBox(
                                                      width: 2,
                                                    ),
                                                    Text(
                                                      '${widget.orderItem?.total?.toString() ?? ''}',
                                                      style: textStyle
                                                          .minTSBasic
                                                          .copyWith(
                                                        color:
                                                            globalColor.black,
                                                      ),
                                                    ),
                                                    Text(
                                                        ' ${Translations.of(context).translate('rail')}',
                                                        style: textStyle
                                                            .minTSBasic
                                                            .copyWith(
                                                                color:
                                                                    globalColor
                                                                        .black)),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Container(
                                                height: 25,
                                                decoration: BoxDecoration(
                                                    color: globalColor.white,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                12.w)),
                                                    border: Border.all(
                                                        color: globalColor.grey
                                                            .withOpacity(0.3),
                                                        width: 0.5)),
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        EdgeMargin.subSubMin,
                                                        EdgeMargin.verySub,
                                                        EdgeMargin.subSubMin,
                                                        EdgeMargin.verySub),
                                                child:
                                                    //  widget.orderItem.order_items.product.discountTypeInt != null &&widget.orderItem.order_items.product.discountTypeInt ==1  ?
                                                    Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    SvgPicture.asset(
                                                      AppAssets.sales_svg,
                                                      width: 12,
                                                    ),
                                                    Text(
                                                      '${widget.orderItem?.price_discount ?? '-'} ${Translations.of(context).translate('rail')}',
                                                      style: textStyle
                                                          .minTSBasic
                                                          .copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: globalColor
                                                                  .primaryColor),
                                                    ),
                                                    Text(
                                                        ' ${Translations.of(context).translate('discount')}',
                                                        style: textStyle
                                                            .minTSBasic
                                                            .copyWith(
                                                                color:
                                                                    globalColor
                                                                        .black)),
                                                  ],
                                                )
                                                //     : Row(
                                                //   mainAxisSize: MainAxisSize.min,
                                                //   crossAxisAlignment:
                                                //   CrossAxisAlignment.center,
                                                //   children: [
                                                //     SvgPicture.asset(
                                                //       AppAssets.sales_svg,
                                                //       width: 12,
                                                //     ),
                                                //     Text(
                                                //       '${widget.orderItem.order_items.product.discountPrice ?? '-'} %' ?? '',
                                                //       style: textStyle.minTSBasic
                                                //           .copyWith(
                                                //           fontWeight:
                                                //           FontWeight.bold,
                                                //           color: globalColor
                                                //               .primaryColor),
                                                //     ),
                                                //     Text(
                                                //         ' ${Translations.of(context).translate('discount')}',
                                                //         style: textStyle
                                                //             .minTSBasic
                                                //             .copyWith(
                                                //             color: globalColor
                                                //                 .black)),
                                                //   ],
                                                // ) ,
                                                )
                                          ],
                                        ),
                                      ))
                                ],
                              ),
                            ],
                          ),
                        ),
                        Divider(
                          color: globalColor.backgroundLightPrim,
                          height: 2.0,
                        ),
                        Container(
                          //padding: const EdgeInsets.all(EdgeMargin.subMin),
                          height: 41.h,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.only(
                                      left: EdgeMargin.subMin,
                                      right: EdgeMargin.subMin),
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
                                                  context: context,
                                                  status: widget.orderItem
                                                          ?.statusint ??
                                                      0) ??
                                              globalColor.green,
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                              color: globalColor.grey
                                                  .withOpacity(0.2),
                                              width: 1.0)),
                                      width: 12.w,
                                      height: 12.w,
                                    ),
                                    HorizontalPadding(
                                      percentage: 1,
                                    ),
                                    Text(
                                      //'${Translations.of(context).translate('delivery_stage')}',
                                      _getStrStatus(
                                          context: context,
                                          status:
                                              widget.orderItem?.statusint ?? 0),
                                      style: textStyle.minTSBasic.copyWith(
                                          color: globalColor.primaryColor),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Divider(
                          color: globalColor.backgroundLightPrim,
                          height: 2.0,
                        ),
                        Container(
                          // padding: const EdgeInsets.all(EdgeMargin.subMin),
                          height: 41.h,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.only(
                                      left: EdgeMargin.subMin,
                                      right: EdgeMargin.subMin),
                                  child: Text(
                                    '${Translations.of(context).translate('time_left_for_delivery')}',
                                    style: textStyle.smallTSBasic.copyWith(
                                        color: globalColor.black,
                                        fontWeight: FontWeight.bold),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ),
                              ),
                              Container(
                                //  margin: const EdgeInsets.only(left:EdgeMargin.min,right: EdgeMargin.min),
                                width: 148.w,
                                height: 41.h,
                                color: globalColor.scaffoldBackGroundGreyColor,
                                alignment: AlignmentDirectional.center,
                                child: Text(
                                  '${widget.orderItem?.city?.shiping_time ?? '-'}',
                                  style: textStyle.smallTSBasic.copyWith(
                                      color: globalColor.primaryColor,
                                      fontWeight: FontWeight.bold),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Divider(
                          color: globalColor.backgroundLightPrim,
                          height: 2.0,
                        ),
                        Container(
                          // padding: const EdgeInsets.all(EdgeMargin.subMin),
                          height: 41.h,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.only(
                                      left: EdgeMargin.subMin,
                                      right: EdgeMargin.subMin),
                                  alignment: AlignmentDirectional.center,
                                  child: Text(
                                    '${Translations.of(context).translate('order_details')}',
                                    style: textStyle.smallTSBasic.copyWith(
                                        color: globalColor.black,
                                        fontWeight: FontWeight.bold),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (ctx) => ConfirmDialog(
                                      title: Translations.of(context)
                                          .translate('delete'),
                                      confirmMessage: Translations.of(context)
                                          .translate('are_you_sure_delete'),
                                      actionYes: () {
                                        Get.Get.back();
                                        _requestDeleteNotificationsNewProduct(
                                            id: widget.orderItem?.id ?? 0,
                                            context: context);
                                      },
                                      actionNo: () {
                                        Get.Get.back();
                                      },
                                    ),
                                  );
                                },
                                child: Container(
                                  child: Center(
                                    child: Container(
                                      // decoration: BoxDecoration(
                                      //     color: globalColor.white,
                                      //     borderRadius: BorderRadius.circular(12.0.w),
                                      //     border: Border.all(
                                      //         color: globalColor.grey.withOpacity(0.3),
                                      //         width: 0.5)),
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            EdgeMargin.sub,
                                            EdgeMargin.sub,
                                            EdgeMargin.sub,
                                            EdgeMargin.sub),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              Icons.delete,
                                              color: globalColor.red,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
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

  _requestDeleteNotificationsNewProduct(
      {required int id, required BuildContext context}) async {
    final result = await DeleteOrderUseCase(locator<OrderRepository>())(
      DeleteOrderParams(cancelToken: widget.cancelToken, id: id),
    );
    if (result.hasDataOnly) {
      Fluttertoast.showToast(
          msg: Translations.of(context).translate('Deleted'),
          backgroundColor: globalColor.primaryColor,
          textColor: globalColor.white);

      if (mounted) {
        setState(() {
          isDeleted = true;
        });
      }
      if (widget.onUpdate != null) widget.onUpdate!();
    } else if (result.hasErrorOnly || result.hasDataAndError)
      Fluttertoast.showToast(
          msg: Translations.of(context).translate('err_unexpected'));
  }
}
