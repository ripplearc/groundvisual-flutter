import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:groundvisual_flutter/landing/timeline/model/gallery_item.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:groundvisual_flutter/extensions/collection.dart';
import 'package:groundvisual_flutter/extensions/scoped.dart';

/// Build a photo item in the gallery. It is capable of building either a SVG
/// or an image asset.
mixin DailyDetailGalleryViewBuilder {
  static const double ScaleFactor = 3;

  PhotoViewGalleryPageOptions buildItem(
          BuildContext context, List<GalleryItem> galleryItems, int index) =>
      galleryItems.getOrNull<GalleryItem>(index)?.let((item) =>
          item.isSvg ? _buildSvg(item, context) : _buildImageAsset(item)) ??
      _buildDefaultItem();

  PhotoViewGalleryPageOptions _buildSvg(
          GalleryItem item, BuildContext context) =>
      PhotoViewGalleryPageOptions.customChild(
        child: SvgPicture.asset(
          item.resource,
          color: Theme.of(context).colorScheme.primary,
          fit: BoxFit.contain,
        ),
        initialScale: PhotoViewComputedScale.contained,
        minScale: PhotoViewComputedScale.contained,
        maxScale: PhotoViewComputedScale.contained,
        heroAttributes: PhotoViewHeroAttributes(tag: item.tag),
      );

  PhotoViewGalleryPageOptions _buildImageAsset(GalleryItem item) =>
      PhotoViewGalleryPageOptions(
        imageProvider: AssetImage(item.resource),
        initialScale: PhotoViewComputedScale.contained,
        minScale: PhotoViewComputedScale.contained,
        maxScale: PhotoViewComputedScale.covered * ScaleFactor,
        heroAttributes: PhotoViewHeroAttributes(tag: item.tag),
      );

  PhotoViewGalleryPageOptions _buildDefaultItem() =>
      PhotoViewGalleryPageOptions.customChild(
        child: Icon(Icons.broken_image_outlined, size: 180),
        initialScale: PhotoViewComputedScale.contained,
        minScale: PhotoViewComputedScale.contained,
        maxScale: PhotoViewComputedScale.contained,
        heroAttributes: PhotoViewHeroAttributes(tag: "unknown"),
      );
}
