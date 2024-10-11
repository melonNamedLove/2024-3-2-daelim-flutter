import 'package:daelim/helper/sotrage_helper.dart';
import 'package:daelim/routes/app_screen.dart';
import 'package:daelim/screens/login/login_sceen.dart';
import 'package:daelim/screens/main/main_screen.dart';
import 'package:daelim/screens/setting/setting_screen.dart';
import 'package:easy_extension/easy_extension.dart';
import 'package:go_router/go_router.dart';

final appRouter = GoRouter(
  initialLocation: AppScreen.login.toPath, //시작점 set

//redirect 시험
  redirect: (context, state) {
    Log.green(state.fullPath);

    if (state.fullPath != AppScreen.login.toPath) {
      return null;
    }
    if (StorageHelper.authData == null) {
      return AppScreen.login.toPath;
    }
    return null;
  },

  routes: [
    // NOTE: 로그인화며면
    GoRoute(
        path: AppScreen.login.toPath,
        name: AppScreen.login.name,
        builder: (context, state) => const LoginSrceen()),

    // NOTE: 메인화면

    GoRoute(
        path: AppScreen.main.toPath,
        name: AppScreen.main.name,
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: MainScreen())),

    // NOTE: 설정화면
    GoRoute(
        path: AppScreen.setting.toPath,
        name: AppScreen.setting.name,
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: SettingScreen()))
  ],
);
