abstract class SearchableItem {
  String get title;
  String get description;
  String? get imageUrl; // Make nullable if some items might not have an image
}
