import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsArticle {
  final String title;
  final String description;
  final String url;
  final String imageUrl;
  final String content;

  NewsArticle({
    required this.title,
    required this.description,
    required this.url,
    required this.imageUrl,
    required this.content,
  });

  factory NewsArticle.fromJson(Map<String, dynamic> json) {
    return NewsArticle(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      url: json['url'] ?? '',
      imageUrl: json['urlToImage'] ?? '',
      content: json['content'] ?? '',
    );
  }
}

class ArticleDetailsScreen extends StatelessWidget {
  final NewsArticle article;

  const ArticleDetailsScreen({required this.article});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(article.title),
        backgroundColor: Colors.indigo[700], // Set the app bar color to indigo(700)
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 200,
                child: CachedNetworkImage(
                  imageUrl: article.imageUrl,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => CircularProgressIndicator(),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
              SizedBox(height: 16),
              Text(
                article.content,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  final String? url = article.url;

                  if (url != null) {
                    final Uri uri = Uri.parse(url);

                    try {
                      if (await canLaunch(uri.toString())) {
                        await launch(uri.toString());
                      } else {
                        throw 'Could not launch $url';
                      }
                    } catch (e) {
                      print('Error launching URL: $e');
                    }
                  }
                },
                child: Text('Read More',
                  style: TextStyle(
                      color: Colors.white,
               ),),
                style: ElevatedButton.styleFrom(
                  primary: Colors.indigo[700], // Set the button color to indigo(700)
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NewsService {
  final String apiKey;

  NewsService(this.apiKey);

  Future<List<NewsArticle>> getNews() async {
    final response = await http.get(
      Uri.parse('https://newsapi.org/v2/top-headlines?country=us&category=technology&apiKey=$apiKey'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      if (data['status'] == 'ok') {
        return (data['articles'] as List)
            .map((article) => NewsArticle(
          title: article['title'] ?? '',
          description: article['description'] ?? '',
          url: article['url'] ?? '',
          imageUrl: article['urlToImage'] ?? '',
          content: article['content'] ?? '',
        ))
            .toList();
      } else {
        throw Exception('Failed to load news');
      }
    } else {
      throw Exception('Failed to load news');
    }
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'News App',
      theme: ThemeData(
        primaryColor: Colors.indigo[700], // Set the primary color to indigo(700)
      ),
      home: NewsScreen(),
    );
  }
}

class NewsScreen extends StatefulWidget {
  @override
  _NewsScreenState createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  final String apiKey = 'c6de117744254a96b36f3b0ce19e3490';
  late NewsService newsService;
  late List<NewsArticle> news = [];

  @override
  void initState() {
    super.initState();
    newsService = NewsService(apiKey);
    loadNews();
  }

  void loadNews() async {
    try {
      List<NewsArticle> loadedNews = await newsService.getNews();
      setState(() {
        news = loadedNews;
      });
    } catch (e) {
      print('Error loading news: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('News App'),
      ),
      body: ListView.builder(
        itemCount: news.length,
        itemBuilder: (context, index) {
          final article = news[index];
          return ListTile(
            title: Text(
              article.title,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              article.description,
              style: TextStyle(fontSize: 12),
            ),
            leading: article.imageUrl.isNotEmpty
                ? CachedNetworkImage(
              imageUrl: article.imageUrl,
              fit: BoxFit.cover,
              //width: 150,
              height: 170,
              placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget: (context, url, error) => Icon(Icons.error),
            )
                : Icon(Icons.image),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ArticleDetailsScreen(article: article),
                ),
              );
            },
          );
        },
      ),
    );
  }
}


