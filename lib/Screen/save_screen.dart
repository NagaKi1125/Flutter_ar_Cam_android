import 'dart:io';
import 'package:flutter_ar_cam/Screen/upload_post.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class SaveImageScreen extends StatefulWidget {
  final List arguments;
  SaveImageScreen({this.arguments});
  @override
  _SaveImageScreenState createState() => _SaveImageScreenState();
}

class _SaveImageScreenState extends State<SaveImageScreen> {
  File image;
  bool savedImage;
  @override
  void initState() {
    super.initState();
    image = widget.arguments[0];
    savedImage = false;
  }

  Future saveImage() async {
    renameImage();
    await GallerySaver.saveImage(image.path, albumName: "PhotoEditor");
    setState(() {
      savedImage = true;
    });
  }

  void renameImage() {
    String ogPath = image.path;
    List<String> ogPathList = ogPath.split('/');
    String ogExt = ogPathList[ogPathList.length - 1].split('.')[1];
    DateTime today = new DateTime.now();
    String dateSlug =
        "${today.day.toString().padLeft(2, '0')}-${today.month.toString().padLeft(2, '0')}-${today.year.toString()}_${today.hour.toString().padLeft(2, '0')}-${today.minute.toString().padLeft(2, '0')}-${today.second.toString().padLeft(2, '0')}";
    image = image.renameSync(
        "${ogPath.split('/image')[0]}/PhotoEditor_$dateSlug.$ogExt");
    print(image.path);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        title: Text(
          "Export Photo",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: <Widget>[
            ClipRRect(
              child: Container(
                color: Theme.of(context).hintColor,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.width * 0.9,
                child: PhotoView(
                  imageProvider: FileImage(image),
                  backgroundDecoration: BoxDecoration(
                    color: Theme.of(context).hintColor,
                  ),
                ),
              ),
            ),
            //
            Spacer(),
            Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FloatingActionButton.extended(
                      disabledElevation: 0,
                      heroTag: "SAVE",
                      icon: Icon(Icons.save),
                      label: savedImage ? Text("SAVED") : Text("SAVE"),
                      backgroundColor: savedImage
                          ? Colors.grey
                          : Theme.of(context).primaryColor,
                      onPressed: savedImage
                          ? null
                          : () {
                              saveImage();
                            }),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FloatingActionButton.extended(
                      heroTag: "SHARE",
                      icon: Icon(Icons.share),
                      label: Text("SHARE"),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => UploadPost()));
                      }),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FloatingActionButton.extended(
                      heroTag: "Back main",
                      icon: Icon(Icons.arrow_back_rounded),
                      label: Text("Back to main screen"),
                      onPressed: () {
                        Navigator.of(context)
                            .popUntil((route) => route.isFirst);
                      }),
                )
              ],
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width * 0.1,
                    child: Center(
                      child: Icon(
                        Icons.info,
                        color: Theme.of(context).colorScheme.secondary.withOpacity(0.6),
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.4,
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Center(
                        child: Text(
                          "Note - The images are saved in the best possible quality.\nPlease save the photo before sharing",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 10,
                            color:
                                Theme.of(context).colorScheme.secondary.withOpacity(0.6),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
