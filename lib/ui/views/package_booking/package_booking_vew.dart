import 'dart:io';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hozzo/app/asset_data.dart';
import 'package:hozzo/datamodels/customer_vehicle.dart';
import 'package:hozzo/datamodels/serviceman.dart';
import 'package:hozzo/hooks/date_picker_controller_hook.dart';
import 'package:hozzo/hooks/page_controller_hook.dart';
import 'package:hozzo/plugins/date_picker_timeline.dart';
import 'package:hozzo/theme/app-theme.dart';
import 'package:hozzo/ui/smart_widgets/app_drawer/app_drawer.dart';
import 'package:hozzo/ui/smart_widgets/app_dropdown/app_dropdown_item.dart';
import 'package:hozzo/ui/smart_widgets/load_image.dart';
import 'package:hozzo/ui/smart_widgets/primary_app_bar/primary_app_bar.dart';
import 'package:hozzo/ui/smart_widgets/primary_button.dart';
import 'package:hozzo/ui/smart_widgets/title_back_button/title_back_button.dart';
import 'package:hozzo/ui/views/package_booking/package_booking_viewmodel.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:stacked/stacked.dart';
import 'package:intl/intl.dart';

class PackageBookingView extends HookWidget {
  final TextEditingController searchController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final pageController = usePageController();
    final datePickerController = useDatePickerController();
    return ViewModelBuilder<PackageBookingViewModel>.reactive(
      builder: (context, model, child) {
        return Scaffold(
          key: model.scaffoldKey,
          appBar: PrimaryAppBar(model.scaffoldKey),
          drawer: AppDrawer(),
          body: Column(
            children: [
              _buildTitle(model),
              Expanded(
                child: Builder(
                  builder: (context) {
                    if (model.isBusy) {
                      return _bookingLoader(size);
                    }
                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          _buildCarChoosing(model),
                          _buildServiceManChoosing(model),
                          _buildSelectDateSection(model),
                          _buildSelectTimeSlotSection(model),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(
                                30.0, 30.0, 20.0, 50.0),
                            child: PrimaryButton(
                              text: "Proceed to Payment",
                              onTap: (startLoading, stopLoading, btnState) =>
                              {
                                      model.goToChoosePaymentView(
                                          startLoading, stopLoading),
                              print('buttonpress')
                                    }),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        );
      },
      viewModelBuilder: () => PackageBookingViewModel(
          size: size,
          pageController: pageController,
          datePickerController: datePickerController,
          searchController: searchController),
    );
  }

  Widget _buildSelectTimeSlotSection(PackageBookingViewModel model) {
    return Padding(
      padding: const EdgeInsets.only(left: 42.0, right: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 30),
          Text(
            "Select time slot",
            style: TextStyle(
              // fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 16),
          Builder(
            builder: (context) {
              if (model.isLoadingSlots) {
                return _slotLoader(model);
              }
              return Align(
                alignment: Alignment.topLeft,
                child: Wrap(
                  alignment: WrapAlignment.center,
                  spacing: model.size.width * 0.05,
                  children: model.slots.map((slot) {
                    return InputChip(
                      showCheckmark: false,
                      isEnabled: DateFormat('y-M-d hh:mm a')
                              .parse(
                                  model.selectedDate + " " + slot.name.trim())
                              .isBefore(DateTime.now())
                          ? false
                          : slot.status,
                      label: Container(
                        width: 66,
                        alignment: Alignment.center,
                        padding:
                            EdgeInsets.only(top: Platform.isIOS ? 9.0 : 0.0),
                        child: Text(
                          slot.name.trim(),
                          style: TextStyle(
                            color:
                                slot.isSelected ? Colors.white : Colors.black,
                            fontSize: 13,
                          ),
                        ),
                      ),
                      selected: slot.isSelected,
                      backgroundColor: Colors.white,
                      shape: StadiumBorder(
                        side: BorderSide(
                          color: !slot.isSelected
                              ? AppColors.grey
                              : AppColors.primary,
                        ),
                      ),
                      selectedColor: AppColors.primary,
                      visualDensity: VisualDensity.compact,
                      shadowColor: Colors.grey[60],
                      onSelected: (isSelected) => model.enableSlot(slot),
                    );
                  }).toList(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSelectDateSection(PackageBookingViewModel model) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 42.0, top: 20.0, right: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Select date",
                style: TextStyle(
                  // fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Visibility(
                visible: false,
                child: SizedBox(
                  width: 150,
                  child: DropdownSearch<String>(
                    mode: Mode.BOTTOM_SHEET,
                    showSelectedItem: true,
                    items: model.months,
                    onChanged: (month) => model.onMonthSelect(month),
                    selectedItem: model.selectedMonth,
                    dropDownButton: SvgPicture.asset(
                      AppIcons.dropdownIcon,
                      color: AppColors.accent,
                    ),
                    dropdownBuilder:
                        (BuildContext context, String month, String value) {
                      return Text(
                        model.getSelectedDate(month),
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontFamily: AppTheme.fontFamily,
                          color: Colors.black.withOpacity(0.8),
                          fontWeight: FontWeight.w500,
                        ),
                      );
                    },
                    popupItemBuilder:
                        (BuildContext context, String month, bool status) {
                      return ListTile(
                        title: Text(
                          month,
                          style: TextStyle(
                            color: model.selectedMonth == month
                                ? AppColors.primary
                                : null,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 26.0,
                        ),
                      );
                    },
                    popupTitle: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(24),
                          topRight: Radius.circular(24),
                        ),
                        gradient: LinearGradient(
                          colors: [
                            AppColors.primary,
                            AppColors.accent,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          "Select Month",
                          style: TextStyle(
                            fontFamily: AppTheme.fontFamily,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    popupShape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24),
                      ),
                    ),
                    dropdownSearchDecoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(0),
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      focusedErrorBorder: InputBorder.none,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 10,
        ),
        DatePicker(
          model.startingDate,
          controller: model.datePickerController,
          initialSelectedDate: model.startingDate,
          selectionColor: AppColors.primary,
          borderColor: AppColors.grey,
          daysCount: 10,
          selectedTextColor: Colors.white,
          width: 52.0,
          onDateChange: (date) => model.chooseDate(date),
        ),
      ],
    );
  }

  Widget _buildServiceManChoosing(PackageBookingViewModel model) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 42.0),
          child: Text(
            "Choose serviceman",
            style: TextStyle(
              // fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 42.0, top: 20.0, right: 30.0),
          child: InkWell(
            onTap: () {},
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(26),
              bottomLeft: Radius.circular(26),
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border.all(color: AppColors.primary),
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(26),
                  bottomLeft: Radius.circular(26),
                  // bottomRight: Radius.circular(26),
                ),
              ),
              margin: const EdgeInsets.all(0),
              child: SizedBox(
                child: DropdownSearch<AppDropDownItem<Serviceman>>(
                  mode: Mode.BOTTOM_SHEET,
                  onFind: (filter) => model.getServicemen(filter),
                  onChanged: (item) => model.selectServiceman(item),
                  searchBoxController: searchController,
                  selectedItem: model.selectedServiceman,
                  filterFn: (value, string) =>
                      model.searchFilter(value, string),
                  showSearchBox: true,
                  compareFn: (AppDropDownItem i, AppDropDownItem s) =>
                      i.isEqual(s),
                  dropDownButton: SvgPicture.asset(
                    AppIcons.dropdownIcon,
                    color: AppColors.accent,
                  ),
                  dropdownBuilder: (BuildContext context,
                      AppDropDownItem<Serviceman> item, String value) {
                    return buildDropDownHead(item.value);
                  },
                  popupItemBuilder: (BuildContext context,
                      AppDropDownItem<Serviceman> item, bool status) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      child: ListTile(
                        leading: CircleAvatar(
                          radius: 22,
                          backgroundColor: AppColors.accent,
                          child: CircleAvatar(
                            radius: 20,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(45.0),
                              child: LoadImage(
                                url: item.value.image.url,
                              ),
                            ),
                          ),
                        ),
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.value.name,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              "${item.value.phone}",
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textColor,
                              ),
                            ),
                          ],
                        ),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(item.value.rating.toString(),
                                style: TextStyle(fontWeight: FontWeight.w500)),
                            RatingBar(
                              initialRating: item.value.rating,
                              minRating: 1,
                              itemCount: 5,
                              itemSize: 15,
                              allowHalfRating: true,
                              ignoreGestures: true,
                              onRatingUpdate: null,
                              ratingWidget: RatingWidget(
                                full: SvgPicture.asset(AppIcons.starFull),
                                half: SvgPicture.asset(AppIcons.starHalf),
                                empty: SvgPicture.asset(AppIcons.starEmpty),
                              ),
                            ),
                          ],
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 26.0,
                        ),
                      ),
                    );
                  },
                  popupTitle: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24),
                      ),
                      gradient: LinearGradient(
                        colors: [
                          AppColors.primary,
                          AppColors.accent,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        "Choose Serviceman",
                        style: TextStyle(
                          fontFamily: AppTheme.fontFamily,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  popupShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                  ),
                  searchBoxDecoration: InputDecoration(
                    enabledBorder: new OutlineInputBorder(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(24),
                        bottomRight: Radius.circular(24),
                        bottomLeft: Radius.circular(24),
                      ),
                      borderSide: BorderSide(color: AppColors.accent),
                    ),
                    focusedBorder: new OutlineInputBorder(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(24),
                        bottomRight: Radius.circular(24),
                        bottomLeft: Radius.circular(24),
                      ),
                      borderSide: BorderSide(color: AppColors.accent),
                    ),
                    contentPadding: EdgeInsets.fromLTRB(20, 12, 8, 12),
                    labelText: "Search",
                    labelStyle: TextStyle(
                      color: AppColors.textColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                    suffixIcon: Container(
                      margin: const EdgeInsets.only(right: 10),
                      padding: const EdgeInsets.all(10.0),
                      child: SvgPicture.asset(AppIcons.search,
                          color: AppColors.primary),
                    ),
                  ),
                  dropdownSearchDecoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(0),
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    focusedErrorBorder: InputBorder.none,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildDropDownHead(Serviceman serviceman) {
    return InkWell(
      child: Padding(
        padding: EdgeInsets.fromLTRB(15.0, 10.0, 0.0, 10.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 32,
              backgroundColor: AppColors.accent,
              child: CircleAvatar(
                radius: 30,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(45.0),
                  child: LoadImage(
                    url: serviceman.image.url,
                  ),
                ),
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${serviceman.name}",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "${serviceman.phone}",
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textColor,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                Text(serviceman.rating.toString(),
                    style: TextStyle(fontWeight: FontWeight.w500)),
                RatingBar(
                  initialRating: serviceman.rating,
                  minRating: 1,
                  itemCount: 5,
                  itemSize: 15,
                  allowHalfRating: true,
                  ignoreGestures: true,
                  onRatingUpdate: null,
                  ratingWidget: RatingWidget(
                    full: SvgPicture.asset(AppIcons.starFull),
                    half: SvgPicture.asset(AppIcons.starHalf),
                    empty: SvgPicture.asset(AppIcons.starEmpty),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCarChoosing(PackageBookingViewModel model) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 42.0),
          child: Text(
            "Your car",
            style: TextStyle(
              // fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        SizedBox(
          height: 160,
          child: Stack(
            children: [
              PageView(
                controller: model.pageController,
                onPageChanged: (index) => model.onVehicleChoose(index),
                children: model.customerVehicles
                    .map((vehicle) => _buildVehicleItem(model.size, vehicle))
                    .toList(),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 30.0),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: SmoothPageIndicator(
                    count: model.customerVehicles.length,
                    controller: model.pageController,
                    effect: ExpandingDotsEffect(
                      expansionFactor: 2,
                      dotHeight: 5,
                      dotWidth: 5,
                      radius: 100,
                      activeDotColor: AppColors.accent,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Stack _buildVehicleItem(Size size, CustomerVehicle vehicle) {
    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.fromLTRB(42.0, 16.0, 30.0, 16.0),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.primary),
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(26),
              bottomLeft: Radius.circular(26),
              // bottomRight: Radius.circular(26),
            ),
          ),
          child: Container(
            alignment: Alignment.topLeft,
            margin:
                EdgeInsets.fromLTRB(size.width * 0.3 + 26.0, 16.0, 0.0, 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      vehicle.vehicleModel.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      vehicle.vehicleModel.vehicleBrand.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: AppColors.textColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      vehicle.vehicleModel.vehicleType.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: AppColors.accent,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      vehicle.vehicleNumber,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Container(
          width: size.width * 0.3,
          height: size.height * 0.2,
          padding: const EdgeInsets.all(10.0),
          margin: const EdgeInsets.only(left: 54.0, top: 28.0),
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(26),
              bottomLeft: Radius.circular(26),
              bottomRight: Radius.circular(26),
            ),
          ),
          child: LoadImage(
            url: vehicle.vehicleModel.image.url,
            fit: BoxFit.fitWidth,
          ),
        ),
      ],
    );
  }

  Container _buildTitle(PackageBookingViewModel model) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(left: 12.0, right: 30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 8, left: 30),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: model.selectedPackages
                              .map((package) => Text(
                                    package.name,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17,
                                      height: 1.3,
                                    ),
                                  ))
                              .toList(),
                        ),
                      ),
                      TitleBackButton(),
                    ],
                  ),
                ),
                Text(
                  model.packagesTotalShowAmount,
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                    height: 1.3,
                  ),
                ),
              ],
            ),
            // Padding(
            //   padding: const EdgeInsets.only(left: 30),
            //   child: Text(
            //     "Service Time: 45 Min",
            //     style: TextStyle(
            //       color: AppColors.textColor,
            //       fontWeight: FontWeight.w600,
            //       fontSize: 12,
            //       height: 1.3,
            //     ),
            //   ),
            // ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _bookingLoader(Size size) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300],
      highlightColor: Colors.grey[100],
      child: ListView.builder(
        padding: const EdgeInsets.only(
            left: 42.0, right: 30.0, top: 30.0, bottom: 10.0),
        itemBuilder: (_, __) => Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 8.0,
                color: Colors.white,
              ),
              SizedBox(height: 5),
              Container(
                width: size.width / 2,
                height: 8.0,
                color: Colors.white,
              ),
              SizedBox(height: 5),
              Container(
                width: ((size.width / 2) / 2),
                height: 8.0,
                color: Colors.white,
              ),
            ],
          ),
        ),
        itemCount: 3,
      ),
    );
  }

  Widget _slotLoader(PackageBookingViewModel model) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300],
      highlightColor: Colors.grey[100],
      child: Align(
        alignment: Alignment.topLeft,
        child: Wrap(
          alignment: WrapAlignment.start,
          spacing: model.size.width * 0.05,
          children: List<Widget>.generate(11, (i) {
            return InputChip(
              showCheckmark: false,
              isEnabled: false,
              label: Container(
                width: 66,
                alignment: Alignment.center,
                padding: EdgeInsets.only(top: Platform.isIOS ? 9.0 : 0.0),
              ),
              backgroundColor: Colors.white,
              shape: StadiumBorder(
                side: BorderSide(color: AppColors.grey),
              ),
              selectedColor: AppColors.primary,
              visualDensity: VisualDensity.compact,
              shadowColor: Colors.grey[60],
            );
          }),
        ),
      ),
    );
  }
}
