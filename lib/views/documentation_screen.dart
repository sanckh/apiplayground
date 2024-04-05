import 'package:algolia/algolia.dart';
import 'package:apiplayground/services/algolia_service.dart';
import 'package:apiplayground/widgets/documentation_cards.dart';
import 'package:apiplayground/widgets/filter_options_widget.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:apiplayground/models/document_model.dart';
import 'package:apiplayground/services/firebase_service.dart';

class DocumentationScreen extends StatefulWidget {
  @override
  _DocumentationScreenState createState() => _DocumentationScreenState();
}

class _DocumentationScreenState extends State<DocumentationScreen> {
  List<Map<String, dynamic>> categories = [];
  List<Map<String, dynamic>> tags = [];
  List<AlgoliaObjectSnapshot> documents = [];
  bool isLoading = false;
  String searchText = '';

  @override
  void initState() {
    super.initState();
    loadCategories();
    loadTags();
  }

  Future<void> loadCategories() async {
    setState(() => isLoading = true);
    List<Map<String, dynamic>> fetchedCategories =
        await FirebaseService().getCategories();
    setState(() {
      categories = fetchedCategories;
      isLoading = false;
    });
  }

  Future<void> loadTags() async {
    setState(() => isLoading = true);
    List<Map<String, dynamic>> fetchedTags = await FirebaseService().getTags();
    setState(() {
      tags = fetchedTags;
      isLoading = false;
    });
  }

  void onCategorySelected(String categoryId) async {
    setState(() => isLoading = true);
    List<AlgoliaObjectSnapshot> documents =
        await AlgoliaService.queryDataWithFilters('', categoryId: categoryId);

    setState(() {
      this.documents = documents;
      isLoading = false;
    });
  }

  void onTagSelected(String tagId) async {
    setState(() => isLoading = true);
    List<AlgoliaObjectSnapshot> documents =
        await AlgoliaService.queryDataWithFilters('', tagId: [tagId]);

    setState(() {
      this.documents = documents;
      isLoading = false;
    });
  }

  void onSearchTextChanged(String text) async {
    if (text.isEmpty) return;

    setState(() => isLoading = true);
    List<AlgoliaObjectSnapshot> documents =
        await AlgoliaService.queryDataWithFilters(text);
    setState(() {
      searchText = text;
      this.documents = documents;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool hasSearched = searchText.isNotEmpty;
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              color: Colors.grey[200],
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  CupertinoTextField(
                    placeholder: 'Search...',
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                    onChanged: onSearchTextChanged,
                  ),
                  SizedBox(height: 10),
                  Expanded(
                    child: isLoading
                        ? Center(child: CircularProgressIndicator())
                        : FilterOptions(
                            categories: categories,
                            tags: tags,
                            onTagSelected: onTagSelected,
                            onCategorySelected: onCategorySelected,
                          ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 8,
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : DocumentationCards(
                    algoliaSnapshots: documents, hasSearched: hasSearched),
          ),
        ],
      ),
    );
  }
}
