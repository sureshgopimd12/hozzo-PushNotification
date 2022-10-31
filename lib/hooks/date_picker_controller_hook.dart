import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hozzo/plugins/date_picker_timeline.dart';

DatePickerController useDatePickerController() {
  return use(_DatePickerControllerHook());
}

class _DatePickerControllerHook extends Hook<DatePickerController> {
  const _DatePickerControllerHook();

  @override
  _DatePickerControllerHookState createState() => _DatePickerControllerHookState();
}

class _DatePickerControllerHookState extends HookState<DatePickerController, _DatePickerControllerHook> {
  DatePickerController _datePickerController = DatePickerController();

  _DatePickerControllerHookState();

  @override
  void initHook() {
    _datePickerController = DatePickerController();
  }

  @override
  DatePickerController build(BuildContext context) => _datePickerController;

  @override
  void dispose() => _datePickerController.dispose();
}
