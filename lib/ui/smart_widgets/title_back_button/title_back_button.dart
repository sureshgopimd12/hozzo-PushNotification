import 'package:flutter/material.dart';
import 'package:hozzo/theme/app-theme.dart';
import 'package:hozzo/ui/smart_widgets/title_back_button/title_back_button_viewmodel.dart';
import 'package:stacked/stacked.dart';

class TitleBackButton extends StatelessWidget {
  final bool isFromDrawer;

  TitleBackButton({this.isFromDrawer = false});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<TitleBackButtonViewModel>.reactive(
      builder: (context, model, child) => WillPopScope(
        onWillPop: model.onWillPop,
        child: Container(
          child: IconButton(
            padding: const EdgeInsets.all(0),
            visualDensity: VisualDensity.compact,
            icon: Icon(
              Icons.chevron_left,
              color: AppColors.accent,
              size: 30,
            ),
            onPressed: model.goBack,
          ),
        ),
      ),
      viewModelBuilder: () => TitleBackButtonViewModel(isFromDrawer),
    );
  }
}
