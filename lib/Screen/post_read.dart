import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ar_cam/Model/Comment.dart';
import 'package:flutter_ar_cam/Model/ResponseMessage.dart';
import 'package:flutter_ar_cam/SharedPreferences/UserPreferences.dart';
import 'package:full_screen_image/full_screen_image.dart';
import 'package:http/http.dart' as http;

bool liked = false;

class Read extends StatefulWidget{
  //value for receiving data
  final int id;
  final String imageId;
  final String image;
  final String content;
  final int userID;
  final String username;
  final String created;
  final int like;

  const Read({this.id, this.imageId, this.image, this.content, this.userID,
    this.username, this.created, this.like});

  @override
  _ReadState createState() => _ReadState(this.like);
}

class _ReadState extends State<Read>{

  //List for comment
  List<Data> comment=[];
  TextEditingController _commentController = new TextEditingController();
  int likeC = 0;
  _ReadState(this.likeC);

  Future _loadPreference() async {
    await UserPreferences.init();
  }
  Future _getComment(int postId) async {
    Comment jsonData;
    var response = await http.get('${UserPreferences.getBaseURL()}social/$postId/comment');
    if (response.statusCode == 200){
      print('success');
      jsonData = Comment.fromJson(jsonDecode(response.body));
      comment = jsonData.data;
      print(comment.toString());
    }else{
      print('failed');
      print(response.body);
    }
  }

  @override
  void initState() {
    super.initState();
    _loadPreference();
    _getComment(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.username}_${widget.userID}'),
      ),
      body: Container(
        width: double.infinity,
        alignment: Alignment.topCenter,
        padding: EdgeInsets.all(8),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ListTile(
                leading: CircleAvatar(
                  radius: 35 ,
                  backgroundColor: Colors.lightGreen,
                  child : Text('${widget.username[0]}', style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),),
                ),
                title: Text('${widget.username}', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),),
                subtitle: Text('ID: ${widget.userID} - ${widget.created} - ${widget.id}'),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: EdgeInsets.all(5),
                  child: Text('${widget.content}'),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: FullScreenWidget(
                  child: Center(
                    child: Image.network(widget.image),
                  ),
                ),
              ),
              ButtonBar(
                alignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                      onPressed: (){
                        setState(() {
                          liked = UserPreferences.getLikedList().contains('${widget.id}');
                          if(liked == true) {
                            liked = false;
                            _userLiked(widget.id, 'dislike');
                          }else{
                            liked = true;
                            _userLiked(widget.id, 'like');
                          }
                        });
                      },
                      child: _favourite('${widget.id}'),
                  ),
                  // ignore: unrelated_type_equality_checks
                  widget.id == UserPreferences.getUserId() ?
                      IconButton(
                          onPressed: (){},
                          icon: Icon(Icons.delete),
                      ) :
                      Center(),
                ],
              ),
              Divider(color: Colors.grey),
              Align(
                alignment: Alignment.topLeft,
                child: Text('Comments:',
                style: TextStyle(fontWeight: FontWeight.w500),),
              ),
              Container(
                padding: EdgeInsets.all(8.0),
                  width: double.infinity,
                  child: _buildComment(comment)
              ),
              ListTile(
                title: TextField(
                  controller: _commentController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    fillColor: Color(0xfff3f3f4),
                    filled: true,
                    hintText: 'Tap to input comment...',
                  ),
                ),
                trailing: InkWell(
                  child: Container(
                    width: 50,
                    height: 30,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(50)
                    ),
                    child: Center(child: Text('Add', style: TextStyle(color: Colors.white),)
                    ),
                  ),
                  onTap: (){
                    _addComment(widget.id);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget _favourite(String id){
    List<String> list = UserPreferences.getLikedList().split('+');
    print(list.contains('haha+${widget.id}'));
    if (list.contains('${widget.id}')){
      return Row(
        children: [
          Icon(Icons.favorite,color:Colors.red),
          Text('Like: ${this.likeC}', style: TextStyle(color: Colors.red),),
        ],
      );
    }else{
      return Row(
        children: [
          Icon(Icons.favorite_outline,),
          Text('Like: ${this.likeC}'),
        ],
      );
    }
  }
  
  _userLiked(int id, String command) async {
    String parameter = '';
    if(command == 'like'){
      parameter = 'user-like-post/$id/like';
    }else if(command == 'dislike'){
      parameter = 'user-dislike-post/$id/dislike';
    }
    var response = await http.put('${UserPreferences.getBaseURL()}$parameter',
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${UserPreferences.getToken()}',
      });
    ResponseMessage jsonData = ResponseMessage.fromJson(jsonDecode(response.body));
    if(response.statusCode == 200){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${jsonData.message}'))
      );
      if(command == 'like'){
        setState(() {
          this.likeC+=1;
          UserPreferences.setLikedList('${UserPreferences.getLikedList()}+${widget.id}');
        });
      }else if(command == 'dislike'){
        setState(() {
          this.likeC-=1;
          String list = UserPreferences.getLikedList().replaceAll('${widget.id}+','');
          UserPreferences.setLikedList(list);
        });
      }
    }else{
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${jsonData.message}'))
      );
    }
  }
  _addComment(id)async{
    if(_commentController.text.isEmpty){
     ScaffoldMessenger.of(context).showSnackBar(
       SnackBar(content: Text('Please leave some comment'))
     );
    }else {
      Map data = {'comment':_commentController.text.toString(),};
      print('${UserPreferences.getBaseURL()}user/$id/comment');
      var response = await http.post('${UserPreferences.getBaseURL()}user/$id/comment',
      body: json.encode(data),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${UserPreferences.getToken()}',
      });
      if(response.statusCode == 200){
        Comment jsonData = Comment.fromJson(jsonDecode(response.body));
        print(jsonData);
        setState(() {
          _commentController.text = '';
          _getComment(widget.id);
        });
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Add comment success'))
        );
      }else{
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Something went wrong, please try again'))
        );
        print(response.body);
        setState(() {
          _commentController.text = '';
        });
      }
    }

  }

  Widget _buildComment(List<Data> list){
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemCount: list.isEmpty ? 0 : list.length,
            itemBuilder: (context, index){
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 20 ,
                      backgroundColor: Colors.lightGreen,
                      child : Text('${list[index].username[0]}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                    ),
                    title: Text('${list[index].username}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                    subtitle: Text('${list[index].comment}'),
                  ),
                  onTap: (){print('${list[index].id}');},
                  // onLongPress: PopupMenuButton(
                  //   itemBuilder: (BuildContext context) {
                  //
                  //   },
                  // ),
                ),
              );
            }
          ),

        ],
      ),
    );
  }


}