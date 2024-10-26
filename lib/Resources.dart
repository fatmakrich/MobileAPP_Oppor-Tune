import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';


class ArticleList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Resources',
          style: TextStyle(color: Color(0xFF356899)),
        ),
        elevation: 6,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('articles').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          List<Article> articles = snapshot.data!.docs.map((doc) {
            Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
            return Article(
              title: data['title'],
              content: data['content'],
              description: data['description'],
              imageUrl: data['imageUrl'],
              color: data['color'],
            );
          }).toList();

          return ListView.builder(
            itemCount: articles.length,
            itemBuilder: (context, index) {
              Color articleColor = parseColor(articles[index].color);
              return Container(
                color:articleColor,
                margin: EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 150,
                      height: 160,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: FutureBuilder(
                          future: FirebaseStorage.instance.refFromURL(articles[index].imageUrl).getDownloadURL(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.done) {
                              return Image.network(
                                snapshot.data.toString(),
                                fit: BoxFit.cover,
                              );
                            } else if (snapshot.hasError) {
                              // Handle error if necessary
                              return Center(child: Text('Error loading image'));
                            } else {
                              // Show a loading indicator while the image is loading
                              return Center(child: CircularProgressIndicator());
                            }
                          },
                        ),
                      ),
                    ),

                    SizedBox(width: 8.0),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              articles[index].title,
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 2.0),
                            Text(
                              articles[index].description,
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: 2.0),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ArticleDetail(article: articles[index]),
                                  ),
                                );
                              },
                              child: Text(
                                'See More',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Theme.of(context).colorScheme.secondary,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}



Color parseColor(String colorString) {
  String hexColor = colorString.replaceAll("#", "");
  int intValue = int.parse(hexColor, radix: 16);
  return Color(intValue | 0xFF000000); // Set alpha value to 255 (fully opaque)
}


class Article {
  final String title;
  final String content;
  final String description;
  final String imageUrl;
  final String color;

  Article({
    required this.title,
    required this.content,
    required this.description,
    required this.imageUrl,
    required this.color,
  });
}

class ArticleDetail extends StatelessWidget {
  final Article article;

  ArticleDetail({required this.article});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(article.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: FutureBuilder(
                future: FirebaseStorage.instance.refFromURL(article.imageUrl).getDownloadURL(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return Image.network(
                      snapshot.data.toString(),
                      width: MediaQuery.of(context).size.width,
                      height: 200,
                      fit: BoxFit.cover,
                    );
                  } else if (snapshot.hasError) {
                    // Handle error if necessary
                    return Center(child: Text('Error loading image'));
                  } else {
                    // Show a loading indicator while the image is loading
                    return Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                article.content,
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
