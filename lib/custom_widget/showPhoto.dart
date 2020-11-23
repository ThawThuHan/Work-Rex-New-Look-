import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ShowPhoto extends StatefulWidget {
  final String imgUrl;

  ShowPhoto({this.imgUrl});

  @override
  _ShowPhotoState createState() => _ShowPhotoState();
}

class _ShowPhotoState extends State<ShowPhoto> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: PhotoView(
        minScale: PhotoViewComputedScale.contained * 0.8,
        maxScale: PhotoViewComputedScale.covered * 1.8,
        initialScale: PhotoViewComputedScale.contained,
        imageProvider: CachedNetworkImageProvider(widget.imgUrl),
      ),
    );
  }
}
