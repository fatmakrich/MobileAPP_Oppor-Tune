import 'package:flutter/material.dart';
import 'customShape.dart';

class JobDetails extends StatefulWidget {
  const JobDetails({Key? key}) : super(key: key);
  static const routeName = '/job details';

  @override
  _JobDetailsState createState() => _JobDetailsState();
}

class _JobDetailsState extends State<JobDetails> {
  int _currentIndex = 0;

  @override
  // create a curvy bar on top of the page
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 130,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        flexibleSpace: Column(
          children: [
            ClipPath(
              clipper: Customshape(),
              child: Container(
                height: 100,
                width: MediaQuery.of(context).size.width,
                color: const Color.fromARGB(255, 5, 68, 120),
                child: const Center(
                  //add logo
                  child: Image(
                    image: AssetImage('assets/logo.png'),
                    width: 200.0,
                    height: 100.0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: SafeArea( //add text 
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 20.0),
              child: Align(
                alignment: Alignment.topCenter,
                child: Text(
                  'UX Designer',
                  style: TextStyle(fontSize: 18),
                  selectionColor: Color.fromARGB(255, 7, 46, 77),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: 150,
              height: 30,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 153, 200, 238),
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: const Center(
                child: Text( //add text inside a container
                  'Full-Time',
                  style: TextStyle(fontSize: 16, color: Color.fromARGB(255, 7, 60, 104)),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.location_on,
                  color: Colors.black,
                  size: 30,
                ),
                Text(
                  'R7WC+F82, Tunis',
                  style: TextStyle(fontSize: 18),
                  selectionColor: Colors.blue,
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Row( //add horizontal list
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: SizedBox(
                    height: 50,
                    child: Center(
                      child: Text('Description'),
                    ),
                  ),
                ),
                Expanded(
                  child: SizedBox(
                    height: 50,
                    child: Center(
                      child: Text('Requirements'),
                    ),
                  ),
                ),
                Expanded(
                  child: SizedBox(
                    height: 50,
                    child: Center(
                      child: Text('About'),
                    ),
                  ),
                ),
                Expanded(
                  child: SizedBox(
                    height: 50,
                    child: Center(
                      child: Text('Reviews'),
                    ),
                  ),
                ),
              ],
            ),
            //
            const SizedBox(height: 20),
            Center(child: _buildListWithCircles()), // Centered list with circles
            const SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.indigo[700],
        unselectedItemColor: Colors.black45,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem( // add bar at the end of the page
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.article),
            label: 'Blog',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.build),
            label: 'Tools',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),


      floatingActionButton: Container(
  alignment: Alignment.bottomCenter,
  padding: const EdgeInsets.only(bottom: 20.0),
  child: ElevatedButton( //add bottom 
    onPressed: () {
      // Handle button press
    },
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.blue,
    ),
    child: const Text(
      'APPLY NOW',
      style: TextStyle(
        color: Colors.white,
        fontSize: 16,
      ),
    ),
  ),
),


    );
  }
  Widget _buildListWithCircles() { //add lines of text
    return Column(
      children: [
        _buildListItem('Proficiency in HTML and CSS'),
        _buildListItem('Strong experience with Angular'),
        _buildListItem('Familiarity with JavaScript/jQuery'),
        _buildListItem('Knowledge of responsive design principles'),
      ],
    );
  }

  Widget _buildListItem(String text) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.grey,
          ),
        ),
        const SizedBox(width: 10),
        Text(
          text,
          style: const TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}
