import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hozzo/theme/app-theme.dart';
import 'package:hozzo/ui/smart_widgets/banner_logo.dart';
import 'package:flutter/material.dart';
import 'package:hozzo/ui/smart_widgets/primary_button.dart';
import 'package:hozzo/ui/smart_widgets/app_text_field/app_text_field.dart';
import 'package:hozzo/ui/views/signup/signup_viewmodel.dart';
import 'package:stacked/stacked.dart';

class SignupView extends HookWidget {
  final String phone;
  const SignupView(this.phone);

  @override
  Widget build(BuildContext context) {
    var nameController = useTextEditingController();
    var emailAddressController = useTextEditingController();
    var phoneController = useTextEditingController();
    var passwordController = useTextEditingController();
    var reEnterPasswordController = useTextEditingController();

    return ViewModelBuilder<SignupViewModel>.reactive(
      onModelReady: (model) => model.init(phone),
      builder: (context, model, child) => Scaffold(
        body: SafeArea(
          bottom: false,
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 30),
                BannerLogo(
                  title: "Signup",
                  heightInPercentage: 0,
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: TextStyle(
                        fontFamily: AppTheme.fontFamily,
                        color: AppColors.textColor,
                        fontWeight: FontWeight.w600,
                        height: 2,
                        fontSize: 11.0,
                      ),
                      children: [
                        TextSpan(
                          text: "Create an account and save time and money while booking ",
                        ),
                        TextSpan(
                          text: "HOZZO",
                          style: TextStyle(
                            color: AppColors.accent,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: " car wash to your door step",
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 40),
                buildForm(model),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: PrimaryButton(
                    text: "Sign up",
                    onTap: (startLoading, stopLoading, btnState) => model.signup(startLoading, stopLoading),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "By signing up you accept our",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: AppTheme.fontFamily,
                    color: AppColors.textColor,
                    fontWeight: FontWeight.w600,
                    height: 2,
                    fontSize: 9.0,
                  ),
                ),
                FlatButton(
                  onPressed: () {},
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  padding: EdgeInsets.all(0),
                  child: Text(
                    "Terms of service & policy",
                    style: TextStyle(
                      fontSize: 9.0,
                      color: AppColors.accent,
                      fontWeight: FontWeight.bold,
                      decorationColor: AppColors.accent,
                      decorationThickness: 5,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
                SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
      viewModelBuilder: () => SignupViewModel(
        nameController: nameController,
        emailAddressController: emailAddressController,
        phoneController: phoneController,
        passwordController: passwordController,
        reEnterPasswordController: reEnterPasswordController,
      ),
    );
  }

  Widget buildForm(SignupViewModel model) {
    return Form(
      key: model.signupFormKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 60),
        child: Column(
          children: [
            AppTextField(
              controller: model.nameController,
              hintText: "Name",
              backgroundColor: AppColors.grey,
              validator: (value) => model.validateName(),
            ),
            SizedBox(height: 16),
            AppTextField(
              controller: model.emailAddressController,
              keyboardType: TextInputType.emailAddress,
              hintText: "Email address",
              backgroundColor: AppColors.grey,
              validator: (value) => model.validateEmail(),
            ),
            SizedBox(height: 16),
            AppTextField(
              controller: model.phoneController,
              keyboardType: TextInputType.phone,
              hintText: "Phone",
              isReadOnly: true,
              backgroundColor: AppColors.grey,
            ),
            SizedBox(height: 16),
            AppTextField(
              controller: model.passwordController,
              obscureText: true,
              hintText: "Password",
              hasShowFieldButton: true,
              hasClearButton: false,
              backgroundColor: AppColors.grey,
              validator: (value) => model.validatePassword(),
            ),
            SizedBox(height: 16),
            AppTextField(
              controller: model.reEnterPasswordController,
              obscureText: true,
              hintText: "Re-enter password",
              hasShowFieldButton: true,
              hasClearButton: false,
              backgroundColor: AppColors.grey,
              validator: (value) => model.validateReEnterPassword(),
            ),
          ],
        ),
      ),
    );
  }
}
