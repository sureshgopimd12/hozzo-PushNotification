import 'package:flutter/material.dart';

class DrawerMenuItem {
  final IconData icon;
  final String name;
  final String page;
  final dynamic arguments;
  final bool isLogout;

  const DrawerMenuItem({
    this.icon,
    this.name,
    this.page,
    this.arguments,
    this.isLogout = false,
  });
}