import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart' as Get;
import 'package:ojos_app/core/bloc/application_bloc.dart';
import 'package:ojos_app/core/bloc/application_events.dart';
import 'package:ojos_app/core/entities/extra_glasses_entity.dart';
import 'package:ojos_app/core/errors/connection_error.dart';
import 'package:ojos_app/core/localization/translations.dart';
import 'package:ojos_app/core/res/app_assets.dart';
import 'package:ojos_app/core/res/global_color.dart';
import 'package:ojos_app/core/res/screen/screen_helper.dart';
import 'package:ojos_app/core/res/text_style.dart';
import 'package:ojos_app/core/res/width_height.dart';
import 'package:ojos_app/features/profile/domin/entities/profile_entity.dart';
import 'package:ojos_app/features/splash/presentation/blocs/splash_bloc.dart';
import 'package:ojos_app/features/user_management/domain/repositories/user_repository.dart';

import 'main_root.dart';

class SplashScreen extends StatefulWidget {
  static const routeName = '/features/SplashScreen';

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  var _cancelToken = CancelToken();

  ExtraGlassesEntity? extraGlassesEntity;
  ProfileEntity? profileEntity;

  var _bloc = SplashBloc();

  @override
  void initState() {
    super.initState();
    delay();
    _bloc.add(SetupSplashEvent(cancelToken: _cancelToken));
  }

  delay() async {
    await Future.delayed(Duration(seconds: 3), () {});
  }

  @override
  Widget build(BuildContext context) {
    ScreensHelper(context);
    final double width = globalSize.setWidthPercentage(100, context);
    final double height = globalSize.setHeightPercentage(100, context);
    return Scaffold(
        resizeToAvoidBottomInset: false,
        extendBodyBehindAppBar: true,
        body: Container(
          width: width,
          height: height,
          child: Stack(
            alignment: AlignmentDirectional.center,
            children: <Widget>[
              BackgroundCircle(
                height: height,
                width: width,
              ),
              Container(
                child: SvgPicture.asset(AppAssets.splashLogo),
              ),
              Positioned(
                bottom: ScreensHelper.fromHeight(5),
                width: ScreensHelper.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    BlocListener<SplashBloc, SplashState>(
                      bloc: _bloc,
                      listener:
                          (BuildContext context, SplashState state) async {
                        print('state state state state : $state');
                        if (state is SplashDoneState) {
                          extraGlassesEntity = state.extraGlassesEntity;
                          if (await UserRepository.hasToken) {
                            _bloc.add(
                                SetupUserDataEvent(cancelToken: _cancelToken));
                          } else {
                            _navigateTo(context);
                          }
                        }
                        if (state is SplashUserDataDoneState) {
                          profileEntity = state.profile;
                          delay();
                          _navigateTo(context);
                        }
                        if (state is SplashUserDataFailureState) {
                          _navigateTo(context);
                        }
                        // if (state is SplashFailureState) {
                        //   final error = state.error;
                        //   if (error is ConnectionError) {
                        //     ErrorViewer.showConnectionError(context, () {
                        //       _bloc.add(SetupSplashEvent(
                        //           filterParams: {},
                        //           pageSize: 100000,
                        //           page: 0,
                        //           cancelToken: _cancelToken
                        //       ));
                        //     },);
                        //   } else if (error is CustomError) {
                        //     ErrorViewer.showCustomError(context, error.message);
                        //   }
                        // }
                      },
                      child: BlocBuilder<SplashBloc, SplashState>(
                        bloc: _bloc,
                        builder: (BuildContext context, state) {
                          if (state is SplashFailureState) {
                            return Center(
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
                                        style: textStyle.normalTSBasic.copyWith(
                                            color: globalColor.accentColor)),
                                  ),
                                  RaisedButton(
                                    onPressed: () {
                                      _bloc.add(SetupSplashEvent(
                                          cancelToken: _cancelToken));
                                    },
                                    elevation: 1.0,
                                    child: Text(
                                        Translations.of(context)
                                            .translate('retry'),
                                        style: textStyle.smallTSBasic.copyWith(
                                            color: globalColor.white)),
                                    color: Theme.of(context).accentColor,
                                  ),
                                ],
                              ),
                            );
                          }

                          return LimitedBox(
                              maxHeight: ScreensHelper.fromHeight(0.4),
                              maxWidth: ScreensHelper.fromWidth(30),
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                      ScreensHelper.fromWidth(2.5)),
                                  child: Container(
                                      child: LinearProgressIndicator(
                                    backgroundColor: globalColor.white,
                                  ))));
                        },
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ));
  }

  Future<void> _navigateTo(BuildContext context) async {
    if (extraGlassesEntity !=
        null) if (BlocProvider.of<ApplicationBloc>(context).isInitialized) {
      /// todo GetFCMTokenAndUpdateItEvent
      BlocProvider.of<ApplicationBloc>(context)
        ..add(SetExtraGlassesEvent(extraGlassesEntity: extraGlassesEntity!));
      if (profileEntity != null)
        BlocProvider.of<ApplicationBloc>(context)
              ..add(SetProfileSplashEvent(profileEntity: profileEntity!))
            // ..add(GetFCMTokenAndUpdateItEvent())
            ;
      Get.Get.offAndToNamed(MainRootPage.routeName);
      return;
    }
  }

  @override
  void dispose() {
    _cancelToken.cancel();
    super.dispose();
  }
}

class BackgroundCircle extends StatelessWidget {
  final double height;
  final double width;

  const BackgroundCircle({required this.height, required this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      color: globalColor.primaryColor,
      child: Center(
        child: Stack(
          children: [
            Container(
              child: CustomPaint(painter: DrawCircle(height * .15)),
            ),
            Container(
              child: CustomPaint(painter: DrawCircle(height * .25)),
            ),
            Container(
              child: CustomPaint(painter: DrawCircle(height * .35)),
            ),
            Container(
              child: CustomPaint(painter: DrawCircle(height * .45)),
            ),
            Container(
              child: CustomPaint(painter: DrawCircle(height * .55)),
            ),
          ],
        ),
      ),
    );
  }
}

class DrawCircle extends CustomPainter {
  final double raduis;

  DrawCircle(this.raduis);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = globalColor.circleSplash
      ..strokeWidth = 40.0.w
      ..style = PaintingStyle.stroke;
    canvas.drawCircle(Offset(0.0, 0.0), raduis, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
