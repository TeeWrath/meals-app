import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:annapurna/core/routes/app_route_config.dart';
import 'package:annapurna/core/theme/app_theme.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ScreenUtilInit(
      designSize: const Size(844, 390),
      minTextAdapt: true,
      child: PlatformProvider(
          builder: (ctx) => PlatformTheme(
              materialLightTheme: AppTheme.light(),
              cupertinoLightTheme: AppTheme.cupLight(),
              builder: (ctx) => PlatformApp.router(
                    localizationsDelegates: const <LocalizationsDelegate<
                        dynamic>>[
                      DefaultMaterialLocalizations.delegate,
                      DefaultCupertinoLocalizations.delegate,
                      DefaultWidgetsLocalizations.delegate
                    ],
                    debugShowCheckedModeBanner: false,
                    routerConfig: MyAppRoutes.returnRouter(),
                  ))),
    );
  }
}
