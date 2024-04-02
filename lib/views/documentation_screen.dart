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
  List<AlgoliaObjectSnapshot> documents = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    loadCategories();
  }

  Future<void> loadCategories() async {
    setState(() => isLoading = true);
    List<Map<String, dynamic>> fetchedCategories = await FirebaseService().getCategories();
    setState(() {
      categories = fetchedCategories;
      isLoading = false;
    });
  }

   void onCategorySelected(String categoryId) async {
    setState(() => isLoading = true);
    List<AlgoliaObjectSnapshot> documents =
        await AlgoliaService.queryDataWithFilters('', category: categoryId);
    setState(() {
      this.documents = documents;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
  final tags = ['Tag 1', 'Tag 2', 'Tag 3'];
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
