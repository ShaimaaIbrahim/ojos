import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ojos_app/core/bloc/application_bloc.dart';
import 'package:ojos_app/core/bloc/application_events.dart';
import 'package:ojos_app/core/bloc/application_state.dart';
import 'package:ojos_app/core/localization/specific_localization_delegate.dart';
import 'package:ojos_app/core/localization/translations_delegate.dart';
import 'package:ojos_app/core/logger/logger_utils.dart';
import 'package:ojos_app/core/providers/app_provider.dart';
import 'package:ojos_app/core/res/global_color.dart';
import 'package:ojos_app/core/routes/app_pages.dart';
import 'package:provider/provider.dart';

import 'core/bloc/root_page_bloc.dart';
import 'core/constants.dart';
import 'core/providers/cart_provider.dart';
import 'core/res/utils.dart';

class MyApp extends StatelessWidget {
  final String lang;

  const MyApp({required this.lang});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.black12,
      ),
      child: ScreenUtilInit(
        designSize: Size(360, 750),
        builder: () {
          return MultiProvider(
            child: Builder(builder: (context) {
              return BlocBuilder<ApplicationBloc, ApplicationState>(
                bloc: BlocProvider.of<ApplicationBloc>(context),
                builder: (context, state) {
                  final _lang = state.language ?? lang;
                  final localeOverrideDelegate =
                      SpecificLocalizationDelegate(Locale(_lang));

                  //for insert lang if  you don't use bloc
                  utils.setLang(_lang);
                  return GetMaterialApp(
                    debugShowCheckedModeBanner: false,
                    title: 'OJOS',
                    enableLog: true,
                    logWriterCallback: Logger.write,
                    initialRoute: AppPages.INITIAL,
                    getPages: AppPages.routes,
                    theme: ThemeData(
                      accentColor: globalColor.accentColor,
                      primaryColor: globalColor.primaryColor,
                      errorColor: globalColor.errorColor,
                      scaffoldBackgroundColor:
                          globalColor.scaffoldBackGroundGreyColor,
                      cursorColor: globalColor.primaryColor,
                      appBarTheme: AppBarTheme(
                        color: globalColor.appBar,
                        iconTheme: IconThemeData(color: globalColor.white),
                      ),
                    ),
                    locale: localeOverrideDelegate.overriddenLocale,
                    localizationsDelegates: [
                      localeOverrideDelegate,
                      const TranslationsDelegate(),
                      GlobalMaterialLocalizations.delegate,
                      GlobalWidgetsLocalizations.delegate,
                    ],
                    fallbackLocale: Locale(LANG_AR),
                    supportedLocales: [Locale(LANG_EN), Locale(LANG_AR)],
                  );
                },
              );
            }),
            providers: [
              BlocProvider<ApplicationBloc>.value(
                value: ApplicationBloc()..add(ApplicationStartedEvent(context)),
              ),
              BlocProvider<RootPageBloc>(
                create: (context) => RootPageBloc(),
              ),
              ChangeNotifierProvider(create: (_) => AppProvider()),
              ChangeNotifierProvider(create: (_) => CartProvider()),
            ],
          );
        },
      ),
    );
  }
}
