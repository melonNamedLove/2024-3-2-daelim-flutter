import 'dart:convert';

import 'package:daelim/common/enums/sso_enum.dart';
import 'package:daelim/common/extensions/context_extension.dart';
import 'package:daelim/common/widgets/gradient_divider.dart';
import 'package:daelim/config.dart';
import 'package:daelim/helper/sotrage_helper.dart';
import 'package:daelim/models/auth_data.dart';
import 'package:daelim/routes/app_screen.dart';
import 'package:easy_extension/easy_extension.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
// ignore: unused_import
import 'package:http/http.dart' as http;

class LoginSrceen extends StatefulWidget {
  const LoginSrceen({super.key});

  @override
  State<LoginSrceen> createState() => _LoginSrceenState();
}

class _LoginSrceenState extends State<LoginSrceen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();
  bool _isObsecure = true;

  @override
  void dispose() {
    _emailController.dispose();
    _pwController.dispose();
    super.dispose();
  }

  final body = {'email': '202230331@daelim.ac.kr', 'password': '202230331'};

  // Note : 로그인 API 호출
  void _onFetchedApi() async {
    final response = await http.post(Uri.parse(getTokenUrl),
        headers: {}, body: jsonEncode(body));

    // Log.green(response.body);
    Log.green({'status': response.statusCode, 'body': response.body});
  }

  //패스워도 재설정
  void _onRecoveryPassword() {}

  //로그인 버튼
  void _onSignIn() async {
    final email = _emailController.text;
    final password = _pwController.text;
    Log.cyan(_emailController.value.text);
    Log.cyan(_pwController.value.text);

    final loginData = {
      "email": email,
      "password": password,
    };

    final response =
        await http.post(Uri.parse(getTokenUrl), body: jsonEncode(loginData));

    final statusCode = response.statusCode;
    final body = utf8.decode(response.bodyBytes);

    if (statusCode != 200) {
      if (mounted) {
        context.showSnackBar(body);
      }
    } else {
      // Auth Data로 변환
      final authData = AuthData.fromJson(body);
      await StorageHelper.setAuthData(authData);

      final savedAuthData = StorageHelper.authData;

      //TODO: 화면 이동

      Log.green(savedAuthData);

      if (mounted) context.goNamed(AppScreen.main.name);
    }
    // if (statusCode == 200) {
    //   Log.green("Success");
    //   Log.green(authData);
    // } else {
    //   Log.red("Failed");
    //   Log.red(response.body);
    // }
  }

  //NOTE:SSO 로그인 버튼
  void _onSsoSignIn(SsoEnum type) {
    // return context.showSnackBar("준비 중인 기능입니다.");
    switch (type) {
      case SsoEnum.google:
      case SsoEnum.apple:
      case SsoEnum.github:
        context.showSnackBar("준비 중인 기능입니다.");
        break;
    }
  }

  //타이틀 텍스트 위젯
  List<Widget> _buildTitleText() => [
        const Text("Hello Again",
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
        15.heightBox,
        const Text(
          "Wellcom back you've\nbeen missed!",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
          ),
        ),
      ];

  //람다 예시
  bool noLambda() {
    return false;
  }

  bool Lambda() => false;

  bool get getLambda => false;

  //텍스트 입력 위젯들
  List<Widget> _buildTextFields() => [
        _buildTextField(
          controller: _emailController,
          hintText: "EnterEmail",
        ),
        10.heightBox,
        _buildTextField(
            onObsecure: (down) {
              setState(() {
                _isObsecure = !_isObsecure;
              });
            },
            controller: _pwController,
            hintText: "Password",
            obsecure: _isObsecure)
      ];

//텍스트 입력 위젯
  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    bool? obsecure,
    Function(bool down)? onObsecure,
  }) {
    return TextField(
        controller: controller,
        obscureText: obsecure ?? false,
        decoration: InputDecoration(
            hintText: hintText,
            fillColor: Colors.white,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none),
            suffixIcon: obsecure != null
                ? GestureDetector(
                    onTapDown: (details) => onObsecure?.call(true),
                    onTapUp: (detauls) => onObsecure?.call(false),
                    child: Icon(obsecure
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined),
                  )
                : null));
  }

// NOTE:SSO 버튼 위젯
  Widget _buildSsoButton({
    required String iconUrl,
    //  Function()? onTap,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
          width: 80,
          height: 60,
          decoration: BoxDecoration(
              border: Border.all(color: Colors.white),
              borderRadius: BorderRadius.circular(6)),
          padding: const EdgeInsets.all(10),
          child: Image.network(iconUrl)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFFDEDEE2),
        body: SafeArea(
          child: SizedBox(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
              child: DefaultTextStyle(
                style: GoogleFonts.poppins(
                    color: context.textTheme.bodyMedium?.color),
                // color: Theme.of(context).textTheme.bodyMedium?.color),
                //   color: Theme.of(context).brightness == Brightness.light
                //       ? Colors.black
                //       : Colors.white,
                // ),
                child: Center(
                  child: SizedBox(
                    width: 300,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        36.heightBox,
                        ..._buildTitleText(),
                        25.heightBox,
                        ..._buildTextFields(),
                        16.heightBox,
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                              onPressed: _onRecoveryPassword,
                              child: const Text("Recovery Password",
                                  style: TextStyle(fontSize: 12))),
                        ),
                        16.heightBox,

                        //로그인 버튼
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                              onPressed: _onSignIn,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFE46A61),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 20),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6)),
                              ),
                              child: const Text(
                                "Sign In",
                                style: TextStyle(color: Colors.white),
                              )),
                        ),

                        32.heightBox,

                        //Or Continue with
                        Row(
                          children: [
                            const Expanded(
                              child: GradientDivider(
                                  // color: Colors.red,
                                  ),
                            ),
                            15.widthBox,
                            const Text("Or Continue with"),
                            15.widthBox,
                            const Expanded(
                              child: GradientDivider(
                                reverse: true,
                              ),
                            ),
                          ],
                        ),

                        //SSO Buttons

                        32.heightBox,
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              //gestureDetector
                              _buildSsoButton(
                                  onTap: () => _onSsoSignIn(SsoEnum.google),
                                  iconUrl: icGoogle),
                              _buildSsoButton(
                                  onTap: () => _onSsoSignIn(SsoEnum.apple),
                                  iconUrl: icApple),
                              _buildSsoButton(
                                  onTap: () => _onSsoSignIn(SsoEnum.github),
                                  iconUrl: icGithub),
                            ])
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          //     child: Center(
          //   child: ElevatedButton(
          //       onPressed: _onFetchedApi,
          //       // onPressed: () {
          //       //   _onPressed();
          //       //   _onPressed.call();  //nullable일 수 있을 떄 call    변수를 반환할 경우 자주 사용
          //       // },
          //       child: const Text('api호출')),
          // )
        ));
  }
}
//b눌러서 테마 변경

//daelim-api.fleecy.dev/api-9847973