import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class GalleryPhotoViewWrapper<T extends ImageItem, R extends Widget> extends StatefulWidget {
  GalleryPhotoViewWrapper({
    super.key,
    this.loadingBuilder,
    this.backgroundDecoration,
    this.minScale,
    this.maxScale,
    this.initialIndex = 0,
    required this.galleryItems,
    this.scrollDirection = Axis.horizontal,
    this.captionOpacity = 0.6,
    required this.captionBuilder,
  }) : pageController = PageController(initialPage: initialIndex);

  final LoadingBuilder? loadingBuilder;
  final BoxDecoration? backgroundDecoration;
  final dynamic minScale;
  final dynamic maxScale;
  final int initialIndex;
  final PageController pageController;
  final List<T> galleryItems;
  final Axis scrollDirection;
  final double captionOpacity;

  final R Function(T) captionBuilder;

  @override
  State<StatefulWidget> createState() {
    return _GalleryPhotoViewWrapperState<T, R>();
  }
}

class _GalleryPhotoViewWrapperState<T extends ImageItem, R extends Widget> extends State<GalleryPhotoViewWrapper<T, R>> {
  late int _currentIndex = widget.initialIndex;
  bool _showCaption = true;

  void onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: widget.backgroundDecoration,
        constraints: BoxConstraints.expand(
          height: MediaQuery.of(context).size.height,
        ),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: <Widget>[
            PhotoViewGallery.builder(
              scrollPhysics: const BouncingScrollPhysics(),
              builder: _buildItem,
              itemCount: widget.galleryItems.length,
              loadingBuilder: widget.loadingBuilder,
              backgroundDecoration: widget.backgroundDecoration,
              pageController: widget.pageController,
              onPageChanged: onPageChanged,
              scrollDirection: widget.scrollDirection,
              enableRotation: true,
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  _showCaption = !_showCaption;
                });
              },
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                child: _showCaption
                    ? Opacity(opacity: widget.captionOpacity, child: widget.captionBuilder(widget.galleryItems[_currentIndex]))
                    : IconButton.outlined(onPressed: () => setState(() => _showCaption = !_showCaption), icon: const Icon(Icons.info_rounded)),
              ),
            )
          ],
        ),
      ),
    );
  }

  PhotoViewGalleryPageOptions _buildItem(BuildContext context, int index) {
    final T item = widget.galleryItems[index];
    // item.resourceType == ResourceType.network ? NetworkImage(item.resource) : AssetImage(item.resource);
    return item.resourceType == ResourceType.network
        ? PhotoViewGalleryPageOptions(
            // imageProvider: item.resourceType == ResourceType.asset ? AssetImage(item.resource) : NetworkImage(item.resource),
            imageProvider: CachedNetworkImageProvider(item.filePath),
            initialScale: PhotoViewComputedScale.contained,
            // minScale: PhotoViewComputedScale.contained * (0.5 + index / 10),
            // maxScale: PhotoViewComputedScale.covered * 4.1,
            heroAttributes: PhotoViewHeroAttributes(tag: item.id),
          )
        : PhotoViewGalleryPageOptions(
            // imageProvider: item.resourceType == ResourceType.asset ? AssetImage(item.resource) : NetworkImage(item.resource),
            imageProvider: AssetImage(item.filePath),
            initialScale: PhotoViewComputedScale.contained,
            // minScale: PhotoViewComputedScale.contained * (0.5 + index / 10),
            // maxScale: PhotoViewComputedScale.covered * 4.1,
            heroAttributes: PhotoViewHeroAttributes(tag: item.id),
          );
  }
}

enum ResourceType { asset, network }

class ImageItem {
  final String id;
  final String filePath;
  final ResourceType resourceType;

  ImageItem({
    required this.id,
    required this.filePath,
    required this.resourceType,
  });
}
