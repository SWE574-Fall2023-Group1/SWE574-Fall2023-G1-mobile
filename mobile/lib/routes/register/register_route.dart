import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memories_app/routes/register/bloc/register_bloc.dart';
import 'package:memories_app/ui/primary_button.dart';
import 'package:memories_app/ui/shows_dialog.dart';
import 'package:memories_app/util/utils.dart';

class RegisterRoute extends StatefulWidget {
  const RegisterRoute({super.key});

  @override
  State<RegisterRoute> createState() => _RegisterRouteState();
}

class _RegisterRouteState extends State<RegisterRoute> {
  final GlobalKey<FormState> _usernameFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _emailFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _passwordFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _passwordAgainFormKey = GlobalKey<FormState>();

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordAgainController =
      TextEditingController();

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
      buildWhen: (RegisterState previousState, RegisterState state) {
        return !(state is RegisterSuccess ||
            state is RegisterFailure ||
            state is RegisterOffline ||
            state is RegisterNavigateToLoginState);
      },
      builder: (BuildContext context, RegisterState state) {
        if (state is RegisterInitial) {
          return const CircularProgressIndicator();
        } else if (state is RegisterDisplayState) {
          return Material(
            child: SafeArea(
              child: Column(children: <Widget>[
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
      listener: (BuildContext context, RegisterState state) {
        if (state is RegisterSuccess) {
          ShowsDialog.showAlertDialog(
              context, "Success!", state.successMessage.toString(),
              isRegisterSuccess: true);
        } else if (state is RegisterFailure) {
          ShowsDialog.showAlertDialog(context, 'Oops!', state.error.toString(),
              isRegisterFail: true);
        } else if (state is RegisterOffline) {
          ShowsDialog.showAlertDialog(
              context, 'Oops!', state.offlineMessage.toString(),
              isRegisterFail: true);
        } else if (state is RegisterNavigateToLoginState) {
          Navigator.of(context).pop();
        }
      },
    );
  }

  Widget _buildRegisterFormsSection(
      BuildContext context, RegisterDisplayState state) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: SpaceSizes.x16),
      child: Column(
        children: <Widget>[
          Form(
            key: _usernameFormKey,
            child: TextFormField(
              key: WidgetKeys.usernameFieldKey,
              scrollPadding: EdgeInsets.only(
                bottom: AppScreenSizeUtils.getScrollPadding(context),
              ),
              controller: _usernameController,
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
                errorText: state.usernameValidationMessage,
              ),
              onChanged: (String username) {
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
                errorText: state.emailValidationMessage,
              ),
              onChanged: (String email) {
                BlocProvider.of<RegisterBloc>(context)
                    .add(RegisterEmailChangedEvent(email));
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
                errorText: state.passwordValidationMessage,
              ),
              onChanged: (String password) {
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
                errorText: state.passwordAgainValidationMessage,
              ),
              onChanged: (String passwordAgain) {
                BlocProvider.of<RegisterBloc>(context).add(
                    RegisterPasswordAgainChangedEvent(
                        _passwordController.text, passwordAgain));
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRegisterButton(
      BuildContext context, RegisterDisplayState state) {
    bool isValid = (state.usernameValidationMessage == null &&
        _usernameController.text.isNotEmpty &&
        _emailController.text.isNotEmpty &&
        state.passwordValidationMessage == null &&
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
                        password: _passwordController.text,
                        passwordAgain: _passwordAgainController.text));
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
