import 'package:apiplayground/models/documents.dart';
import 'package:apiplayground/views/document_detail_screen.dart';
import 'package:flutter/material.dart';

//Screens
import 'package:apiplayground/widgets/monaco_editor_widget.dart';

// Define a model for Grid Items for flexibility
class GridItem {
  final String title;
  final String description;
  final VoidCallback onTap;
  final String? backgroundImage;

  GridItem(
      {required this.title,
      required this.description,
      required this.onTap,
      this.backgroundImage});
}

class HomeScreenGridWidget extends StatelessWidget {
  final List<Document> recentDocuments;
  final VoidCallback onCodeEditorTap;
  final VoidCallback onChallengesTap;
  final VoidCallback onForumTap;
  final VoidCallback onTutorialsTap;

  // Initialize with required callbacks or actions
  HomeScreenGridWidget({
    Key? key,
    required this.recentDocuments,
    required this.onCodeEditorTap,
    required this.onChallengesTap,
    required this.onForumTap,
    required this.onTutorialsTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    // Combine recent documents with other cards
    List<GridItem> items = recentDocuments.map((tutorial) {
      return GridItem(
          title: tutorial.title,
          description: tutorial.description,
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => DocumentDetailScreen(document: tutorial),
            ));
          });
    }).toList();

    void onCodeEditorTap() {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => MonacoEditorWidget(),
      ));
    }

    // Add other predefined cards with background images
    items.addAll([
      GridItem(
          title: 'Code Editor',
          description: 'Access the code editor.',
          onTap: onCodeEditorTap,
          backgroundImage: 'assets/asset3.png'),
      GridItem(
          title: 'Challenges',
          description: 'Solve challenges and quizzes.',
          onTap: onChallengesTap,
          backgroundImage: 'assets/asset3.png'),
      GridItem(
          title: 'Forum',
          description: 'Join the community forum.',
          onTap: onForumTap,
          backgroundImage: 'assets/asset3.png'),
      GridItem(
          title: 'Tutorials',
          description: 'Browse more tutorials.',
          onTap: onTutorialsTap,
          backgroundImage: 'assets/asset3.png'),
    ]);

    // Get screen width
    double screenWidth = MediaQuery.of(context).size.width;
    // Dynamic crossAxisCount based on screen width to control width of items
    int crossAxisCount = 2; // Example of 2
    // Assume a max item height of 200 pixels and calculate the aspect ratio accordingly
    // This is a simplistic approach; adjust the calculation based on your grid's margin, padding, and number of columns
    double maxItemHeight = 300.0;
    double maxItemWidth = screenWidth / crossAxisCount;
    double childAspectRatio = maxItemWidth / maxItemHeight;

    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount:
            crossAxisCount, // Adjust based on your layout preference
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: childAspectRatio,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return InkWell(
          onTap: item.onTap,
          child: Card(
            clipBehavior: Clip
                .antiAlias, // Ensures the image (or any decoration) is clipped to the card's borders
            child: Container(
              decoration: item.backgroundImage != null
                  ? BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(item.backgroundImage!),
                        fit: BoxFit.cover, // Cover the card's background
                        colorFilter: ColorFilter.mode(
                            Colors.black.withOpacity(0.3),
                            BlendMode
                                .darken), // Darken the image a bit for better text visibility
                      ),
                    )
                  : null,
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge!
                          .copyWith(color: const Color.fromARGB(255, 0, 0, 0)),
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 5),
                    Text(
                      item.description,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(color: const Color.fromARGB(255, 0, 0, 0)),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
