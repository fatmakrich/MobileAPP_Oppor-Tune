import 'package:flutter/material.dart';


class BottomNavBar extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTabTapped;

  BottomNavBar({required this.currentIndex, required this.onTabTapped});

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: widget.currentIndex,
      onTap: widget.onTabTapped,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
          backgroundColor: Colors.indigo[700],
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.article),
          label: 'Blog',
            backgroundColor: Colors.indigo[700],

        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.build),
          label: 'Tools',
            backgroundColor: Colors.indigo[700],

        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
            backgroundColor: Colors.indigo[700],

        ),
      ],
    );
  }
}