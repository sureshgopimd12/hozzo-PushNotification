import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:hozzo/app/router.gr.dart' as router;
import 'package:hozzo/app/locator.dart';
import 'package:hozzo/services/utility_service.dart';
import 'package:hozzo/theme/app-theme.dart';
import 'package:hozzo/services/graphql_service.dart';
import 'package:hozzo/theme/setup_snackbar_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:stacked_services/stacked_services.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
  await setupLocator();
  setupSnackbarUi();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final _utilityService = locator<UtilityService>();
  
  @override
  
  Widget build(BuildContext context) {
    // Disabled screen rotation of application
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: Colors.transparent,
      statusBarBrightness:
          Platform.isAndroid ? Brightness.dark : Brightness.light,
    ));

    return GestureDetector(
      onTap: _utilityService.closeKeyBoard,
      child: GraphQLProvider(
        client: GraphQLService.initailizeClient(),
        child: MaterialApp(
          title: 'HOZZO',
          debugShowCheckedModeBanner: false,
          navigatorKey: locator<NavigationService>().navigatorKey,
          theme: appTheme,
          onGenerateRoute: router.Router(),
        ),
      ),
    );
  }
}
