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

  String? errorMessage;

  Future<void> getCategory() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });
    try {
      final response = await http.get(Uri.parse(ApiRequests.allSections));

      if (response.statusCode == 200) {
        final decodedToken = jsonDecode(response.body);
        final contentMain = SectionMainModel.fromJson(decodedToken["response"]);

        if (!mounted) return;
        setState(() {
          contentCategory = contentMain.results;
        });
      } else {
        if (!mounted) return;
        setState(() {
          errorMessage =
              'Failed to load categories. Status: ${response.statusCode}';
        });
      }
    } catch (e) {
      debugPrint("Error fetching category: $e");
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
    getCategory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                        onPressed: getCategory,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : contentCategory.isEmpty
                  ? const Center(child: Text("No Categories Found"))
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
