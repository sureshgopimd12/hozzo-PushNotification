import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:hozzo/app/asset_data.dart';
import 'package:hozzo/datamodels/banner.dart';
import 'package:hozzo/datamodels/coupon_code.dart';
import 'package:hozzo/datamodels/popular_service.dart';
import 'package:hozzo/hooks/page_controller_hook.dart';
import 'package:hozzo/theme/app-theme.dart';
import 'package:hozzo/ui/smart_widgets/app_drawer/app_drawer.dart';
import 'package:hozzo/ui/smart_widgets/load_image.dart';
import 'package:hozzo/ui/smart_widgets/primary_app_bar/primary_app_bar.dart';
import 'package:hozzo/ui/views/home/home_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:stacked/stacked.dart';

class HomeView extends HookWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final mainSliderController = usePageController();
    final searchController = useTextEditingController();
    final couponCodeController = usePageController();

    return ViewModelBuilder<HomeViewModel>.reactive(
      builder: (context, model, child) => Scaffold(
        key: model.scaffoldKey,
        appBar: PrimaryAppBar(model.scaffoldKey),
        drawer: AppDrawer(),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(25.0, 25.0, 25.0, 0.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    buildHead(model),
                    SizedBox(height: 30),
                    // buildSearchBox(model),
                    // SizedBox(height: 30),
                  ],
                ),
              ),
              buildMainSlider(model),
              buildPopularServices(model, size),
              buildSubscriptions(context, model),
              buildOffers(context, model, size)
            ],
          ),
        ),
      ),
      viewModelBuilder: () => HomeViewModel(
        mainSliderController: mainSliderController,
        searchController: searchController,
        size: size,
        couponCodeController: couponCodeController,
      ),
      onModelReady: (model) => model.checkForUpdate(),
    );
  }

  Widget buildHead(HomeViewModel model) {
    return Builder(
      builder: (context) {
        if (!model.isBusy) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                model?.greetings?.title ?? '',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                model?.greetings?.subtitle ?? '',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          );
        }
        return Shimmer.fromColors(
          baseColor: Colors.grey[300],
          highlightColor: Colors.grey[100],
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                color: Colors.white,
                height: 18,
                width: 150,
              ),
              SizedBox(height: 10),
              Container(
                color: Colors.white,
                height: 13,
                width: model.size.width - 100,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget buildSearchBox(HomeViewModel model) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.only(left: 17.0, right: 9.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        boxShadow: [
          BoxShadow(
            color: AppColors.textColor.withOpacity(0.3),
            offset: Offset(0, 3),
            blurRadius: 6,
          ),
        ],
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: model.searchController,
              onChanged: (text) => model.searchService(text),
              style: TextStyle(
                fontWeight: FontWeight.w600,
              ),
              decoration: InputDecoration(
                hintText: "Search for a service",
                hintStyle: TextStyle(
                  color: AppColors.textColor.withOpacity(0.4),
                  fontWeight: FontWeight.w600,
                ),
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 10),
            padding: const EdgeInsets.all(10.0),
            child: SvgPicture.asset(AppIcons.search),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(5),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildMainSlider(HomeViewModel model) {
    return Builder(
      builder: (context) {
        if (!model.isBusy) {
          return Stack(
            children: [
              Container(
                height: model.size.height * 0.26,
                child: PageView(
                  controller: model.mainSliderController,
                  children: model.banners
                      .map((homeSlider) =>
                          buildMainSliderCard(model, homeSlider))
                      .toList(),
                ),
              ),
              Positioned(
                bottom: 25,
                left: 0,
                right: 0,
                child: Align(
                  child: SmoothPageIndicator(
                    count: model.slidesCount,
                    controller: model.mainSliderController,
                    effect: ExpandingDotsEffect(
                      expansionFactor: 2,
                      dotHeight: 5,
                      dotWidth: 5,
                      radius: 100,
                      dotColor: Colors.white.withOpacity(0.5),
                      activeDotColor: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          );
        }
        return Shimmer.fromColors(
          baseColor: Colors.grey[300],
          highlightColor: Colors.grey[100],
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Container(
                margin: const EdgeInsets.only(bottom: 15),
                clipBehavior: Clip.antiAliasWithSaveLayer,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primary,
                      AppColors.accent,
                    ],
                    begin: Alignment.bottomLeft,
                    end: Alignment.topRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.textColor.withOpacity(0.6),
                      offset: Offset(0, 5),
                      blurRadius: 4,
                    ),
                  ],
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: Container(height: 200)),
          ),
        );
      },
    );
  }

  Widget buildMainSliderCard(HomeViewModel model, HomeBanner banner) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: GestureDetector(
        onTap: () => model.sliderTap(banner),
        child: Container(
          margin: const EdgeInsets.only(bottom: 15),
          clipBehavior: Clip.antiAliasWithSaveLayer,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.primary,
                AppColors.accent,
              ],
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.textColor.withOpacity(0.6),
                offset: Offset(0, 5),
                blurRadius: 4,
              ),
            ],
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Builder(
            builder: (context) {
              if (!banner.hasImage) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(17.0, 17.0, 80.0, 0.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        banner.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 20,
                          height: 1.3,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 40),
                      Text(
                        banner.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 15,
                          height: 1.3,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                );
              }
              return LoadImage(url: banner.image.url);
            },
          ),
        ),
      ),
    );
  }

  Widget buildPopularServices(HomeViewModel model, Size size) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 25.0, top: 30.0),
          child: Text(
            "Popular Services",
            style: TextStyle(
              fontSize: 20,
              color: AppColors.accent,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Builder(builder: (context) {
          if (!model.isBusy) {
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding:
                  const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10),
              child: Row(
                children: model.popularPackages
                    .map((service) => buildPopularServiceCard(model, service))
                    .toList(),
              ),
            );
          }
          return Shimmer.fromColors(
            baseColor: Colors.grey[300],
            highlightColor: Colors.grey[100],
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding:
                  const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10),
              child: Row(
                children: [1, 2, 3].map((_) {
                  return Padding(
                    padding: const EdgeInsets.all(15),
                    child: Container(
                      width: model.size.width * 0.5,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.textColor.withOpacity(0.3),
                            offset: Offset(0, 3),
                            blurRadius: 6,
                          ),
                        ],
                        borderRadius: BorderRadius.circular(13.0),
                      ),
                      child: Column(
                        children: [
                          Container(
                            height: 240,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  AppColors.primary,
                                  AppColors.accent,
                                ],
                                begin: Alignment.bottomRight,
                                end: Alignment.topLeft,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget buildPopularServiceCard(HomeViewModel model, PopularService package) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: GestureDetector(
        onTap: () => model.goToPackage(package),
        child: Container(
          width: model.size.width * 0.5,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: AppColors.textColor.withOpacity(0.3),
                offset: Offset(0, 3),
                blurRadius: 6,
              ),
            ],
            borderRadius: BorderRadius.circular(13.0),
          ),
          child: Column(
            children: [
              Container(
                height: 100,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primary,
                      AppColors.accent,
                    ],
                    begin: Alignment.bottomRight,
                    end: Alignment.topLeft,
                  ),
                ),
                child: Hero(
                  tag: "servicePreview${package.serviceID}",
                  child: LoadImage(url: package.image.url),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 40,
                      child: Text(
                        package.serviceName,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyle(
                          fontSize: 16,
                          height: 1.2,
                          color: AppColors.accent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 5),
                    SizedBox(
                      // height: 50,
                      child: Text(
                        package.serviceDescription,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                        style: TextStyle(
                          fontSize: 12,
                          height: 1.4,
                          color: AppColors.textColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () => model.goToServiceDetails(package),
                          child: SvgPicture.asset(
                            AppIcons.info,
                            height: 18,
                            width: 18,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            RichText(
                              text: TextSpan(
                                style: TextStyle(
                                  fontFamily: AppTheme.fontFamily,
                                  color: AppColors.accent,
                                  fontWeight: FontWeight.bold,
                                ),
                                children: [
                                  TextSpan(
                                    text: "starts from ",
                                    style: TextStyle(
                                      fontSize: 12,
                                    ),
                                  ),
                                  TextSpan(
                                    text: package.serviceAmount,
                                    style: TextStyle(
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 2, bottom: 3),
                              child: SvgPicture.asset(
                                AppIcons.arrowRight,
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildOffers(BuildContext context, HomeViewModel model, Size size) {
    return !model.isBusy
        ? Visibility(
            visible: !(model.couponCodes?.length == 0),
            child: Column(
              children: [
                Container(
                  alignment: Alignment.topLeft,
                  padding: const EdgeInsets.only(left: 25.0, top: 30.0),
                  child: Text(
                    "OFFERS",
                    style: TextStyle(
                      fontSize: 20.0,
                      color: AppColors.accent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Stack(
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 10.0),
                      child: ExpandablePageView(
                        controller: model.couponCodeController,
                        children: model.couponCodes
                            .map(
                              (couponCode) => buildOffersCard(
                                  context, model, size, couponCode),
                            )
                            .toList(),
                      ),
                    ),
                    Positioned(
                      child: Container(
                        padding: const EdgeInsets.only(right: 25.0),
                        child: Align(
                          alignment: Alignment.topRight,
                          child: SmoothPageIndicator(
                            count: model.couponCodes.length,
                            controller: model.couponCodeController,
                            effect: ExpandingDotsEffect(
                              expansionFactor: 2,
                              dotHeight: 5,
                              dotWidth: 5,
                              radius: 100,
                              // dotColor: Colors.white.withOpacity(1),
                              activeDotColor: AppColors.primary,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 24,
                )
              ],
            ),
          )
        : Column(
            children: [Container()],
          );
  }

  buildSubscriptions(BuildContext context, HomeViewModel model) {
    List<Map<String, Color>> colors = model.subscriptionSwiperColors;
    if (model.isBusy) return Container();
    return model.popularSubscriptions.length != 0
        ? Column(
            children: [
              Container(
                alignment: Alignment.topLeft,
                padding: const EdgeInsets.only(left: 25.0, top: 30.0),
                child: Text(
                  "Subscriptions",
                  style: TextStyle(
                    fontSize: 20.0,
                    color: AppColors.accent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              new Swiper(
                duration: 800,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(16.0),
                        bottomRight: Radius.circular(16.0),
                        topRight: Radius.circular(16.0),
                      ),
                      child: Container(
                        color: colors[index]["backgroundColor"],
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Container(
                            decoration: BoxDecoration(
                              // color: AppColors.textColor,
                              border: Border.all(
                                width: 1.0,
                                color: colors[index]["borderColor"],
                              ),
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(16.0),
                                bottomRight: Radius.circular(16.0),
                                topRight: Radius.circular(16.0),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(12.0),
                                    decoration: BoxDecoration(
                                      // color: AppColors.primary,
                                      borderRadius: BorderRadius.circular(1.0),
                                    ),
                                    child: Column(
                                      children: [
                                        Text(
                                          "starts at",
                                          style: titlTextStyle(
                                            color: colors[index]["amountColor"],
                                            size: 12,
                                          ),
                                          textAlign: TextAlign.start,
                                        ),
                                        Text(
                                          model.popularSubscriptions[index]
                                              .price,
                                          style: titlTextStyle(
                                            color: colors[index]["amountColor"],
                                            size: 30,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    model.popularSubscriptions[index].name,
                                    style: titlTextStyle(
                                      size: 18,
                                      color: colors[index]["borderColor"],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5.0,
                                  ),
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width * .6,
                                    child: Text(
                                      model.popularSubscriptions[index]
                                          .description,
                                      textAlign: TextAlign.center,
                                      style: subtitlTextStyle(
                                        size: 13,
                                        color: colors[index]["subtitleColor"],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  FlatButton(
                                    color: colors[index]["buttonColor"],
                                    onPressed: () => model.goToVehicleSelect(
                                        model.popularSubscriptions[index]),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "BUY NOW",
                                          style: titlTextStyle(
                                            color: colors[index]["buynowColor"],
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
                itemCount: model.popularSubscriptions.length,
                itemWidth: MediaQuery.of(context).size.width,
                itemHeight: 320.0,
                layout: SwiperLayout.STACK,
                autoplay: true,
                autoplayDisableOnInteraction: true,
                autoplayDelay: 3000,
                pagination: new SwiperPagination(
                  alignment: Alignment.bottomRight,
                  margin: const EdgeInsets.only(right: 20.0),
                  builder: new DotSwiperPaginationBuilder(
                    color: AppColors.grey,
                    activeColor: AppColors.primary,
                    size: 5,
                    activeSize: 8.0,
                  ),
                ),
              ),
            ],
          )
        : Container();
  }

  Widget buildOffersCard(BuildContext context, HomeViewModel model, Size size,
      CouponCode couponCode) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Card(
        elevation: 4.0,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.all(
                Radius.circular(10.0),
              ),
              child: LoadImage(
                url: couponCode.image.url,
                fit: BoxFit.fitWidth,
                width: MediaQuery.of(context).size.width,
              ),
            ),
            SizedBox(
              height: 12.0,
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                couponCode.title,
                style: TextStyle(
                  fontSize: 16,
                  height: 1.2,
                  color: AppColors.accent,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              height: 8.0,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                width: MediaQuery.of(context).size.width * .7,
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: RichText(
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                  text: TextSpan(
                    text: couponCode.description,
                    style: TextStyle(
                      fontSize: 13,
                      height: 1.2,
                      color: AppColors.textColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 8.0,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                            style: TextStyle(
                              fontSize: 14,
                              height: 1.4,
                              color: AppColors.textColor,
                              fontWeight: FontWeight.bold,
                            ),
                            text: "coupon code: "),
                        TextSpan(
                            style: TextStyle(
                              fontSize: 14,
                              height: 1.4,
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                            text: couponCode.code)
                      ],
                    ),
                  ),
                  Container(
                    height: 25,
                    child: OutlineButton(
                      onPressed: () => model.copyToClipboard(couponCode.code),
                      borderSide: BorderSide(color: AppColors.primary),
                      child: Row(
                        children: [
                          Text(
                            "copy",
                            style: TextStyle(color: AppColors.textColor),
                          ),
                          SizedBox(
                            width: 5.0,
                          ),
                          Icon(
                            Icons.copy,
                            size: 14,
                            color: AppColors.textColor,
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 16.0,
            )
          ],
        ),
      ),
    );
  }

  TextStyle subtitlTextStyle(
      {double size = 13, Color color = AppColors.textColor}) {
    return TextStyle(
      fontSize: size,
      height: 1.2,
      color: color,
      fontWeight: FontWeight.bold,
    );
  }

  TextStyle titlTextStyle({double size = 16, Color color = AppColors.accent}) {
    return TextStyle(
      fontSize: size,
      height: 1.2,
      color: color,
      fontWeight: FontWeight.bold,
    );
  }
}
