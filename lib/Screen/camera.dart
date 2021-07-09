import 'package:camera_deep_ar/camera_deep_ar.dart';
import 'package:flutter/material.dart';

const apiKey =
    '8600de7c3f87f26cce5a06292acc0beda8c6df045b9e3fdb91b20dad9f9cd94aa4e6a01bc770333f';

class Camera extends StatefulWidget {
  @override
  _FilterAppState createState() => _FilterAppState();
}

class _FilterAppState extends State<Camera> {
  String _platformVersion = 'Unknown';
  CameraDeepArController cameraDeepArController;
  int currentMaskPage = 0;
  int currentFilterPage = 0;
  int currentEffectPage = 0;
  final vp = PageController(viewportFraction: .24);
  Effects currentEffect = Effects.none;
  Filters currentFilter = Filters.none;
  Masks currentMask = Masks.none;
  bool isRecording = false;
  bool isFrontCamera = false;
  bool _effectVisibility = false;
  bool _maskVisibility = false;
  bool _filterVisibility = false;
  Color _effectActiveColors = Colors.transparent;
  Color _maskActiveColors = Colors.transparent;
  Color _filterActiveColors = Colors.transparent;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            CameraDeepAr(
                onCameraReady: (isReady) {
                  _platformVersion = "Camera status $isReady";
                  setState(() {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(_platformVersion)));
                  });
                },
                onImageCaptured: (path) {
                  _platformVersion = "Image Taken @ $path";
                  setState(() {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(_platformVersion)));
                  });
                },
                onVideoRecorded: (path) {
                  _platformVersion = "Video Recorded @ $path";
                  isRecording = false;
                  setState(() {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(_platformVersion)));
                  });
                },
                androidLicenceKey: apiKey,
                iosLicenceKey: null,
                cameraDeepArCallback: (c) async {
                  cameraDeepArController = c;
                  setState(() {});
                }),
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: EdgeInsets.all(15),
                child: FloatingActionButton(
                  backgroundColor: Colors.transparent,
                  heroTag: 'change_camera',
                  child: Icon(Icons.cameraswitch_outlined),
                  onPressed: () async {
                    if (isFrontCamera==false) {
                      cameraDeepArController.switchCameraDirection(
                          direction: CameraDirection.front);
                      isFrontCamera = true;
                    } else {
                      cameraDeepArController.switchCameraDirection(
                          direction: CameraDirection.back);
                      isFrontCamera = false;
                    }
                  },
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: EdgeInsets.all(20),
                //height: 250,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        FloatingActionButton(
                          heroTag: 'change_effect',
                          onPressed: () async{
                            if(_effectVisibility == false){
                              setState(() {
                                _effectVisibility = true;
                                _effectActiveColors = Colors.lightBlue;
                              });
                            }else {
                              setState(() {
                                _effectVisibility = false;
                                _effectActiveColors = Colors.transparent;
                              });
                            }
                          },
                          child: Icon(Icons.waves),
                          backgroundColor: _effectActiveColors,
                        ),
                        FloatingActionButton(
                          heroTag: 'change_filter',
                          onPressed: () async {
                              if(_filterVisibility == false){
                                setState(() {
                                  _filterVisibility = true;
                                  _filterActiveColors = Colors.lightGreen;
                                });
                              }else{
                                setState(() {
                                  _filterVisibility = false;
                                  _filterActiveColors = Colors.transparent;
                                });
                              }
                          },
                          child: Icon(Icons.photo_camera_back),
                          backgroundColor: _filterActiveColors,
                        ),
                        FloatingActionButton(
                          heroTag: 'snap_photo',
                          onPressed: () {
                            if (null == cameraDeepArController) return;
                            if (isRecording) return;
                            cameraDeepArController.snapPhoto();
                          },
                          child: Icon(Icons.camera_enhance_outlined),
                          backgroundColor: Colors.transparent,
                        ),
                        if (isRecording)
                          FloatingActionButton(
                            heroTag: 'stop_recording_video',
                            onPressed: () {
                              if (null == cameraDeepArController) return;
                              cameraDeepArController.stopVideoRecording();
                              isRecording = false;
                              setState(() {});
                            },
                            child: Icon(Icons.videocam_off),
                            backgroundColor: Colors.transparent,
                          )
                        else
                          FloatingActionButton(
                            heroTag: 'start_recording',
                            onPressed: () {
                              if (null == cameraDeepArController) return;
                              cameraDeepArController.startVideoRecording();
                              isRecording = true;
                              setState(() {});
                            },
                            child: Icon(Icons.videocam),
                            backgroundColor: Colors.transparent,
                          ),
                        FloatingActionButton(
                            heroTag: 'change_mask',
                            onPressed: ()async{
                              if(_maskVisibility==false){
                                setState(() {
                                  _maskVisibility = true;
                                  _maskActiveColors = Colors.orangeAccent;
                                });
                              }else {
                                setState(() {
                                  _maskVisibility = false;
                                  _maskActiveColors = Colors.transparent;
                                });
                              }
                            },
                            child: Icon(Icons.face_retouching_natural),
                          backgroundColor: _maskActiveColors,
                        )
                      ],
                    ),
                    Visibility(
                      visible: _maskVisibility,
                      child: SingleChildScrollView(
                        padding: EdgeInsets.all(15),
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: List.generate(Masks.values.length-1, (p) {
                            bool active = currentMaskPage == p;
                            return GestureDetector(
                              onTap: () {
                                currentMaskPage = p;
                                cameraDeepArController.changeMask(p);
                                setState(() {});
                              },
                              child: Container(
                                  margin: EdgeInsets.all(2),
                                  padding: EdgeInsets.all(4),
                                  width: active ? 40 : 35,
                                  height: active ? 40 : 35,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      color:
                                          active ? _maskActiveColors : Colors.white,
                                      shape: BoxShape.rectangle),
                                  child: Text(
                                    '$p',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: active ? 16 : 14,
                                        color: Colors.black),
                                  )),
                            );
                          }),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: _filterVisibility,
                      child: SingleChildScrollView(
                        padding: EdgeInsets.all(15),
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: List.generate(Filters.values.length-1, (p) {
                            bool active = currentFilterPage == p;
                            return GestureDetector(
                              onTap: () {
                                currentFilterPage = p;
                                cameraDeepArController.changeFilter(p);
                                setState(() {});
                              },
                              child: Container(
                                  margin: EdgeInsets.all(2),
                                  padding: EdgeInsets.all(4),
                                  width: active ? 40 : 35,
                                  height: active ? 40 : 35,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      color:
                                      active ? _filterActiveColors : Colors.white,
                                      shape: BoxShape.circle),
                                  child: Text(
                                    '$p',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: active ? 16 : 14,
                                        color: Colors.black),
                                  )),
                            );
                          }),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: _effectVisibility,
                      child: SingleChildScrollView(
                        padding: EdgeInsets.all(15),
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: List.generate(Effects.values.length, (p) {
                            bool active = currentEffectPage == p;
                            return GestureDetector(
                              onTap: () {
                                currentEffectPage = p;
                                cameraDeepArController.changeEffect(p);
                                setState(() {});
                              },
                              child: Container(
                                  margin: EdgeInsets.all(2),
                                  padding: EdgeInsets.all(4),
                                  width: active ? 40 : 35,
                                  height: active ? 40 : 35,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      color:
                                      active ? _effectActiveColors : Colors.white,
                                      shape: BoxShape.circle),
                                  child: Text(
                                    '$p',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: active ? 16 : 14,
                                        color: Colors.black),
                                  )),
                            );
                          }),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
