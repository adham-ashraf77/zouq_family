import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class MagnifyPhotoScreen extends StatefulWidget {
  List photos;
  String itemTitle;

  MagnifyPhotoScreen(this.photos, this.itemTitle);

  static List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }

    return result;
  }

  @override
  _MagnifyPhotoScreenState createState() => _MagnifyPhotoScreenState();
}

class _MagnifyPhotoScreenState extends State<MagnifyPhotoScreen> {
  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[50],
        title: Text(
          "${widget.itemTitle}",
          style: TextStyle(color: Colors.green),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.green,
            size: 30,
          ),
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            PhotoViewGallery.builder(
              backgroundDecoration: BoxDecoration(color: Colors.white),
              scrollPhysics: const BouncingScrollPhysics(),
              builder: (BuildContext context, int index) {
                return PhotoViewGalleryPageOptions(
                  imageProvider: NetworkImage(widget.photos[index]),
                  initialScale: PhotoViewComputedScale.contained * 0.8,
                  maxScale: 2.5,
                  minScale: 0.1,
                );
              },
              itemCount: widget.photos.length,
              onPageChanged: (index) {
                currentPage = index;
                setState(() {});
              },
              loadingBuilder: (context, event) => Center(
                child: Container(
                  width: 20.0,
                  height: 20.0,
                  child: CircularProgressIndicator(
                    value: event == null ? 0 : event.cumulativeBytesLoaded / event.expectedTotalBytes,
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: MagnifyPhotoScreen.map<Widget>(
                  widget.photos,
                  (index, url) {
                    return Container(
                      width: 15.0,
                      height: 15.0,
                      margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: currentPage == index ? Colors.green : Colors.grey[300]),
                    );
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
