import 'package:hozzo/ui/smart_widgets/app_dropdown/app_dropdown_controller.dart';
import 'package:hozzo/ui/smart_widgets/app_dropdown/app_dropdown_item.dart';
import 'package:stacked/stacked.dart';

class AppDropdownViewModel extends BaseViewModel {
  List<AppDropDownItem> items;
  bool canLoadAgain = true;
  AppDropDownItem selectedAppDropDownItem;
  final String Function(AppDropDownItem item) validator;
  String validationMessage;

  AppDropdownViewModel(this.validator);

  init(AppDropdownController controller) {
    if (controller != null) {
      controller.validate = validate;
      controller.setValidationError = setValidationError;
    }
  }

  onChanged(AppDropDownItem item, Function(AppDropDownItem item) onChanged) {
    selectedAppDropDownItem = item;
    validationMessage = null;
    notifyListeners();
    onChanged(item);
  }

  bool get isValidationError => validator != null && validationMessage != null;

  bool validate() {
    validationMessage = validator != null ? validator(selectedAppDropDownItem) : null;
    notifyListeners();
    return validationMessage == null;
  }

  bool setValidationError(String errorMessage) {
    validationMessage = errorMessage;
    notifyListeners();
    return validationMessage == null;
  }
}
