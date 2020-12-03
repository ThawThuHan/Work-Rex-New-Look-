import 'dart:io';
import 'package:uuid/uuid.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../code_models/post_model.dart';
import '../../custom_widget/progress_hub.dart';
import '../../services/post_database.dart';
import '../../code_models/user_model.dart';
import '../../custom_widget/profile_pic.dart';

class CreatePost extends StatefulWidget {
  final WorkRexUser user;
  final PostModel post;

  CreatePost({this.user, this.post});

  @override
  _CreatePostState createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  List postPlace = [];
  String selectValue;
  List<File> images = [];
  String postId;
  TextEditingController _postController;
  bool _isAsyncCall = false;
  String username;
  String department;
  String userImgUrl;
  List postImgUrl = [];

  @override
  void initState() {
    super.initState();
    _postController = TextEditingController();
    checkPostEditorNot();
    postPlace = ['public', department];
    selectValue = postPlace[0];
    postId = Uuid().v4();
  }

  checkPostEditorNot() {
    if (widget.user == null) {
      username = widget.post.postOwnerName;
      department = widget.post.postOwerDept;
      userImgUrl = widget.post.postOwnerImgUrl;
      postImgUrl = widget.post.postImgUrls;
      _postController.text = widget.post.postText;
    } else {
      username = widget.user.name;
      department = widget.user.department;
      userImgUrl = widget.user.imgUrl;
    }
  }

  List<DropdownMenuItem> getDrowButtomitems() {
    List<DropdownMenuItem> items = postPlace
        .map((e) => DropdownMenuItem(
              child: Text(e),
              value: e,
            ))
        .toList();
    return items;
  }

  imageFormCamera() async {
    PickedFile imagePick =
        await ImagePicker().getImage(source: ImageSource.camera);
    if (imagePick != null) {
      File image = File(imagePick.path);
      setState(() {
        images.add(image);
      });
    }
  }

  imageFormGallery() async {
    PickedFile imagePick =
        await ImagePicker().getImage(source: ImageSource.gallery);
    if (imagePick != null) {
      File image = File(imagePick.path);
      setState(() {
        images.add(image);
        getImages();
      });
    }
  }

  getImages() {
    if (images.isEmpty) {
      return Container();
    } else {
      List<Widget> children = images.map((e) {
        return Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white),
            ),
            width: 100.0,
            child: Stack(
              alignment: Alignment.topRight,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Image.file(e),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      images.remove(e);
                    });
                  },
                  child: Icon(
                    Icons.remove_circle,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList();
      return Container(
        height: 100,
        width: double.infinity,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: children,
        ),
      );
    }
  }

  _addPhoto() {
    showDialog(
        context: context,
        builder: (context) => SimpleDialog(
              title: Text('Add Photo'),
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    imageFormGallery();
                  },
                  child: Text(
                    'Gallery',
                    style: TextStyle(
                      fontSize: 18.0,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    imageFormCamera();
                  },
                  child: Text(
                    'Camera',
                    style: TextStyle(
                      fontSize: 18.0,
                    ),
                  ),
                ),
              ],
            ));
  }

  Future<List<String>> getDownloadUrl() async {
    List<String> imgUrls = [];
    for (File image in images) {
      String imgUrl = await uploadImagesToStorage(postId, image);
      imgUrls.add(imgUrl);
    }
    return imgUrls;
  }

  Future uploadImagesToStorage(String postid, File file) async {
    String filename = Uuid().v1();
    Reference ref =
        FirebaseStorage.instance.ref().child('/posts/$postid/$filename');
    TaskSnapshot task = await ref.putFile(file);
    String imgUrl = await task.ref.getDownloadURL();
    return imgUrl;
  }

  _uploadPost() async {
    if (widget.user != null) {
      if (_postController.text.isNotEmpty) {
        setState(() {
          _isAsyncCall = true;
        });
        List<String> imgUrls = await getDownloadUrl();
        PostModel postModel = PostModel(
          postId: postId,
          postOwnerName: widget.user.name,
          postOwerDept: widget.user.department,
          postOwnerImgUrl: widget.user.imgUrl,
          postImgUrls: imgUrls,
          postTo: selectValue,
          postText: _postController.text.trim(),
        );
        await PostService.uploadPost(
          postId,
          selectValue,
          PostModel.toMap(postModel),
        );
        setState(() {
          _isAsyncCall = false;
          Navigator.pop(context);
        });
      } else {
        print('null');
      }
    } else {
      print(widget.post.postId);
      print(widget.post.postTo);
      setState(() {
        _isAsyncCall = true;
      });
      List<String> imgUrls = await getDownloadUrl();
      await PostService.updatePost(
        widget.post.postTo,
        widget.post.postId,
        {
          'postText': _postController.text.trim(),
          'postImgUrls': imgUrls,
        },
      );
      await deletePhotoFromFirebaseStorage(widget.post.postImgUrls);
      setState(() {
        _isAsyncCall = false;
        Navigator.pop(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String title = widget.user != null ? "Create Post" : "Edit Post";
    return Container(
      child: ProgressHUD(
        inAsyncCall: _isAsyncCall,
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              title,
              style: TextStyle(
                color: Theme.of(context).accentColor,
              ),
            ),
            iconTheme: IconThemeData(color: Theme.of(context).accentColor),
            elevation: 0.0,
            backgroundColor: Colors.transparent,
          ),
          body: ListView(
            children: [
              ListTile(
                leading: CustomCircleProfilePic(
                  imgUrl: userImgUrl,
                  radius: 20.0,
                ),
                title: Text(
                  username,
                  style: TextStyle(
                    fontSize: 20.0,
                  ),
                ),
                subtitle: Text(department),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    TextField(
                      autocorrect: false,
                      style: TextStyle(fontSize: 24.0),
                      cursorColor: Colors.black,
                      controller: _postController,
                      maxLines: widget.user != null ? 5 : 3,
                      decoration: InputDecoration(
                        hintText: "What's your announcement?",
                        hintStyle: TextStyle(
                          fontSize: 24.0,
                        ),
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                      ),
                    ),
                    getImages(),
                    FlatButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      minWidth: double.infinity,
                      color: Theme.of(context).accentColor,
                      onPressed: images.length < 4 ? _addPhoto : null,
                      child: Text(
                        '+ Photo',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        widget.user != null
                            ? buildDropdownButton()
                            : buildDeleteBottom(),
                        Container(
                          height: 40.0,
                          width: 150.0,
                          child: FlatButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            minWidth: double.infinity,
                            color: Theme.of(context).accentColor,
                            onPressed: _uploadPost,
                            child: Text(
                              'Post Now',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> deletePhotoFromFirebaseStorage(List imgUrls) async {
    for (String imgUrl in imgUrls) {
      Reference storageRef = FirebaseStorage.instance.refFromURL(imgUrl);
      await storageRef.delete();
    }
  }

  deletePost() async {
    await PostService.postDelete(widget.post.postTo, widget.post.postId);
  }

  Container buildDeleteBottom() {
    return Container(
      height: 40.0,
      width: 150.0,
      child: FlatButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        minWidth: double.infinity,
        color: Colors.red,
        onPressed: () async {
          setState(() {
            _isAsyncCall = true;
          });
          await deletePost();
          await deletePhotoFromFirebaseStorage(widget.post.postImgUrls);
          setState(() {
            _isAsyncCall = true;
            Navigator.pop(context);
          });
        },
        child: Text(
          'Delete Post',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Container buildDropdownButton() {
    return Container(
      height: 40.0,
      // margin: EdgeInsets.all(8.0),
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).accentColor),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton(
          items: getDrowButtomitems(),
          value: selectValue,
          onChanged: (value) {
            setState(() {
              selectValue = value;
            });
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _postController.dispose();
    super.dispose();
  }
}
