import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class NotePhotoGallery extends StatelessWidget {
  final List<String> photoUrls;

  const NotePhotoGallery({Key? key, required this.photoUrls}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: PhotoViewGallery.builder(
        itemCount: photoUrls.length,
        builder: (context, index) {
          return PhotoViewGalleryPageOptions(
            imageProvider: NetworkImage(
              photoUrls[index],
            ),
            minScale: PhotoViewComputedScale.covered,
            maxScale: PhotoViewComputedScale.covered * 2,
          );
        },
        scrollPhysics: const ClampingScrollPhysics(),
        backgroundDecoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          color: Theme.of(context).canvasColor,
        ),
        enableRotation: false,
        loadingBuilder: (context, event) => Center(
          child: SizedBox(
            width: 30.0,
            height: 30.0,
            child: CircularProgressIndicator(
              backgroundColor: Colors.orange,
              value: event?.expectedTotalBytes == null ||
                      event?.cumulativeBytesLoaded == null
                  ? 0
                  : event!.cumulativeBytesLoaded / event.expectedTotalBytes!,
            ),
          ),
        ),
      ),
    );
  }
}
