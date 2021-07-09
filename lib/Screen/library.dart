import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ar_cam/Model/UserImage.dart';
import 'package:flutter_ar_cam/Screen/login.dart';
import 'package:flutter_ar_cam/SharedPreferences/UserPreferences.dart';
import 'package:full_screen_image/full_screen_image.dart';
import '../Model/UserFollow.dart';
import 'package:http/http.dart' as http;

class Library extends StatefulWidget {
  @override
  _LibraryState createState() => _LibraryState();
}

class _LibraryState extends State<Library> {
  String email = '';
  List<String> followerList = [];
  List<String> followWhomList = [];
  List<ImageName> imageList = [];
  bool _followerVisibility = false;
  bool _followedVisibility = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadPreference();
    if (UserPreferences.getLoginStatus() == true) {
      _getUserInfo();
      _getUserImage();
    }
  }

  _loadPreference() async {
    await UserPreferences.init();
  }

  _getUserInfo() async {
    UserFollow jsonData_1;
    UserFollow jsonData_2;
    String token = UserPreferences.getToken();
    print(token);
    var response_1 = await http
        .get('${UserPreferences.getBaseURL()}user-follower', headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    print(UserPreferences.getToken());

    if (response_1.statusCode == 200) {
      jsonData_1 = UserFollow.fromJson(jsonDecode(response_1.body));
      jsonData_1.data.forEach((element) {
        setState(() {
          followerList.add(element.follower);
        });
      });
    } else {
      print('loaded failed');
    }
    var response_2 = await http
        .get('${UserPreferences.getBaseURL()}user-follow-whom', headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });

    if (response_2.statusCode == 200) {
      jsonData_2 = UserFollow.fromJson(jsonDecode(response_2.body));
      jsonData_2.data.forEach((element) {
        setState(() {
          followWhomList.add(element.follow);
        });
      });
    } else {
      print('loaded failed');
    }

    print(followerList);
    print(followWhomList);
  }

  _logout() async {
    var response =
        await http.get('${UserPreferences.getBaseURL()}logout', headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${UserPreferences.getToken()}',
    });
    if (response.statusCode == 200) {
      print(response.body.toString());
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Logout')));
      await UserPreferences.setLoginStatus(false);

      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) => super.widget));
    } else {
      print(response.body.toString());
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Something went wrong')));
    }
  }

  _getUserImage() async {
    var response =
        await http.get('${UserPreferences.getBaseURL()}user-image', headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${UserPreferences.getToken()}',
    });
    if (response.statusCode == 200) {
      imageList = UserImage.fromJson(jsonDecode(response.body)).data;
    }
  }

  Widget _buildBody() {
    if (UserPreferences.getLoginStatus() == false ||
        UserPreferences.getLoginStatus() == null) {
      return Container(
        child: Center(
          child: SizedBox(
            width: double.infinity,
            child: FloatingActionButton(
              heroTag: 'Navigate to login',
              child: Text('Navigate to login screen'),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              onPressed: () async {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginPage()));
              },
            ),
          ),
        ),
      );
    } else {
      return Container(
        alignment: Alignment.topCenter,
        width: double.infinity,
        padding: EdgeInsets.all(8),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: InkWell(
                    child: Container(
                      width: 50,
                      decoration: BoxDecoration(
                        color: Colors.amber.shade300,
                        border: Border.all(color: Colors.grey.withOpacity(0.5)),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        ' <-- Logout  ',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    onTap: (){
                      _logout();
                    },
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.lightGreen,
                    child: Text(
                      '${UserPreferences.getUserName()[0]}',
                      style:
                          TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(50, 0, 10, 0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${UserPreferences.getUserName()}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                              style: TextButton.styleFrom(
                                backgroundColor: Colors.lightBlue,
                              ),
                              onPressed: () => {
                                this.setState(() {
                                  if (_followerVisibility == false) {
                                    _followerVisibility = true;
                                  } else {
                                    _followerVisibility = false;
                                  }
                                })
                              },
                              child: Text('Follower: ${followerList.length}',
                                  style: TextStyle(color: Colors.white)),
                            ),
                            TextButton(
                              style: TextButton.styleFrom(
                                backgroundColor: Colors.lightBlue,
                              ),
                              onPressed: () => {
                                this.setState(() {
                                  if (_followedVisibility == false) {
                                    _followedVisibility = true;
                                  } else {
                                    _followedVisibility = false;
                                  }
                                })
                              },
                              child: Text('Followed: ${followWhomList.length}',
                                  style: TextStyle(color: Colors.white)),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
              _showFollowList(
                  'Follower List', followerList, _followerVisibility),
              _showFollowList(
                  'Followed List', followWhomList, _followedVisibility),
              Divider(
                color: Colors.grey,
              ),
              Center(
                child: Text(
                  'Your upload images',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
              _showImageGrid(imageList),
            ],
          ),
        ),
      );
    }
  }

  Widget _showImageGrid(List<ImageName> list) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: double.infinity,
        height: 250,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey),
          ),
          child: SingleChildScrollView(
            padding: EdgeInsets.all(3),
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(list.length, (index) {
                return Padding(
                  padding: EdgeInsets.all(5),
                  child: FullScreenWidget(
                    child: Center(
                      child: Hero(
                        tag: 'User Image',
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.network(
                            list[index].image,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }

  Widget _showFollowList(String title, List<String> followList, bool _visible) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 4),
      child: Visibility(
        visible: _visible,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.withOpacity(0.5)),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              Center(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Divider(
                color: Colors.grey,
              ),
              SizedBox(
                width: double.infinity,
                height: 150,
                child: ListView.builder(
                  itemCount: followList.length,
                  itemBuilder: (context, index) {
                    String id = followList[index].split('+')[0];
                    String name = followList[index].split('+')[1];
                    return Column(
                      children: [
                        ListTile(
                          leading: CircleAvatar(
                            radius: 20,
                            child: Text('${name[0]}'),
                            backgroundColor: Colors.deepPurpleAccent,
                          ),
                          title: Text(name),
                          subtitle: Text('ID: $id'),
                        ),
                        Divider(
                          color: Colors.grey,
                        )
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(email == "" ? 'Library' : email),
        ),
        body: _buildBody());
  }
}
