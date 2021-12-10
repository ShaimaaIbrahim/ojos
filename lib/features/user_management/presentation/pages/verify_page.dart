import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart' as Get;
import 'package:ojos_app/extra_lip/model_progress_hud.dart';

import 'package:ojos_app/core/appConfig.dart';
import 'package:ojos_app/core/bloc/application_bloc.dart';
import 'package:ojos_app/core/bloc/application_events.dart';
import 'package:ojos_app/core/constants.dart';
import 'package:ojos_app/core/errors/connection_error.dart';
import 'package:ojos_app/core/errors/custom_error.dart';
import 'package:ojos_app/core/lib/flutter_verification_code/src/flutter_verification_code.dart';
import 'package:ojos_app/core/localization/translations.dart';
import 'package:ojos_app/core/providers/auth_service.dart';
import 'package:ojos_app/core/res/edge_margin.dart';
import 'package:ojos_app/core/res/global_color.dart';
import 'package:ojos_app/core/res/screen/vertical_padding.dart';
import 'package:ojos_app/core/res/text_style.dart';
import 'package:ojos_app/core/res/width_height.dart';
import 'package:ojos_app/core/ui/button/arrow_back_button_widget.dart';
import 'package:ojos_app/core/ui/dailog/faild_verify_account_dialog.dart';
import 'package:ojos_app/core/ui/dailog/success_verify_account_dialog.dart';
import 'package:ojos_app/core/ui/widget/button/rounded_button.dart';
import 'package:ojos_app/core/ui/widget/general_widgets/error_widgets.dart';
import 'package:ojos_app/features/user_management/presentation/args/verify_page_args.dart';
import 'package:ojos_app/features/user_management/presentation/blocs/verify_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../main.dart';
import '../../../main_root.dart';

class VerifyPage extends StatefulWidget {
  static const routeName = '/features/VerifyPage';

  @override
  _VerifyPageState createState() => _VerifyPageState();
}

class _VerifyPageState extends State<VerifyPage> {
  final args = Get.Get.arguments as VerifyPageArgs;

  @override
  Widget build(BuildContext context) {
    double widthC = globalSize.setWidthPercentage(100, context);
    double heightC = globalSize.setHeightPercentage(100, context);
    return Container(
      width: widthC,
      height: heightC,
      child: Stack(
        children: [
          // UserManagementBackground(
          //   height: heightC,
          //   image: AppAssets.backgroundSignUp,
          //   width: widthC,
          // ),
          VerifyBox(mobileNumber: args.userName, otpCode: args.otpCode),
        ],
      ),
    );
  }
}

class VerifyBox extends StatefulWidget {
  final String mobileNumber;
  final int? otpCode;

  const VerifyBox({required this.mobileNumber, required this.otpCode});

  @override
  _VerifyBoxState createState() => _VerifyBoxState();
}

class _VerifyBoxState extends State<VerifyBox> {
  final AuthService firebaseAuth = AuthService();
  bool _onEditing = true;
  String? _code;

  final _formKey = GlobalKey<FormState>();

  final _bloc = VerifyBloc();

  final _verifyCancelToken = CancelToken();
  final _resendCodeCancelToken = CancelToken();

  String phoneNuumberWithCode = '';
  @override
  void initState() {
    super.initState();
    if (widget.mobileNumber != null && widget.mobileNumber[0] == '0') {
      phoneNuumberWithCode = GSM + widget.mobileNumber.substring(1);
    } else {
      phoneNuumberWithCode = GSM + widget.mobileNumber;
    }
    firebaseAuth.sendingSMSForProvidedPhoneNumber(
      phoneNumber: GSM + widget.mobileNumber,
      //  phoneNumber: '+9630951971272',

      onSendSMSDone: _onSendSMSDone,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    AppBar appBar = AppBar(
      backgroundColor: globalColor.transparent,
      brightness: Brightness.dark,
      leading: ArrowIconButtonWidget(
        iconColor: globalColor.black,
      ),
      iconTheme: IconThemeData(
        color: globalColor.black,
      ),
      title: Text(
        Translations.of(context).translate('confirm_phone_number'),
        style:
            textStyle.middleTSBasic.copyWith(color: globalColor.primaryColor),
      ),
      elevation: 0,
      centerTitle: true,
    );

    double widthC = globalSize.setWidthPercentage(100, context);
    double heightC = globalSize.setHeightPercentage(100, context);

    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: appBar,
        backgroundColor: globalColor.white,
        body: BlocListener<VerifyBloc, VerifyState>(
          bloc: _bloc,
          child: BlocBuilder<VerifyBloc, VerifyState>(
            bloc: _bloc,
            builder: (context, state) {
              return ModalProgressHUD(
                  inAsyncCall: state is VerifyLoading,
                  color: globalColor.primaryColor,
                  opacity: 0.2,
                  child: Container(
                      width: widthC,
                      height: heightC,
                      child: SingleChildScrollView(
                        child: Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              VerticalPadding(
                                percentage: 12.5,
                              ),
                              Container(
                                child: Text(
                                  Translations.of(context)
                                      .translate('account_confirmation'),
                                  style: textStyle.bigTSBasic.copyWith(
                                      color: globalColor.primaryColor),
                                ),
                              ),
                              VerticalPadding(
                                percentage: 1.5,
                              ),
                              Container(
                                child: Text(
                                  Translations.of(context).translate(
                                      'secret_code_sent_to_confirm_the_account'),
                                  style: textStyle.smallTSBasic
                                      .copyWith(color: globalColor.black),
                                ),
                              ),
                              VerticalPadding(
                                percentage: .5,
                              ),
                              Container(
                                child: Text(
                                  '${widget.mobileNumber}',
                                  style: textStyle.bigTSBasic.copyWith(
                                    color: globalColor.black,
                                    fontWeight: FontWeight.w200,
                                  ),
                                ),
                              ),
                              VerticalPadding(
                                percentage: 7.5,
                              ),
                              VerificationCode(
                                textStyle: textStyle.middleTSBasic
                                    .copyWith(color: globalColor.black),
                                keyboardType: TextInputType.number,
                                // in case underline color is null it will use primaryColor: Colors.red from Theme
                                underlineColor: Colors.white,
                                length: 6,
                                // clearAll is NOT required, you can delete it
                                // takes any widget, so you can implement your design
                                // clearAll: Padding(
                                //   padding: const EdgeInsets.all(8.0),
                                //   child: Text(
                                //     'clear all',
                                //     style: TextStyle(
                                //         fontSize: 14.0,
                                //         decoration: TextDecoration.underline,
                                //         color: Colors.blue[700]),
                                //   ),
                                // ),
                                onCompleted: (String value) {
                                  setState(() {
                                    _code = value;
                                  });
                                },
                                onEditing: (bool value) {
                                  setState(() {
                                    _onEditing = value;
                                  });
                                  if (!_onEditing)
                                    FocusScope.of(context).unfocus();
                                },
                              ),
                              VerticalPadding(
                                percentage: 2.5,
                              ),
                              Container(
                                child: Text(
                                  Translations.of(context)
                                      .translate('did_not_get_code_text'),
                                  style: textStyle.smallTSBasic
                                      .copyWith(color: globalColor.black),
                                ),
                              ),
                              VerticalPadding(
                                percentage: .5,
                              ),
                              Container(
                                child: InkWell(
                                  onTap: () {
                                    // firebaseMessaging.getToken().then((token) async {
                                    //   assert(token != null);
                                    //   var _homeScreenText;
                                    //   _homeScreenText = "FCM Messaging token sign up: $token";
                                    //
                                    //   if(appConfig.notNullOrEmpty(token)){
                                    //     _bloc.add(
                                    //       ResendCodeEvent(
                                    //         username:widget.mobileNumber,
                                    //         device_token: token,
                                    //         cancelToken: _resendCodeCancelToken,
                                    //       ),
                                    //     );
                                    //   }
                                    //   else{
                                    //     Fluttertoast.showToast(
                                    //         msg: Translations.of(context)
                                    //             .translate('something_went_wrong_try_again'));
                                    //   }
                                    //
                                    // });
                                    firebaseAuth
                                        .sendingSMSForProvidedPhoneNumber(
                                      phoneNumber: GSM + widget.mobileNumber,
                                      // phoneNumber: '+9630951971272',
                                      onSendSMSDone: _onSendSMSDone,
                                    );

                                    appConfig.showToast(
                                        msg: Translations.of(context).translate(
                                            'new_code_is_being_requested_please wait'),
                                        backgroundColor:
                                            globalColor.primaryColor,
                                        textColor: globalColor.white);
                                  },
                                  child: Text(
                                    Translations.of(context)
                                        .translate('send_new_code'),
                                    style: textStyle.smallTSBasic.copyWith(
                                        color: globalColor.primaryColor),
                                  ),
                                ),
                              ),
                              VerticalPadding(
                                percentage: 2.5,
                              ),
                              Container(
                                  padding: const EdgeInsets.only(
                                      left: EdgeMargin.min,
                                      right: EdgeMargin.min),
                                  child: RoundedButton(
                                    height: 55.h,
                                    width: widthC,
                                    color: globalColor.primaryColor,
                                    borderRadius: 8.w,
                                    onPressed: () {
                                      firebaseAuth.signInWithPhoneNumber(
                                        smsCode: _code ?? '',
                                        onVerifyDone: (result) {
                                          /// result is true then the process done successfully
                                          /// you can make your own request here.
                                          print(
                                              'code is ==========================$_code');

                                          if (result) {
                                            print(
                                                'code is ==========================$_code');

                                            if (_code != null &&
                                                (_code?.isNotEmpty ?? false) &&
                                                _code?.length == 6) {
                                              //code: widget.otpCode.toString(),
                                              _bloc.add(
                                                VerifyEvent(
                                                  mobile: widget.mobileNumber,
                                                  code:
                                                      widget.otpCode.toString(),
                                                  cancelToken:
                                                      _verifyCancelToken,
                                                ),
                                              );
                                            } else {
                                              ErrorViewer.showCustomError(
                                                  context,
                                                  Translations.of(context)
                                                      .translate(
                                                          'msg_code_missing'));
                                            }
                                          }

                                          /// otherwise no
                                          else {
                                            appConfig.showToast(
                                                msg: Translations.of(context)
                                                    .translate(
                                                        'the_code_is_wrong'),
                                                backgroundColor:
                                                    globalColor.primaryColor,
                                                textColor: globalColor.white);
                                          }
                                        },
                                      );
                                    },
                                    child: Container(
                                      child: Center(
                                        child: Text(
                                          Translations.of(context)
                                              .translate('send'),
                                          style: textStyle.middleTSBasic
                                              .copyWith(
                                                  color: globalColor.white),
                                        ),
                                      ),
                                    ),
                                  )),
                              VerticalPadding(
                                percentage: 5.5,
                              ),
                              _buildSignInButton(context)
                            ],
                          ),
                        ),
                      )));
            },
          ),
          listener: (context, state) async {
            if (state is VerifySuccess) {
              // if (state.data.resultCode == LOGIN_SUCCESS) {
              //   while (Navigator.of(context).canPop())
              //     Navigator.of(context).pop();
              //   Navigator.of(context).pushReplacement(
              //     MaterialPageRoute(
              //       builder: (ctx) => MainPage(),
              //     ),
              //   );
              //
              // }
              // BlocProvider.of<ApplicationBloc>(context)..add(
              //   VerifyUserAccountEvent(),
              // )..add(GetFCMTokenAndUpdateItEvent());
              showDialog(
                barrierDismissible: false,
                context: context,
                builder: (ctx) => SuccessVerifyAccountDialog(),
              );
            }
            if (state is VerifyFailure) {
              final error = state.error;
              if (error is ConnectionError) {
                ErrorViewer.showConnectionError(context, state.callback);
              } else if (error is CustomError) {
                ErrorViewer.showCustomError(context, error.message);
              } else {
                // ErrorViewer.showUnexpectedError(context);

              }
            }
            if (state is ResendCodeSuccess) {
              ErrorViewer.showCustomError(
                  context, Translations.of(context).translate('code_sent'));
            }
            if (state is ResendCodeFailure) {
              final error = state.error;
              if (error is ConnectionError) {
                ErrorViewer.showConnectionError(context, state.callback);
              } else if (error is CustomError) {
                ErrorViewer.showCustomError(context, error.message);
              } else {
                // ErrorViewer.showUnexpectedError(context);
                showDialog(
                  context: context,
                  builder: (ctx) => FaildVerifyAccountDialog(
                    requestNewCode: _onRequestNewCodeAction,
                  ),
                );
              }
            }
          },
        ));
  }

  _onRequestNewCodeAction(bool val) {
    if (val) {
      firebaseMessaging.getToken().then((token) async {
        assert(token != null);
        var _homeScreenText;
        _homeScreenText = "FCM Messaging token sign up: $token";

        if (appConfig.notNullOrEmpty(token)) {
          _bloc.add(
            ResendCodeEvent(
              username: widget.mobileNumber,
              device_token: token!,
              cancelToken: _resendCodeCancelToken,
            ),
          );
        } else {
          Fluttertoast.showToast(
              msg: Translations.of(context)
                  .translate('something_went_wrong_try_again'));
        }
      });
    }
  }

  Widget _buildSignInButton(BuildContext context) {
    return Column(
      children: <Widget>[
        Wrap(
          children: <Widget>[
            Text(
              '${Translations.of(context).translate('you_have_account')} ',
              style: textStyle.middleTSBasic.copyWith(color: globalColor.white),
            ),
            InkWell(
              child: Text(
                Translations.of(context).translate('login'),
                style: textStyle.middleTSBasic.copyWith(
                    //  decoration: TextDecoration.underline,
                    color: globalColor.white),
              ),
              onTap: () {
                Get.Get.back();
              },
            )
          ],
        ),
      ],
    );
  }

  _onSendSMSDone(bool result) {
    /// result is true then the process done successfully
    if (result) {
      appConfig.showToast(
          msg: Translations.of(context)
              .translate('The_verification_code_is_being_requested'),
          backgroundColor: globalColor.primaryColor,
          textColor: globalColor.white);
    }

    /// otherwise does not succeeded for some reasons
    else {
      appConfig.showToast(
          msg: Translations.of(context).translate('please_try_later'),
          backgroundColor: globalColor.primaryColor,
          textColor: globalColor.white);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _verifyCancelToken.cancel();
    _resendCodeCancelToken.cancel();
    _bloc.close();
    firebaseAuth.signOut();
  }
}
