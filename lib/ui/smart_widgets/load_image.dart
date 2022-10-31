import 'package:cached_network_image/cached_network_image.dart';
import 'package:hozzo/theme/app-theme.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class LoadImage extends StatelessWidget {
  const LoadImage({
    @required this.url,
    this.fit = BoxFit.cover,
    this.height,
    this.width,
    this.alignment = Alignment.center,
    Key key,
  }) : super(key: key);

  final String url;
  final BoxFit fit;
  final double height;
  final double width;
  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        try {
          if (this.url != null && this.url.isNotEmpty) {
            return CachedNetworkImage(
              fit: fit,
              imageUrl: url,
              height: height,
              width: width,
              alignment: alignment,
              placeholder: (context, url) => showShimmer(),
              errorWidget: (context, url, error) => showError(),
            );
          }
          return showError();
        } catch (e) {
          return Placeholder();
        }
      },
    );
  }

  Shimmer showError() {
    return Shimmer.fromColors(
      baseColor: Colors.yellow,
      highlightColor: Colors.red,
      child: Container(
        width: double.infinity,
        child: Icon(
          Icons.error,
          size: 36,
        ),
      ),
    );
  }

  Shimmer showShimmer() {
    return Shimmer.fromColors(
      baseColor: AppColors.primary,
      highlightColor: AppColors.accent,
      child: Container(
        alignment: Alignment.center,
        color: AppColors.primary,
      ),
    );
  }
}
