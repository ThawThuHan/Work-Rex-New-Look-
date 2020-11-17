import 'package:flutter/material.dart';
import '../code_models/user_model.dart';
import '../services/user_database.dart';
import '../screens/homeBNavigatorPages/profile_page.dart';
import '../screens/homeBNavigatorPages/rating_page.dart';
import '../screens/homeBNavigatorPages/searchuser_page.dart';
import '../screens/homeBNavigatorPages/sub_home.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.userid});

  final String userid;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PageController _pageController;
  int pageIndex = 0;
  WorkRexUser user;
  String currentUserId;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    init();
  }

  init() async {
    user = await UserService.getUserbyId(widget.userid);
    currentUserId = user.userid;
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
            RatingPage(),
            SearchUserPage(
              user: user,
              crrentUserId: currentUserId,
            ),
            ProfilePage(
              user: user,
              currentUserid: currentUserId,
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
