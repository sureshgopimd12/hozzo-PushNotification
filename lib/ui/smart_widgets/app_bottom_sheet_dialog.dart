import 'package:argon_buttons_flutter/argon_buttons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hozzo/app/asset_data.dart';
import 'package:hozzo/ui/smart_widgets/primary_button.dart';

class AppBottomSheetDialog extends StatelessWidget {
  final String title;
  final String description;
  final String buttonText;
  final Function(Function, Function, ButtonState) onTap;
  final VoidCallback onSkip;

  const AppBottomSheetDialog({
    Key key,
    @required this.title,
    @required this.description,
    @required this.buttonText,
    @required this.onTap,
    this.onSkip,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      child: Align(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 50),
                child: Column(
                  children: [
                    SizedBox(height: size.height * 0.03),
                    SvgPicture.asset(AppIcons.hozzoSymbol),
                    SizedBox(height: size.height * 0.03),
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        height: 2,
                        fontSize: 27.0,
                      ),
                    ),
                    SizedBox(height: size.height * 0.04),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: Text(
                        description,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          height: 2,
                          fontSize: 11.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: size.height * 0.03),
              PrimaryButton(
                text: buttonText,
                onTap: onTap,
              ),



              Visibility(
                visible: onSkip != null,
                child: TextButton(
                  onPressed: onSkip,
                  child: Text(
                    "Skip for now",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),

              SizedBox(height: size.height * 0.03),
            ],
          ),
        ),
      ),
    );
  }
}
