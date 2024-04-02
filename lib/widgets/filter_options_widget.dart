import 'package:flutter/material.dart';

class FilterOptions extends StatelessWidget {
  final List<Map<String, dynamic>> categories;
  final Function(String categoryId) onCategorySelected;
  final List<String> tags;

  const FilterOptions({Key? key, required this.categories, required this.onCategorySelected, required this.tags}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Text('Categories'),
        for (var category in categories) 
          ListTile(
            title: Text(category['name']),
            onTap: () {
              onCategorySelected(category['id']);
            },
          ),
        Divider(),
        Text('Tags'),
        for (var tag in tags)
          ListTile(
            title: Text(tag),
            onTap: () {
              // Update your search/filter logic
            },
          ),
      ],
    );
  }
}
