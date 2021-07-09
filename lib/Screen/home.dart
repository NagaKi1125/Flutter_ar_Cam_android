import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_ar_cam/Model/Paginate.dart';
import 'package:flutter_ar_cam/Model/SocialPost.dart';
import 'package:flutter_ar_cam/Screen/login.dart';
import 'package:flutter_ar_cam/Screen/post_read.dart';
import 'package:flutter_ar_cam/Screen/upload_post.dart';
import 'package:flutter_ar_cam/SharedPreferences/UserPreferences.dart';
import 'package:full_screen_image/full_screen_image.dart';
import 'package:http/http.dart' as http;


class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<SocialPost> socialData;
  List<int> click;

  _loadPreference() async {
    await UserPreferences.init();
  }

  Future<List<SocialPost>> _getPost() async{
    Paginate jsonData;
    var response = await http.get('${UserPreferences.getBaseURL()}social');

    if(response.statusCode == 200){
      print('success');
      setState(() {
        jsonData = Paginate.fromJson(jsonDecode(response.body));
        socialData = jsonData.data;
        print(socialData);
      });
      return socialData;
    }else{
      print('failed');
      return null;
    }
  }

    @override
    void initState() {
      super.initState();
      _loadPreference();
      _getPost();
    }

  Widget _buildBody(){
    // List<int> favourite = List<int>.generate(socialData.length, (index) => 0);
    // List<Color> heart = List<Color>.generate(socialData.length, (index) => Colors.grey.withOpacity(0.4));
    return ListView.builder(
      itemCount: socialData == null ? 0: socialData.length,
      itemBuilder: (BuildContext context, index){
        return InkWell(
          onTap: (){
            _readPost(
              socialData[index].id,
              socialData[index].imageId,
              socialData[index].image,
              socialData[index].content,
              socialData[index].userId,
              socialData[index].username,
              socialData[index].createdAt,
              socialData[index].like,
            );
          },
          child: Padding(
            padding: const EdgeInsets.fromLTRB(3, 2, 3, 1),
            child: new Card(
              clipBehavior: Clip.antiAlias,
              child: Column(
                children: [
                  ListTile(
                    leading: Image.asset('assets/logo_notext.png'),
                    title: Text(socialData[index].username, style: TextStyle(color: Colors.black, fontSize: 18)),
                    subtitle: Text(socialData[index].createdAt,style: TextStyle(color: Colors.black.withOpacity(0.6))),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(6, 1, 6, 4),
                      child: Text(socialData[index].content),
                    )
                  ),
                  FullScreenWidget(
                    child:Center(
                        child: Image.network(socialData[index].image),
                    )
                  ),
                  UserPreferences.getLoginStatus() == true ?
                  ButtonBar(
                    alignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // IconButton(
                      //   onPressed: () async {
                      //     favourite[index]++;
                      //     if(favourite[index] == 0) {
                      //       this.setState(() {
                      //         heart[index] = Colors.white;
                      //       });
                      //     }else{
                      //       this.setState(() {
                      //         heart[index] = Colors.red;
                      //       });
                      //     }
                      //     if(favourite[index] >= 2) favourite[index] = 0;
                      //   },
                      //   icon: Icon(Icons.favorite_outlined),
                      //   color: heart[index],
                      // ),
                      IconButton(
                        onPressed: ()=>{},
                        icon: Icon(Icons.comment),
                        color: Colors.blue,

                      ),
                    ],
                  )
                  : ButtonBar(
                    alignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                        clipBehavior: Clip.antiAlias,
                        child: Text('Please login to comment or react'),
                        onPressed: (){
                          Navigator.of(context).push(MaterialPageRoute(builder: (context)=>LoginPage()));
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  _readPost(int id, String imageId,String image,String content, int userID, String username, String created, int like){
    if(UserPreferences.getLoginStatus() == false){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please login to read a post'),
      ));
    }else {
      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //   content: Text('${username}_$userID'),
      // ));
      Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
          Read(
              id: id,
              imageId: imageId,
              image: image,
              content: content,
              userID: userID,
              username: username,
              created: created,
              like: like
          )));
      }
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Screen'),
      ),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        heroTag: null,
        child: Icon(Icons.add_a_photo_outlined),
        onPressed: () async {
          if(UserPreferences.getLoginStatus() == false){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginPage()));
          }else{
            Navigator.push(context, MaterialPageRoute(builder: (context) => UploadPost()));
          }
          // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          //   content: Text('You have clicked the button in home'),
          // ))
        },
      ),
    );
  }
}


