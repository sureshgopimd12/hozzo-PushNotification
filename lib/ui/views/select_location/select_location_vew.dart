import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hozzo/services/google_map_service.dart';
import 'package:hozzo/theme/app-theme.dart';
import 'package:hozzo/ui/smart_widgets/primary_button.dart';
import 'package:hozzo/ui/smart_widgets/secondary_app_bar/secondary_app_bar.dart';
import 'package:hozzo/ui/smart_widgets/shimmer_blocks.dart';
import 'package:hozzo/ui/views/select_location/select_location_viewmodel.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_hooks/stacked_hooks.dart';

class SelectLocationView extends HookWidget {

  @override
  Widget build(BuildContext context) {
    var _searchController = useTextEditingController();
    double bottomSpace = MediaQuery.of(context).padding.bottom;
    return ViewModelBuilder<SelectLocationViewModel>.nonReactive(
      onModelReady: (model) async => await model.goToYourInitialLocation(),
      builder: (context, model, child) => Scaffold(
        appBar: SecondaryAppBar(
          leftBorderRadius: 0,
          title: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Stack(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 17, left: 40),
                        child: Text(
                          "Choose your Location",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                            height: 1,
                          ),
                        ),
                      ),
                      Material(
                        color: Colors.transparent,
                        child: Container(
                          height: 50,
                          width: 50,
                          child: InkWell(
                            customBorder: new CircleBorder(),
                            onTap: model.goBack,
                            child: Container(
                              child: Align(
                                child: Icon(
                                  Icons.chevron_left,
                                  color: Colors.white,
                                  size: 30,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(left: 20.0,),
                child: Stack(
                  children: [
                    Container(
                      // margin: EdgeInsets.only(right: 10.0),
                      padding: EdgeInsets.only(left: 20),
                      // width: MediaQuery.of(context).size.height*0.35,
                      decoration: BoxDecoration(
                        color: AppColors.backgroundColor,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(24),
                          bottomLeft: Radius.circular(24),
                        ),
                      ),
                      child: TypeAheadField<PlaceInfo>(
                        textFieldConfiguration: TextFieldConfiguration(
                          style: TextStyle(fontWeight: FontWeight.w600),
                          decoration: InputDecoration(
                            hintText: "Search your place",
                            hintMaxLines: 1,
                            hintStyle: TextStyle(
                              color: AppColors.textColor,
                              fontWeight: FontWeight.w600,
                            ),
                            contentPadding: const EdgeInsets.only(right: 45.5),
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            focusedErrorBorder: InputBorder.none,
                            errorMaxLines: 1,
                            errorStyle: TextStyle(
                              color: Colors.transparent,
                            ),
                          ),
                          controller: _searchController,
                        ),
                        hideOnLoading: true,
                        debounceDuration: Duration(milliseconds: 400),
                        suggestionsBoxDecoration: SuggestionsBoxDecoration(
                          color: AppColors.grey,
                          borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(24),
                            bottomLeft: Radius.circular(24),
                          ),
                        ),
                        // suggestionsCallback: (pattern) =>
                        //     model.onSearch(pattern),
                        suggestionsCallback: (pattern,) async {
                          if (pattern.length > 5) {
                            return await model.onSearch(pattern);
                          } else {
                            return [];
                          }
                        },
                        suggestionsBoxVerticalOffset: 1,
                        transitionBuilder:
                            (context, suggestionsBox, controller) {
                          return FadeTransition(
                            child: suggestionsBox,
                            opacity: CurvedAnimation(
                                parent: controller,
                                curve: Curves.fastOutSlowIn),
                          );
                        },
                        itemBuilder: (context, placeInfo) {
                          return ListTile(
                            dense: true,
                            title: Row(
                              children: [
                                Icon(Icons.location_on,
                                    color: AppColors.textColor, size: 20),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    placeInfo.address,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        height: 1.3),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        noItemsFoundBuilder: (context) {
                          return Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              "Oops...No Places found.",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                // fontSize: 14,
                                color: AppColors.textColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          );
                        },
                        onSuggestionSelected: (placeInfo) =>
                            model.onSearchSelected(placeInfo),
                      ),
                    ),
                    // _SearchLoaidng(),
                    // SizedBox(width: 5,),
                    // Expanded(
                    //     child: InkWell(
                    //       onTap: () {
                    //         searchStart == "1";
                    //         print(searchStart);
                    //       },
                    //       child: Container(
                    //         decoration: BoxDecoration(
                    //             color: const Color(0xff93C01F),
                    //             border: Border.all(
                    //                 color: const Color(0xff93C01F)
                    //             ),
                    //             borderRadius: BorderRadius.all(Radius.circular(12))
                    //         ),
                    //         width: MediaQuery.of(context).size.height*0.4,
                    //         height: MediaQuery.of(context).size.height*0.065,
                    //         child: Align(
                    //           alignment: Alignment.center,
                    //           child: Text ("Search",
                    //             style: TextStyle(
                    //                 color: Colors.white,
                    //                 fontSize: 10,
                    //                 fontWeight: FontWeight.bold
                    //             ),
                    //           ),
                    //         ),
                    //       ),
                    //     )
                    // ),


                  ],
                ),
              ),
            ],
          ),
        ),
        body: Stack(
          children: [
            GoogleMap(
              initialCameraPosition: model.getInitialCameraPosition(),
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
              onCameraMoveStarted: model.onCameraMoveStarted,
              onCameraMove: (position) => model.onCameraMove(position),
              onCameraIdle: model.onCameraIdle,
              onMapCreated: (GoogleMapController controller) =>
                  model.onMapCreated(controller),
            ),
            Container(
              margin: const EdgeInsets.only(top: 10, right: 10),
              alignment: Alignment.topRight,
              child: FloatingActionButton(
                onPressed: model.goToYourLocation,
                backgroundColor: Colors.white,
                child: Icon(Icons.my_location, color: AppColors.textColor),
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 40 + bottomSpace),
              child: Center(
                child: SvgPicture.asset('assets/icons/pin.svg', width: 40),
              ),
            ),
            _PlaceChooserView(),
          ],
        ),
      ),
      viewModelBuilder: () => SelectLocationViewModel(
        searchController: _searchController,
      ),
    );
  }
}

class _SearchLoaidng extends HookViewModelWidget<SelectLocationViewModel> {
  _SearchLoaidng({Key key}) : super(key: key, reactive: true);

  @override
  Widget buildViewModelWidget(
      BuildContext context, SelectLocationViewModel model) {
    if (!model.isLoadingPlaces) return Container();
    return Align(
      alignment: Alignment.topRight,
      child: Container(
        height: 20,
        width: 20,
        margin: const EdgeInsets.only(top: 14,right: 30),
        child: CircularProgressIndicator(
          strokeWidth: 2.0,
        ),
      ),
    );
  }
}

class _PlaceChooserView extends HookViewModelWidget<SelectLocationViewModel> {
  _PlaceChooserView({Key key}) : super(key: key, reactive: true);

  @override
  Widget buildViewModelWidget(
      BuildContext context, SelectLocationViewModel model) {
    return Positioned(
      bottom: 10,
      left: 0,
      right: 0,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(36)),
          ),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
            child: Builder(
              builder: (context) {
                if (model.placeInfo.isInitial && !model.isCameraMoving) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 21,
                          width: 21,
                          child: Visibility(
                            visible: !model.canLoadPlaceInfo,
                            child: CircularProgressIndicator(
                              strokeWidth: 1,
                            ),
                          ),
                        ),
                        Visibility(
                            visible: !model.canLoadPlaceInfo,
                            child: SizedBox(width: 10)),
                        Text(
                          !model.canLoadPlaceInfo
                              ? "Getting your location."
                              : 'Please choose your location',
                          style: TextStyle(
                            color: AppColors.accent,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  );
                } else if (model.placeInfo.isError && !model.isCameraMoving) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15.0),
                    child: Center(
                      child: Text(
                        'Something went wrong, try agian.!',
                        style: TextStyle(
                          color: AppColors.error.withOpacity(0.9),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                }

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Builder(
                        builder: (context) {
                          if (model.isCameraMoving) return ListShimmerBlock();
                          return Text(
                            model?.placeInfo?.address ?? '',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              height: 1.2,
                              fontSize: 13,
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(width: 15),
                    PrimaryButton(
                      text: "Choose",
                      height: 45,
                      width: 75,
                      textStyle: TextStyle(color: Colors.white),
                      elevation: 0,
                      padding: const EdgeInsets.all(0),
                      onTap: (startLoading, stopLoading, btnState) async =>
                          model.chooseLocation(startLoading, stopLoading),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
