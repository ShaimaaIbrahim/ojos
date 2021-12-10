import 'dart:ui';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ojos_app/core/bloc/root_page_bloc.dart';
import 'package:ojos_app/core/localization/translations.dart';
import 'package:ojos_app/core/notification/notifications_service.dart';
import 'package:ojos_app/core/res/app_assets.dart';
import 'package:ojos_app/core/res/global_color.dart';
import 'package:ojos_app/core/res/screen/screen_helper.dart';
import 'package:ojos_app/core/res/text_style.dart';
import 'package:ojos_app/features/brand/presentation/pages/brand_page.dart';
import 'package:ojos_app/features/cart/presentation/pages/cart_page.dart';
import 'package:ojos_app/features/order/presentation/pages/my_order_page.dart';
import 'package:ojos_app/features/section/presentation/pages/section_page.dart';

import 'home/presentation/pages/home_page.dart';

final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
final notificationsService = NotificationsService();

class MainRootPage extends StatefulWidget {
  static const routeName = '/features/MainRootPage';
  final BuildContext? menuScreenContext;

  MainRootPage({Key? key, this.menuScreenContext}) : super(key: key);

  @override
  _MainRootPageState createState() => _MainRootPageState();
}

class _MainRootPageState extends State<MainRootPage>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  DateTime? currentBackPressTime;

  @override
  void initState() {
    super.initState();
    tabController = new TabController(length: 5, vsync: this);
    tabController.addListener(() {
      if (tabController.indexIsChanging) setState(() {});
    });

    notificationsService.selectNotificationSubject.listen((payload) {
      print('payload is : $payload');
      // if (notificationsService != null)
      //   notificationsService.onNotificationPressed(context, payload);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RootPageBloc, RootPageState>(
      listener: (context, state) {
        if (state is PageIndexState) {
          if (state.pageIndex != null) {
            tabController.index = state.pageIndex;
            setState(() {});
          }
        }
      },
      child: Scaffold(
        backgroundColor: globalColor.scaffoldBackGroundGreyColor,
        bottomNavigationBar: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(14.w)),
          child: Material(
            color: Colors.transparent,
            child: Stack(
              overflow: Overflow.visible,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.only(
                      left: 05.0, right: 5.0, bottom: 5.0),
                  color: globalColor.transparent,
                  child: Container(
                    height: 65.h,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(14.w)),
                        color: globalColor.white),
                    child: TabBar(
                      controller: tabController,
                      indicatorColor: Colors.transparent,
                      indicatorPadding: EdgeInsets.all(0.0),
                      labelPadding: EdgeInsets.all(0.0),
                      indicatorSize: TabBarIndicatorSize.label,
                      tabs: <Widget>[
                        _buildTabItem(
                            Translations.of(context).translate('home'),
                            AppAssets.home_btnv_svg,
                            PagesEnum.HOME_PAGE),

                        _buildTabItem(
                            Translations.of(context).translate('brand'),
                            AppAssets.brand_btnv_svg,
                            PagesEnum.BRAND_PAGE),
                        Container(
                          width: 55.w,
                          height: 55.w,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: globalColor.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  blurRadius: 10.0,
                                  // has the effect of softening the shadow
                                  spreadRadius: 3,
                                  offset: Offset(0,
                                      3), // has the effect of extending the shadow
                                ),
                              ]),
                          child: Center(
                            child: Container(
                              width: 45.w,
                              height: 45.w,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: globalColor.primaryColor,
                                  border: Border.all(
                                      width: 1.0,
                                      color: globalColor.goldColor)),
                              child: Center(
                                child:
                                    SvgPicture.asset(AppAssets.cart_btnv_svg),
                              ),
                            ),
                          ),
                        ),
                        // _buildTabItem(
                        //     Translations.of(context).translate('cart'),
                        //     AppAssets.cart_btnv_svg,
                        //     PagesEnum.CART_PAGE),
                        _buildTabItem(
                            Translations.of(context).translate('section'),
                            AppAssets.sections_btnv_svg,
                            PagesEnum.SECTIONS_PAGE),
                        _buildTabItem(
                            Translations.of(context).translate('order_drawer'),
                            AppAssets.order_drawer,
                            PagesEnum.PROFILE_PAGE),
//                  if(!appSharedPrefs.isGuest)
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        body: WillPopScope(
          onWillPop: _onWillPop,
          child: Container(
            child: TabBarView(
              controller: tabController,
              physics: NeverScrollableScrollPhysics(),
              children: <Widget>[
                HomePage(
                  tabController: tabController,
                ),
                BrandPage(),
                CartPage(
                  tabController: tabController,
                ),
                SectionPage(),
                MyOrderPage()
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    tabController.dispose();
    notificationsService.dispose();
    super.dispose();
  }

  Widget _buildTabItem(String text, String iconPath, PagesEnum page) {
    bool isSelected = (page.index == tabController.index);

    final iconColor = isSelected ? globalColor.primaryColor : globalColor.black;
    return Container(
      child: Padding(
        padding: EdgeInsets.only(top: ScreensHelper.fromHeight(0.5)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            AnimatedContainer(
              duration: Duration(milliseconds: 500),
              width: ScreensHelper.fromWidth(isSelected ? 6.0 : 5.5),
              height: ScreensHelper.fromHeight(isSelected ? 3.75 : 3.3),
              child: FittedBox(
                child: SvgPicture.asset(
                  iconPath,
                  color: iconColor,
                ),
              ),
            ),
            Container(
              child: Text(
                text,
                style: textStyle.minTSBasic
                    .copyWith(color: iconColor, fontWeight: FontWeight.w200),
                overflow: TextOverflow.ellipsis,
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<bool> _onWillPop() {
    if (checkIndex()) return Future.value(false);

    if (tabController.index != PagesEnum.HOME_PAGE.index) {
      BlocProvider.of<RootPageBloc>(context)
          .add(ChangePageEvent(PagesEnum.HOME_PAGE.index));
      return Future.value(false);
    }
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(
        msg: Translations.of(context).translate('tab_to_exit'),
        backgroundColor: globalColor.primaryColor,
      );
      return Future.value(false);
    }
    SystemNavigator.pop();
    return Future.value(true);
  }

  bool checkIndex() {
    if (tabController.index == 0) return false;
    // botNavBar.onTap(0);
    tabController.animateTo(0);
    return true;
  }
}

enum PagesEnum {
  HOME_PAGE,
  BRAND_PAGE,
  CART_PAGE,
  SECTIONS_PAGE,
  PROFILE_PAGE,
}
