import 'package:flutter/material.dart';
import '../code_models/user_model.dart';
import '../screens/homeBNavigatorPages/profile_page.dart';
import '../screens/homeBNavigatorPages/rating_page.dart';
import '../screens/homeBNavigatorPages/searchuser_page.dart';
import '../screens/homeBNavigatorPages/sub_home.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.user});

  final WorkRexUser user;

  @override
  _HomePageState createState() => _HomePageState(user: user);
}

class _HomePageState extends State<HomePage> {
  _HomePageState({this.user});

  final WorkRexUser user;
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

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        body: PageView(
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
        ),
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
