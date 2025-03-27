import 'package:flutter/material.dart';
import '../models/news_model.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailedNewsScreen extends StatelessWidget {
  final NewsArticle article;

  const DetailedNewsScreen({Key? key, required this.article}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("News Details")),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            article.imageUrl != null
                ? Image.network(article.imageUrl!, fit: BoxFit.cover)
                : SizedBox.shrink(),
            SizedBox(height: 10),
            Text(article.title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text(article.description, style: TextStyle(fontSize: 16)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (await canLaunch(article.url)) {
                  await launch(article.url);
                } else {
                  throw 'Could not launch ${article.url}';
                }
              },
              child: Text("Read Full Article"),
            ),
          ],//runnnnnnnnnn!!!!!!!!!!!!!!!!!!!!
        ),
      ),
    );
  }
}