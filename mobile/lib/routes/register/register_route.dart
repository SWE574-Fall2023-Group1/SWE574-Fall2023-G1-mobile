import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memories_app/routes/register/bloc/register_bloc.dart';
import '../../ui/primary_button.dart';
import '../../ui/shows_dialog.dart';
import '../../util/router.dart';
import '../../util/utils.dart';

class RegisterRoute extends StatefulWidget {
  const RegisterRoute({super.key});

  @override
  State<RegisterRoute> createState() => _RegisterRouteState();
}

class _RegisterRouteState extends State<RegisterRoute> {
  final _usernameFormKey = GlobalKey<FormState>();
  final _emailFormKey = GlobalKey<FormState>();
  final _passwordFormKey = GlobalKey<FormState>();
  final _passwordAgainFormKey = GlobalKey<FormState>();

  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordAgainController = TextEditingController();

  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _passwordAgainController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RegisterBloc, RegisterState>(
      buildWhen: (previousState, state) {
        return !(state is RegisterFailure || state is RegisterOffline);
      },
      builder: (context, state) {
        if (state is RegisterInitial) {
          return const CircularProgressIndicator();
        } else if (state is RegisterDisplayState) {
          return Material(
            child: SafeArea(
              child: Column(children: [
                AppBar(title: const Text("Register"), centerTitle: true),
                const SizedBox(height: SpaceSizes.x32),
                _buildRegisterFormsSection(context, state),
                const Spacer(),
                _buildRegisterButton(context, state),
              ]),
            ),
          );
        }
        return Container();
      },
      listener: (context, state) {
        if (state is RegisterSuccess) {
          AppRoute.home.navigate(context);
        } else if (state is RegisterFailure) {
          ShowsDialog.showAlertDialog(context, 'Oops!', state.error.toString(),
              isRegisterFail: true);
        } else if (state is RegisterOffline) {
          ShowsDialog.showAlertDialog(
              context, 'Oops!', state.offlineMessage.toString(),
              isRegisterFail: true);
        }
      },
    );
  }

  Widget _buildRegisterFormsSection(
      BuildContext context, RegisterDisplayState state) {
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
                BlocProvider.of<RegisterBloc>(context)
                    .add(RegisterUsernameChangedEvent(username));
              },
            ),
          ),
          const SizedBox(height: SpaceSizes.x16),
          Form(
            key: _emailFormKey,
            child: TextFormField(
              key: WidgetKeys.emailFieldKey,
              scrollPadding: EdgeInsets.only(
                bottom: AppScreenSizeUtils.getScrollPadding(context),
              ),
              controller: _emailController,
              onTap: () {
                Timer(const Duration(milliseconds: 200), () {
                  _scrollController
                      .jumpTo(_scrollController.position.maxScrollExtent);
                });
              },
              style: const TextStyle(color: Colors.black),
              obscureText: false,
              decoration: InputDecoration(
                hintText: "Email",
                labelText: state.isEmailFieldFocused ? "Email" : null,
                labelStyle: const TextStyle(color: Colors.black),
                hintStyle: TextStyle(
                  color: state.isEmailFieldFocused
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
                BlocProvider.of<RegisterBloc>(context)
                    .add(RegisterEmailChangedEvent(username));
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
                BlocProvider.of<RegisterBloc>(context)
                    .add(RegisterPasswordChangedEvent(password));
              },
            ),
          ),
          const SizedBox(height: SpaceSizes.x16),
          Form(
            key: _passwordAgainFormKey,
            child: TextFormField(
              key: WidgetKeys.passwordAgainFieldKey,
              scrollPadding: EdgeInsets.only(
                bottom: AppScreenSizeUtils.getScrollPadding(context),
              ),
              controller: _passwordAgainController,
              onTap: () {
                Timer(const Duration(milliseconds: 200), () {
                  _scrollController
                      .jumpTo(_scrollController.position.maxScrollExtent);
                });
              },
              style: const TextStyle(color: Colors.black),
              obscureText: true,
              decoration: InputDecoration(
                hintText: "Password Again",
                labelText:
                    state.isPasswordAgainFieldFocused ? "Password Again" : null,
                labelStyle: const TextStyle(color: Colors.black),
                hintStyle: TextStyle(
                  color: state.isPasswordAgainFieldFocused
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
                errorText: state.passwordAgainValidationMessage != ""
                    ? state.passwordAgainValidationMessage
                    : null,
              ),
              onChanged: (password) {
                BlocProvider.of<RegisterBloc>(context)
                    .add(RegisterPasswordAgainChangedEvent(password));
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRegisterButton(
      BuildContext context, RegisterDisplayState state) {
    var isValid = ((state.usernameValidationMessage == '' ||
            state.usernameValidationMessage == null) &&
        _usernameController.text.isNotEmpty &&
        state.passwordValidationMessage == '' &&
        _passwordController.text == _passwordAgainController.text);

    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: SpaceSizes.x24, vertical: SpaceSizes.x16),
      child: PrimaryButton(
        key: WidgetKeys.registerButtonKey,
        width: MediaQuery.of(context).size.width,
        onPressed: isValid
            ? () {
                BlocProvider.of<RegisterBloc>(context).add(
                    RegisterPressRegisterButtonEvent(
                        username: _usernameController.text,
                        email: _emailController.text,
                        password: _passwordController.text));
              }
            : null,
        borderRadius: BorderRadius.circular(SpaceSizes.x12),
        buttonColor:
            isValid ? AppColors.buttonColor : AppColors.textFieldBorderColor,
        child: Text(
          "Register",
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
