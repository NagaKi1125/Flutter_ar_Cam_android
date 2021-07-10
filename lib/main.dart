import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'Screen/camera.dart';
import 'Screen/home.dart';
import 'Screen/library.dart';
import 'Screen/image_enhance.dart';
import 'SharedPreferences/UserPreferences.dart';

const apiKey =
    '8600de7c3f87f26cce5a06292acc0beda8c6df045b9e3fdb91b20dad9f9cd94aa4e6a01bc770333f';

String base_url = 'http://192.168.0.102:8000/api/';
bool _isLogin = false;

void main() {
  runApp(new MaterialApp(
    home: new MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _page = 0;
  Widget page;
  GlobalKey _bottomNavKey = GlobalKey();
  Widget _camera = Camera();
  Widget _home = Home();
  Widget _library = Library();
  Widget _enhance = ImageEnhance();

  @override
  void initState() {
    super.initState();
    _loadPreference();
  }

  _loadPreference() async {
    await UserPreferences.init();
    await UserPreferences.setLoginStatus(_isLogin);
    await UserPreferences.setBaseURL(base_url);
    await UserPreferences.setToken('');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: this.getBody(),
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavKey,
        index: 0,
        height: 50.0,
        items: <Widget>[
          Icon(Icons.camera),
          Icon(Icons.edit_road),
          Icon(Icons.home),
          Icon(Icons.person_pin_circle_outlined),
        ],
        color: Colors.white,
        buttonBackgroundColor: Colors.white,
        backgroundColor: Colors.blueAccent,
        animationCurve: Curves.easeOut,
        animationDuration: Duration(milliseconds: 400),
        onTap: (index) {
          this.onTapHandler(index, context);
        },
        letIndexChange: (index) => true,
      ),
    );
  }

  getBody() {

    if (this._page == 0)
      return this._camera;
    else if (this._page == 1)
      return this._enhance;
    else if (this._page == 2)
      return this._home;
    else
      return this._library;
  }

  void onTapHandler(index, context) {
    this.setState(() {
      _page = index;
    });
  }
}

