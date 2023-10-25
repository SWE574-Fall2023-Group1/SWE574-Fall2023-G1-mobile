import "dart:async";

import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:memories_app/routes/login/bloc/login_bloc.dart";
import "package:memories_app/ui/logo_widget.dart";
import "package:memories_app/ui/primary_button.dart";
import "package:memories_app/ui/shows_dialog.dart";
import "package:memories_app/util/router.dart";
import "package:memories_app/util/utils.dart";

class LoginRoute extends StatefulWidget {
  const LoginRoute({super.key});

  @override
  State<LoginRoute> createState() => _LoginRouteState();
}

class _LoginRouteState extends State<LoginRoute> {
  final _usernameFormKey = GlobalKey<FormState>();
  final _passwordFormKey = GlobalKey<FormState>();

  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginBloc, LoginState>(
      buildWhen: (previousState, state) {
        return state is! LoginFailure;
      },
      builder: (context, state) {
        if (state is LoginInitial) {
          return const CircularProgressIndicator();
        } else if (state is LoginDisplayState) {
          return Material(
            child: SafeArea(
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Column(children: [
                  const SizedBox(
                    height: SpaceSizes.x24,
                  ),
                  const SizedBox(height: SpaceSizes.x16),
                  const LogoWidget(),
                  const SizedBox(height: SpaceSizes.x16),
                  _buildLoginFormsSection(context, state),
                  const SizedBox(height: SpaceSizes.x16),
                  _buildRegisterSection(context, state),
                  const SizedBox(height: SpaceSizes.x16),
                  _buildLoginButton(context, state),
                  const SizedBox(
                    height: SpaceSizes.x120,
                  )
                ]),
              ),
            ),
          );
        }
        return Container();
      },
      listener: (context, state) {
        if (state is LoginSuccess) {
          AppRoute.home.navigate(context);
        } else if (state is LoginFailure) {
          ShowsDialog.showAlertDialog(context, 'Oops!', state.error.toString(),
              isLoginFail: true);
        }
      },
    );
  }

  Widget _buildLoginFormsSection(
      BuildContext context, LoginDisplayState state) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: SpaceSizes.x16),
      child: Column(
        children: [
          Form(
            key: _usernameFormKey,
            child: TextFormField(
              key: WidgetKeys.usernameFieldKey,
              scrollPadding: EdgeInsets.only(
                bottom: AppScreenSizeUtils.getScrollPadding(context),
              ),
              controller: _usernameController,
              onTap: () {
                Timer(const Duration(milliseconds: 200), () {
                  _scrollController
                      .jumpTo(_scrollController.position.maxScrollExtent);
                });
              },
              style: const TextStyle(color: Colors.black),
              obscureText: false,
              decoration: InputDecoration(
                hintText: "Username",
                labelText: state.isUsernameFieldFocused ? "Username" : null,
                labelStyle: const TextStyle(color: Colors.black),
                hintStyle: TextStyle(
                  color: state.isUsernameFieldFocused
                      ? Colors.black
                      : AppColors.textFieldHintColor,
                ),
                // Use OutlineInputBorder to create a rectangular border
                border: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: AppColors.textFieldBorderColor,
                  ),
                  borderRadius: BorderRadius.circular(SpaceSizes.x12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Colors.black,
                  ),
                  borderRadius: BorderRadius.circular(SpaceSizes.x12),
                ),
                focusedErrorBorder: null,
                errorText: state.usernameValidationMessage != ""
                    ? state.usernameValidationMessage
                    : null,
              ),
              onChanged: (username) {
                BlocProvider.of<LoginBloc>(context)
                    .add(LoginUsernameChangedEvent(username));
              },
            ),
          ),
          const SizedBox(height: SpaceSizes.x16),
          Form(
            key: _passwordFormKey,
            child: TextFormField(
              key: WidgetKeys.passwordFieldKey,
              scrollPadding: EdgeInsets.only(
                bottom: AppScreenSizeUtils.getScrollPadding(context),
              ),
              controller: _passwordController,
              onTap: () {
                Timer(const Duration(milliseconds: 200), () {
                  _scrollController
                      .jumpTo(_scrollController.position.maxScrollExtent);
                });
              },
              style: const TextStyle(color: Colors.black),
              obscureText: true,
              decoration: InputDecoration(
                hintText: "Password",
                labelText: state.isPasswordFieldFocused ? "Password" : null,
                labelStyle: const TextStyle(color: Colors.black),
                hintStyle: TextStyle(
                  color: state.isPasswordFieldFocused
                      ? Colors.black
                      : AppColors.textFieldHintColor,
                ),
                // Use OutlineInputBorder to create a rectangular border
                border: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: AppColors.textFieldBorderColor,
                  ),
                  borderRadius: BorderRadius.circular(SpaceSizes.x12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Colors.black,
                  ),
                  borderRadius: BorderRadius.circular(SpaceSizes.x12),
                ),
                focusedErrorBorder: null,
                errorText: state.passwordValidationMessage != ""
                    ? state.passwordValidationMessage
                    : null,
              ),
              onChanged: (password) {
                BlocProvider.of<LoginBloc>(context)
                    .add(LoginPasswordChangedEvent(password));
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRegisterSection(BuildContext context, LoginDisplayState state) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: SpaceSizes.x24, vertical: SpaceSizes.x16),
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(SpaceSizes.x12),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'Don’t you have any account yet?',
            style: TextStyle(
              color: Colors.black,
              fontSize: FontSizes.regularSize,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(
            height: SpaceSizes.x4,
          ),
          GestureDetector(
            onTap: () {
              AppRoute.register.navigate(context);
            },
            child: const Text(
              'Register Now!',
              style: TextStyle(
                color: AppColors.buttonColor,
                fontSize: FontSizes.regularSize,
                fontWeight: FontWeight.w700,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginButton(BuildContext context, LoginDisplayState state) {
    var isValid = ((state.usernameValidationMessage == '' ||
            state.usernameValidationMessage == null) &&
        _usernameController.text.isNotEmpty &&
        state.passwordValidationMessage == '');

    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: SpaceSizes.x24, vertical: SpaceSizes.x16),
      child: PrimaryButton(
        key: WidgetKeys.loginButtonKey,
        width: MediaQuery.of(context).size.width,
        onPressed: isValid
            ? () {
                BlocProvider.of<LoginBloc>(context).add(
                    LoginPressLoginButtonEvent(
                        username: _usernameController.text,
                        password: _passwordController.text));
              }
            : null,
        borderRadius: BorderRadius.circular(SpaceSizes.x12),
        buttonColor:
            isValid ? AppColors.buttonColor : AppColors.textFieldBorderColor,
        child: Text(
          "Login",
          style: TextStyle(
            color: isValid ? Colors.white : AppColors.disabledButtonTextColor,
            fontSize: FontSizes.regularSize,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
