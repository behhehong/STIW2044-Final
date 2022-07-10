import 'package:flutter/material.dart';
import 'package:my_tutor/views/favouritepage.dart';
import 'package:my_tutor/views/subjectpage.dart';
import 'package:my_tutor/views/tutorpage.dart';
import 'package:my_tutor/views/subscribepage.dart';
import 'package:my_tutor/views/profilepage.dart';

import '../models/user.dart';

class MainPage extends StatefulWidget {
  final User user;
  const MainPage({Key? key, required this.user}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late int _selectedIndex;
  late List<Widget> _pages;
  late Widget _page1, _page2, _page3, _page4, _page5;
  late Widget _currentPage;
  String text = '';
  String text1 = "Subjects";
  String text2 = "Tutors";
  String text3 = "Subscribe";
  String text4 = "Favourite";
  String text5 = "Profile";

  @override
  void initState() {
    super.initState();

    _page1 = SubjectPage(user: widget.user);
    _page2 = TutorPage(user: widget.user);
    _page3 = const SubscribePage();
    _page4 = const FavouritePage();
    _page5 = Profile(user: widget.user);
    _pages = [_page1, _page2, _page3, _page4, _page5];
    _selectedIndex = 0;
    _currentPage = _page1;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _currentPage = _pages[index];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _currentPage,
      bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.subject),
              label: 'Subjects',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.school),
              label: 'Tutors',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add),
              label: 'Subscribe',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: 'Favourite',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: const Color.fromARGB(255, 9, 56, 95),
          unselectedItemColor: Colors.grey,
          onTap: (index) {
            _onItemTapped(index);
          }),
    );
  }
}
