import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart' as Get;
import 'package:ojos_app/extra_lip/model_progress_hud.dart';
import 'package:ojos_app/core/appConfig.dart';
import 'package:ojos_app/core/errors/bad_request_error.dart';
import 'package:ojos_app/core/errors/connection_error.dart';
import 'package:ojos_app/core/errors/custom_error.dart';
import 'package:ojos_app/core/localization/translations.dart';
import 'package:ojos_app/core/res/app_assets.dart';
import 'package:ojos_app/core/res/edge_margin.dart';
import 'package:ojos_app/core/res/global_color.dart';
import 'package:ojos_app/core/res/screen/vertical_padding.dart';
import 'package:ojos_app/core/res/text_style.dart';
import 'package:ojos_app/core/res/width_height.dart';
import 'package:ojos_app/core/ui/button/arrow_back_button_widget.dart';
import 'package:ojos_app/core/ui/widget/button/rounded_button.dart';
import 'package:ojos_app/core/ui/widget/general_widgets/error_widgets.dart';
import 'package:ojos_app/core/validators/base_validator.dart';
import 'package:ojos_app/core/validators/required_validator.dart';
import 'package:ojos_app/features/user_management/domain/repositories/user_repository.dart';
import 'package:ojos_app/features/user_management/presentation/args/verify_page_args.dart';
import 'package:ojos_app/features/user_management/presentation/blocs/register_bloc.dart';
import 'package:ojos_app/features/user_management/presentation/pages/verify_page.dart';
import 'package:ojos_app/features/user_management/presentation/widgets/user_management_background.dart';
import 'package:ojos_app/features/user_management/presentation/widgets/user_management_text_field_widget.dart';

import '../../../main_root.dart';

class SignUpPage extends StatelessWidget {
  static const routeName = '/features/SignUpPage';

  @override
  Widget build(BuildContext context) {
    double widthC = globalSize.setWidthPercentage(100, context);
    double heightC = globalSize.setHeightPercentage(100, context);
    return Container(
      width: widthC,
      height: heightC,
      child: Stack(
        children: [
          UserManagementBackground(
            height: heightC,
            image: AppAssets.backgroundSignUp,
            width: widthC,
          ),
          SignUpBox(),
        ],
      ),
    );
  }
}

class SignUpBox extends StatefulWidget {
  @override
  _SignUpBoxState createState() => _SignUpBoxState();
}

class _SignUpBoxState extends State<SignUpBox> {
  /// fullName parameters
  bool _fullNameValidation = false;
  String _fullName = '';
  final TextEditingController fullNameEditingController =
      new TextEditingController();

  /// phone parameters
  bool _phoneValidation = false;
  String _phone = '';
  final TextEditingController phoneEditingController =
      new TextEditingController();

  /// password parameters
  bool _passwordValidation = false;
  String _password = '';
  final TextEditingController passwordEditingController =
      new TextEditingController();

  final _formKey = GlobalKey<FormState>();

  final _bloc = RegisterBloc();

  final _registerCancelToken = CancelToken();

  @override
  void initState() {
    super.initState();
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
        Translations.of(context).translate('create_account'),
        style: textStyle.middleTSBasic.copyWith(color: globalColor.white),
      ),
      elevation: 0,
      centerTitle: true,
    );

    double widthC = globalSize.setWidthPercentage(100, context);
    double heightC = globalSize.setHeightPercentage(100, context);

    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: appBar,
        backgroundColor: globalColor.transparent,
        body: BlocListener<RegisterBloc, RegisterState>(
          bloc: _bloc,
          child: BlocBuilder<RegisterBloc, RegisterState>(
            bloc: _bloc,
            builder: (context, state) {
              return ModalProgressHUD(
                  inAsyncCall: state is RegisterLoading,
                  color: globalColor.primaryColor,
                  opacity: 0.2,
                  child: Container(
                      width: widthC,
                      height: heightC,
                      child: SingleChildScrollView(
                        child: Container(
                          child: Form(
                            key: _formKey,
                            child: Container(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  VerticalPadding(
                                    percentage: 8.5,
                                  ),
                                  Container(
                                    child:
                                        SvgPicture.asset(AppAssets.splashLogo),
                                  ),
                                  VerticalPadding(
                                    percentage: 7.5,
                                  ),
                                  Container(
                                    padding: const EdgeInsets.only(
                                        left: EdgeMargin.min,
                                        right: EdgeMargin.min),
                                    child: UserManagementTextFieldWidget(
                                      controller: fullNameEditingController,
                                      validator: (value) {
                                        return BaseValidator.validateValue(
                                          context,
                                          value!,
                                          [RequiredValidator()],
                                          _fullNameValidation,
                                        );
                                      },
                                      hintText: '',
                                      prefixIcon: Container(
                                        width: 15.w,
                                        height: 15.w,
                                        child: Center(
                                          child: SvgPicture.asset(
                                            AppAssets.userSvg,
                                            color: globalColor.white,
                                            width: 15.w,
                                            height: 15.w,
                                          ),
                                        ),
                                      ),
                                      label: Translations.of(context)
                                          .translate('full_name'),
                                      keyboardType: TextInputType.text,
                                      borderRadius: widthC * .02,
                                      onChanged: (value) {
                                        setState(() {
                                          _fullNameValidation = true;
                                          _fullName = value;
                                        });
                                      },
                                      borderColor: globalColor.white,
                                      textInputAction: TextInputAction.next,
                                      onFieldSubmitted: (_) {
                                        FocusScope.of(context).nextFocus();
                                      },
                                    ),
                                  ),
                                  VerticalPadding(
                                    percentage: 2.5,
                                  ),
                                  Container(
                                    padding: const EdgeInsets.only(
                                        left: EdgeMargin.min,
                                        right: EdgeMargin.min),
                                    child: UserManagementTextFieldWidget(
                                      controller: phoneEditingController,
                                      validator: (value) {
                                        return BaseValidator.validateValue(
                                          context,
                                          value!,
                                          [RequiredValidator()],
                                          _phoneValidation,
                                        );
                                      },
                                      hintText: '',
                                      prefixIcon: Container(
                                        width: 15.w,
                                        height: 15.w,
                                        child: Center(
                                          child: SvgPicture.asset(
                                            AppAssets.phoneSvg,
                                            color: globalColor.white,
                                            width: 15.w,
                                            height: 15.w,
                                          ),
                                        ),
                                      ),
                                      label: Translations.of(context)
                                          .translate('phone_number'),
                                      keyboardType: TextInputType.phone,
                                      borderRadius: widthC * .02,
                                      onChanged: (value) {
                                        setState(() {
                                          _phoneValidation = true;
                                          _phone = value;
                                        });
                                      },
                                      borderColor: globalColor.white,
                                      textInputAction: TextInputAction.next,
                                      onFieldSubmitted: (_) {
                                        FocusScope.of(context).nextFocus();
                                      },
                                    ),
                                  ),
                                  VerticalPadding(
                                    percentage: 2.5,
                                  ),
                                  Container(
                                    padding: const EdgeInsets.only(
                                        left: EdgeMargin.min,
                                        right: EdgeMargin.min),
                                    child: UserManagementTextFieldWidget(
                                      controller: passwordEditingController,
                                      isPasswordField: true,
                                      validator: (value) {
                                        return BaseValidator.validateValue(
                                          context,
                                          value!,
                                          [RequiredValidator()],
                                          _passwordValidation,
                                        );
                                      },
                                      hintText: '',
                                      inputFormat: [
                                        LengthLimitingTextInputFormatter(10),
                                      ],
                                      prefixIcon: Container(
                                        width: 15.w,
                                        height: 15.w,
                                        child: Center(
                                          child: SvgPicture.asset(
                                            AppAssets.lockSvg,
                                            color: globalColor.white,
                                            width: 15.w,
                                            height: 15.w,
                                          ),
                                        ),
                                      ),
                                      label: Translations.of(context)
                                          .translate('password'),
                                      keyboardType:
                                          TextInputType.visiblePassword,
                                      borderRadius: widthC * .02,
                                      onChanged: (value) {
                                        setState(() {
                                          _passwordValidation = true;
                                          _password = value;
                                        });
                                      },
                                      borderColor: globalColor.white,
                                      textInputAction: TextInputAction.next,
                                      onFieldSubmitted: (_) {
                                        FocusScope.of(context).nextFocus();
                                      },
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
                                        onPressed: () async {
                                          //  Get.Get.toNamed(VerifyPage.routeName);
                                          if (_fullName != null &&
                                              _fullName.length >= 10) {
                                            setState(() {
                                              _fullNameValidation = true;
                                              _phoneValidation = true;
                                              _passwordValidation = true;
                                            });
                                            if (_formKey.currentState
                                                    ?.validate() ??
                                                false) {
                                              // String device_token =await UserRepository.getFcmTokenForDevice();
                                              // print('device_token $device_token');
                                              firebaseMessaging
                                                  .getToken()
                                                  .then((token) async {
                                                assert(token != null);
                                                var _homeScreenText;
                                                _homeScreenText =
                                                    "FCM Messaging token sign up: $token";

                                                if (appConfig
                                                    .notNullOrEmpty(token)) {
                                                  _bloc.add(
                                                    RegisterEvent(
                                                      name: _fullName,
                                                      mobile: _phone,
                                                      password: _password,
                                                      device_token: token!,
                                                      cancelToken:
                                                          _registerCancelToken,
                                                    ),
                                                  );
                                                } else {
                                                  Fluttertoast.showToast(
                                                      msg: Translations.of(
                                                              context)
                                                          .translate(
                                                              'something_went_wrong_try_again'));
                                                }
                                              });
                                            }
                                          } else {
                                            ErrorViewer.showCustomError(
                                                context,
                                                Translations.of(context)
                                                    .translate(
                                                        'msg_error_less_length'));
                                          }
                                        },
                                        borderRadius: 8.w,
                                        child: Container(
                                          child: Center(
                                            child: Text(
                                              Translations.of(context)
                                                  .translate('create_account'),
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
                          ),
                        ),
                      )));
            },
          ),
          listener: (context, state) async {
            if (state is RegisterSuccess) {
              Get.Get.toNamed(VerifyPage.routeName,
                  arguments: VerifyPageArgs(
                      userName: state.data.mobile!,
                      otpCode: state.data.otpCode));
            }
            if (state is RegisterFailure) {
              final error = state.error;
              if (error is ConnectionError) {
                ErrorViewer.showConnectionError(context, state.callback);
              } else if (error is CustomError) {
                ErrorViewer.showCustomError(context, error.message);
              } else if (error is BadRequestError) {
                ErrorViewer.showCustomError(context, error.message);
              } else {
                ErrorViewer.showUnexpectedErrorSign(context);
              }
            }
          },
        ));
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

  @override
  void dispose() {
    super.dispose();
    _registerCancelToken.cancel();
    _bloc.close();
  }
}
