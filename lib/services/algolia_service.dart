import 'package:algolia/algolia.dart';
import 'package:apiplayground/algolia_options.dart';

class AlgoliaService {
  static final Algolia algolia = Algolia.init(
    applicationId: AlgoliaOptions.applicationId,
    apiKey: AlgoliaOptions.apiKey,
  );
  
  static Future<List<AlgoliaObjectSnapshot>> queryDocumentationData(String queryString) async {
    AlgoliaQuery query = AlgoliaService.algolia.instance
        .index('documentation')
        .query(queryString);
    
    AlgoliaQuerySnapshot snapshot = await query.getObjects();
    List<AlgoliaObjectSnapshot> results = snapshot.hits;

    return results;
  }

  static Future<List<AlgoliaObjectSnapshot>> queryDataWithFilters(String queryString, {String? categoryId, List<String>? tagId}) async {
    AlgoliaQuery query = AlgoliaService.algolia.instance.index('documentation').query(queryString);
    
    if (categoryId != null) {
    query = query.facetFilter('category_id:$categoryId');
  }

  if (tagId != null && tagId.isNotEmpty) {
    for (String tag in tagId) {
      query = query.facetFilter('tag_ids:$tag');
    }
  }

  AlgoliaQuerySnapshot snapshot = await query.getObjects();
  return snapshot.hits;
  }

    static Future<List<AlgoliaObjectSnapshot>> queryPostData(String queryString) async {
    AlgoliaQuery query = AlgoliaService.algolia.instance
        .index('post')
        .query(queryString);
    
    AlgoliaQuerySnapshot snapshot = await query.getObjects();
    List<AlgoliaObjectSnapshot> results = snapshot.hits;

    return results;
  }
}



