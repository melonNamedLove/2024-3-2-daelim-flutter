import 'package:daelim/helper/sotrage_helper.dart';
import 'package:daelim/routes/app_router.dart';
import 'package:daelim/screens/login/login_sceen.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await StorageHelper.init();
  await Supabase.initialize(
      url: 'https://daelim-server.fleecy.dev',
      anonKey:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.ewogICJyb2xlIjogImFub24iLAogICJpc3MiOiAic3VwYWJhc2UiLAogICJpYXQiOiAxNzE3MzQwNDAwLAogICJleHAiOiAxODc1MTA2ODAwCn0.aMXxldFuuDXaZhl1Ap5bTQS_601EwbOOVE8YdPmAuc8');
  runApp(const MyApp());
}

//theme -- eggplant purple
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // return MaterialApp(
    return MaterialApp.router(
      theme: FlexThemeData.light(
        scheme: FlexScheme.purpleM3,
        surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
        blendLevel: 7,
        subThemesData: const FlexSubThemesData(
          blendOnLevel: 10,
          blendOnColors: false,
          useTextTheme: true,
          useM2StyleDividerInM3: true,
          alignedDropdown: true,
          useInputDecoratorThemeInDialogs: true,
        ),
        visualDensity: FlexColorScheme.comfortablePlatformDensity,
        useMaterial3: true,
        swapLegacyOnMaterial3: true,
      ),
      darkTheme: FlexThemeData.dark(
        scheme: FlexScheme.purpleM3,
        surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
        blendLevel: 13,
        subThemesData: const FlexSubThemesData(
          blendOnLevel: 20,
          useTextTheme: true,
          useM2StyleDividerInM3: true,
          alignedDropdown: true,
          useInputDecoratorThemeInDialogs: true,
        ),
        visualDensity: FlexColorScheme.comfortablePlatformDensity,
        useMaterial3: true,
        swapLegacyOnMaterial3: true,
      ),
      themeMode: ThemeMode.system,

      // debugShowCheckedModeBanner: false, //debug 라벨 제거
      // debugShowMaterialGrid: true,//격자보임
//flutter web에서만 작동하지 않는 기능
      // showPerformanceOverlay: true,

      // home: const LoginSrceen(),
      routerConfig: appRouter,
    );
  }
}
