import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'Home_Page.dart'; // Import your BlogPage file
import 'ToolsScreen.dart'; // Import your ToolsPage file
import 'Profile.dart'; // Import your ProfilePage file
import 'BottomNavBar.dart';




class BlogPage extends StatelessWidget {
  int _currentIndex = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Blogs'),
      ),
      body: BlogList(),
      floatingActionButton: Padding(
        padding: EdgeInsets.symmetric(vertical: 0, horizontal: 100.0),
        child: Container(
          width: 300, // Largeur du bouton
          height: 45, // Hauteur du bouton
          child: FloatingActionButton.extended(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PostBlogPage()),
              );
            },
            label: Text(
              'Post Blog', // Changed the label to 'Post Blog'
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            backgroundColor: Colors.indigo[300],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
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
  }
}
class BlogList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('blogs').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        var blogs = snapshot.data!.docs;
        blogs.sort((a, b) => b['timestamp'].compareTo(a['timestamp']));
        return ListView(
          children: blogs.map<Widget>((blog) {
            Map<String, dynamic>? blogData = blog.data() as Map<String, dynamic>?;

            if (blogData != null) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.blue[300],
                        child: Icon(Icons.person),
                      ),
                      title: FutureBuilder<String>(
                        future: getUserNameFromUserId(blogData['userId']),
                        builder: (context, userSnapshot) {
                          if (userSnapshot.connectionState == ConnectionState.waiting) {
                            return Text(
                              'Loading...',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            );
                          }
                          return Text(
                            userSnapshot.data ?? 'Anonymous',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  // Conteneur du blog avec une couleur spécifique
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 3, horizontal: 20),
                    padding: EdgeInsets.fromLTRB(8, 3, 0, 8),
                    decoration: BoxDecoration(
                      color: Colors.blue[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            blogData['title'] ?? 'No Title',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            blogData['content'],
                            style: TextStyle(color: Colors.black, fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Conteneur des commentaires avec une autre couleur
                  Container(
                    color: Colors.purple[50], // Couleur différente pour les commentaires
                    margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    padding: EdgeInsets.fromLTRB(8, 5, 0, 8),
                    child: AddCommentWidget(blogId: blog.id),
                  ),
                ],
              );
            } else {
              return SizedBox.shrink();
            }
          }).toList(),
        );
      },
    );
  }

  Future<String> getUserNameFromUserId(String userId) async {
    try {
      DocumentSnapshot userSnapshot =
      await FirebaseFirestore.instance.collection('users').doc(userId).get();
      Map<String, dynamic>? userData =
      userSnapshot.data() as Map<String, dynamic>?;

      if (userData != null) {
        return '${userData['firstName']} ${userData['lastName']}';
      }
    } catch (e) {
      print('Error getting user data: $e');
    }

    return 'Anonymous';
  }
}

class AddCommentWidget extends StatelessWidget {
  final String blogId;
  final TextEditingController _commentController = TextEditingController();

  AddCommentWidget({required this.blogId});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 16),
        Text(
          'Comments:',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 8),
        StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('comments')
              .where('blogId', isEqualTo: blogId)
              .snapshots(),
          builder: (context, commentSnapshot) {
            if (!commentSnapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }

            var comments = commentSnapshot.data!.docs;

            if (comments.isEmpty) {
              return Text(
                'No comments yet.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              );
            }

            return Column(
              children: comments.map<Widget>((comment) {
                Map<String, dynamic>? commentData =
                comment.data() as Map<String, dynamic>?;

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.blue[300],
                        radius: 10,
                        child: Icon(Icons.person,
                          size: 15,
                        ),
                      ),
                      SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FutureBuilder<String>(
                            future: getUserNameFromUserId(
                                commentData?['userId'] ?? ''),
                            builder: (context, userSnapshot) {
                              if (userSnapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Text('Loading...');
                              }
                              return Text(
                                userSnapshot.data ?? 'Anonymous',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              );
                            },
                          ),
                          SizedBox(height: 4),
                          Text(
                            commentData?['content'] ?? '',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }).toList(),
            );
          },
        ),
        SizedBox(height: 16),
        Row(
          children: [
            Expanded (
              child: TextField(
                controller: _commentController,
                decoration: InputDecoration(
                  hintText: 'Add a comment...',
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.send),
              onPressed: () {
                addComment(blogId, _commentController.text.trim());
                _commentController.clear();
              },
            ),
          ],
        ),
      ],
    );
  }

  Future<void> addComment(String blogId, String commentContent) async {
    try {
      String userId =
          FirebaseAuth.instance.currentUser?.uid ?? 'anonymous_user';

      await FirebaseFirestore.instance.collection('comments').add({
        'blogId': blogId,
        'userId': userId,
        'content': commentContent,
        'timestamp': FieldValue.serverTimestamp(),
      });

      print('Comment added successfully!');
    } catch (e) {
      print('Error adding comment: $e');
    }
  }

  Future<String> getUserNameFromUserId(String userId) async {
    try {
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      Map<String, dynamic>? userData =
      userSnapshot.data() as Map<String, dynamic>?;

      if (userData != null) {
        return '${userData['firstName']} ${userData['lastName']}';
      }
    } catch (e) {
      print('Error getting user data: $e');
    }

    return 'Anonymous';
  }
}
class PostBlogPage extends StatefulWidget {
  @override
  _PostBlogPageState createState() => _PostBlogPageState();
}

class _PostBlogPageState extends State<PostBlogPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _blogController = TextEditingController();

  Future<void> postBlog() async {
    try {
      String userId = FirebaseAuth.instance.currentUser?.uid ?? 'anonymous_user';
      String blogTitle = _titleController.text.trim();
      String blogContent = _blogController.text.trim();

      if (blogContent.isNotEmpty && blogTitle.isNotEmpty) {
        // Création d'un ID pour le blog
        String blogId = FirebaseFirestore.instance.collection('blogs').doc().id;
        await FirebaseFirestore.instance.collection('blogs').add({
          'blogId': blogId, // Ajout de l'identifiant unique du blog
          'userId': userId,
          'title': blogTitle,
          'content': blogContent,
          'timestamp': FieldValue.serverTimestamp(),
        });

        _titleController.clear();
        _blogController.clear();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Blog posted successfully!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please fill in title and content before posting!')),
        );
      }
    } catch (e) {
      print('Error posting blog: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to post blog. Please try again later.'),
        ),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add a Blog'), // Changed the title to 'Add a Blog'
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  hintText: 'Blog Title', // Changed hint to 'Title...'
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _blogController,
                maxLines: 7,
                decoration: InputDecoration(
                  hintText: 'Write Your Blog here',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 50),
              ElevatedButton(
                onPressed: () async {
                  await postBlog();
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24), // Ajuster le padding au besoin
                  child: Text(
                    'Post Blog',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                style: ElevatedButton.styleFrom(

                  primary: Colors.indigo[300], // Couleur de fond du bouton
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10), // Bord arrondi du bouton
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
