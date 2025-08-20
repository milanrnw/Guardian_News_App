import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mynewsapp/core/api_requests.dart';
import 'package:mynewsapp/models/section/section_model.dart';
import 'package:http/http.dart' as http;
import 'package:mynewsapp/presentation/article_webview.dart';

class NewsScreen extends StatefulWidget {
  final String sectionId;
  const NewsScreen({super.key, required this.sectionId});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  List<SectionModel> contentDetails = [];
  bool isLoading = false;

  Future<void> getSectionDetails() async {
    setState(() {
      isLoading = true;
    });

    final response = await http.get(
      Uri.parse(
        ApiRequests.contentUrl(widget.sectionId),
      ),
    );

    if (response.statusCode == 200) {
      final decodedToken = jsonDecode(response.body);
      final content = decodedToken["response"]["results"];

      final articles = List<SectionModel>.from(
        content.map((item) => SectionModel.fromJson(item)),
      );

      setState(() {
        contentDetails = articles;
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getSectionDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('News - ${widget.sectionId}'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: contentDetails.length,
              itemBuilder: (context, index) {
                final content = contentDetails[index];
                return ListTile(
                  title: Text(content.webTitle),
                  subtitle: Text(content.id),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ArticleWebView(url: content.webUrl),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
