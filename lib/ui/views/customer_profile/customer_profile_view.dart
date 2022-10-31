import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hozzo/ui/smart_widgets/app_drawer/app_drawer.dart';
import 'package:hozzo/ui/smart_widgets/option_tile/option_tile.dart';
import 'package:hozzo/ui/smart_widgets/primary_app_bar/primary_app_bar.dart';
import 'package:hozzo/ui/views/customer_profile/customer_profile_viewmodel.dart';
import 'package:stacked/stacked.dart';

class CustomerProfileView extends HookWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CustomerProfileViewModel>.reactive(
      builder: (context, model, child) {
        return WillPopScope(
          onWillPop: () => model.goToHome(),
          child: Scaffold(
            key: model.scaffoldKey,
            drawer: AppDrawer(),
            body: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          _buildProfileImage(
                              boxConstraints: constraints, model: model),
                          Container(
                            height: constraints.maxHeight / 2,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  const Color(0x00000000),
                                  const Color(0x00000000),
                                  const Color(0x00000000),
                                  const Color(0x00000000),
                                  const Color(0xCC000000),
                                ],
                              ),
                            ),
                          ),
                          _buildTextOnImage(
                              name: model.user.name,
                              boxConstraints: constraints,
                              model: model),
                          Positioned(
                            child: PrimaryAppBar(model.scaffoldKey),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      OptionTile(
                        header: 'Phone Number :',
                        title: model.user.phone,
                        icon: Icons.phone,
                        showArrow: false,
                        onOptionTap: () {},
                      ),
                      OptionTile(
                        header: 'E-mail :',
                        title: model.user.email,
                        icon: Icons.mail,
                        showArrow: false,
                        onOptionTap: () {},
                      ),
                      OptionTile(
                        title: 'Manage Address',
                        icon: Icons.location_on,
                        onOptionTap: () => model.goToManageAddress(),
                      ),
                      OptionTile(
                        title: 'My Vehicles',
                        icon: Icons.directions_car_sharp,
                        onOptionTap: () => model.goToMyVehicles(),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
      viewModelBuilder: () => CustomerProfileViewModel(),
    );
  }
}

Widget _buildTextOnImage(
    {String name,
    BoxConstraints boxConstraints,
    CustomerProfileViewModel model}) {
  return Positioned(
    top: boxConstraints.maxHeight / 2.3,
    width: boxConstraints.maxWidth,
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            name,
            style: TextStyle(color: Colors.white, fontSize: 24),
          ),
          InkWell(
            radius: 100,
            enableFeedback: true,
            onTap: () => model.goToEditProfile(),
            child: Icon(
              Icons.edit_rounded,
              color: Colors.white,
              size: 20,
            ),
          )
        ],
      ),
    ),
  );
}

Widget _buildProfileImage(
    {BoxConstraints boxConstraints, CustomerProfileViewModel model}) {
  return Align(
    alignment: Alignment.topCenter,
    child: Container(
      height: boxConstraints.maxHeight / 2,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(model.user.image.url),
          fit: BoxFit.cover,
        ),
      ),
    ),
  );
}

// Container _buildTitle(bool isFromDrawer) {
//   return Container(
//     child: Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 12.0),
//       child: Stack(
//         children: [
//           TitleBackButton(isFromDrawer: isFromDrawer),
//         ],
//       ),
//     ),
//   );
// }
