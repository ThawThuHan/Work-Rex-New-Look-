import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:workrex/custom_widget/progress_hub.dart';

import '../screens/register_next.dart';
import '../custom_widget/profileplaceholder.dart';
import '../custom_widget/customRaisedButton.dart';
import '../custom_widget/customtextformfield.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController nameController, phController, staffidController;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String selectDept;
  File image;
  String imgUrl;
  bool _isAsyncCall = false;

  final List departments = [
    'IT-Department',
    'HR-Department',
    'Finance-Department',
    'Account-Department',
  ];

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

  List<DropdownMenuItem> dropdownMenuList() {
    List<DropdownMenuItem> items = departments
        .map((e) => DropdownMenuItem(
              child: Text(
                e,
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              value: e,
            ))
        .toList();
    return items;
  }

  Future uploadPhoto() async {
    Reference storageRef = FirebaseStorage.instance
        .ref()
        .child('/Users/${nameController.text.trim()}');
    UploadTask task = storageRef.putFile(image);
    return task;
  }

  validateRegisterForm() async {
    if (_formKey.currentState.validate()) {
      setState(() {
        _isAsyncCall = true;
      });
      String name = nameController.text.trim();
      String phone = phController.text.trim();
      String staffid = staffidController.text.trim();
      if (image != null) {
        await uploadPhoto().whenComplete(() async {
          imgUrl = await FirebaseStorage.instance
              .ref()
              .child('/Users/${nameController.text.trim()}')
              .getDownloadURL();
        });
      }
      print(imgUrl);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => RegisterNext(
            name: name,
            phone: phone,
            staffid: staffid,
            department: selectDept,
            imgUrl: imgUrl,
          ),
        ),
      );
      setState(() {
        _isAsyncCall = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    selectDept = departments[0];
    nameController = TextEditingController();
    phController = TextEditingController();
    staffidController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ProgressHUD(
        inAsyncCall: _isAsyncCall,
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Text(
              'Register',
              style: TextStyle(
                fontSize: 24.0,
              ),
            ),
            elevation: 0.0,
            backgroundColor: Colors.transparent,
            centerTitle: true,
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  GestureDetector(
                    onTap: () {
                      _imagePickerDialog(context);
                    },
                    child: image != null
                        ? CircleAvatar(
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
                          )
                        : ProfilePlaceholder(
                            radius: 60.0,
                          ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  MyTextFormField(
                    controller: nameController,
                    hintText: 'Name *',
                    validator: (String value) {
                      if (value.isEmpty) {
                        return 'Staff ID is required!';
                      }
                      return null;
                    },
                  ),
                  MyTextFormField(
                    controller: phController,
                    hintText: 'Phone Number *',
                    keyboardType: TextInputType.phone,
                    validator: (String value) {
                      if (value.isEmpty) {
                        return 'Staff ID is required!';
                      }
                      return null;
                    },
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ConstrainedBox(
                        constraints: BoxConstraints(
                          maxHeight: 90,
                          maxWidth: 150,
                          minHeight: 20,
                          minWidth: 100,
                        ),
                        child: MyTextFormField(
                          controller: staffidController,
                          hintText: 'Staff ID *',
                          validator: (String value) {
                            if (value.isEmpty) {
                              return 'Staff ID is required!';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: DropdownButtonHideUnderline(
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 3.0),
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: Theme.of(context).accentColor),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: DropdownButton(
                                value: selectDept,
                                items: dropdownMenuList(),
                                onChanged: (value) {
                                  setState(() {
                                    selectDept = value;
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  MyRaisedButton(
                    label: 'Next',
                    onPressed: validateRegisterForm,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    phController.dispose();
    staffidController.dispose();
    super.dispose();
  }
}
