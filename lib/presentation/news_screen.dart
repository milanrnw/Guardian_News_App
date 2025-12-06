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

  String? errorMessage;

  Future<void> getSectionDetails() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
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

        if (!mounted) return;
        setState(() {
          contentDetails = articles;
        });
      } else {
        if (!mounted) return;
        setState(() {
          errorMessage =
              'Failed to load articles. Status: ${response.statusCode}';
        });
      }
    } catch (e) {
      debugPrint("Error fetching section details: $e");
      if (!mounted) return;
      setState(() {
        errorMessage = "An error occurred: $e";
      });
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
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
          ? const Center(child: CircularProgressIndicator())
          : errorMessage != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(errorMessage!, textAlign: TextAlign.center),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: getSectionDetails,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : contentDetails.isEmpty
                  ? const Center(child: Text("No Articles Found"))
                  : ListView.builder(
                      itemCount: contentDetails.length,
                      itemBuilder: (context, index) {
                        final content = contentDetails[index];
                        return ListTile(
                          minVerticalPadding: 16,
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
