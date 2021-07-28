import 'package:better_assignments/main_tabs/completed.dart';
import 'package:better_assignments/alt_screens/settings/settings.dart';
import 'package:better_assignments/main_tabs/star.dart';
import 'package:better_assignments/main_tabs/home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import '../slidable_widgets/assign_widgets.dart';

class TabView extends StatefulWidget {
  @override
  _TabViewState createState() => _TabViewState();
}

class _TabViewState extends State<TabView> {
  PersistentTabController _controller =
      PersistentTabController(initialIndex: 0);
  @override
  Widget build(BuildContext context) {
    return _tabView();
  }

  Widget _tabView() {
    return PersistentTabView(
      context,
      controller: _controller,
      navBarHeight: 60,
      screens: _buildScreens(),
      items: _navBarsItems(),
      confineInSafeArea: true,
      backgroundColor: Colors.black,
      handleAndroidBackButtonPress: true,
      resizeToAvoidBottomInset: true,
      stateManagement: true,
      hideNavigationBarWhenKeyboardShows: true,
      decoration: NavBarDecoration(
        borderRadius: BorderRadius.circular(30.0),
        colorBehindNavBar: Colors.transparent,
      ),
      popAllScreensOnTapOfSelectedTab: true,
      popActionScreens: PopActionScreensType.all,
      itemAnimationProperties: ItemAnimationProperties(
        // Navigation Bar's items animation properties.
        duration: Duration(milliseconds: 200),
        curve: Curves.ease,
      ),
      screenTransitionAnimation: ScreenTransitionAnimation(
        // Screen transition animation on change of selected tab.
        animateTabTransition: true,
        curve: Curves.ease,
        duration: Duration(milliseconds: 200),
      ),
      navBarStyle:
          NavBarStyle.style7, // Choose the nav bar style with this property.
      onItemSelected: (index) {
        setState(() {});
      },
    );
  }

  List<Widget> _buildScreens() {
    return [
      Home(),
      Star(),
      Home(),
      Completed(),
      Settings(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(Icons.home),
        title: "Home",
        textStyle: TextStyle(color: Colors.white),
        activeColorSecondary: Colors.white,
        activeColorPrimary: Colors.purple,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.star),
        title: ("Prioritized"),
        textStyle: TextStyle(color: Colors.white),
        activeColorSecondary: Colors.white,
        activeColorPrimary: Colors.amber,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.add),
        title: ("Add"),
        textStyle: TextStyle(color: Colors.white),
        activeColorSecondary: Colors.white,
        activeColorPrimary: Colors.white,
        onPressed: (context) async {
          await assignModal(true, null, "");
          setState(() {});
        },
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.check_box),
        title: ("Completed"),
        activeColorPrimary: Colors.green,
        textStyle: TextStyle(color: Colors.white),
        activeColorSecondary: Colors.white,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.settings),
        title: ("Settings"),
        activeColorPrimary: Colors.blue,
        textStyle: TextStyle(color: Colors.blue),
        activeColorSecondary: Colors.white,
      ),
    ];
  }
}
