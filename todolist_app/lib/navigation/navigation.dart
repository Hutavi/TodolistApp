import 'package:flutter/material.dart';
import 'package:todolist_app/constants/colors.dart';
import 'package:todolist_app/screens/calendar_page/calendar_page.dart';
import 'package:todolist_app/screens/home_page/home_page.dart';
import 'package:todolist_app/screens/search_page/search_page.dart';
import 'package:todolist_app/screens/task_page/task_page.dart';

class NavigationBottom extends StatefulWidget {
  final int initialIndex;
  final int tabForward;
  const NavigationBottom({Key? key, this.initialIndex = 0, this.tabForward = 0})
      : super(key: key);

  @override
  State<NavigationBottom> createState() => _NavigationBottomState();
}

class _NavigationBottomState extends State<NavigationBottom> {
  static int _selectedIndex = 0;
  static int _tabForward = 0;
  static List<Widget> _pages = [];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
    _tabForward = widget.tabForward;
    _pages = <Widget>[
      HomePage(initialTab: _tabForward),
      const HomePage(
        initialTab: 0,
      ),
      const TaskPage(),
      const CalendarPage(),
      const SearchPage()
    ];
  }

  @override
  Widget build(BuildContext context) {
    Widget navigationContainer = Material(
      child: BottomNavigationBar(
        elevation: 0,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        backgroundColor: COLOR_BG_BOTTOM_NAV_BAR,
        selectedItemColor: COLOR_LATE,
        unselectedItemColor: COLOR_GRAY,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.all_inbox_outlined),
            label: 'Tasks',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Calendar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search_rounded),
            label: 'Search',
          ),
        ],
      ),
    );
    return Scaffold(
      bottomNavigationBar: navigationContainer,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: _pages.elementAt(_selectedIndex + 1)),
        ],
      ),
      floatingActionButton: Container(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerTop,
    );
  }
}
