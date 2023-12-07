import 'package:flutter/material.dart';
import 'package:news_app/core/utils/app_colors.dart';
import 'package:news_app/src/presentation/pages/bookmark_page.dart';
import 'package:news_app/src/presentation/pages/article_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _bottomNavIndex = 0;

  final List<BottomNavigationBarItem> _bottomNavbarItems = [
    const BottomNavigationBarItem(
      icon: Icon(Icons.home),
      label: "Home",
    ),
    const BottomNavigationBarItem(
      icon: Icon(
        Icons.bookmark,
      ),
      label: "Bookmark",
    ),
  ];

  final List<Widget> _listWidget = [
    const ArticlePage(),
    const BookmarkPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _listWidget[_bottomNavIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: AppColors.primaryColor,
        currentIndex: _bottomNavIndex,
        items: _bottomNavbarItems,
        onTap: (selected) {
          setState(() {
            _bottomNavIndex = selected;
          });
        },
      ),
    );
  }
}
