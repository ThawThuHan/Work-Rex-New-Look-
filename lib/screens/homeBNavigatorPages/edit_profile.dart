import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:workrex/code_models/user_model.dart';
import 'package:workrex/custom_widget/customRaisedButton.dart';
import 'package:workrex/custom_widget/customtextformfield.dart';
import 'package:workrex/custom_widget/profile_pic.dart';
import 'package:workrex/custom_widget/progress_hub.dart';
import 'package:workrex/services/user_database.dart';

class EditProfilePage extends StatefulWidget {
  final WorkRexUser user;

  EditProfilePage({this.user});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  TextEditingController nameController,
      idController,
      phoneController,
      emailController;
  File image;
  bool _isAsyncCall = false;
  String downloadUrl;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    idController = TextEditingController();
    phoneController = TextEditingController();
    emailController = TextEditingController();
    init();
  }

  init() {
    nameController.text = widget.user.name;
    idController.text = widget.user.staffId;
    phoneController.text = widget.user.phone;
    emailController.text = widget.user.email;
    downloadUrl = widget.user.imgUrl;
  }

  Future uploadImagesToStorage(File file) async {
    Reference ref = FirebaseStorage.instance
        .ref()
        .child('/Users/${nameController.text.trim()}');
    TaskSnapshot task = await ref.putFile(file);
    String imgUrl = await task.ref.getDownloadURL();
    return imgUrl;
  }

  imageFormGallery() async {
    PickedFile imagePick =
        await ImagePicker().getImage(source: ImageSource.gallery);
    if (imagePick != null) {
      File image = File(imagePick.path);
      setState(() {
        this.image = image;
      });
    }
  }

  imageFormCamera() async {
    PickedFile imagePick =
        await ImagePicker().getImage(source: ImageSource.camera);
    if (imagePick != null) {
      File image = File(imagePick.path);
      setState(() {
        this.image = image;
      });
    }
  }

  _imagePickerDialog(context) {
    showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: Text('Upload Image'),
          children: [
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context);
                imageFormCamera();
              },
              child: const Text('Camera'),
            ),
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context);
                imageFormGallery();
              },
              child: const Text('Gallery'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final WorkRexUser user = widget.user;
    return ProgressHUD(
      inAsyncCall: _isAsyncCall,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Editing Profile',
            style: TextStyle(
              color: Theme.of(context).accentColor,
              fontSize: 24.0,
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          centerTitle: true,
          iconTheme: IconThemeData(color: Theme.of(context).accentColor),
        ),
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: ListView(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  this.image == null
                      ? CustomCircleProfilePic(
                          imgUrl: user.imgUrl,
                          radius: 60.0,
                        )
                      : CircleAvatar(
                          radius: 60.0,
                          // backgroundImage: FileImage(image),
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: FileImage(image),
                              ),
                            ),
                          ),
                        ),
                  IconButton(
                    icon: Icon(
                      Icons.camera_alt_outlined,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      _imagePickerDialog(context);
                    },
                  ),
                ],
              ),
              SizedBox(
                height: 20.0,
              ),
              MyTextFormField(
                controller: nameController,
                hintText: 'Name *',
              ),
              MyTextFormField(
                controller: idController,
                hintText: 'ID *',
              ),
              MyTextFormField(
                controller: phoneController,
                hintText: 'Phone No. *',
              ),
              MyTextFormField(
                controller: emailController,
                hintText: 'Email Address *',
              ),
              MyRaisedButton(
                label: 'Save',
                onPressed: () async {
                  setState(() {
                    _isAsyncCall = true;
                  });
                  if (image != null) {
                    downloadUrl = await uploadImagesToStorage(image);
                  }
                  await UserService.updateData(user.userid, {
                    WorkRexUser.nameField: nameController.text.trim(),
                    WorkRexUser.staffidField: idController.text.trim(),
                    WorkRexUser.phoneField: phoneController.text.trim(),
                    WorkRexUser.emailfield: emailController.text.trim(),
                    WorkRexUser.imgUrlField: downloadUrl,
                  });
                  setState(() {
                    _isAsyncCall = false;
                    Navigator.pop(context);
                  });
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
