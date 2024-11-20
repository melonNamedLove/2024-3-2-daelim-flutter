import 'dart:math';

import 'package:daelim/common/extensions/context_extension.dart';
import 'package:daelim/helper/api_helper.dart';
import 'package:daelim/helper/sotrage_helper.dart';
import 'package:daelim/routes/app_screen.dart';
import 'package:daelim/screens/login/login_sceen.dart';
import 'package:easy_extension/easy_extension.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ChangePasswordDialog extends StatefulWidget {
  const ChangePasswordDialog({super.key});

  @override
  State<ChangePasswordDialog> createState() => _ChangePasswordDialogState();
}

class _ChangePasswordDialogState extends State<ChangePasswordDialog> {
  final _currentPwController = TextEditingController();
  final _newPwController = TextEditingController();
  final _newConfirmPwController = TextEditingController();

  final _currentPwFormKey = GlobalKey<FormState>();
  final _newPwFormKey = GlobalKey<FormState>();
  final _newConfirmPwFormKey = GlobalKey<FormState>();

  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureNewConfirm = true;

  final _bgColor = const Color(0xfff3f4f6);
  String _currentPasswordValidateMsg = '';

  @override
  void dispose() {
    _currentPwController.dispose();
    _newPwController.dispose();
    _newConfirmPwController.dispose();
    super.dispose();
  }

//NOTE 패스워드 입력 위젯
  Widget _buildTextField(
      {required Key formKey,
      TextEditingController? textController,
      required String hintText,
      bool obsecureText = true,
      String? Function(String? value)? validator,
      //! validator : p0
      VoidCallback? onObscurePressed}) {
    return ListTile(
        // dense: true,
        title: Form(
      key: formKey,
      child: TextFormField(
        obscureText: obsecureText,
        validator: validator,
        controller: textController,
        decoration: InputDecoration(
          suffixIcon: InkWell(
              onTap: onObscurePressed,
              child:
                  Icon(obsecureText ? Icons.visibility : Icons.visibility_off)),
          hintText: hintText,
          filled: false,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          focusedErrorBorder: InputBorder.none,
        ),
      ),
    ));
  }

  ///NOTE 입력란 검증
  /// - empty value check
  String? _validator(String? value) {
    if (value == null || value.isEmpty || value.trim().isEmpty) {
      return '이 입력란을 작성하세요';
    }
    return null;
  }

  ///NOTE 비밀번호 변경
  void _onChangedPasswword() async {
    setState(() {
      _currentPasswordValidateMsg = '';
    });
    final currentValidate = _currentPwFormKey.currentState?.validate() ?? false;
    final newValidate = _newPwFormKey.currentState?.validate() ?? false;
    final newConfirmValidate =
        _newConfirmPwFormKey.currentState?.validate() ?? false;

    if (!currentValidate || !newValidate || !newConfirmValidate) {
      return;
    }

    final currentPassword = _currentPwController.text;
    final newPassword = _newPwController.text;

    /// Todo: 현재 비밀번호 검사 -> 검사 실패 시 에러 표시
    final authData = await ApiHelper.signIn(
      email: StorageHelper.authData!.email,
      password: currentPassword,
    );

    if (authData == null) {
      return setState(() {
        _currentPasswordValidateMsg = '현재 비밀번호가 일치하지 않습니다.';
      });
    }
    Log.green('비밀번호 검사 결과 ${authData != null}');

    /// Todo: 새로운 비밀번호로 변경 -> 성공 후 로그아웃 및 로그인 화면으로 이동
    // NOTE: 비밀번호 변경 에러
    final (success, error) = await ApiHelper.changePassword(newPassword);
    if (!success) {
      Log.red('비밀번호 변경 에러: $error');
      if (mounted) {
        return context.showSnackBar(
          kDebugMode ? error : '비밀번호를 변경할 수 없습니다.',
        );
      }
      return;
    }

    // NOTE: 비밀번호 변경 성공
    if (!mounted) return;
    ApiHelper.signOut(context);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
        backgroundColor: _bgColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "비밀번호 변경",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              30.heightBox,
              Card(
                elevation: 0,
                shape: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: context.thene.dividerColor,
                    )),
                child: Column(
                  children: ListTile.divideTiles(context: context, tiles: [
                    // NOTE: 현재 비밀번호 입력란
                    _buildTextField(
                        formKey: _currentPwFormKey,
                        textController: _currentPwController,
                        hintText: '현재 비밀번호',
                        obsecureText: _obscureCurrent,
                        validator: (value) {
                          return _validator(value);
                        },
                        onObscurePressed: () {
                          setState(() {
                            _obscureCurrent = !_obscureCurrent;
                          });
                        }),
                    Container(
                      alignment: Alignment.center,
                      height: 20,
                      color: _bgColor,
                      child: Text(
                        _currentPasswordValidateMsg,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                    // NOTE: 새 비밀번호 입력란
                    _buildTextField(
                      formKey: _newPwFormKey,
                      textController: _newPwController,
                      hintText: '새로운 비밀번호',
                      validator: (value) {
                        final isEmptyValidate = _validator(value);
                        if (isEmptyValidate != null) {
                          return isEmptyValidate;
                        }
                        if (value!.length < 6) {
                          return '6글자 이상 설정해야 합니다.';
                        }
                        return null;
                      },
                      obsecureText: _obscureNew,
                      onObscurePressed: () {
                        setState(() {
                          _obscureNew = !_obscureNew;
                        });
                      },
                    ),
                    // NOTE: 새 비밀번호 확인 입력란
                    _buildTextField(
                        formKey: _newConfirmPwFormKey,
                        textController: _newConfirmPwController,
                        hintText: '새로운 비밀번호 확인',
                        validator: (value) {
                          final isEmptyValidate = _validator(value);

                          if (isEmptyValidate != null) {
                            return isEmptyValidate;
                          }
                          final newPassword = _newPwController.text;
                          if (value != newPassword) {
                            return '비밀번호가 일치하지 않습니다';
                          }

                          return null;
                        },
                        obsecureText: _obscureNewConfirm,
                        onObscurePressed: () {
                          setState(() {
                            _obscureNewConfirm = !_obscureNewConfirm;
                          });
                        }),
                  ]).toList(),
                ),
              ),
              20.heightBox,

              /// NOTE 비밀번호 변경 버튼
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff1e13dc),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8))),
                  onPressed: _onChangedPasswword,
                  child: const Text(
                    "변경하기",
                    style: TextStyle(color: Colors.white),
                  )),
            ],
          ),
        ));
  }
}
