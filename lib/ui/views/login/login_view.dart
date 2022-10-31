import 'package:argon_buttons_flutter/argon_buttons_flutter.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hozzo/theme/app-theme.dart';
import 'package:hozzo/ui/smart_widgets/banner_logo.dart';
import 'package:hozzo/ui/smart_widgets/primary_button.dart';
import 'package:hozzo/ui/smart_widgets/app_text_field/app_text_field.dart';
import 'package:hozzo/ui/views/login/login_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:stacked/stacked.dart';

class LoginView extends HookWidget {
  @override
  Widget build(BuildContext context) {
    var phoneController = useTextEditingController();
    var passwordController = useTextEditingController();
    var size = MediaQuery.of(context).size;

    return ViewModelBuilder<LoginViewModel>.reactive(
      builder: (context, model, child) => Scaffold(
        body:  Column(
          children: [
            BannerLogo(),
            Expanded(child: _buildGetSatrted(model, size)),
          ],
        ),



        // ListView(
        //   children: <Widget>[
        //
        //     BannerLogo(),
        //     _buildGetSatrted(model, size)
        //
        //
        //   ],
        // )

//..............................
      // replaced Colum for scrolling loginpage on  16/jun/2022
      //   Column(
      //     children: [
      //     BannerLogo(),
      //       Expanded(child: _buildGetSatrted(model, size)),
      //     ],
      //   ),
 //..............................




      ),
      viewModelBuilder: () => LoginViewModel(
        phoneController,
        passwordController,
      ),
    );
  }

  Widget _buildGetSatrted(LoginViewModel model, Size size) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Container(
        child: Align(
          alignment: Alignment.topCenter,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(top: 50),
              child: Column(
                children: [
                  Text(
                    "Get started",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 25.0,
                    ),
                  ),
                  SizedBox(height: 40),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Text(
                      "Enter your phone number and complete the registration or login if you already registered",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        height: 2,
                        fontSize: 11.0,
                      ),
                    ),
                  ),
                  Form(
                    key: model.loginFormKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Column(
                        children: [
                          SizedBox(height: 30),
                          AppTextField(
                            controller: model.phoneController,
                            validator: (value) => model.validatePhone(),
                            onChanged: (value) => model.hidePasswordField(),
                            onClear: model.hidePasswordField,
                            keyboardType: TextInputType.phone,
                            hintText: "Phone number",
                            prefixText: model.phonePrefixText,
                          ),
                          SizedBox(height: 30),
                          Visibility(
                            visible: model.showPassword,
                            child: AppTextField(
                              controller: model.passwordController,
                              validator: (value) =>
                                  model.validatePassword(value),
                              obscureText: true,
                              hasClearButton: false,
                              hintText: "Enter password",
                              hasShowFieldButton: true,
                            ),
                          ),
                          Visibility(
                            visible: model.showPassword,
                            child: buildForgotButton(model, size),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: !model.showPassword ? 20 : null),
                  PrimaryButton(
                    text: "Next",
                    onTap: (startLoading, stopLoading, btnState) =>
                        model.login(startLoading, stopLoading),
                  ),
                ],
              ),
            ),
          ),
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.primary,
              AppColors.accent,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(36),
            topRight: Radius.circular(36),
          ),
        ),
      ),
    );
  }

  Widget buildForgotButton(LoginViewModel model, Size size) {
    return ArgonButton(
      height: 50,
      roundLoadingShape: true,
      width: size.width,
      highlightColor: Colors.transparent,
      highlightElevation: 0,
      splashColor: Colors.transparent,
      onTap: (startLoading, stopLoading, btnState) =>
          model.goToForgotPasswordView(startLoading, stopLoading, btnState),
      child: Text(
        "Forgot Password?",
        style: TextStyle(color: Colors.white, fontSize: 12),
      ),
      loader: Container(
        padding: EdgeInsets.all(10),
        child: SpinKitRing(
          color: Colors.white,
          lineWidth: 2,
          size: 20.0,
        ),
      ),
      borderRadius: 5.0,
      color: Colors.transparent,
      elevation: 0,
    );
  }
}
