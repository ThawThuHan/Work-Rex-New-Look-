import 'package:flutter/material.dart';
import 'package:workrex/code_models/user_model.dart';
import 'package:workrex/custom_widget/profile_pic.dart';
import 'package:workrex/custom_widget/profileplaceholder.dart';
import 'package:workrex/screens/homeBNavigatorPages/profile_page.dart';
import 'package:workrex/services/user_database.dart';

class SearchUserPage extends StatefulWidget {
  final WorkRexUser user;
  final String crrentUserId;

  SearchUserPage({this.user, this.crrentUserId});

  @override
  _SearchUserPageState createState() => _SearchUserPageState();
}

class _SearchUserPageState extends State<SearchUserPage> {
  List<WorkRexUser> users = [];
  List<WorkRexUser> _searchResult = [];
  TextEditingController searchController;

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).accentColor,
          title: TextField(
            cursorColor: Colors.white,
            style: TextStyle(color: Colors.white),
            controller: searchController,
            autocorrect: false,
            onSubmitted: (name) async {
              _searchResult = await UserService.getUserbyname(name);
              print(_searchResult);
              setState(() {});
            },
            decoration: InputDecoration(
                hintText: 'Search Users',
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(30),
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.white,
                ),
                suffixIcon: IconButton(
                  splashRadius: 20.0,
                  icon: Icon(Icons.clear, color: Colors.white),
                  onPressed: () {
                    _searchResult = [];
                    searchController.clear();
                    setState(() {});
                  },
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 12.0),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(30),
                )),
          ),
        ),
        body: Container(
          child: StreamBuilder<List<WorkRexUser>>(
            stream: UserService.getUserbyDepartment(widget.user.department),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              List<WorkRexUser> userofDept = snapshot.data;
              users = _searchResult.isEmpty ? userofDept : _searchResult;
              return ListView.separated(
                itemBuilder: (context, index) {
                  String imgUrl = users[index].imgUrl;
                  String name = users[index].name;
                  String dept = users[index].department;
                  return ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProfilePage(
                            user: users[index],
                            currentUserid: widget.crrentUserId,
                          ),
                        ),
                      );
                    },
                    leading: imgUrl != null
                        ? CustomCircleProfilePic(
                            imgUrl: imgUrl,
                            radius: 30.0,
                          )
                        : ProfilePlaceholder(radius: 30.0),
                    title: Text(name),
                    subtitle: Text(dept),
                  );
                },
                separatorBuilder: (_, __) {
                  return Divider();
                },
                itemCount: users.length,
              );
            },
          ),
        ),
      ),
    );
  }
}
