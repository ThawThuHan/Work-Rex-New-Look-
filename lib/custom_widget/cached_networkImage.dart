import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CustomCachedNetworkImage extends StatelessWidget {
  final String mediaUrl;

  CustomCachedNetworkImage({this.mediaUrl});

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: mediaUrl,
      fit: BoxFit.cover,
      placeholder: (context, url) =>
          Image.asset('assets/images/defaultplaceholderimage.png'),
      errorWidget: (context, url, error) =>
          Image.asset('assets/images/defaultplaceholderimage.png'),
    );
  }
}
