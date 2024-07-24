// ignore_for_file: must_be_immutable, deprecated_member_use

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jahnhalle/utils/extensions.dart';

class ImageWidget<T> extends StatelessWidget {
  String url;
  File? imageFile;
  double? height, width;
  BoxFit? fit;
  Color? color;
  ImageWidget(
      {super.key,
      this.url = '',
      this.imageFile,
      this.color,
      this.fit,
      this.height,
      this.width});

  @override
  Widget build(BuildContext context) {
    if (T == File) {
      if (imageFile != null) {
        return Image.file(
          imageFile!,
          height: height,
          width: width,
          color: color,
          scale: 8,
          fit: fit ?? BoxFit.contain,
        );
      } else {
        return const SizedBox();
      }
    } else {
      if (url.isEmpty) {
        return const SizedBox();
      } else if (url.startsWith("http://") || url.startsWith("https://")) {
        if (url.getExtension() == "svg") {
          return SvgPicture.network(
            url,
            height: height,
            width: width,
            color: color,
            fit: fit ?? BoxFit.contain,
          );
        } else {
          return CachedNetworkImage(
            imageUrl: url,
            height: height,
            width: width,
            color: color,
            fit: fit,
            errorWidget: (context, url, error) => Icon(
              CupertinoIcons.person_alt,
              size: width,
              color: Colors.grey,
            ),
            progressIndicatorBuilder: (context, url, progress) => const Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      } else if (url.getExtension() == "svg") {
        return SvgPicture.asset(
          url,
          height: height,
          width: width,
          color: color,
          fit: fit ?? BoxFit.contain,
        );
      } else {
        return Image.asset(
          url,
          height: height,
          width: width,
          color: color,
          errorBuilder: (context, error, stackTrace) => const SizedBox(),
          fit: fit,
        );
      }
    }
  }
}
