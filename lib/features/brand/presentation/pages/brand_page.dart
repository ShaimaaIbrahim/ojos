import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:ojos_app/core/localization/translations.dart';
import 'package:ojos_app/core/res/global_color.dart';
import 'package:ojos_app/core/res/text_style.dart';
import 'package:ojos_app/core/res/width_height.dart';
import 'package:ojos_app/core/ui/button/arrow_back_button_widget.dart';
import 'package:ojos_app/core/ui/list/build_list_brand.dart';

class BrandPage extends StatefulWidget {
  static const routeName = '/brand/pages/BrandPage';

  @override
  _BrandPageState createState() => _BrandPageState();
}

class _BrandPageState extends State<BrandPage> {
  @override
  void initState() {
    super.initState();
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
        Translations.of(context).translate('brand'),
        style: textStyle.middleTSBasic.copyWith(color: globalColor.black),
      ),
      centerTitle: true,
    );

    return Scaffold(
        appBar: appBar,
        key: _scaffoldKey,
        body: Container(
            child: BuildListBrandWidget(
          params: {},
          cancelToken: _cancelToken,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 1,
            mainAxisSpacing: 1,
            childAspectRatio: globalSize.setWidthPercentage(40, context) /
                globalSize.setWidthPercentage(40, context),
          ),
        )));
  }

  @override
  void dispose() {
    _cancelToken.cancel();
    super.dispose();
  }
}
