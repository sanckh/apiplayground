import 'package:algolia/algolia.dart';
import 'package:apiplayground/services/algolia_service.dart';
import 'package:apiplayground/widgets/documentation_cards.dart';
import 'package:apiplayground/widgets/filter_options_widget.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:apiplayground/models/documents.dart';
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

  @override
  void initState() {
    super.initState();
    loadCategories();
    loadTags();
  }

  Future<void> loadCategories() async {
    setState(() => isLoading = true);
    List<Map<String, dynamic>> fetchedCategories = await FirebaseService().getCategories();
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
  // Since queryDataWithFilters now expects a List<String> for tagId,
  // we wrap the single tagId in a list.
  List<AlgoliaObjectSnapshot> documents =
      await AlgoliaService.queryDataWithFilters('', tagId: [tagId]);
      
  setState(() {
    this.documents = documents;
    isLoading = false;
  });
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            flex: 2,
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : FilterOptions(
                    categories: categories,
                    tags: tags,
                    onTagSelected: onTagSelected,
                    onCategorySelected: onCategorySelected,
                  ),
          ),
          Expanded(
            flex: 8,
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : DocumentationCards(algoliaSnapshots: documents),
          ),
        ],
      ),
    );
  }
  
}
