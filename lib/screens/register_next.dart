import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:workrex/custom_widget/progress_hub.dart';
import 'package:workrex/services/auth_service.dart';
import '../code_models/user_model.dart';
import '../services/user_database.dart';
import '../custom_widget/customRaisedButton.dart';
import '../custom_widget/customtextformfield.dart';

class RegisterNext extends StatefulWidget {
  RegisterNext({
    this.name,
    this.phone,
    this.staffid,
    this.department,
    this.imgUrl,
  });

  final String name;
  final String phone;
  final String staffid;
  final String department;
  final String imgUrl;

  @override
  _RegisterNextState createState() => _RegisterNextState();
}

class _RegisterNextState extends State<RegisterNext> {
  TextEditingController emailController, passwordController, repassController;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isAsyncCall = false;
  bool _isFail = false;

  validateRegister() async {
    if (_formKey.currentState.validate()) {
      setState(() {
        _isAsyncCall = true;
        _isFail = false;
      });
      String email = emailController.text.trim();
      String password = repassController.text.trim();

      User user = await MyAuthService.registerUser(email, password);
      print(widget.imgUrl);

      if (user != null) {
        String userid = user.uid;
        WorkRexUser workRexUser = WorkRexUser(
          name: widget.name,
          phone: widget.phone,
          staffId: widget.staffid,
          department: widget.department,
          email: user.email,
          userid: userid,
          imgUrl: widget.imgUrl,
          performance: 0.0,
          personality: 0.0,
          knowledge: 0.0,
          teamwork: 0.0,
          overall: 0.0,
        );

        await UserService.saveUser(data: WorkRexUser.toMap(user: workRexUser));
        Navigator.pop(context);
        setState(() {
          _isAsyncCall = false;
        });
      } else {
        setState(() {
          _isFail = true;
          _isAsyncCall = false;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    repassController = TextEditingController();
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
                color: Theme.of(context).accentColor,
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
                  MyTextFormField(
                    keyboardType: TextInputType.emailAddress,
                    hintText: 'Email Address',
                    controller: emailController,
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
                    secureText: true,
                    hintText: 'Password',
                    controller: passwordController,
                    validator: (String val) {
                      if (val.isEmpty) {
                        return 'password is required!';
                      } else if (!(val.length >= 6)) {
                        return 'password need at least 6 char!';
                      }
                      return null;
                    },
                  ),
                  MyTextFormField(
                    secureText: true,
                    hintText: 'Re-Password',
                    controller: repassController,
                    validator: (String val) {
                      if (val.trim() != passwordController.text.trim()) {
                        return 'Re-Type your password!';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  _isFail
                      ? Center(
                          child: Text(
                            'Something Wrong!!',
                            style: TextStyle(
                              color: Colors.red,
                            ),
                          ),
                        )
                      : Container(),
                  MyRaisedButton(
                    label: 'Done',
                    onPressed: validateRegister,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
