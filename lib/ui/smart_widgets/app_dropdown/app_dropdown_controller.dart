class AppDropdownController {
  bool Function() validate;
  bool Function(String errorMessage) setValidationError;

  void dispose() {
    validate = null;
    setValidationError = null;
  }
}
