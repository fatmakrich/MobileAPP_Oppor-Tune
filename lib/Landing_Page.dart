import 'package:flutter/material.dart';
import 'SigninScreen.dart';


class FirstPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background with Gradient Overlay
          Container(
            color: Colors.white, // Light grey background color
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Colors.black.withOpacity(0.8)],
              ),
            ),
          ),
          // Logo and Text
          Positioned(
            top: 150.0,
            left: 20.0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Animated logo
                InkWell(
                  onTap: () {
                    // Add your desired animation when clicking the logo
                    // For example, you can use a custom animation or navigate to a specific page
                    print("Logo Clicked!");
                  },
                  child: Hero(
                    tag: 'logoTag',
                    child: Container(
                      margin: EdgeInsets.only(bottom: 30, left: 50.0, right: 25.0),
                      child: Image.asset(
                        "assets/Asset1.png",
                        height: 250.0,
                        width: 250.0,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                // Text
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Find Your",
                      style: TextStyle(
                        color: Colors.yellow[200],
                        fontSize: 32.0,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                        shadows: [Shadow(color: Colors.black, offset: Offset(1, 1), blurRadius: 2)],
                      ),
                    ),
                    Text(
                      "Dream Job",
                      style: TextStyle(
                        color: Colors.yellow[200],
                        fontSize: 32.0,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                        shadows: [Shadow(color: Colors.black, offset: Offset(1, 1), blurRadius: 2)],
                      ),
                    ),
                    Text(
                      "Here !",
                      style: TextStyle(
                        color: Colors.yellow[200],
                        fontSize: 32.0,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                        shadows: [Shadow(color: Colors.black, offset: Offset(1, 1), blurRadius: 2)],
                      ),
                    ),
                    SizedBox(height: 20.0),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.8, // Set a percentage of screen width
                      child: Text(
                        "Explore all the most exciting job roles based on your interest and study major.",
                        style: TextStyle(
                          color: Colors.grey[300],
                          fontSize: 18.0,
                          letterSpacing: 1.2,
                        ),
                        textAlign: TextAlign.left,
                        softWrap: true, // Allow text to wrap onto the next line
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Button
          Positioned(
            bottom: 40.0,
            right: 20.0,
            child: FloatingActionButton(
              onPressed: () {
                // Navigate to the next page with custom page transition
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) => SigninScreen(),
                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                      const begin = Offset(1.0, 0.0);
                      const end = Offset.zero;
                      const curve = Curves.easeInOutCubic;
                      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                      var offsetAnimation = animation.drive(tween);
                      return SlideTransition(position: offsetAnimation, child: child);
                    },
                  ),
                );
              },
              child: Icon(Icons.arrow_forward),
              backgroundColor: Colors.blueAccent,
              elevation: 5.0,
              highlightElevation: 10.0,
            ),
          ),
        ],
      ),
    );
  }
}
