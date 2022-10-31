import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hozzo/app/asset_data.dart';
import 'package:hozzo/theme/app-theme.dart';
import 'package:hozzo/ui/smart_widgets/app_dropdown/app_dropdown_controller.dart';
import 'package:hozzo/ui/smart_widgets/app_dropdown/app_dropdown_item.dart';
import 'package:hozzo/ui/smart_widgets/app_dropdown/app_dropdown_viewmodel.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_hooks/stacked_hooks.dart';

class AppDropDown extends HookWidget {
  final AppDropdownController controller;
  final String hintText;
  final String title;
  final String searchBoxHintText;
  final String emptyText;
  final String Function(AppDropDownItem item) validator;
  final Function(AppDropDownItem item) onChanged;
  final Future<List<AppDropDownItem>> Function(String filter) onFind;
  const AppDropDown({
    this.controller,
    this.hintText = '',
    this.title = 'Data',
    this.searchBoxHintText = 'Search',
    this.emptyText = 'Oops..! No data found.',
    this.validator,
    @required this.onChanged,
    this.onFind,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final searchController = useTextEditingController();
    return ViewModelBuilder<AppDropdownViewModel>.nonReactive(
      onModelReady: (model) => model.init(controller),
      builder: (context, model, child) => Theme(
        data: appTheme.copyWith(
          textTheme: TextTheme(
            subtitle1: TextStyle(
              fontFamily: AppTheme.fontFamily,
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: Colors.black,
            ),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _ValidationBlock(),
            Container(
              padding: const EdgeInsets.only(left: 20.0, right: 10.0),
              decoration: BoxDecoration(
                color: AppColors.accent.withOpacity(0.1),
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                  bottomLeft: Radius.circular(24),
                ),
              ),
              child: DropdownSearch<AppDropDownItem>(
                searchBoxController: searchController,
                mode: Mode.BOTTOM_SHEET,
                showSelectedItem: true,
                showSearchBox: true,
                isFilteredOnline: true,
                dropDownButton: SvgPicture.asset(
                  AppIcons.dropdownIcon,
                  color: AppColors.accent,
                ),
                loadingBuilder: (BuildContext context, String value) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 40),
                      child: CircularProgressIndicator(),
                    ),
                  );
                },
                onFind: (String filter) async {
                  if (onFind != null) {
                    try {
                      model.items = await onFind(filter);
                    } catch (e) {}
                  }
                  return model.items;
                },
                compareFn: (AppDropDownItem i, AppDropDownItem s) => i.isEqual(s),
                onChanged: (value) => model.onChanged(value, onChanged),
                selectedItem: null,
                popupItemBuilder: (BuildContext context, AppDropDownItem item, bool status) {
                  return ListTile(
                    title: Text(item.name),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 26.0,
                    ),
                  );
                },
                dropdownBuilderSupportsNullItem: true,
                dropdownBuilder: (BuildContext context, AppDropDownItem item, String value) {
                  return Text(
                    value,
                    style: TextStyle(
                      fontFamily: AppTheme.fontFamily,
                      color: Colors.black.withOpacity(0.8),
                      fontWeight: FontWeight.bold,
                    ),
                  );
                },
                popupTitle: Container(
                  height: 50,
                  margin: const EdgeInsets.only(bottom: 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primary,
                        AppColors.accent,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      title,
                      style: TextStyle(
                        fontFamily: AppTheme.fontFamily,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                popupShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                searchBoxDecoration: InputDecoration(
                  enabledBorder: new OutlineInputBorder(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(24),
                      bottomRight: Radius.circular(24),
                      bottomLeft: Radius.circular(24),
                    ),
                    borderSide: BorderSide(color: AppColors.accent),
                  ),
                  focusedBorder: new OutlineInputBorder(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(24),
                      bottomRight: Radius.circular(24),
                      bottomLeft: Radius.circular(24),
                    ),
                    borderSide: BorderSide(color: AppColors.accent),
                  ),
                  contentPadding: EdgeInsets.fromLTRB(20, 12, 8, 12),
                  labelText: searchBoxHintText,
                  labelStyle: TextStyle(
                    color: AppColors.textColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                  suffixIcon: Container(
                    margin: const EdgeInsets.only(right: 10),
                    padding: const EdgeInsets.all(10.0),
                    child: SvgPicture.asset(AppIcons.search, color: AppColors.primary),
                  ),
                ),
                emptyBuilder: (BuildContext context, String value) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        AppIcons.crash,
                        width: 80,
                      ),
                      SizedBox(height: 25),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          emptyText,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontFamily: AppTheme.fontFamily,
                            color: AppColors.textColor,
                          ),
                        ),
                      )
                    ],
                  );
                },
                dropdownSearchDecoration: InputDecoration(
                  hintText: hintText,
                  alignLabelWithHint: true,
                  hintMaxLines: 1,
                  contentPadding: const EdgeInsets.all(0),
                  isDense: true,
                  hintStyle: TextStyle(
                    color: Colors.black.withOpacity(0.4),
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  focusedErrorBorder: InputBorder.none,
                  errorMaxLines: 1,
                ),
              ),
            ),
          ],
        ),
      ),
      viewModelBuilder: () => AppDropdownViewModel(validator),
    );
  }
}

class _ValidationBlock extends HookViewModelWidget<AppDropdownViewModel> {
  _ValidationBlock({Key key}) : super(key: key, reactive: true);

  @override
  Widget buildViewModelWidget(BuildContext context, AppDropdownViewModel model) {
    if (model.isValidationError == null) return Container();
    return Padding(
      padding: const EdgeInsets.only(bottom: 5.0),
      child: Text(
        model.validationMessage ?? '',
        textAlign: TextAlign.right,
        style: TextStyle(
          color: AppColors.error,
          fontWeight: FontWeight.w600,
          fontSize: 9,
        ),
      ),
    );
  }
}
