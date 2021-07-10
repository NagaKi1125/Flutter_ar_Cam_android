import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_ar_cam/Model/ResponseMessage.dart';
import 'package:flutter_ar_cam/SharedPreferences/UserPreferences.dart';
import 'login.dart';
import 'package:http/http.dart' as http;


bool _isLogin;
String _token = '';
String url = '';

class SignUpPage extends StatefulWidget {
  SignUpPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController _nameController = new TextEditingController();
  TextEditingController _usernameController = new TextEditingController();
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  TextEditingController _brithdayCotnroller = new TextEditingController();
  DateTime _selectedDate;

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
        Navigator.pop(context);
      },
      child: Container(
        child: Row(
          children: <Widget>[
            Container(
              child: Icon(Icons.keyboard_arrow_left, color: Colors.black),
            ),
            Text('Back',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500))
          ],
        ),
      ),
    );
  }

  Widget _entryField(String title,TextEditingController _controller,{bool isEnable = true, bool isPassword = false}) {
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
              controller: _controller,
              enabled: isEnable,
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
          child: Text(
            'Register Now',
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
          style: ElevatedButton.styleFrom(
            primary: Colors.orangeAccent,
            shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30)
          ),
        ), onPressed: () {
            _register();
        },
        ),
      ),
    );
  }

  Widget _loginAccountLabel() {
    return InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => LoginPage()));
      },
      child: Container(
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Already have an account ?    ',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            Text(
              'Login',
              style: TextStyle(
                  color: Color(0xfff79c4f),
                  fontSize: 13,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
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
        _entryField("Name", _nameController),
        _entryField("Username",_usernameController),
        _entryField("Email id",_emailController),
        _entryField("Password",_passwordController, isPassword: true),
        GestureDetector(
            onTap: (){
              showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1960,1),
                  lastDate: DateTime(2021,12),
              ).then((value){
                  _selectedDate = value;
                  _brithdayCotnroller.text = _selectedDate.toString().split(' ')[0];
              });
            },
            child: _entryField("Birthday",_brithdayCotnroller, isEnable: false)
        ),
      ],
    );
  }

  _register(){
    if(_nameController.text.isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please type in your name'),
      ));
    }else if(_usernameController.text.isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please type in your Username'),
      ));
    }else if(_emailController.text.isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please fill in your email'),
      ));
    }else if(_passwordController.text.isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please choose a password'),
      ));
    }else if(_selectedDate.toString().isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please tell us when were you born'),
      ));
    }else{
      _requestSignUp(_nameController.text,
          _usernameController.text,
          _emailController.text,
          _passwordController.text,
          _selectedDate.toString().split(' ')[0]);
    }
  }

  _requestSignUp(name,username,email,pass,date) async {
    Map data={
      'name': name,
      'username': username,
      'email': email,
      'password':pass,
      'birthday': date,
    };
    ResponseMessage jsonData;
    var response = await http.post('${UserPreferences.getBaseURL()}register', body: data);
    if(response.statusCode == 200){
      jsonData = ResponseMessage.fromJson(jsonDecode(response.body));
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('New User Sign up successfully your new id is ${jsonData.message}'),
      ));
      setState(() {
        _passwordController.text = '';
        _usernameController.text = '';
      });
    }else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('something went wrong, please try again'),
      ));
      setState(() {
        _passwordController.text = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          reverse: true,
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Positioned(top: 40, left: 0, child: _backButton()),
              _title(),
              _emailPasswordWidget(),
              SizedBox(height: 20),
              Center(
                child: _submitButton(),
              ),
              _loginAccountLabel(),
            ],
          ),
        ),
      ),
    );
  }



}
