import 'package:flutter/material.dart';
import '../../code_models/user_model.dart';
import '../../custom_widget/profile_pic.dart';
import '../../custom_widget/profileplaceholder.dart';
import '../../screens/homeBNavigatorPages/profile_page.dart';
import '../../services/user_database.dart';

class SearchUserPage extends StatefulWidget {
  final WorkRexUser user;
  final String currentUserId;
  final String currentUserName;

  SearchUserPage({this.user, this.currentUserId, this.currentUserName});

  @override
  _SearchUserPageState createState() => _SearchUserPageState();
}

class _SearchUserPageState extends State<SearchUserPage> {
  List<WorkRexUser> users = [];
  List<WorkRexUser> _searchResult = [];
  TextEditingController searchController;
  Stream<List<WorkRexUser>> streamWorkRexUsers;

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
    streamWorkRexUsers =
        UserService.getUserbyDepartment(widget.user.department);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          title: TextField(
            cursorColor: Theme.of(context).accentColor,
            style:
                TextStyle(color: Theme.of(context).accentColor, fontSize: 18.0),
            controller: searchController,
            autocorrect: false,
            onSubmitted: (name) async {
              _searchResult = await UserService.getUserbyname(name);
              print(_searchResult);
              setState(() {});
            },
            decoration: InputDecoration(
                hintText: 'Search Users',
                hintStyle: TextStyle(color: Colors.grey),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Theme.of(context).accentColor),
                  borderRadius: BorderRadius.circular(30),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(30),
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: Theme.of(context).accentColor,
                ),
                suffixIcon: IconButton(
                  splashRadius: 20.0,
                  icon: Icon(Icons.clear, color: Theme.of(context).accentColor),
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
            stream: streamWorkRexUsers,
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
                            currentUserid: widget.currentUserId,
                            currentUserName: widget.currentUserName,
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
