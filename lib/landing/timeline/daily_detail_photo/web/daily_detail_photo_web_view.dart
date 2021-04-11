// import 'package:flutter/widgets.dart';
//
// class DailyDetailPhotoWebView extends StatefulWidget {
//   DailyDetailPhotoWebView({
//     this.loadingBuilder,
//     this.backgroundDecoration,
//     this.minScale,
//     this.maxScale,
//     this.initialIndex = 0,
//     required this.galleryItems,
//     this.scrollDirection = Axis.horizontal,
//   }) : pageController = PageController(initialPage: initialIndex);
//
//   final LoadingBuilder? loadingBuilder;
//   final BoxDecoration? backgroundDecoration;
//   final dynamic minScale;
//   final dynamic maxScale;
//   final int initialIndex;
//   final PageController pageController;
//   final List<GalleryExampleItem> galleryItems;
//   final Axis scrollDirection;
//
//   @override
//   State<StatefulWidget> createState() {
//     return _GalleryPhotoViewWrapperState();
//   }
// }
//
// class _GalleryPhotoViewWrapperState extends State<DailyDetailPhotoWebView> {
//   late int currentIndex = widget.initialIndex;
//
//   void onPageChanged(int index) {
//     setState(() {
//       currentIndex = index;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: widget.backgroundDecoration,
//       width: MediaQuery.of(context).size.width,
//       height: MediaQuery.of(context).size.height,
//       // height: 600,
//       // width: 500,
//       // constraints: BoxConstraints.expand(
//       //   height: MediaQuery.of(context).size.height,
//       // ),
//       child: Stack(
//         alignment: Alignment.bottomRight,
//         children: <Widget>[
//           Align(
//             alignment: Alignment.centerLeft,
//             child: Icon(Icons.arrow_back_outlined, size: 30),
//           ),
//           Padding(
//               padding: EdgeInsets.all(20),
//               child: PhotoViewGallery.builder(
//                 scrollPhysics: const BouncingScrollPhysics(),
//                 builder: _buildItem,
//                 itemCount: widget.galleryItems.length,
//                 loadingBuilder: widget.loadingBuilder,
//                 backgroundDecoration: widget.backgroundDecoration,
//                 pageController: widget.pageController,
//                 onPageChanged: onPageChanged,
//                 scrollDirection: widget.scrollDirection,
//               )),
//           Container(
//             padding: const EdgeInsets.all(20.0),
//             child: Text(
//               "Image ${currentIndex + 1}",
//               style: const TextStyle(
//                 color: Colors.white,
//                 fontSize: 17.0,
//                 decoration: null,
//               ),
//             ),
//           ),
//           Align(
//             alignment: Alignment.centerRight,
//             child: GestureDetector(
//               child: Icon(Icons.arrow_forward_outlined, size: 30),
//               onTap: () => widget.pageController.animateToPage(
//                   (widget.pageController.page ?? 0).toInt() + 1,
//                   curve: Curves.easeIn,
//                   duration: Duration(milliseconds: 500)),
//             ),
//           )
//         ],
//       ),
//     );
//   }
//
//   PhotoViewGalleryPageOptions _buildItem(BuildContext context, int index) {
//     final GalleryExampleItem item = widget.galleryItems[index];
//     return item.isSvg
//         ? PhotoViewGalleryPageOptions.customChild(
//       child: SvgPicture.asset(
//         item.resource,
//         color: Theme.of(context).colorScheme.primary,
//         fit: BoxFit.contain,
//       ),
//       initialScale: PhotoViewComputedScale.contained,
//       minScale: PhotoViewComputedScale.contained,
//       maxScale: PhotoViewComputedScale.covered * 4.1,
//       heroAttributes: PhotoViewHeroAttributes(tag: item.id),
//     )
//         : PhotoViewGalleryPageOptions(
//       imageProvider: AssetImage(item.resource),
//       initialScale: PhotoViewComputedScale.contained,
//       minScale: PhotoViewComputedScale.contained,
//       maxScale: PhotoViewComputedScale.covered * 4.1,
//       heroAttributes: PhotoViewHeroAttributes(tag: item.id),
//     );
//   }
// }
//
// class GalleryExampleItem {
//   GalleryExampleItem({
//     required this.id,
//     required this.resource,
//     this.isSvg = false,
//   });
//
//   final String id;
//   final String resource;
//   final bool isSvg;
// }
