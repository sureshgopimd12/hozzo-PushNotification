import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hozzo/ui/smart_widgets/app_dropdown/app_dropdown_controller.dart';

AppDropdownController useAppDropdownController() {
  return use(_AppDropdownControllerHook());
}

class _AppDropdownControllerHook extends Hook<AppDropdownController> {
  const _AppDropdownControllerHook();

  @override
  _AppDropdownControllerHookState createState() => _AppDropdownControllerHookState();
}

class _AppDropdownControllerHookState extends HookState<AppDropdownController, _AppDropdownControllerHook> {
  AppDropdownController _appDropdownController = AppDropdownController();

  _AppDropdownControllerHookState();

  @override
  void initHook() {
    _appDropdownController = AppDropdownController();
  }

  @override
  AppDropdownController build(BuildContext context) => _appDropdownController;

  @override
  void dispose() => _appDropdownController.dispose();
}
