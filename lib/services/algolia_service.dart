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
}

