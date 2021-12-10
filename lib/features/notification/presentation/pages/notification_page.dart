import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ojos_app/core/localization/translations.dart';
import 'package:ojos_app/core/res/global_color.dart';
import 'package:ojos_app/core/res/text_style.dart';
import 'package:ojos_app/core/res/width_height.dart';
import 'package:ojos_app/core/ui/button/arrow_back_button_widget.dart';
import 'package:ojos_app/core/ui/list/build_list_notifications.dart';

class NotificationPage extends StatefulWidget {
  static const routeName = '/notification/pages/NotificationPage';

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  void initState() {
    super.initState();
  }

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey _globalKey = GlobalKey();
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
        Translations.of(context).translate('notifications'),
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
        backgroundColor: globalColor.scaffoldBackGroundGreyColor,
        body: Container(
            key: _globalKey,
            height: height,
            child: BuildListNotificationsWidget(
              cancelToken: _cancelToken,
              onUpdate: _onUpdate,
              isEnablePagination: true,
              isEnableRefresh: true,
              params: {},
              itemWidth: width,
            )));
  }

  _onUpdate() {
    _globalKey = GlobalKey();
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _cancelToken.cancel();
    super.dispose();
  }
}
