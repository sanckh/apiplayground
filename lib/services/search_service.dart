import 'package:cloud_firestore/cloud_firestore.dart';

class SearchService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<DocumentSnapshot>> performSearch(String query) async {
    List<String> searchTerms = query.toLowerCase().split(' ');
    List<Query> searchQueries = searchHelper(searchTerms);
    List<DocumentSnapshot> searchResults = [];

    for (Query searchQuery in searchQueries) {
      QuerySnapshot results = await searchQuery.get();
      searchResults.addAll(results.docs);
    }

    // Remove duplicates from searchResults, if any
    searchResults = searchResults.toSet().toList();

    return searchResults;
  }

  List<Query> searchHelper(List<String> searchTerms) {
    List<Query> queries = [];
    for (String term in searchTerms) {
      queries.add(_firestore.collection('documentation').where('author', arrayContains: term));
      queries.add(_firestore.collection('documentation').where('title', isEqualTo: term));
      queries.add(_firestore.collection('documentation').where('content', isEqualTo: term));
      queries.add(_firestore.collection('documentation').where('tags', arrayContains: term));
      queries.add(_firestore.collection('documentation').where('category', arrayContains: term));
      // Add other fields you want to search in
    }
    return queries;
  }
}