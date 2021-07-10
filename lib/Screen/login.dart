import 'dart:convert';

import 'package:flutter_ar_cam/Model/Login.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'register.dart';
import '../SharedPreferences/UserPreferences.dart';

bool _isLogin;
String _token = '';
String url = '';

class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadPreference();
  }

  _loadPreference() async {
    await UserPreferences.init();
    _isLogin = UserPreferences.getLoginStatus() ?? false;
    url = UserPreferences.getBaseURL() ?? '';
    _token = UserPreferences.getToken() ?? '';
  }

  Widget _backButton() {
    return InkWell(
      onTap: () {
        Navigator.of(context).popUntil((route) => route.isFirst);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 0, top: 10, bottom: 10),
              child: Icon(Icons.keyboard_arrow_left, color: Colors.black),
            ),
            Text('Back',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500))
          ],
        ),
      ),
    );
  }

  Widget _entryField(String title, String hint, TextEditingController controller,{bool isPassword = false}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          SizedBox(
            height: 10,
          ),
          TextField(
              controller: controller,
              obscureText: isPassword,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  fillColor: Color(0xfff3f3f4),
                  filled: true))
        ],
      ),
    );
  }

  Widget _submitButton() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: SizedBox(
        width: 300,
        height: 50,
        child: ElevatedButton(
          onPressed: ()=>{
            signIn(_emailController.text, _passwordController.text)
          },
          child: Text(
            'Login',
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
          style: ElevatedButton.styleFrom(
            primary: Colors.orangeAccent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30)
            ),
          ),
        ),
      ),
    );
  }

  Widget _createAccountLabel() {
    return InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => SignUpPage()));
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Don\'t have an account ?   ',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          ),
          Text(
            'Register',
            style: TextStyle(
                color: Color(0xfff79c4f),
                fontSize: 13,
                fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _title() {
    return SizedBox(
      width: 300,
      height: 300,
      child: Align(
        alignment: Alignment.topCenter,
        child: Image.asset('assets/logo.png'),
      ),
    );
  }

  Widget _emailPasswordWidget() {
    return Column(
      children: <Widget>[
        _entryField("Email id", 'Type in your email', _emailController),
        _entryField("Password", 'Type in your password', _passwordController,
            isPassword: true),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          reverse: true,
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Positioned(child: _backButton(), left: 0, top: 40,),
              _title(),
              _emailPasswordWidget(),
              SizedBox(height: 20),
              _submitButton(),
              _createAccountLabel(),
            ],
          ),
        ),
      ));
  }

  signIn(String email, String password) async {
    Map data = {
      'email': email,
      'password': password,
    };
    Login jsonData;
    var response = await http.post(url + 'login', body: data);
    if (response.statusCode == 200) {
      jsonData = Login.fromJson(jsonDecode(response.body));
      String mess = jsonData.success.toString()+ ': '+jsonData.message.toString();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(mess)));
      _isLogin = true;
      _token = jsonData.token.toString();
      await UserPreferences.setLoginStatus(_isLogin);
      await UserPreferences.setToken(_token);
      await UserPreferences.setUserId(jsonData.message.split('_')[0]);
      await UserPreferences.setUserName(jsonData.message.split('_')[1]);
      print(jsonData.message.split('_'));
      if(jsonData.message.split('_')[2].isNotEmpty){
        print(jsonData.message.split('_')[2]);
        await UserPreferences.setLikedList(jsonData.message.split('_')[2]);
      }else {
        await UserPreferences.setLikedList('+');
      }
      Navigator.of(context).popUntil((route) => route.isFirst);
      print(UserPreferences.getToken());
      print(UserPreferences.getLoginStatus());
    } else{
      print(response.body);
      jsonData = Login.fromJson(jsonDecode(response.body));
      String mess = jsonData.success.toString()+ ': '+jsonData.message;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(mess)));
    }

  }
}
