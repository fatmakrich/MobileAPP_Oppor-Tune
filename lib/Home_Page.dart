import 'package:flutter/material.dart';
import 'BottomNavBar.dart';
import 'Blog.dart';
import 'ToolsScreen.dart';
import 'Profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  final bool isUser;

  HomePage({required this.isUser});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  late TextEditingController _searchController;
  List<Map<String, dynamic>> _filteredData = [];
  late QuerySnapshot _firestoreSnapshot;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home page'),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: Text(
                      'Find your job opportunity',
                      style: TextStyle(
                        fontSize: 20,
                        letterSpacing: .8,
                        color: Colors.purple[300],
                      ),
                    ),
                  ),
                ),
                _buildSearchBar(),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Recently added offers',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[900],
                    ),
                  ),
                ),
              ],
            ),
          ),
          _buildJobListForJobSeeker(),
        ],
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTabTapped: (index) {
          setState(() {
            _currentIndex = index;
          });

          // Handle navigation based on the tapped item
          switch (index) {
            case 0:
            // Do nothing or add additional logic if needed
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
  }

  Widget _buildSearchBar() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                children: [
                  Icon(Icons.search),
                  SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Search for job offers...',
                        border: InputBorder.none,
                      ),
                      onChanged: (value) {
                        String searchTerm = value.toLowerCase();
                        List<Map<String, dynamic>> filteredData = [];

                        for (var document in _firestoreSnapshot.docs) {
                          var data = document.data() as Map<String, dynamic>;

                          // Check if the sector contains the search term
                          if (data['sector'].toLowerCase().contains(searchTerm)) {
                            filteredData.add(data);
                          }
                        }

                        setState(() {
                          // Update the state with the filtered data
                          _filteredData = filteredData;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJobListForJobSeeker() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('posts').orderBy('timestamp', descending: true).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SliverFillRemaining(
            child: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return SliverFillRemaining(
            child: Center(child: Text('Error: ${snapshot.error}')),
          );
        } else {
          _firestoreSnapshot = snapshot.data!; // Store the snapshot

          return SliverList(
            delegate: SliverChildBuilderDelegate(
                  (context, index) {
                var data = _filteredData.isNotEmpty
                    ? _filteredData[index]
                    : snapshot.data!.docs[index].data() as Map<String, dynamic>;

                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    data['imageUrl'],
                                    width: 300,
                                    height: 120,
                                    fit: BoxFit.contain,
                                    errorBuilder: (context, error, stackTrace) {
                                      print('Error loading image: $error');
                                      return const Text('Image not available');
                                    },
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Job Title : ${data['jobTitle']}',

                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                    'Requirements : ${data['requirements']}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Sector : ${data['sector']}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 8),

                      Text(
                        'Number of offer: ${data['numberOfOffers']}',

                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 16),
                      if (data['formLink'] != null)
                        GestureDetector(
                          onTap: () => _launchURL(data['formLink']),
                          child: Text(
                            'Form Link: ${data['formLink']}',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color.fromARGB(255, 3, 21, 36),
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      const SizedBox(height: 16),
                      Divider(),
                    ],
                  ),
                );
              },
              childCount: _filteredData.isNotEmpty
                  ? _filteredData.length
                  : snapshot.data!.docs.length,
            ),
          );
        }
      },
    );
  }

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
