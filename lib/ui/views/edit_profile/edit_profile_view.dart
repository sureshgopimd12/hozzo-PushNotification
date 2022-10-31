import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hozzo/theme/app-theme.dart';
import 'package:hozzo/ui/smart_widgets/app_drawer/app_drawer.dart';
import 'package:hozzo/ui/smart_widgets/app_text_field/app_text_field.dart';
import 'package:hozzo/ui/smart_widgets/primary_app_bar/primary_app_bar.dart';
import 'package:hozzo/ui/smart_widgets/primary_button.dart';
import 'package:hozzo/ui/smart_widgets/title_back_button/title_back_button.dart';
import 'package:hozzo/ui/views/edit_profile/edit_profile_viewmodel.dart';
import 'package:stacked/stacked.dart';

class EditProfileView extends HookWidget {
  Widget build(BuildContext context) {
    var nameController = useTextEditingController();
    var emailAddressController = useTextEditingController();
    var passwordController = useTextEditingController();
    return ViewModelBuilder<EditProfileViewModel>.reactive(
      onModelReady: (model) => model.init(),
      builder: (context, model, child) {
        return Scaffold(
          key: model.scaffoldKey,
          appBar: PrimaryAppBar(model.scaffoldKey),
          drawer: AppDrawer(),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTitle(false),
                SizedBox(
                  height: 20,
                ),
                Form(
                  key: model.profileFormKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 60),
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            _buildProfileImage(model),
                            _buildAddPhotoIcon(model),
                          ],
                        ),
                        SizedBox(height: 16),
                        AppTextField(
                          controller: model.nameController,
                          hintText: "Name",
                          backgroundColor: AppColors.grey,
                          validator: (value) => model.validateName(),
                        ),
                        SizedBox(height: 16),
                        AppTextField(
                          controller: model.emailController,
                          hintText: "E-mail",
                          backgroundColor: AppColors.grey,
                          validator: (value) => model.validateEmail(),
                        ),
                        SizedBox(height: 13),
                        AppTextField(
                          controller: model.passwordController,
                          hintText: "Confirm Password",
                          backgroundColor: AppColors.grey,
                          validator: (value) => model.validatePassword(),
                          obscureText: true,
                          hasShowFieldButton: true,
                          hasClearButton: false,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 50),
                  child: PrimaryButton(
                    text: "Save",
                    onTap: (startLoading, stopLoading, btnState) =>
                        model.updateProfile(startLoading, stopLoading),
                  ),
                )
              ],
            ),
          ),
        );
      },
      viewModelBuilder: () => EditProfileViewModel(
          nameController: nameController,
          emailController: emailAddressController,
          passwordController: passwordController),
    );
  }
}

Container _buildTitle(bool isFromDrawer) {
  return Container(
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Stack(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 8, left: 30),
            child: Text(
              "Edit Profile",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 17,
                height: 1.3,
              ),
            ),
          ),
          TitleBackButton(isFromDrawer: isFromDrawer),
        ],
      ),
    ),
  );
}

LayoutBuilder _buildProfileImage(EditProfileViewModel model) {
  return LayoutBuilder(
    builder: (context, BoxConstraints constraints) {
      return Container(
        width: constraints.maxWidth,
        height: constraints.maxWidth,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(180.0),
            side: BorderSide(color: AppColors.primary, width: 4),
          ),
          margin: const EdgeInsets.all(0),
          color: AppColors.grey,
          semanticContainer: true,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          child: InkWell(
            onTap: () {},
            child: model.selectedImage == null
                ? Image.network(
                    model.user.image.url,
                    fit: BoxFit.cover,
                  )
                : Image.file(
                    model.selectedImage,
                    fit: BoxFit.cover,
                  ),
          ),
        ),
      );
    },
  );
}

Container _buildAddPhotoIcon(model) {
  return Container(
    alignment: Alignment.topLeft,
    child: RawMaterialButton(
      padding: EdgeInsets.all(10),
      onPressed: () => model.pickImage(),
      elevation: 2.0,
      fillColor: Colors.white,
      child: Icon(
        Icons.add_a_photo,
        size: 20,
        color: AppColors.primary,
      ),
      shape: CircleBorder(side: BorderSide(color: AppColors.primary, width: 2)),
    ),
  );
}
