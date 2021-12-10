import 'dart:ui';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart' as Get;
import 'package:ojos_app/core/appConfig.dart';
import 'package:ojos_app/core/bloc/application_bloc.dart';
import 'package:ojos_app/core/bloc/application_events.dart';
import 'package:ojos_app/core/bloc/application_state.dart';
import 'package:ojos_app/core/constants.dart';
import 'package:ojos_app/core/entities/category_entity.dart';
import 'package:ojos_app/core/errors/connection_error.dart';
import 'package:ojos_app/core/localization/translations.dart';
import 'package:ojos_app/core/params/no_params.dart';
import 'package:ojos_app/core/repositories/core_repository.dart';
import 'package:ojos_app/core/res/app_assets.dart';
import 'package:ojos_app/core/res/edge_margin.dart';
import 'package:ojos_app/core/res/global_color.dart';
import 'package:ojos_app/core/res/screen/horizontal_padding.dart';
import 'package:ojos_app/core/res/screen/vertical_padding.dart';
import 'package:ojos_app/core/res/shared_preference_utils/shared_preferences.dart';
import 'package:ojos_app/core/res/text_style.dart';
import 'package:ojos_app/core/res/utils.dart';
import 'package:ojos_app/core/res/width_height.dart';
import 'package:ojos_app/core/ui/button/icon_button_widget.dart';
import 'package:ojos_app/core/ui/dailog/confirm_dialog.dart';
import 'package:ojos_app/core/ui/dailog/login_first_dialog.dart';
import 'package:ojos_app/core/ui/dailog/soon_dailog.dart';
import 'package:ojos_app/core/ui/items_shimmer/base_shimmer.dart';
import 'package:ojos_app/core/ui/items_shimmer/home/offer_item_shimmer.dart';
import 'package:ojos_app/core/ui/items_shimmer/item_category_shimmer.dart';
import 'package:ojos_app/core/ui/list/build_list_product.dart';
import 'package:ojos_app/core/ui/widget/network/network_widget.dart';
import 'package:ojos_app/core/ui/widget/title_with_view_all_widget.dart';
import 'package:ojos_app/core/usecases/get_categories.dart';
import 'package:ojos_app/features/home/data/models/category_model.dart';
import 'package:ojos_app/features/home/data/models/product_model.dart';
import 'package:ojos_app/features/home/presentation/args/products_view_all_args.dart';
import 'package:ojos_app/features/home/presentation/blocs/offer_bloc.dart';
import 'package:ojos_app/features/home/presentation/pages/chewie_video_player.dart';
import 'package:ojos_app/features/home/presentation/pages/products_view_all_page.dart';
import 'package:ojos_app/features/home/presentation/widget/home_select_style_widget.dart';
import 'package:ojos_app/features/home/presentation/widget/item_category.dart';
import 'package:ojos_app/features/home/presentation/widget/item_offer_bottom_widget.dart';
import 'package:ojos_app/features/home/presentation/widget/item_offer_middle1_widget.dart';
import 'package:ojos_app/features/home/presentation/widget/item_offer_middle2_widget.dart';
import 'package:ojos_app/features/home/presentation/widget/item_offer_widget.dart';
import 'package:ojos_app/features/notification/presentation/pages/notification_page.dart';
import 'package:ojos_app/features/others/domain/entity/about_app_result.dart';
import 'package:ojos_app/features/others/domain/usecases/get_about_app.dart';
import 'package:ojos_app/features/others/presentation/pages/favorite_page.dart';
import 'package:ojos_app/features/others/presentation/pages/offers_page.dart';
import 'package:ojos_app/features/others/presentation/pages/settings_page.dart';
import 'package:ojos_app/features/product/domin/entities/product_entity.dart';
import 'package:ojos_app/features/product/presentation/widgets/item_product_home_widget.dart';
import 'package:ojos_app/features/profile/presentation/pages/profile_page.dart';
import 'package:ojos_app/features/reviews/presentation/pages/reviews_page.dart';
import 'package:ojos_app/features/search/presentation/pages/filter_search_page.dart';
import 'package:ojos_app/features/search/presentation/pages/search_page.dart';
import 'package:ojos_app/features/section/presentation/blocs/section_home_bloc.dart';
import 'package:ojos_app/features/test/presentation/pages/main_test_page.dart';
import 'package:ojos_app/features/user_management/domain/repositories/user_repository.dart';
import 'package:ojos_app/features/user_management/presentation/pages/sign_in_page.dart';
import 'package:shrink_sidemenu/shrink_sidemenu.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../core/res/app_assets.dart';
import '../../../../core/ui/button/icon_button_widget.dart';
import '../../../../core/ui/widget/title_with_view_all_widget.dart';
import '../../../../main.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/home/pages/HomePage';

  final TabController? tabController;

  const HomePage({this.tabController});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  List<String> list = [
    AppAssets.slider_image_png,
    AppAssets.slider_image_png,
    AppAssets.slider_image_png,
    AppAssets.slider_image_png,
  ];

  final GlobalKey<SideMenuState> _sideMenuKey = GlobalKey<SideMenuState>();

  Widget? rightChild, leftChild;
  PageController controller =
      PageController(initialPage: 0, keepPage: true, viewportFraction: 1);
  var currentPageValue = 0;
  var _itemsCategory;

  int? _styleSelected;
  GlobalKey _key = GlobalKey();

  //GlobalKey _keySection = GlobalKey();

  List<ProductModel> listOfProduct = [];
  List<ProductModel>? listOfMenProduct;

  var _cancelToken = CancelToken();
  var _offerBloc = OfferBloc();
  var _sectionHomeBloc = SectionHomeBloc();

  List<CategoryEntity>? _listOfCategory;
  CategoryEntity? _category1;
  CategoryEntity? _category2;
  CategoryEntity? _category3;
  CategoryEntity? _category4;
  bool _isCategoryEmpty = false;
  var _listKey = GlobalKey();

  List<Widget> _coulumnSection = [];

  initCategory() {
    _itemsCategory = [
      CategoryModel(id: 1, imageUrl: AppAssets.cat_1, title: 'اكسسوارات'),
      CategoryModel(id: 2, imageUrl: AppAssets.cat_2, title: 'عدسات لاصقه'),
      CategoryModel(id: 3, imageUrl: AppAssets.cat_1, title: 'نظارات طبيه'),
      CategoryModel(id: 4, imageUrl: AppAssets.cat_2, title: 'نظارات شمسية'),
    ];

    listOfProduct = [
      ProductModel(
          type: 'جديد',
          title: 'نظارة طبية',
          image: AppAssets.product_1,
          price: '80',
          colorCountAvailable: '5',
          isFavorite: true,
          rateAvg: '3.5',
          isLenses: false),
      ProductModel(
          type: 'مستعمل',
          title: 'نظارة شمسية',
          image: AppAssets.product_2,
          price: '50',
          colorCountAvailable: '10',
          isFavorite: false,
          rateAvg: '5',
          isLenses: false),
    ];

    listOfMenProduct = [
      ProductModel(
          type: 'جديد',
          title: 'عدسات لاصقة',
          image: AppAssets.men_pro_1,
          price: '80',
          colorCountAvailable: '5',
          isFavorite: true,
          rateAvg: '3.5',
          isLenses: true),
      ProductModel(
          type: 'مستعمل',
          title: 'عدسات لاصقة',
          image: AppAssets.men_pro_2,
          price: '50',
          colorCountAvailable: '10',
          isFavorite: false,
          rateAvg: '5',
          isLenses: true),
    ];
  }

  late bool isAuth = false;

  @override
  void initState() {
    super.initState();
    _offerBloc.add(SetupOfferEvent(cancelToken: _cancelToken));
    _sectionHomeBloc.add(GetSectionHomeEvent(cancelToken: _cancelToken));
    _listOfCategory = [];
    _category1 = null;
    _category2 = null;
    _category3 = null;
    _category4 = null;

    _getCategories(1);
    // _menuController =
    // new Rs.MenuController(vsync: this, direction: Rs.ScrollDirection.LEFT);
    /* _menuController = Rs.MenuController(
        vsync: this,
        direction: isLanguageArabic()
            ? Rs.ScrollDirection.RIGHT
            : Rs.ScrollDirection.LEFT);

    Provider.of<AppProvider>(context, listen: false).addListener(() {
      ///buildDrawerMenu();
      _menuController = new Rs.MenuController(
          vsync: this,
          direction: isLanguageArabic()
              ? Rs.ScrollDirection.RIGHT
              : Rs.ScrollDirection.LEFT);
    });*/
  }

  // buildDrawerMenu() {
  //   if (isLanguageArabic()) {
  //     rightChild = getDrawerMenu(utils.setHeightPercentage(100, context));
  //     leftChild = null;
  //   } else {
  //     leftChild = getDrawerMenu(utils.setHeightPercentage(100, context));
  //     rightChild = null;
  //   }
  // }

  bool isLanguageArabic() =>
      BlocProvider.of<ApplicationBloc>(context, listen: false).state.language ==
      LANG_AR;

  @override
  Widget build(BuildContext context) {
    //=========================================================================
    initCategory();
    isAuth =
        BlocProvider.of<ApplicationBloc>(context).state.isUserAuthenticated ||
            BlocProvider.of<ApplicationBloc>(context).state.isUserVerified;
    AppBar appBar = AppBar(
      backgroundColor: globalColor.appBar,
      brightness: Brightness.light,
      elevation: 0,
      leading: IconButtonWidget(
        icon: Icon(
          Icons.menu,
          color: globalColor.primaryColor,
        ),
        onTap: _onTapMenuDrawer,
      ),
      title: Container(
        child: SvgPicture.asset(
          AppAssets.appbar_logo,
          width: 25,
          height: 25,
        ),
      ),
      centerTitle: true,
      actions: [
        IconButtonWidget(
          icon: SvgPicture.asset(
            AppAssets.notification,
            width: 25,
            height: 25,
          ),
          onTap: () async {
            if (await UserRepository.hasToken && isAuth) {
              Get.Get.toNamed(NotificationPage.routeName);
            } else {
              showDialog(
                context: context,
                builder: (ctx) => LoginFirstDialog(),
              );
            }
          },
        ),
        HorizontalPadding(
          percentage: 2.5,
        )
      ],
    );

    double width = globalSize.setWidthPercentage(100, context);
    double height = globalSize.setHeightPercentage(100, context) -
        appBar.preferredSize.height -
        MediaQuery.of(context).viewPadding.top;

    return BlocBuilder<ApplicationBloc, ApplicationState>(
        bloc: BlocProvider.of<ApplicationBloc>(context),
        builder: (context, state) {
          return SideMenu(
            key: _sideMenuKey,
            menu: getDrawerMenu(height, state),
            type: SideMenuType.shrinkNSlide,
            inverse: isLanguageArabic(),
            // end side menu
            radius: BorderRadius.circular(15),
            background: globalColor.primaryColor,
            child: Scaffold(
                backgroundColor: globalColor.scaffoldBackGroundGreyColor,
                appBar: appBar,
                body: Container(
                    height: height,
                    key: _listKey,
                    child: RefreshIndicator(
                      onRefresh: () async {
                        setState(() {
                          _listKey = GlobalKey();
                        });
                        return null;
                      },
                      child: SingleChildScrollView(
                        //physics: BouncingScrollPhysics(),
                        child: Container(
                          child: Column(
                            children: [
                              _buildSearchWidget(
                                  width: width, context: context),
                              // VerticalPadding(
                              //   percentage: .5,
                              // ),
                              _buildTopAds(
                                  context: context,
                                  width: width,
                                  height: height),

                              _buildProduct(
                                  context: context,
                                  width: width,
                                  height: height),
                              VerticalPadding(
                                percentage: .5,
                              ),
                              _buildTestWidget(
                                  context: context,
                                  width: width,
                                  height: height),
                              VerticalPadding(
                                percentage: 1.0,
                              ),
                              _buildStyleWidget(
                                  context: context,
                                  width: width,
                                  height: height),
                              VerticalPadding(
                                percentage: .5,
                              ),
                              _buildVideoWidget(
                                  context: context,
                                  width: width,
                                  height: height),
                              VerticalPadding(
                                percentage: .5,
                              ),
                              _buildMostSold(
                                  context: context,
                                  width: width,
                                  height: height),
                              VerticalPadding(
                                percentage: .5,
                              ),
                              _buildDiscountAds1(
                                  context: context,
                                  width: width,
                                  height: height),

                              _buildDiscountAds2(
                                  context: context,
                                  width: width,
                                  height: height),

                              VerticalPadding(
                                percentage: .5,
                              ),

                              _buildMenProduct(
                                  context: context,
                                  width: width,
                                  height: height),
                              VerticalPadding(
                                percentage: .5,
                              ),
                              _buildProductsCategorySection(
                                  context: context,
                                  width: width,
                                  height: height),
                              VerticalPadding(
                                percentage: .5,
                              ),
                              _buildBottomAdsOne(
                                  context: context,
                                  width: width,
                                  height: height),

                              _buildBottomAdsTwo(
                                  context: context,
                                  width: width,
                                  height: height),

                              VerticalPadding(
                                percentage: 1.5,
                              ),

                              // _buildWidgetForDetails(context: context, width: width, height: height)
                            ],
                          ),
                        ),
                      ),
                    ))),
          );
          /*   return Rs.ResideMenu.custom(
            decoration: new BoxDecoration(
              color: globalColor.primaryColor,
              // gradient: new LinearGradient(
              //     colors: [Color(0xff6094e8), globalColor.primaryColor],
              //     begin: Alignment.bottomLeft,
              //     end: Alignment.topRight),
            ),
            controller: _menuController,
            leftView: getDrawerMenu(height, state),
            // leftChild,
            rightView: getDrawerMenu(height, state),
            child:  ,
          );*/
        });
  }

  @override
  void dispose() {
    _cancelToken.cancel();
    _offerBloc.close();
    _sectionHomeBloc.close();

    /// _menuController.dispose();
    super.dispose();
  }

  ///Lis-t of interview questions.
  Widget getListItem(Color color, String iconPath, String title) {
    return GestureDetector(
      key: title == 'Behavioural Based' ? Key('item') : null,
      child: Container(
        color: color,
        height: 300.0,
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Hero(
              tag: iconPath,
              child: Image.asset(
                iconPath,
                width: 80.0,
                height: 80.0,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              title,
              style: Theme.of(context).textTheme.headline6?.copyWith(
                    color: globalColor.white,
                    fontSize: 10,
                    fontFamily: 'Cairo',
                  ),
              textAlign: TextAlign.center,
            )
          ],
        )),
      ),
      onTap: () {},
    );
  }

  Widget getMaterialResideMenuItem(
    String drawerMenuTitle,
    String? drawerMenuIcon,
    MenuSpecItem state, {
    bool isHideArrow = false,
  }) {
    return InkWell(
      onTap: () {
        //      _menuController.closeMenu();
        _sideMenuKey.currentState?.closeSideMenu();
        _onItemMenuPress(state);
      },
      child: Container(
        margin: EdgeInsets.only(
          right: isRtl(context) ? 10.0 : 30.0,
        ),
        child: Row(
          children: [
            SvgPicture.asset(
              drawerMenuIcon ?? AppAssets.home_nav_bar,
              color: globalColor.goldColor,
              width: 20,
            ),
            SizedBox(
              width: 16,
            ),
            Text(
              drawerMenuTitle,
              style: textStyle.normalTSBasic.copyWith(color: globalColor.white),
            ),
            Spacer(),
            isHideArrow
                ? Container()
                : Container(
                    child: Icon(
                      utils.getLang() == 'ar'
                          ? Icons.keyboard_arrow_left
                          : Icons.keyboard_arrow_right,
                      color: globalColor.goldColor,
                      size: 25,
                    ),
                  ),
            // ListTile(
            //   onTap: () {
            //     //      _menuController.closeMenu();
            //     _sideMenuKey.currentState?.closeSideMenu();
            //     _onItemMenuPress(state);
            //   },
            //   leading:  SvgPicture.asset(
            //     drawerMenuIcon ?? AppAssets.home_nav_bar,
            //     color: globalColor.goldColor,
            //     width: 20,
            //   ),
            //   title:  Text(
            //     drawerMenuTitle,
            //     style: textStyle.normalTSBasic
            //         .copyWith(color: globalColor.white),
            //   ),
            //   trailing: isHideArrow
            //       ? Container()
            //       : Container(
            //     child: Icon(
            //       utils.getLang() == 'ar'
            //           ? MaterialIcons.keyboard_arrow_left
            //           : MaterialIcons.keyboard_arrow_right,
            //       color: globalColor.goldColor,
            //       size: 25,
            //     ),
            //   ),
            //   //contentPadding: contentPadding,
            // ),
          ],
        ),
      ),
    );
  }

  _onItemMenuPress(MenuSpecItem state) async {
    switch (state) {
      case MenuSpecItem.HomePage:
        // TODO: Handle this case.
        break;
      case MenuSpecItem.ProfilePage:
        if (await UserRepository.hasToken && isAuth) {
          Get.Get.toNamed(ProfilePage.routeName);
        } else {
          showDialog(
            context: context,
            builder: (ctx) => LoginFirstDialog(),
          );
        }

        break;
      case MenuSpecItem.BrandPage:
        widget.tabController?.animateTo(1);
        break;
      case MenuSpecItem.OrderPage:
        widget.tabController?.animateTo(4);
        break;
      case MenuSpecItem.SectionPage:
        widget.tabController?.animateTo(3);
        break;
      case MenuSpecItem.WalletPage:
        // if (await UserRepository.hasToken && isAuth) {
        //   Get.Get.toNamed(WalletPage.routeName);
        // }
        // else {
        //   showDialog(
        //     context: context,
        //     builder: (ctx) => LoginFirstDialog(),
        //   );
        // }
        showDialog(
          context: context,
          builder: (ctx) => SoonDialog(),
        );

        break;
      case MenuSpecItem.FavoritePage:
        if (await UserRepository.hasToken && isAuth) {
          Get.Get.toNamed(FavoritePage.routeName);
        } else {
          showDialog(
            context: context,
            builder: (ctx) => LoginFirstDialog(),
          );
        }

        break;
      case MenuSpecItem.ReviewsPage:
        if (await UserRepository.hasToken && isAuth) {
          Get.Get.toNamed(ReviewPage.routeName);
        } else {
          showDialog(
            context: context,
            builder: (ctx) => LoginFirstDialog(),
          );
        }

        break;
      case MenuSpecItem.OffersPage:
        Get.Get.toNamed(OffersPage.routeName);
        break;
      case MenuSpecItem.SettingsPage:
        Get.Get.toNamed(SettingsPage.routeName);
        break;
      case MenuSpecItem.SignInPage:
        Get.Get.toNamed(SignInPage.routeName);
        break;
      case MenuSpecItem.SignOut:
        showDialog(
          context: context,
          builder: (ctx) => ConfirmDialog(
            title: Translations.of(context).translate('logout'),
            confirmMessage:
                Translations.of(context).translate('are_you_sure_logout'),
            actionYes: () {
              // logoutFromFacebookIfLoggedIn();
              BlocProvider.of<ApplicationBloc>(context).add(UserLogoutEvent());
              Get.Get.back();
            },
            actionNo: () {
              setState(() {
                Get.Get.back();
              });
            },
          ),
        );
        break;
      default:
        break;
    }
  }

  bool isRtl(context) => TextDirection.rtl == Directionality.of(context);

  getHeaderText(String? userName) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            Translations.of(context).translate('welcome'),
            style: textStyle.normalTSBasic.copyWith(color: globalColor.white),
          ),
          Text(
            userName ?? '',
            maxLines: 1,
            style:
                textStyle.normalTSBasic.copyWith(color: globalColor.goldColor),
          ),
        ],
      ),
    );
  }

  Widget getDrawerMenu(double height, ApplicationState state) {
    return new Container(
      padding:
          new EdgeInsets.only(left: EdgeMargin.small, right: EdgeMargin.small),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          getHeaderText(state.profile?.name ?? state.userData?.name),
          Expanded(
            child: Container(
              child: new ListView(
                physics: const BouncingScrollPhysics(),
                itemExtent: 40.0,
                shrinkWrap: true,
                children: getListMaterialResideMenuItem(state),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> getListMaterialResideMenuItem(ApplicationState state) {
    return [
      getMaterialResideMenuItem(Translations.of(context).translate('home'),
          AppAssets.home_nav_bar, MenuSpecItem.HomePage),
      getMaterialResideMenuItem(
          Translations.of(context).translate('profile_drawer'),
          AppAssets.profile_nav_bar,
          MenuSpecItem.ProfilePage),
//      getMaterialResideMenuItem(Translations.of(context).translate('messages'),
//          EvilIcons.envelope, 3),
      getMaterialResideMenuItem(Translations.of(context).translate('brand'),
          AppAssets.brand_nav_bar, MenuSpecItem.BrandPage),
      getMaterialResideMenuItem(
          Translations.of(context).translate('order_drawer'),
          AppAssets.order_drawer,
          MenuSpecItem.OrderPage),
      getMaterialResideMenuItem(Translations.of(context).translate('section'),
          AppAssets.section_nav_bar, MenuSpecItem.SectionPage),
      getMaterialResideMenuItem(
          Translations.of(context).translate('wallet_drawer'),
          AppAssets.wallet_drawer,
          MenuSpecItem.WalletPage),

      getMaterialResideMenuItem(
          Translations.of(context).translate('favorite_drawer'),
          AppAssets.love,
          MenuSpecItem.FavoritePage),

      getMaterialResideMenuItem(
          Translations.of(context).translate('rated_drawer'),
          AppAssets.review_drawer,
          MenuSpecItem.ReviewsPage),

      getMaterialResideMenuItem(
          Translations.of(context).translate('offers_drawer'),
          AppAssets.sales,
          MenuSpecItem.OffersPage),

      getMaterialResideMenuItem(Translations.of(context).translate('settings'),
          AppAssets.settings_drawer, MenuSpecItem.SettingsPage),
      Padding(
        padding: EdgeInsets.only(
          right: isRtl(context) ? 0 : 30.0,
        ),
        child: Divider(
          height: 1,
          color: globalColor.grey.withOpacity(0.5),
        ),
      ),
      state.isUserAuthenticated || state.isUserVerified
          ? getMaterialResideMenuItem(
              Translations.of(context).translate('logout'),
              AppAssets.logout_svg,
              MenuSpecItem.SignOut,
              isHideArrow: true)
          : getMaterialResideMenuItem(
              Translations.of(context).translate('login'),
              AppAssets.login_svg,
              MenuSpecItem.SignInPage,
              isHideArrow: true),
    ];
  }

  _onTapMenuDrawer() {
    final _state = _sideMenuKey.currentState;
    if (_state!.isOpened)
      _state.closeSideMenu();
    else
      _state.openSideMenu();
  }

  _buildPageIndicator2({double? width, required int count}) {
    return Container(
      alignment: AlignmentDirectional.center,
      width: width,
      child: SmoothPageIndicator(
          controller: controller, //// PageController
          count: count,
          effect: WormEffect(
            spacing: 8.0,
            radius: 12.0,
            dotWidth: 12.0,
            dotHeight: 12.0,
            dotColor: Colors.white,
            paintStyle: PaintingStyle.fill,
            strokeWidth: 2,
            activeDotColor: globalColor.goldColor,
          ), // your preferred effect
          onDotClicked: (index) {}),
    );
  }

  _buildSearchWidget({required BuildContext context, required double width}) {
    return InkWell(
      onTap: () {
        Get.Get.toNamed(FilterSearchPage.routeName);
      },
      child: Padding(
        padding: const EdgeInsets.all(EdgeMargin.small),
        child: Container(
          height: 50.h,
          decoration: BoxDecoration(
            color: globalColor.white,
            borderRadius: BorderRadius.circular(12.0.w),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                blurRadius: 5, // has the effect of softening the shadow
                spreadRadius: 0, // has the effect of extending the shadow
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 1,
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                        child: Center(
                          child: Icon(
                            Icons.search,
                            size: 28.w,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 50.h,
                      color: globalColor.grey.withOpacity(0.2),
                      width: .5,
                    )
                  ],
                ),
              ),
              Expanded(
                  flex: 6,
                  child: TextField(
                    decoration: new InputDecoration(
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        contentPadding: EdgeInsets.only(
                            left: 15, bottom: 11, top: 11, right: 15),
                        hintText: Translations.of(context)
                            .translate('Find_your_product_here'),
                        hintStyle: textStyle.smallTSBasic
                            .copyWith(color: globalColor.grey)),
                    readOnly: true,
                    onTap: () {
                      Get.Get.toNamed(SearchPage.routeName, arguments: null);
                    },
                  )),
              Expanded(
                flex: 1,
                child: Row(
                  children: [
                    Container(
                      height: 50.h,
                      color: globalColor.grey.withOpacity(0.2),
                      width: .5,
                    ),
                    Expanded(
                      flex: 1,
                      child: SvgPicture.asset(
                        AppAssets.filter,
                        width: 22,
                        height: 22,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _buildTopAds(
      {required BuildContext context,
      required double width,
      required double height}) {
    return BlocListener<OfferBloc, OfferState>(
      bloc: _offerBloc,
      listener: (BuildContext context, state) async {
        if (state is OfferDoneState) {
          // _navigateTo(context, state.extraGlassesEntity);
        }
      },
      child: BlocBuilder<OfferBloc, OfferState>(
          bloc: _offerBloc,
          builder: (BuildContext context, state) {
            if (state is OfferFailureState) {
              return Container(
                width: width,
                height: 184.h,
                child: Center(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(
                            (state.error is ConnectionError)
                                ? Translations.of(context)
                                    .translate('err_connection')
                                : Translations.of(context)
                                    .translate('err_unexpected'),
                            style: textStyle.normalTSBasic
                                .copyWith(color: globalColor.accentColor)),
                      ),
                      RaisedButton(
                        onPressed: () {
                          _offerBloc
                              .add(SetupOfferEvent(cancelToken: _cancelToken));
                        },
                        elevation: 1.0,
                        child: Text(Translations.of(context).translate('retry'),
                            style: textStyle.smallTSBasic
                                .copyWith(color: globalColor.white)),
                        color: Theme.of(context).accentColor,
                      ),
                    ],
                  ),
                ),
              );
            }
            if (state is OfferDoneState) {
              if (state.offer?.topHome != null &&
                  (state.offer?.topHome.isNotEmpty ?? false)) {
                return Container(
                  width: width,
                  height: 184.h,
                  child: Stack(
                    children: [
                      PageView(
                        controller: controller,
                        scrollDirection: Axis.horizontal,
                        physics: BouncingScrollPhysics(),
                        children: state.offer!.topHome
                            .map((item) => ItemOfferWidget(
                                  offerItem: item,
                                  width: width,
                                ))
                            .toList(),
                      ),
                      Positioned(
                          bottom: 10,
                          child: Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  EdgeMargin.small, 0.0, EdgeMargin.small, 0.0),
                              child: _buildPageIndicator2(
                                  width: width,
                                  count: state.offer?.topHome.length ?? 0)))
                    ],
                  ),
                );
              } else {
                return Container();
              }
            }

            return Container(
              width: width,
              height: 184.h,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                    EdgeMargin.small, 0.0, EdgeMargin.small, 0.0),
                child: HomeAdsItemShimmer(
                  height: 184,
                  width: width,
                ),
              ),
            );
          }),
    );
  }

  _buildProduct(
      {required BuildContext context,
      required double width,
      required double height}) {
    return Container(
      child: !_isCategoryEmpty
          ? Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      left: EdgeMargin.small, right: EdgeMargin.small),
                  child: TitleWithViewAllWidget(
                    width: width,
                    title: Translations.of(context)
                        .translate('product_classifications'),
                    onClickView: () {
                      widget.tabController?.animateTo(3);
                    },
                    strViewAll: Translations.of(context).translate('view_all'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: EdgeMargin.small, right: EdgeMargin.small),
                  child: Container(
                    //height: height * .16,
                    width: width,
                    decoration: BoxDecoration(
                      color: globalColor.white,
                      borderRadius: BorderRadius.circular(12.0.w),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                            child: _buildCategoryItem(
                                category: _category1,
                                height: height,
                                width: width)),
                        Expanded(
                            child: _buildCategoryItem(
                                category: _category2,
                                height: height,
                                width: width)),
                        Expanded(
                            child: _buildCategoryItem(
                                category: _category3,
                                height: height,
                                width: width)),
                        Expanded(
                            child: _buildCategoryItem(
                                category: _category4,
                                height: height,
                                width: width)),
                      ],
                    ),
                  ),
                ),
              ],
            )
          : Container(),
    );
  }

  _buildCategoryItem(
      {CategoryEntity? category,
      required double width,
      required double height}) {
    return Container(
      child: category != null
          ? ItemCategory(
              category: category,
              height: height * .25,
              width: width * .22,
            )
          : Container(
              child: ItemCategoryShimmer(
                height: height * .25,
                width: width * .22,
              ),
            ),
    );
  }

  _buildMostSold(
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
              title: Translations.of(context).translate('most_sold'),
              onClickView: () {
                Get.Get.toNamed(ProductsVeiwAllPage.routeName,
                    arguments:
                        ProductsViewAllArgs(params: {FILTER_BEST_SALES: '0'}));
              },
              strViewAll: Translations.of(context).translate('view_all'),
            ),
          ),
          Container(
            height: globalSize.setWidthPercentage(60, context),
            child: BuildListProductWidget(
              cancelToken: _cancelToken,
              params: {FILTER_BEST_SALES: '0'},
              getProducts: (products) => (products),
              listScrollDirection: Axis.horizontal,
              isEnablePagination: false,
              isEnableRefresh: false,
              isFromHomePage: true,
              isScrollList: true,
              listWidth: width,
              listHeight: height * .4,
            ),
          ),
          // Container(
          //   child: GridView.builder(
          //       physics: NeverScrollableScrollPhysics(),
          //       padding: const EdgeInsets.only(
          //           left: EdgeMargin.small, right: EdgeMargin.small),
          //       itemCount: listOfProduct.length,
          //       shrinkWrap: true,
          //       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          //         crossAxisCount: 2,
          //         crossAxisSpacing: 4,
          //         mainAxisSpacing: 4,
          //         childAspectRatio: globalSize.setWidthPercentage(40, context) /
          //             globalSize.setWidthPercentage(55, context),
          //       ),
          //       itemBuilder: (context, index) {
          //         return ItemProductHomeWidget(
          //           product: listOfProduct[index],
          //           height: globalSize.setWidthPercentage(55, context),
          //           width: globalSize.setWidthPercentage(40, context),
          //         );
          //       }),
          // )
        ],
      ),
    );
  }

  _buildMenProduct(
      {required BuildContext context,
      required double width,
      required double height}) {
    return Container(
      key: _key,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
                left: EdgeMargin.small, right: EdgeMargin.small),
            child: TitleWithViewAllWidget(
              width: width,
              title: _styleSelected == null || _styleSelected == -1111
                  ? Translations.of(context).translate('men_women_style')
                  : _styleSelected == 38
                      ? Translations.of(context).translate('men_style')
                      : Translations.of(context).translate('women_style'),
              onClickView: () {
                Get.Get.toNamed(ProductsVeiwAllPage.routeName,
                    arguments: ProductsViewAllArgs(
                        params: _styleSelected == null ||
                                _styleSelected == -1111
                            ? {}
                            : {FILTER_GENDER_ID: _styleSelected.toString()}));
              },
              strViewAll: Translations.of(context).translate('view_all'),
            ),
          ),
          Container(
            height: globalSize.setWidthPercentage(60, context),
            child: BuildListProductWidget(
              cancelToken: _cancelToken,
              params: _styleSelected == null || _styleSelected == -1111
                  ? {}
                  : {FILTER_GENDER_ID: _styleSelected.toString()},
              listScrollDirection: Axis.horizontal,
              isEnablePagination: false,
              isEnableRefresh: false,
              isFromHomePage: true,
              isScrollList: true,
              listWidth: width,
              listHeight: height * .4,
            ),
          ),
        ],
      ),
    );
  }

  _buildTestWidget(
      {required BuildContext context,
      required double width,
      required double height}) {
    return InkWell(
      onTap: () {
        Get.Get.toNamed(MainTestPage.routeName);
      },
      child: Padding(
        padding: const EdgeInsets.only(
            left: EdgeMargin.small,
            right: EdgeMargin.small,
            bottom: EdgeMargin.verySub,
            top: EdgeMargin.min),
        child: Container(
            decoration: BoxDecoration(
              color: globalColor.primaryColor,
              borderRadius: BorderRadius.circular(12.0.w),
            ),
            padding: const EdgeInsets.all(EdgeMargin.small),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      SvgPicture.asset(
                        AppAssets.paper,
                        width: 49,
                        height: 49,
                      ),
                    ],
                  ),
                ),
                Expanded(
                    flex: 7,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Text(
                                Translations.of(context).translate(
                                    'test_log_to_show_you_the_best_results'),
                                style: textStyle.smallTSBasic
                                    .copyWith(color: globalColor.goldColor),
                              ),
                            ),
                            Icon(
                              utils.getLang() == 'ar'
                                  ? Icons.keyboard_arrow_left
                                  : Icons.keyboard_arrow_right,
                              color: globalColor.white,
                              size: 25,
                            ),
                          ],
                        ),
                        Container(
                          child: Text(
                            Translations.of(context)
                                .translate('desc_test_home'),
                            style: textStyle.minTSBasic
                                .copyWith(color: globalColor.white),
                          ),
                        ),
                      ],
                    )),
              ],
            )),
      ),
    );
  }

  _buildStyleWidget(
      {required BuildContext context,
      required double width,
      required double height}) {
    return Padding(
        padding: const EdgeInsets.only(
            left: EdgeMargin.small,
            right: EdgeMargin.small,
            bottom: EdgeMargin.verySub,
            top: EdgeMargin.subMin),
        child: HomeSelectStyleWidget(
          height: height,
          width: width,
          onSelected: _onSelectedStyle,
        ));
  }

  _onSelectedStyle(int? selected) {
    if (mounted)
      setState(() {
        _key = GlobalKey();
        _styleSelected = selected;
      });
    print('style selected is ${_styleSelected.toString()}');
  }

  _buildVideoWidget(
      {required BuildContext context,
      required double width,
      required double height}) {
    return NetworkWidget<AboutAppResult?>(
      loadingWidgetBuilder: (BuildContext context) {
        return Container(
          width: width,
          height: height * .23,
          padding: const EdgeInsets.only(
              left: EdgeMargin.small,
              right: EdgeMargin.small,
              bottom: EdgeMargin.verySub,
              top: EdgeMargin.subMin),
          child: BaseShimmerWidget(
            child: Container(
              color: Colors.white,
            ),
          ),
        );
      },
      fetcher: () {
        return GetAboutApp(locator<CoreRepository>())(
          GetAboutAppParams(
            cancelToken: _cancelToken,
          ),
        );
      },
      builder: (BuildContext context, aboutAppResult) {
        return InkWell(
          onTap: () {
            Get.Get.toNamed(OJOSVideoPlayer.routeName,
                arguments: aboutAppResult?.videoHome?.video_link);
          },
          child: Padding(
            padding: const EdgeInsets.only(
                left: EdgeMargin.small,
                right: EdgeMargin.small,
                bottom: EdgeMargin.verySub,
                top: EdgeMargin.subMin),
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(12.0.w)),
              child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.0.w),
                  ),
                  height: height * .23,
                  child: Stack(
                    children: [
                      Image.asset(
                        AppAssets.video,
                        width: width,
                        height: height * .23,
                        fit: BoxFit.fill,
                      ),
                      Align(
                        alignment: AlignmentDirectional.center,
                        child: Container(
                          child: Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.all(EdgeMargin.small),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                          bottomLeft: utils.getLang() == 'ar'
                                              ? Radius.circular(0.0)
                                              : Radius.circular(12.0.w),
                                          topLeft: utils.getLang() == 'ar'
                                              ? Radius.circular(0.0)
                                              : Radius.circular(12.0.w),
                                          topRight: utils.getLang() == 'ar'
                                              ? Radius.circular(12.0.w)
                                              : Radius.circular(0.0),
                                          bottomRight: utils.getLang() == 'ar'
                                              ? Radius.circular(12.0.w)
                                              : Radius.circular(0.0),
                                        ),
                                        color:
                                            globalColor.white.withOpacity(0.6)),
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.all(EdgeMargin.sub),
                                      child: Text(
                                        Translations.of(context).translate(
                                            'click_to_view_the_video'),
                                        style: textStyle.middleTSBasic
                                            .copyWith(color: globalColor.black),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Container(),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Align(
                        child: Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                              color: globalColor.white.withOpacity(0.1),
                              shape: BoxShape.circle),
                          child: Center(
                            child: Container(
                              width: 45,
                              height: 45,
                              decoration: BoxDecoration(
                                  color: globalColor.primaryColor,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      width: 0.5,
                                      color: globalColor.goldColor)),
                              child: Center(
                                child: SvgPicture.asset(
                                  AppAssets.video_home_svg,
                                  width: 15.w,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )),
            ),
          ),
        );
      },
    );
  }

  // _buildDiscountAds1({required BuildContext context, required  double width,required  double height}) {
  //   return Padding(
  //     padding: const EdgeInsets.fromLTRB(EdgeMargin.small, EdgeMargin.verySub,
  //         EdgeMargin.small, EdgeMargin.verySub),
  //     child: Container(
  //       width: width,
  //       height: 90.h,
  //       child: ClipRRect(
  //         borderRadius: BorderRadius.all(Radius.circular(width * .04)),
  //         child: Stack(
  //           children: [
  //             Container(
  //               width: width,
  //               height: height * .25,
  //               child: Image.asset(
  //                 AppAssets.slider_image_png,
  //                 width: width,
  //                 height: 90.h,
  //                 fit: BoxFit.cover,
  //               ),
  //             ),
  //             Align(
  //               alignment: AlignmentDirectional.centerEnd,
  //               child: Diagonal(
  //                 clipHeight: 70.0,
  //                 axis: Axis.vertical,
  //                 position: DiagonalPosition.TOP_RIGHT,
  //                 child: Container(
  //                   width: 154.86.w,
  //                   height: height * .25,
  //                   color: globalColor.primaryColor,
  //                   child: Column(
  //                     crossAxisAlignment: CrossAxisAlignment.end,
  //                     children: [
  //                       Padding(
  //                         padding: const EdgeInsets.only(
  //                             left: 20, right: 10, top: 5),
  //                         child: Text(
  //                           Translations.of(context).translate('discount'),
  //                           style: textStyle.lagerTSBasic
  //                               .copyWith(color: globalColor.white),
  //                         ),
  //                       ),
  //                       Container(
  //                         padding: const EdgeInsets.only(left: 20),
  //                         child: RichText(
  //                           text: new TextSpan(
  //                             text: '99',
  //                             style: textStyle.lagerTSBasic.copyWith(
  //                                 fontWeight: FontWeight.bold,
  //                                 height: .8,
  //                                 color: globalColor.goldColor),
  //                             children: <TextSpan>[
  //                               new TextSpan(
  //                                   text: Translations.of(context)
  //                                       .translate('rail'),
  //                                   style: textStyle.smallTSBasic
  //                                       .copyWith(color: globalColor.white)),
  //                             ],
  //                           ),
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }
  _buildProductsCategorySection(
      {required BuildContext context,
      required double width,
      required double height}) {
    return BlocListener<SectionHomeBloc, SectionHomeState>(
      bloc: _sectionHomeBloc,
      listener: (BuildContext context, state) async {
        if (state is SectionHomeDoneState) {
          // _navigateTo(context, state.extraGlassesEntity);
          // if(state.list!=null && state.list.isNotEmpty){
          //   if(mounted){
          //     _coulumnSection.add(_buildWidgetProduct(
          //       list: state.list,
          //       id: state.id,
          //       height: height,
          //       title: state.name,
          //       width: width,
          //       context: context,
          //     ));
          //     setState(() {
          //       //_keySection = GlobalKey();
          //     });
          //   }
          // }
        }
      },
      child: BlocBuilder<SectionHomeBloc, SectionHomeState>(
          bloc: _sectionHomeBloc,
          builder: (BuildContext context, state) {
            if (state is SectionHomeFailureState) {
              return Container(
                width: width,
                child: Center(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(
                            (state.error is ConnectionError)
                                ? Translations.of(context)
                                    .translate('err_connection')
                                : Translations.of(context)
                                    .translate('err_unexpected'),
                            style: textStyle.normalTSBasic
                                .copyWith(color: globalColor.accentColor)),
                      ),
                      RaisedButton(
                        onPressed: () {
                          _sectionHomeBloc.add(
                              GetSectionHomeEvent(cancelToken: _cancelToken));
                        },
                        elevation: 1.0,
                        child: Text(Translations.of(context).translate('retry'),
                            style: textStyle.smallTSBasic
                                .copyWith(color: globalColor.white)),
                        color: Theme.of(context).accentColor,
                      ),
                    ],
                  ),
                ),
              );
            }
            if (state is SectionHomeDoneState) {
              return Column(
                children: state.sectionArgsHome?.map<Widget>(
                      (option) {
                        if (option.list?.isNotEmpty ?? false)
                          return _buildWidgetProduct(
                            list: option.list!,
                            id: option.id,
                            height: height,
                            title: option.name,
                            width: width,
                            context: context,
                          );

                        return Container();
                      },
                    ).toList() ??
                    [],
              );
            }

            return Container(
              width: width,
            );
          }),
    );
  }

  _buildWidgetProduct(
      {required BuildContext context,
      required double width,
      required double height,
      String? title,
      required List<ProductEntity> list,
      int? id}) {
    return Container(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
                left: EdgeMargin.small, right: EdgeMargin.small),
            child: TitleWithViewAllWidget(
              width: width,
              title: title ?? '',
              onClickView: () {
                if (id != null)
                  Get.Get.toNamed(ProductsVeiwAllPage.routeName,
                      arguments: ProductsViewAllArgs(
                          params: {'category_id': id.toString()}));
              },
              strViewAll: Translations.of(context).translate('view_all'),
            ),
          ),
          Container(
            height: globalSize.setWidthPercentage(60, context),
            alignment: AlignmentDirectional.centerStart,
            child: ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: list.length,
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int index) {
                  return ItemProductHomeWidget(
                    height: globalSize.setWidthPercentage(60, context),
                    width: globalSize.setWidthPercentage(47, context),
                    product: list[index],
                  );
                }),
          ),
        ],
      ),
    );
  }

  _buildDiscountAds1(
      {required BuildContext context,
      required double width,
      required double height}) {
    return BlocListener<OfferBloc, OfferState>(
      bloc: _offerBloc,
      listener: (BuildContext context, state) async {
        if (state is OfferDoneState) {
          // _navigateTo(context, state.extraGlassesEntity);
        }
      },
      child: BlocBuilder<OfferBloc, OfferState>(
          bloc: _offerBloc,
          builder: (BuildContext context, state) {
            if (state is OfferFailureState) {
              return Container(
                width: width,
                height: 184.h,
                child: Center(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(
                            (state.error is ConnectionError)
                                ? Translations.of(context)
                                    .translate('err_connection')
                                : Translations.of(context)
                                    .translate('err_unexpected'),
                            style: textStyle.normalTSBasic
                                .copyWith(color: globalColor.accentColor)),
                      ),
                      RaisedButton(
                        onPressed: () {
                          _offerBloc
                              .add(SetupOfferEvent(cancelToken: _cancelToken));
                        },
                        elevation: 1.0,
                        child: Text(Translations.of(context).translate('retry'),
                            style: textStyle.smallTSBasic
                                .copyWith(color: globalColor.white)),
                        color: Theme.of(context).accentColor,
                      ),
                    ],
                  ),
                ),
              );
            }
            if (state is OfferDoneState) {
              if (state.offer?.middleOneHome != null &&
                  (state.offer?.middleOneHome.isNotEmpty ?? false)) {
                return Container(
                  child: ListView.builder(
                      itemCount: state.offer?.middleOneHome.length,
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return ItemOfferMiddle1Widget(
                          height: height,
                          width: width,
                          offerItem: state.offer?.middleOneHome[index],
                        );
                      }),
                );
              } else {
                return Container();
              }
            }

            return Container(
              width: width,
              height: 90.h,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                    EdgeMargin.small, 0.0, EdgeMargin.small, 0.0),
                child: HomeAdsItemShimmer(
                  height: 90.h,
                  width: width,
                ),
              ),
            );
          }),
    );
  }

  _buildDiscountAds2(
      {required BuildContext context,
      required double width,
      required double height}) {
    return BlocListener<OfferBloc, OfferState>(
      bloc: _offerBloc,
      listener: (BuildContext context, state) async {
        if (state is OfferDoneState) {
          // _navigateTo(context, state.extraGlassesEntity);
        }
      },
      child: BlocBuilder<OfferBloc, OfferState>(
          bloc: _offerBloc,
          builder: (BuildContext context, state) {
            if (state is OfferFailureState) {
              return Container(
                width: width,
                child: Center(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(
                            (state.error is ConnectionError)
                                ? Translations.of(context)
                                    .translate('err_connection')
                                : Translations.of(context)
                                    .translate('err_unexpected'),
                            style: textStyle.normalTSBasic
                                .copyWith(color: globalColor.accentColor)),
                      ),
                      RaisedButton(
                        onPressed: () {
                          _offerBloc
                              .add(SetupOfferEvent(cancelToken: _cancelToken));
                        },
                        elevation: 1.0,
                        child: Text(Translations.of(context).translate('retry'),
                            style: textStyle.smallTSBasic
                                .copyWith(color: globalColor.white)),
                        color: Theme.of(context).accentColor,
                      ),
                    ],
                  ),
                ),
              );
            }
            if (state is OfferDoneState) {
              if (state.offer?.middleTwoHome != null &&
                  (state.offer?.middleTwoHome.isNotEmpty ?? false)) {
                return Container(
                  child: ListView.builder(
                      itemCount: state.offer?.middleTwoHome.length,
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return ItemOfferMiddle2Widget(
                          height: height,
                          width: width,
                          offerItem: state.offer?.middleTwoHome[index],
                        );
                      }),
                );
              } else {
                return Container();
              }
            }

            return Container(
              width: width,
              height: 90.h,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                    EdgeMargin.small, 0.0, EdgeMargin.small, 0.0),
                child: HomeAdsItemShimmer(
                  height: 90.h,
                  width: width,
                ),
              ),
            );
          }),
    );
  }

  _buildBottomAdsOne(
      {required BuildContext context,
      required double width,
      required double height}) {
    return BlocListener<OfferBloc, OfferState>(
      bloc: _offerBloc,
      listener: (BuildContext context, state) async {
        if (state is OfferDoneState) {
          // _navigateTo(context, state.extraGlassesEntity);
        }
      },
      child: BlocBuilder<OfferBloc, OfferState>(
          bloc: _offerBloc,
          builder: (BuildContext context, state) {
            if (state is OfferFailureState) {
              return Container(
                width: width,
                height: 90.h,
                child: Center(
                  child: Column(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text(
                              (state.error is ConnectionError)
                                  ? Translations.of(context)
                                      .translate('err_connection')
                                  : Translations.of(context)
                                      .translate('err_unexpected'),
                              style: textStyle.normalTSBasic
                                  .copyWith(color: globalColor.accentColor)),
                        ),
                      ),
                      RaisedButton(
                        onPressed: () {
                          _offerBloc
                              .add(SetupOfferEvent(cancelToken: _cancelToken));
                        },
                        elevation: 1.0,
                        child: Text(Translations.of(context).translate('retry'),
                            style: textStyle.smallTSBasic
                                .copyWith(color: globalColor.white)),
                        color: Theme.of(context).accentColor,
                      ),
                    ],
                  ),
                ),
              );
            } else if (state is OfferDoneState) {
              if (state.offer?.bottomOneHome != null &&
                  (state.offer?.bottomOneHome.isNotEmpty ?? false)) {
                return Container(
                  child: ListView.builder(
                      itemCount: state.offer?.bottomOneHome.length,
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return ItemOfferBottomWidget(
                          height: height,
                          offerItem: state.offer?.bottomOneHome[index],
                          width: width,
                        );
                      }),
                );
              } else {
                return Container();
              }
            }

            return Container(
              width: width,
              height: 90.h,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                    EdgeMargin.small, 0.0, EdgeMargin.small, 0.0),
                child: HomeAdsItemShimmer(
                  height: 90.h,
                  width: width,
                ),
              ),
            );
          }),
    );
  }

  _buildBottomAdsTwo(
      {required BuildContext context,
      required double width,
      required double height}) {
    return BlocListener<OfferBloc, OfferState>(
      bloc: _offerBloc,
      listener: (BuildContext context, state) async {
        if (state is OfferDoneState) {
          // _navigateTo(context, state.extraGlassesEntity);
        }
      },
      child: BlocBuilder<OfferBloc, OfferState>(
          bloc: _offerBloc,
          builder: (BuildContext context, state) {
            if (state is OfferFailureState) {
              return Container(
                width: width,
                child: Center(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(
                            (state.error is ConnectionError)
                                ? Translations.of(context)
                                    .translate('err_connection')
                                : Translations.of(context)
                                    .translate('err_unexpected'),
                            style: textStyle.normalTSBasic
                                .copyWith(color: globalColor.accentColor)),
                      ),
                      RaisedButton(
                        onPressed: () {
                          _offerBloc
                              .add(SetupOfferEvent(cancelToken: _cancelToken));
                        },
                        elevation: 1.0,
                        child: Text(Translations.of(context).translate('retry'),
                            style: textStyle.smallTSBasic
                                .copyWith(color: globalColor.white)),
                        color: Theme.of(context).accentColor,
                      ),
                    ],
                  ),
                ),
              );
            }
            if (state is OfferDoneState) {
              if (state.offer?.bottomTwoHome != null &&
                  (state.offer?.bottomTwoHome.isNotEmpty ?? false)) {
                return Container(
                  child: ListView.builder(
                      itemCount: state.offer?.bottomTwoHome.length,
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return ItemOfferBottomWidget(
                          height: height,
                          offerItem: state.offer?.bottomTwoHome[index],
                          width: width,
                        );
                      }),
                );
              } else {
                return Container();
              }
            }

            return Container(
              width: width,
              height: 90.h,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                    EdgeMargin.small, 0.0, EdgeMargin.small, 0.0),
                child: HomeAdsItemShimmer(
                  height: 90.h,
                  width: width,
                ),
              ),
            );
          }),
    );
  }

  _buildWidgetForDetails(
      {required BuildContext context,
      required double width,
      required double height}) {
    return Padding(
      padding: const EdgeInsets.all(EdgeMargin.small),
      child: Container(
          decoration: BoxDecoration(
            color: globalColor.white,
            borderRadius: BorderRadius.circular(12.0.w),
          ),
          padding: const EdgeInsets.all(6.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(12.0.w)),
                child: Stack(
                  children: [
                    Image.asset(
                      AppAssets.glass,
                      fit: BoxFit.fill,
                      width: width,
                      height: height * .2,
                    ),
                    Positioned(
                      left: 4.0,
                      top: 4.0,
                      child: Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: globalColor.white,
                              borderRadius: BorderRadius.circular(12.0.w),
                            ),
                            height: height * .035,
                            constraints: BoxConstraints(minWidth: width * .1),
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 4.0, right: 4.0),
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
                                    '4',
                                    style: TextStyle(
                                        color: globalColor.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 5.0,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: globalColor.primaryColor,
                              borderRadius: BorderRadius.circular(12.0.w),
                            ),
                            height: height * .035,
                            constraints: BoxConstraints(minWidth: width * .17),
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 4.0, right: 4.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 2,
                                  ),
                                  SvgPicture.asset(
                                    AppAssets.newww,
                                    width: 12,
                                  ),
                                  SizedBox(
                                    width: 4,
                                  ),
                                  Text(
                                    'جديد',
                                    style: TextStyle(color: globalColor.white),
                                  ),
                                ],
                              ),
                            ),
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
                                'نسائية',
                                style: TextStyle(
                                  color: globalColor.black,
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                              text: new TextSpan(
                                text: 'حصرياً :',
                                style: new TextStyle(
                                    fontSize: 15,
                                    color: globalColor.primaryColor),
                                children: <TextSpan>[
                                  new TextSpan(
                                      text: ' نظارات شركة ايكيا الطبية',
                                      style: new TextStyle(
                                          fontSize: 15,
                                          color: globalColor.black)),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  width: 2,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      color: globalColor.primaryColor,
                                      borderRadius: BorderRadius.circular(14.0),
                                      border: Border.all(
                                          width: 1,
                                          color: globalColor.primaryColor
                                              .withOpacity(0.3))),
                                  child: CircleAvatar(
                                    child: Icon(
                                      Icons.check,
                                      color: globalColor.black,
                                      size: 10,
                                    ),
                                    radius: 7,
                                    backgroundColor: globalColor.goldColor,
                                  ),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  'عدسات مجانية',
                                  style: TextStyle(
                                      fontSize: 11, color: globalColor.black),
                                ),
                                SizedBox(
                                  width: 5,
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Container(
                          alignment: AlignmentDirectional.centerEnd,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    color: globalColor.white,
                                    borderRadius: BorderRadius.circular(12.0.w),
                                    border: Border.all(
                                        width: 1,
                                        color: globalColor.primaryColor
                                            .withOpacity(0.3))),
                                height: height * .035,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 4.0, right: 4.0),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        '89',
                                        style: new TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                            color: globalColor.primaryColor),
                                      ),
                                      Text(' ريال ',
                                          style: new TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.normal,
                                              color: globalColor.black)),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 5.0,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    color: globalColor.white,
                                    borderRadius: BorderRadius.circular(12.0.w),
                                    border: Border.all(
                                        width: 1,
                                        color: globalColor.primaryColor
                                            .withOpacity(0.3))),
                                height: height * .035,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 4.0, right: 4.0),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: 2,
                                      ),
                                      SvgPicture.asset(
                                        AppAssets.sales,
                                        width: 12,
                                      ),
                                      SizedBox(
                                        width: 4,
                                      ),
                                      Text(
                                        '30%',
                                        style: new TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                            color: globalColor.primaryColor),
                                      ),
                                      Text(' خصم ',
                                          style: new TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.normal,
                                              color: globalColor.black)),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: width,
                    color: globalColor.grey.withOpacity(0.2),
                    child: Row(
                      children: [
                        Expanded(
                            flex: 1,
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border(
                                        left: BorderSide(
                                            width: 1,
                                            color: globalColor.grey
                                                .withOpacity(0.3)))),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'الاحجام المتوفرة',
                                      style: TextStyle(
                                          color: globalColor.black,
                                          fontSize: 12),
                                    ),
                                    SizedBox(
                                      height: 7,
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                              color: globalColor.white
                                                  .withOpacity(0.3),
                                              borderRadius:
                                                  BorderRadius.circular(12.0.w),
                                              border: Border.all(
                                                  width: 1,
                                                  color: globalColor
                                                      .primaryColor
                                                      .withOpacity(0.3))),
                                          height: height * .035,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 4.0, right: 4.0),
                                            child: Center(
                                              child: Text(
                                                '40 - 48',
                                                style: new TextStyle(
                                                    fontSize: 11,
                                                    fontWeight: FontWeight.bold,
                                                    color: globalColor.black),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 2,
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                              color: globalColor.white
                                                  .withOpacity(0.3),
                                              borderRadius:
                                                  BorderRadius.circular(12.0.w),
                                              border: Border.all(
                                                  width: 1,
                                                  color: globalColor
                                                      .primaryColor)),
                                          height: height * .035,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 4.0, right: 4.0),
                                            child: Center(
                                              child: Text(
                                                '49 - 54',
                                                style: new TextStyle(
                                                    fontSize: 11,
                                                    fontWeight: FontWeight.bold,
                                                    color: globalColor
                                                        .primaryColor),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 2,
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                              color: globalColor.white
                                                  .withOpacity(0.3),
                                              borderRadius:
                                                  BorderRadius.circular(12.0.w),
                                              border: Border.all(
                                                  width: 1,
                                                  color: globalColor
                                                      .primaryColor
                                                      .withOpacity(0.3))),
                                          height: height * .035,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 4.0, right: 4.0),
                                            child: Center(
                                              child: Text(
                                                '55 - 58',
                                                style: new TextStyle(
                                                    fontSize: 11,
                                                    fontWeight: FontWeight.bold,
                                                    color: globalColor.black),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 7,
                                    ),
                                  ],
                                ),
                              ),
                            )),
                        Expanded(
                            flex: 1,
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'الألوان المتوفرة',
                                      style: TextStyle(
                                          color: globalColor.black,
                                          fontSize: 12),
                                    ),
                                    SizedBox(
                                      height: 7,
                                    ),
                                    Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 10,
                                          backgroundColor: Colors.red,
                                        ),
                                        SizedBox(
                                          width: 4,
                                        ),
                                        CircleAvatar(
                                          radius: 10,
                                          backgroundColor: Colors.green,
                                          child: Center(
                                            child: Icon(
                                              Icons.check,
                                              color: globalColor.white,
                                              size: 10,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 4,
                                        ),
                                        CircleAvatar(
                                          radius: 10,
                                          backgroundColor:
                                              Colors.lightBlueAccent,
                                          child: Center(
                                            child: Icon(
                                              Icons.check,
                                              color: globalColor.white,
                                              size: 10,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 4,
                                        ),
                                        CircleAvatar(
                                          radius: 10,
                                          backgroundColor: Colors.pinkAccent,
                                          child: Center(
                                            child: Icon(
                                              Icons.check,
                                              color: globalColor.white,
                                              size: 10,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 4,
                                        ),
                                        CircleAvatar(
                                          radius: 10,
                                          backgroundColor: Colors.black,
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 7,
                                    ),
                                  ],
                                ),
                              ),
                            )),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: globalColor.white,
                            borderRadius: BorderRadius.circular(16.0),
                            border: Border.all(
                                width: 1,
                                color: globalColor.grey.withOpacity(0.3))),
                        height: height * .05,
                        constraints: BoxConstraints(minWidth: width * .17),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 4.0, right: 4.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 8.0,
                              ),
                              SvgPicture.asset(
                                AppAssets.camera,
                                width: 20,
                              ),
                              SizedBox(
                                width: 4,
                              ),
                              Text(
                                'جرب النظارة قبل الشراء',
                                style: TextStyle(
                                    fontSize: 13, color: globalColor.black),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        height: height * .05,
                        width: height * .05,
                        decoration: BoxDecoration(
                            color: globalColor.white,
                            shape: BoxShape.circle,
                            border: Border.all(
                                width: 1,
                                color: globalColor.grey.withOpacity(0.3))),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SvgPicture.asset(
                            AppAssets.love,
                            width: 10,
                            height: 10,
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: globalColor.white,
                            borderRadius: BorderRadius.circular(16.0),
                            border: Border.all(
                                width: 1,
                                color: globalColor.grey.withOpacity(0.3))),
                        height: height * .05,
                        constraints: BoxConstraints(minWidth: width * .17),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 4.0, right: 4.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 8.0,
                              ),
                              SvgPicture.asset(
                                AppAssets.cart_nav_bar,
                                color: globalColor.black,
                                width: 20,
                              ),
                              SizedBox(
                                width: 4,
                              ),
                              Text(
                                'إضافة  للسلة',
                                style: TextStyle(
                                    fontSize: 13,
                                    color: globalColor.primaryColor),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ],
          )),
    );
  }

  Future<void> _getCategories(int reloadCount) async {
    int count = reloadCount;
    if (mounted) {
//      setState(() {
//        _listOfProfessions.addAll(result.data);
//        _professionId =
//        profile.profession != null ? profile.profession.id : null;
//
//        if (!appConfig.notNullOrEmpty(_professionId))
//          _professionId = _listOfProfessions[0]?.id ?? null;
//      });
      final result = await GetCategories(locator<CoreRepository>())(
        NoParams(cancelToken: _cancelToken),
      );

      if (result.data != null) {
        setState(() {
          if ((result.data?.isNotEmpty ?? false) && result.data?[0] != null) {
            _category1 = result.data![0];
          }
          if ((result.data?.isNotEmpty ?? false) && result.data?[1] != null) {
            _category2 = result.data![1];
          }
          if ((result.data?.isNotEmpty ?? false) && result.data?[2] != null) {
            _category3 = result.data![2];
          }
          if ((result.data?.isNotEmpty ?? false) && result.data?[3] != null) {
            _category4 = result.data![3];
          }

          if (_category1 == null &&
              _category2 == null &&
              _category3 == null &&
              _category4 == null) {
            _isCategoryEmpty = true;
          }
        });
      } else {
        if (count != 3)
          appConfig.check().then((internet) {
            if (internet != null && internet) {
              _getCategories(count + 1);
            }
            // No-Internet Case
          });
      }
    }
  }
}

enum MenuSpecItem {
  HomePage,
  ProfilePage,
  BrandPage,
  OrderPage,
  SectionPage,
  WalletPage,
  FavoritePage,
  ReviewsPage,
  OffersPage,
  SettingsPage,
  SignInPage,
  SignOut
}
