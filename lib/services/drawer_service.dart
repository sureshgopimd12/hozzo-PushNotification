import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

@injectable
class DrawerService {
  openDrawer(GlobalKey<ScaffoldState> scaffoldKey) {
    scaffoldKey.currentState.openDrawer();
  }
}
