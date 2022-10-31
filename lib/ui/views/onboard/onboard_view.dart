import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hozzo/app/asset_data.dart';
import 'package:hozzo/datamodels/onboard.dart';
import 'package:hozzo/hooks/page_controller_hook.dart';
import 'package:hozzo/theme/app-theme.dart';
import 'package:hozzo/ui/views/onboard/onboard_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:stacked/stacked.dart';

class OnboardView extends HookWidget {
  const OnboardView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final pageController = usePageController();

    return ViewModelBuilder<OnboardViewModel>.reactive(
      builder: (context, model, child) => Scaffold(
        body: SafeArea(
          bottom: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 30.0, bottom: 15.0),
                  child: PageView(
                    controller: pageController,
                    children: model.onboards
                        .map((onboard) => buildOnboardCard(onboard))
                        .toList(),
                  ),
                ),
              ),
              Align(
                child: SmoothPageIndicator(
                  count: model.onboards.length,
                  controller: pageController,
                  effect: ExpandingDotsEffect(
                    expansionFactor: 2,
                    dotHeight: 5,
                    dotWidth: 5,
                    radius: 100,
                    activeDotColor: AppColors.accent,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    MaterialButton(
                      onPressed: model.goToLogin,
                      padding: const EdgeInsets.all(16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      color: AppColors.primary,
                      textColor: Colors.white,
                      child: Text(
                        'Next',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    SizedBox(height: 10),
                    TextButton(
                      onPressed: model.goToLogin,
                      child: Text(
                        'Skip',
                        style: TextStyle(fontSize: 16, color: AppColors.accent),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      viewModelBuilder: () => OnboardViewModel(),
    );
  }

  Widget buildOnboardCard(Onboard onboard) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Stack(
        children: [
          ColorFiltered(
            colorFilter: ColorFilter.mode(
              Colors.white.withOpacity(0.5),
              BlendMode.srcOver,
            ),
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(AppImages.logoPattern),
                  colorFilter: new ColorFilter.mode(
                      Colors.black.withOpacity(0.1), BlendMode.dstATop),
                  fit: BoxFit.cover,
                  // repeat: ImageRepeat.repeat
                ),
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary,
                    AppColors.accent,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Column(
              children: [
                Expanded(
                  child: Image(
                    image: AssetImage(onboard.imageUrl),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(40.0, 0.0, 40.0, 40.0),
                  child: Column(
                    children: [
                      Text(
                        onboard.title,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w500,
                          height: 1.3,
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        onboard.description,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
