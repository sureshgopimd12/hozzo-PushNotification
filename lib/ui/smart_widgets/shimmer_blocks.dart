import 'package:flutter/material.dart';
import 'package:hozzo/theme/app-theme.dart';
import 'package:shimmer/shimmer.dart';

class ListShimmerBlock extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.grey,
      highlightColor: AppColors.backgroundColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(height: 8.0, color: Colors.white),
          SizedBox(height: 4.0),
          Container(height: 8.0, color: Colors.white),
          SizedBox(height: 4.0),
          Container(width: 40.0, height: 8.0, color: Colors.white),
        ],
      ),
    );
  }
}
