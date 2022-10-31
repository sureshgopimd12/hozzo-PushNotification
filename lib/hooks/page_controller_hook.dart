import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

PageController usePageController({int initialPage: 0}) {
  return use(_PageControllerHook(initialPage: initialPage));
}

class _PageControllerHook extends Hook<PageController> {
  final int initialPage;

  const _PageControllerHook({this.initialPage});

  @override
  _PageControllerHookState createState() => _PageControllerHookState(initialPage: initialPage);
}

class _PageControllerHookState extends HookState<PageController, _PageControllerHook> {
  PageController _pageController = PageController();
  final int initialPage;

  _PageControllerHookState({this.initialPage});

  @override
  void initHook() {
    _pageController = PageController(initialPage: initialPage);
  }

  @override
  PageController build(BuildContext context) => _pageController;

  @override
  void dispose() => _pageController.dispose();
}
