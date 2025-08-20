import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mynewsapp/core/api_requests.dart';
import 'package:mynewsapp/models/section/section_main_model.dart';
import 'package:http/http.dart' as http;
import 'package:mynewsapp/models/section/section_model.dart';
import 'package:mynewsapp/presentation/news_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<SectionModel> contentCategory = [];
  bool isLoading = false;

  Future<void> getCategory() async {
    setState(() {
      isLoading = true;
    });
    final response = await http.get(Uri.parse(ApiRequests.allSections));

    if (response.statusCode == 200) {
      final decodedToken = jsonDecode(response.body);
      final contentMain = SectionMainModel.fromJson(decodedToken["response"]);

      setState(() {
        contentCategory = contentMain.results;
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getCategory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemBuilder: (context, index) {
                final categories = contentCategory[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => NewsScreen(
                          sectionId: categories.id,
                        ),
                      ),
                    );
                  },
                  child: ListTile(
                    title: Text(categories.webTitle),
                  ),
                );
              },
              itemCount: contentCategory.length,
            ),
    );
  }
}
