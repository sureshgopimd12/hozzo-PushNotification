import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hozzo/app/asset_data.dart';
import 'package:hozzo/theme/app-theme.dart';
import 'package:hozzo/ui/smart_widgets/app_text_field/app_text_field_viewmodel.dart';
import 'package:stacked/stacked.dart';

class AppTextField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final TextInputType keyboardType;
  final String hintText;
  final String prefixText;
  final Color backgroundColor;
  final bool obscureText;
  final bool hasClearButton;
  final bool hasShowFieldButton;
  final String initialValue;
  final bool isReadOnly;
  final TextStyle style;
  final TextStyle hintStyle;
  final Widget trailing;
  final int maxLines;
  final String Function(String value) validator;
  final void Function(String value) onChanged;
  final void Function(bool isFocus) onFocus;
  final VoidCallback onClear;

  AppTextField({
    this.controller,
    this.focusNode,
    this.keyboardType,
    this.hintText,
    this.prefixText,
    this.backgroundColor = AppColors.backgroundColor,
    this.obscureText = false,
    this.hasClearButton = true,
    this.hasShowFieldButton = false,
    this.initialValue,
    this.isReadOnly = false,
    this.style = const TextStyle(fontWeight: FontWeight.w600),
    this.hintStyle = const TextStyle(
      color: AppColors.textColor,
      fontWeight: FontWeight.w600,
    ),
    this.trailing: const SizedBox(),
    this.maxLines,
    this.validator,
    this.onChanged,
    this.onFocus,
    this.onClear,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AppTextFieldViewModel>.reactive(
      builder: (context, model, child) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Visibility(
            visible: model.hasErrorMessage,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 5.0),
              child:
              Text(
                model.errorMessage ?? '',
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: AppColors.error,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ),
          ),
          Column(children: [
            Row( mainAxisAlignment: MainAxisAlignment.end,
              children: [


              ],),
            Container(
            alignment: Alignment.center,
            padding: EdgeInsets.only(left: 20),
            decoration: BoxDecoration(
              color: isReadOnly ? backgroundColor.withOpacity(0.3) : backgroundColor,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(24),
                bottomRight: Radius.circular(24),
                bottomLeft: Radius.circular(24),
              ),
            ),
            child: Row(
              children: <Widget>[
                Text(
                  prefixText ?? '',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                Expanded(
                  child: Focus(
                    onFocusChange: (bool isFocus) {
                      if (onFocus != null) onFocus(isFocus);
                    },
                    child: TextFormField(

                      initialValue: initialValue,
                      readOnly: isReadOnly,
                      controller: controller,
                      focusNode: focusNode,
                      maxLines: !model.obscureText ? maxLines : 1,
                      onChanged: (value) {
                        if (validator == null) model.onChanged(value);
                        if (onChanged != null) onChanged(value);
                      },
                      validator: (value) {
                        if (validator != null) {
                          model.errorMessage = validator(value);
                        }
                        return model.errorMessage;
                      },
                      keyboardType: keyboardType,
                      obscureText: model.obscureText,
                      style: style,
                      decoration: InputDecoration(
                        hintText: hintText,
                        hintMaxLines: 1,
                        hintStyle: hintStyle,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        focusedErrorBorder: InputBorder.none,
                        errorMaxLines: 1,
                        errorStyle: TextStyle(
                          color: Colors.transparent,
                          height: Platform.isAndroid ? 0 : null,
                        ),
                      ),
                    ),
                  ),
                ),

                trailing,

                Visibility(
                  visible: hasShowFieldButton,
                  child: IconButton(
                    icon: SvgPicture.asset(
                      model.getShowFieldButtonIcon(),
                      width: 12,
                      height: 12,
                    ),
                    onPressed: model.clearShowField,
                  ),
                ),


                Visibility(
                  visible: model.canShowClearButton && !isReadOnly,
                  child: IconButton(
                    icon: SvgPicture.asset(
                      AppIcons.clearText,
                      width: 16,
                      height: 16,
                    ),
                    onPressed: () {
                      model.clearTextFiled();
                      if (onClear != null) onClear();
                    },
                  ),
                ),
              ],
            ),
          ),],),



        ],
      ),
      viewModelBuilder: () => AppTextFieldViewModel(
        controller: controller,
        obscureText: obscureText,
        hasClearButton: hasClearButton,
        hasShowFieldButton: hasShowFieldButton,
      ),
    );
  }
}
