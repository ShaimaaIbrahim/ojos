import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart' as Get;
import 'package:ojos_app/extra_lip/model_progress_hud.dart';

import 'package:ojos_app/core/appConfig.dart';
import 'package:ojos_app/core/bloc/application_bloc.dart';
import 'package:ojos_app/core/errors/connection_error.dart';
import 'package:ojos_app/core/errors/custom_error.dart';
import 'package:ojos_app/core/localization/translations.dart';
import 'package:ojos_app/core/params/no_params.dart';
import 'package:ojos_app/core/providers/cart_provider.dart';
import 'package:ojos_app/core/repositories/core_repository.dart';
import 'package:ojos_app/core/res/app_assets.dart';
import 'package:ojos_app/core/res/edge_margin.dart';
import 'package:ojos_app/core/res/global_color.dart';
import 'package:ojos_app/core/res/screen/horizontal_padding.dart';
import 'package:ojos_app/core/res/screen/vertical_padding.dart';
import 'package:ojos_app/core/res/text_style.dart';
import 'package:ojos_app/core/res/utils.dart';
import 'package:ojos_app/core/res/width_height.dart';
import 'package:ojos_app/core/ui/button/arrow_back_button_widget.dart';
import 'package:ojos_app/core/ui/widget/button/rounded_button.dart';
import 'package:ojos_app/core/ui/widget/general_widgets/error_widgets.dart';
import 'package:ojos_app/core/usecases/get_payment_method.dart';
import 'package:ojos_app/extra_lip/model_progress_hud.dart';
import 'package:ojos_app/features/cart/domin/entities/payment_method_entity.dart';
import 'package:ojos_app/features/cart/presentation/args/check_and_pay_args.dart';
import 'package:ojos_app/features/cart/presentation/args/enter_info_cart_args.dart';
import 'package:ojos_app/features/cart/presentation/widgets/item_pay_widget.dart';
import 'package:ojos_app/features/main_root.dart';
import 'package:ojos_app/features/order/data/requests/order_request.dart';
import 'package:ojos_app/features/order/presentation/blocs/send_order_bloc.dart';
import 'package:ojos_app/features/product/presentation/widgets/lens_select_ipd_add_widget.dart';
import 'package:ojos_app/features/product/presentation/widgets/lens_select_size_widget.dart';
import 'package:provider/provider.dart';

import '../../../../main.dart';

class CheckAndPayPage extends StatefulWidget {
  static const routeName = '/cart/pages/CheckAndPayPage';

  @override
  _CheckAndPayPageState createState() => _CheckAndPayPageState();
}

class _CheckAndPayPageState extends State<CheckAndPayPage> {
  final args = Get.Get.arguments as EnterInfoCartArgs;

  late PaymentMethodEntity _selectedPaymentMethod;
  late List<PaymentMethodEntity> _listOfPaymentMethods;

  bool sendRequest = true;

  final _bloc = SendOrderBloc();

  @override
  void initState() {
    super.initState();
    _listOfPaymentMethods = [];
    _getPaymentMethods(0);
  }

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  var _cancelToken = CancelToken();

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
        Translations.of(context).translate('payment'),
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
        body: BlocListener<SendOrderBloc, SendOrderState>(
          bloc: _bloc,
          listener: (context, state) async {
            if (state is SendOrderDoneState) {
              //  ErrorViewer.showCustomError(context,Translations.of(context).translate('msg_contact_us_success'));
              appConfig.showToast(
                  msg: Translations.of(context)
                      .translate('order_successfully_added'));
              await Provider.of<CartProvider>(context, listen: false)
                  .initList();
              Get.Get.offAllNamed(MainRootPage.routeName);
            }
            if (state is SendOrderFailureState) {
              final error = state.error;
              if (error is ConnectionError) {
                ErrorViewer.showConnectionError(context, state.callback);
              } else if (error is CustomError) {
                ErrorViewer.showCustomError(context, error.message);
              } else {
                ErrorViewer.showUnexpectedError(context);
              }
            }
          },
          child: BlocBuilder<SendOrderBloc, SendOrderState>(
              bloc: _bloc,
              builder: (context, state) {
                return ModalProgressHUD(
                  inAsyncCall: state is SendOrderLoadingState,
                  color: globalColor.primaryColor,
                  opacity: 0.2,
                  child: Container(
                    child: Container(
                        height: height,
                        child: Stack(
                          children: [
                            SingleChildScrollView(
                              physics: BouncingScrollPhysics(),
                              child: Container(
                                child: Column(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.only(
                                          left: EdgeMargin.min,
                                          right: EdgeMargin.min),
                                      child: _buildTotalWidget(
                                          context: context,
                                          width: width,
                                          height: 50.h,
                                          price: args.totalPrice?.toString()),
                                    ),
                                    sendRequest
                                        ? Container(
                                            width: width,
                                            child: Center(
                                              child: CircularProgressIndicator(
                                                backgroundColor:
                                                    globalColor.primaryColor,
                                              ),
                                            ),
                                          )
                                        : _buildAvailablePaymentWidget(
                                            width: width,
                                            height: height,
                                            list: _listOfPaymentMethods,
                                            context: context),
                                    VerticalPadding(
                                      percentage: 4.0,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              child: _buildButtonsWidget(
                                  height: height,
                                  context: context,
                                  widthC: width),
                            ),
                          ],
                        )),
                  ),
                );
              }),
        ));
  }

  _buildTotalWidget(
      {required BuildContext context,
      required double width,
      required double height,
      String? price}) {
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
        height: height,
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
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        Translations.of(context).translate('total_of_cart'),
                        style: textStyle.smallTSBasic
                            .copyWith(color: globalColor.black),
                      ),
                      HorizontalPadding(
                        percentage: 1.0,
                      ),
                      Text(
                        price ?? '',
                        style: textStyle.normalTSBasic.copyWith(
                            color: globalColor.goldColor,
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
            ),
            Container(
              width: 1.0,
              color: globalColor.grey.withOpacity(0.3),
            ),
            Expanded(
              flex: 3,
              child: InkWell(
                onTap: () {
                  Get.Get.back();
                },
                child: Container(
                  color: globalColor.primaryColor,
                  padding: const EdgeInsets.fromLTRB(
                    EdgeMargin.subMin,
                    EdgeMargin.verySub,
                    EdgeMargin.subMin,
                    EdgeMargin.verySub,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        AppAssets.cart_btnv_svg,
                      ),
                      Expanded(
                        child: Container(
                          child: FittedBox(
                            child: Text(
                              Translations.of(context).translate('show_cart'),
                              style: textStyle.smallTSBasic
                                  .copyWith(color: globalColor.white),
                            ),
                          ),
                          alignment: AlignmentDirectional.center,
                        ),
                      ),
                      Container(
                        child: Icon(
                          utils.getLang() != 'ar'
                              ? Icons.keyboard_arrow_right
                              : Icons.keyboard_arrow_left,
                          color: globalColor.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buildAvailablePaymentWidget(
      {required BuildContext context,
      required double width,
      required double height,
      List<PaymentMethodEntity>? list}) {
    if (list != null && list.isNotEmpty) {
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
                            .translate('choose_payment_method'),
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
            VerticalPadding(
              percentage: .5,
            ),
            Container(
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: list.length,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return ItemPayWidget(
                      width: width,
                      item: list[index],
                      onSelect: _onSelectedPayment,
                      isSelect: _selectedPaymentMethod.id == list[index].id,
                    );
                  }),
            ),
          ],
        ),
      );
    }
    return Container();
  }

  _buildButtonsWidget(
      {required BuildContext context,
      required double widthC,
      required double height}) {
    return Container(
      height: 80.h,
      width: widthC,
      color: globalColor.white,
      child: Center(
        child: Container(
          height: 50.h,
          padding: const EdgeInsets.only(
              left: EdgeMargin.min, right: EdgeMargin.min),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                  child: RoundedButton(
                height: 50.h,
                width: widthC * .35,
                color: globalColor.primaryColor,
                onPressed: () {
                  OrderRequest request = OrderRequest(
                      total: args.total,
                      coupon_id: args.coupon_id,
                      tax: args.tax,
                      shipping_id: args.shipping_id,
                      shipping_fee: args.shipping_fee,
                      point_map: args.point_map,
                      price_discount: args.price_discount,
                      orginal_price: args.orginal_price,
                      couponcode: args.couponcode,
                      city_id: args.city_id,
                      listorder: args.listOfOrder
                          ?.map((i) => ProductOrderRequest(
                                product_id: i.productEntity!.id,
                                type_product: i.productEntity!.type,
                                quantity: i.count,
                                price: i.productEntity!.price,
                                Is_Glasses:
                                    i.productEntity!.isGlasses == true ? 1 : 0,
                                brand_id: i.productEntity!.brandId,
                                color_id: i.productEntity!.colorInfo![0].id,
                                RightSPH:
                                    i.sizeForRightEye == LensesSelectedEnum.CPH
                                        ? 1
                                        : 0,
                                RightAXI:
                                    i.sizeForRightEye == LensesSelectedEnum.AXIS
                                        ? 1
                                        : 0,
                                RightCYL:
                                    i.sizeForRightEye == LensesSelectedEnum.CYI
                                        ? 1
                                        : 0,
                                LeftSPH:
                                    i.sizeForLeftEye == LensesSelectedEnum.CPH
                                        ? 1
                                        : 0,
                                LeftAXI:
                                    i.sizeForLeftEye == LensesSelectedEnum.AXIS
                                        ? 1
                                        : 0,
                                LeftCYL:
                                    i.sizeForLeftEye == LensesSelectedEnum.CYI
                                        ? 1
                                        : 0,
                                APD: i.lensSize == LensesIpdAddEnum.ADD ? 1 : 0,
                                IPD: i.lensSize == LensesIpdAddEnum.IPD ? 1 : 0,
                              ))
                          .toList(),
                      note: args.note ?? '',
                      method_id: _selectedPaymentMethod.id,
                      user_address_id: args.city_id,
                      card: null,
                      delivery: args.deliveryOrder,
                      lenses_img: '');
                  print('Order Request ${request.toJson()}');

                  _bloc.add(GetSendOrderEvent(
                      cancelToken: _cancelToken, request: request));
                },
                borderRadius: 8.w,
                child: Container(
                  child: Center(
                    child: Text(
                      Translations.of(context).translate('send_order'),
                      style: textStyle.smallTSBasic
                          .copyWith(color: globalColor.white),
                    ),
                  ),
                ),
              )),
              HorizontalPadding(
                percentage: 4.0,
              ),
              Container(
                  child: RoundedButton(
                height: 50.h,
                width: widthC * .35,
                color: globalColor.backgroundLightPrim,
                onPressed: () {
                  Get.Get.back();
                },
                borderRadius: 8.w,
                child: Container(
                  child: Center(
                    child: Text(
                      Translations.of(context).translate('cancel'),
                      style: textStyle.smallTSBasic
                          .copyWith(color: globalColor.black),
                    ),
                  ),
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _cancelToken.cancel();
    _bloc.close();
    super.dispose();
  }

  _onSelectedPayment(PaymentMethodEntity selected) {
    if (mounted)
      setState(() {
        _selectedPaymentMethod = selected;
      });
    print('style selected is ${_selectedPaymentMethod.toString()}');
  }

// Future<void> _getShippingCarriers(int reloadCount) async {
//   int count = reloadCount;
//   if (mounted) {
//     final result = await GetShippingCarriers(locator<CoreRepository>())(
//       NoParams(cancelToken: _cancelToken),
//     );
//
//     if (result.data != null) {
//       setState(() {
//         _listOfShippingCarriers = result.data;
//         if (result.data.isNotEmpty) {
//           _shippingCarriers = result.data[0];
//         }
//       });
//     } else {
//       if (count != 3)
//         appConfig.check().then((internet) {
//           if (internet != null && internet) {
//             _getShippingCarriers(count + 1);
//           }
//           // No-Internet Case
//         });
//     }
//   }
// }
  Future<void> _getPaymentMethods(int reloadCount) async {
    if (mounted)
      setState(() {
        sendRequest = true;
      });
    int count = reloadCount;
    if (mounted) {
      final result = await GetPaymentMethods(locator<CoreRepository>())(
        NoParams(cancelToken: _cancelToken),
      );

      if (result.data != null) {
        setState(() {
          _listOfPaymentMethods = result.data!;
          if (result.data?.isNotEmpty ?? false) {
            _selectedPaymentMethod = result.data![0];
          }
          sendRequest = false;
        });
      } else {
        if (count != 3)
          appConfig.check().then((internet) {
            if (internet != null && internet) {
              _getPaymentMethods(count + 1);
            }
            // No-Internet Case
          });
      }
    }
  }
}
