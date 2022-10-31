import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hozzo/datamodels/popular_service.dart';
import 'package:stacked/stacked.dart';

class ServiceDetailsViewModel extends BaseViewModel {
  ServiceDetailsViewModel({this.service});
  final PopularService service;
  final scaffoldKey = GlobalKey<ScaffoldState>();
}
