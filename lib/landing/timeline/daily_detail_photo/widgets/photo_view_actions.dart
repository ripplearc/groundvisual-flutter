import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:groundvisual_flutter/landing/timeline/model/gallery_item.dart';
import 'package:groundvisual_flutter/extensions/collection.dart';
import 'package:groundvisual_flutter/extensions/scoped.dart';

mixin PhotoViewAccessories {
  List<Widget> buildActions(BuildContext context, {bool simplified = false}) =>
      simplified ? _buildIconsOnly() : _buildButtons(context);

  List<Widget> buildTitleContent(
          List<GalleryItem> galleryItems, int index, BuildContext context,
          {TextStyle? style}) =>
      galleryItems.getOrNull<GalleryItem>(index)?.let((item) => [
            Text(item.tag,
                style: style ?? Theme.of(context).textTheme.headline6),
            if (item.statusLabel.isNotEmpty)
              Text(item.statusLabel,
                  style: style ?? Theme.of(context).textTheme.headline6)
          ]) ??
      [];

  List<Widget> _buildButtons(BuildContext context) => [
        Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: OutlinedButton.icon(
                icon: Icon(Icons.favorite_outline),
                label: Text("Save"),
                style: _getStyle(context),
                onPressed: () {})),
        Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: OutlinedButton.icon(
                icon: Icon(Icons.share_outlined),
                label: Text("Share"),
                style: _getStyle(context),
                onPressed: () {}))
      ];

  List<Widget> _buildIconsOnly() => [
        Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Icon(Icons.favorite_border_outlined)),
        Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Icon(Icons.share_outlined)),
      ];

  ButtonStyle _getStyle(BuildContext context) => OutlinedButton.styleFrom(
      minimumSize: Size(120, 45),
      side: BorderSide(color: Theme.of(context).colorScheme.primary));
}
