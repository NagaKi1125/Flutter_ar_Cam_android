import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_ar_cam/SharedPreferences/UserPreferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

class UploadPost extends StatefulWidget {
  @override
  _UploadPostState createState() => _UploadPostState();
}
class _UploadPostState extends State<UploadPost> {
  /// Variables
  File imageFile;
  TextEditingController content_controller = new TextEditingController();

  /// Widget
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Image Picker"),
        ),
        body: Container(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ListTile(
                    leading: Text('Contents: ',style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
                    title: TextField(
                        controller: content_controller,
                        maxLines: 6,
                        decoration: InputDecoration(
                            border: UnderlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                            fillColor: Color(0xfff3f3f4),
                            filled: true))
                  ),
                  ListTile(
                    leading: Text('Image: ',style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
                    title: imageFile == null ?
                      Container(
                        child: Center(child: Icon(Icons.image_search),),
                      ) :
                      Container(
                        child: Image.file(
                          imageFile,
                          fit: BoxFit.contain,
                        ),
                      ),
                    subtitle: TextButton(
                      onPressed: () {
                        _getFromGallery();
                      },
                      child: Text("PICK FROM GALLERY"),
                    ),
                  ),
                  Divider(color: Colors.grey,),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.blueAccent,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: SizedBox(
                          width: double.infinity,
                          child: TextButton(
                            child: Text('Upload post',style: TextStyle(color: Colors.white),),
                            onPressed: (){
                              if(imageFile == null){
                                ScaffoldMessenger.of(context)
                                    .showSnackBar( SnackBar(
                                    content: Text('Please select an image'))
                                );
                              }else if(content_controller.text.trim().isEmpty){
                                ScaffoldMessenger.of(context)
                                    .showSnackBar( SnackBar(
                                    content: Text('Please type in somethings'))
                                );
                              }else {
                                setState(() {
                                  _uploadPost(imageFile,content_controller.text);
                                });
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.blueAccent,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: SizedBox(
                          width: double.infinity,
                          child: TextButton(
                            child: Text('Back to main screen',style: TextStyle(color: Colors.white),),
                            onPressed: (){
                              Navigator.of(context).popUntil((route) => route.isFirst);
                            },
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )));
  }


  _uploadPost(File image, String text) async {
    var stream = new http.ByteStream(Stream.castFrom(image.openRead()));
    var length = await image.length();

    var uri = Uri.parse('${UserPreferences.getBaseURL()}user/social-add');

    var request = new http.MultipartRequest("POST", uri);
    var multipart = new http.MultipartFile('image', stream, length,
      filename: basename(image.path));
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${UserPreferences.getToken()}',};

    request.fields['contents'] = text;

    request.headers.addAll(headers);
    request.files.add(multipart);

    var response = await request.send();
    print(response.statusCode);
    if(response.statusCode == 200){

    }
    response.stream.transform(utf8.decoder).listen((event) {
      print(event);
    });

  }

  /// Get from gallery
  _getFromGallery() async {
    PickedFile pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxWidth: 1000,
      maxHeight: 1000,
    );
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
    }
  }
}