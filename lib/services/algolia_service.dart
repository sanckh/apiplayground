import 'package:algolia/algolia.dart';
import 'package:apiplayground/algolia_options.dart';

class AlgoliaService {
  static final Algolia algolia = Algolia.init(
    applicationId: AlgoliaOptions.applicationId,
    apiKey: AlgoliaOptions.apiKey,
  );
  
  static Future<List<AlgoliaObjectSnapshot>> queryData(String queryString) async {
    AlgoliaQuery query = AlgoliaService.algolia.instance
        .index('documentation')
        .query(queryString);
    
    AlgoliaQuerySnapshot snapshot = await query.getObjects();
    List<AlgoliaObjectSnapshot> results = snapshot.hits;

    return results;
  }

  static Future<List<AlgoliaObjectSnapshot>> queryDataWithFilters(String queryString, {String? category, List<String>? tags}) async {

    AlgoliaQuery query = AlgoliaService.algolia.instance.index('documentation').query(queryString);
    if (category != null) {
    query = query.facetFilter('category:$category');
  }

  if (tags != null && tags.isNotEmpty) {
    for (String tag in tags) {
      query = query.facetFilter('tags:$tag');
    }
  }

  AlgoliaQuerySnapshot snapshot = await query.getObjects();
  return snapshot.hits;
  }
}

