import 'package:flutter/material.dart';
import 'package:swipe_photos/src/swipe_photos.dart';

class HomePageWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget> {
  final List<ServerImageItem> galleryItems = <ServerImageItem>[
    ServerImageItem(id: "tag1", filePath: "assets/gallery1.jpg", resourceType: ResourceType.asset, fileName: "gallery1.jpg", fileSize: 12343),
    ServerImageItem(id: "tag3", filePath: "assets/gallery2.jpg", resourceType: ResourceType.asset, fileName: "gallery2.jpg", fileSize: 12343),
    ServerImageItem(id: "tag4", filePath: "assets/gallery3.jpg", resourceType: ResourceType.asset, fileName: "gallery3.jpg", fileSize: 12343),
    ServerImageItem(
        id: "tag5",
        filePath: "https://raw.githubusercontent.com/bluefireteam/photo_view/main/example/assets/gallery1.jpg",
        resourceType: ResourceType.network,
        fileName: "gallery1_url.jpg",
        fileSize: 12343),
  ];

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FilledButton.tonal(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => GalleryPhotoViewWrapper<ServerImageItem, Container>(
                          initialIndex: 1,
                          galleryItems: galleryItems,
                          captionOpacity: 0.5,
                          captionBuilder: (ServerImageItem item) {
                            return Container(
                              margin: const EdgeInsets.only(bottom: 50),
                              child: Card(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ListTile(
                                      leading: const Icon(Icons.info_rounded),
                                      title: Text(item.fileName, style: const TextStyle(color: Colors.green, fontSize: 18)),
                                      subtitle: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("Path: ${item.filePath}"),
                                          const SizedBox(
                                            height: 6,
                                          ),
                                          Text("Size: ${formatBytes(item.fileSize)}"),
                                          const SizedBox(
                                            height: 6,
                                          ),
                                          // Text("Created: ${formatMilliSec(widget.imageFileObj.lastModified.toString())}"),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        )));
          },
          child: const Text("Click")),
    );
  }

  String formatBytes(int bytes) {
    var inKB = bytes / 1024;
    var inMB = inKB / 1024;
    var inGB = inMB / 1024;
    var result = "${inGB.toStringAsFixed(2)} gb";
    if (inGB < 1) {
      result = "${inMB.toStringAsFixed(2)} mb";
    }
    if (inMB < 1) {
      result = "${inKB.toStringAsFixed(2)} kb";
    }
    return result;
  }
}

class ServerImageItem extends ImageItem {
  ServerImageItem({required this.fileName, required super.filePath, required this.fileSize, required super.id, required super.resourceType});

  final String fileName;
  final int fileSize;
}
