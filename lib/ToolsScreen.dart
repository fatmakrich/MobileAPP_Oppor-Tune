import 'package:flutter/material.dart';
import 'Resources.dart';
import 'CV_generator.dart';
import 'cv_corrector.dart';
import 'Blog.dart';
import 'profile.dart';
import'Home_Page.dart';
import 'BottomNavBar.dart';
import 'news_screen.dart';
import 'ChatScreen.dart'; // Import the ChatScreen


class ToolsScreen extends StatefulWidget {
  const ToolsScreen({super.key});

  @override
  State<ToolsScreen> createState() => _ToolsScreenState();
}

class _ToolsScreenState extends State<ToolsScreen> {
  int _currentIndex = 2;
  late PageController _pageController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('TOOLS'),
          elevation: 6,
        ),
        body: Column(
          children: [
            SizedBox(height: 100),

            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconContainer(
                          text: 'CV generator',
                          containerColor: Color(0xFF84B6E6),

                          icon: Icons.picture_as_pdf,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CvGenerator()),
                            );
                          },
                        ),
                        SizedBox(width: 12),
                        IconContainer(
                          text: 'Resources',
                          containerColor: Color(0xFF51A1EE),
                          icon: Icons.auto_awesome_motion,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ArticleList()),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  Container(
                    //auto_fix_high
                    padding: EdgeInsets.all(2.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconContainer(
                          text: 'Chatbot', // Updated label
                          containerColor: Color(0xFF51A1EE),
                          icon: Icons.chat_bubble_outline,
                          onPressed: () {
                            // Open the ChatScreen when the Chatbot icon is pressed
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChatScreen(),
                              ),
                            );
                          },
                        ),
                        SizedBox(width: 12),
                        IconContainer(
                           text: 'Technology \n Updates',

                            containerColor: Color(0xFF84B6E6),
                            icon: Icons.travel_explore,
                            // Replace with your icon
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => NewsScreen()),
                              );
                            },
                          ),

                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTabTapped: (index) {
          // Handle navigation based on the tapped item
          switch (index) {
            case 0:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => HomePage(isUser: true)),
              );
              break;
            case 1:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => BlogPage()),
              );
              break;
            case 2:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => ToolsScreen()),
              );
              break;
            case 3:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => ProfilePage()),
              );
              break;
          }
        },
      ),

    );
  }}

class IconContainer extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final String text;
  final Color containerColor;

  IconContainer({
    required this.icon,
    required this.onPressed,
    required this.text,
    required this.containerColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140.0,
      height: 180.0,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(12.0),
        color: containerColor,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: Icon(icon, size: 50.0, color: Colors.black),
            onPressed: onPressed,
          ),
          SizedBox(height: 8.0),
          Text(
            text,
            style: TextStyle(
              color: Colors.black,
              fontSize: 16.0,
            ),
          ),
        ],
      ),

    );
  }
}


