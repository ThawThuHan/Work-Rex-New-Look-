import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../custom_widget/customRaisedButton.dart';
import '../custom_widget/customtextformfield.dart';
import '../services/auth_service.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  bool isLogin = true;

  _login() async {
    if (_formKey.currentState.validate()) {
      String email = emailController.text.trim();
      String password = passController.text.trim();
      User user = await MyAuthService.signWithEmail(email, password);
      Navigator.pop(context);
      if (user == null) {
        setState(() {
          isLogin = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Work Rex',
                  style: TextStyle(
                    fontSize: 55.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                MyTextFormField(
                  controller: emailController,
                  hintText: 'Email Address',
                  validator: (String val) {
                    if (val.isEmpty) {
                      return 'Email is required!';
                    } else if (!val.contains('@') || !val.contains('.')) {
                      return 'Unvalid Email Address';
                    }
                    return null;
                  },
                ),
                MyTextFormField(
                  controller: passController,
                  hintText: 'Password',
                  secureText: true,
                  validator: (String val) {
                    print(val.length);
                    if (val.isEmpty) {
                      return "Password is Required!";
                    } else if (!(val.length > 6)) {
                      return 'password need at least 6 char!';
                    }
                    return null;
                  },
                ),
                MyRaisedButton(
                  label: 'Login',
                  onPressed: _login,
                ),
                SizedBox(
                  height: 30.0,
                ),
                isLogin
                    ? Container()
                    : Text(
                        'Worng Email or Password !!',
                        style: TextStyle(
                          color: Colors.red,
                        ),
                      )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
