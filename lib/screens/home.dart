import 'package:flutter/material.dart';
import 'package:workrex/services/user_database.dart';
import '../code_models/user_model.dart';
import '../screens/homeBNavigatorPages/profile_page.dart';
import '../screens/homeBNavigatorPages/rating_page.dart';
import '../screens/homeBNavigatorPages/searchuser_page.dart';
import '../screens/homeBNavigatorPages/sub_home.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.userId});

  final String userId;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PageController _pageController;
  int pageIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  _onTap(value) {
    setState(() {
      pageIndex = value;
      _pageController.animateToPage(value,
          duration: Duration(microseconds: 300), curve: Curves.bounceIn);
    });
  }

  buildLoadingScreen() {
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).accentColor,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                  flex: 2,
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Work Rex',
                          style: TextStyle(
                            fontSize: 38.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        CircularProgressIndicator(
                          backgroundColor: Colors.white,
                        ),
                      ],
                    ),
                  )),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        body: StreamBuilder<Object>(
            stream: UserService.getStreamUserbyId(widget.userId),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return buildLoadingScreen();
              }
              final WorkRexUser user = snapshot.data;
              return PageView(
                controller: _pageController,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  SubHome(
                    user: user,
                  ),
                  RatingPage(
                    dept: user.department,
                  ),
                  SearchUserPage(
                    user: user,
                    currentUserId: user.userid,
                    currentUserName: user.name,
                  ),
                  ProfilePage(
                    user: user,
                    currentUserid: user.userid,
                    currentUserName: user.name,
                  ),
                ],
              );
            }),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: pageIndex,
          selectedItemColor: Theme.of(context).accentColor,
          unselectedItemColor: Colors.grey,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.star), label: 'Rating'),
            BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Users'),
            BottomNavigationBarItem(
                icon: Icon(Icons.account_circle), label: 'Profile'),
          ],
          onTap: _onTap,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
