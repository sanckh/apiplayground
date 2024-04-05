import 'package:apiplayground/models/topic_model.dart';
import 'package:apiplayground/services/firebase_service.dart';
import 'package:apiplayground/widgets/posts_page_widget.dart';
import 'package:flutter/material.dart';

class TopicsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Topic>>(
      stream: FirebaseService().fetchTopics(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return CircularProgressIndicator();
        List<Topic> topics = snapshot.data!;
        return ListView.builder(
          itemCount: topics.length,
          itemBuilder: (context, index) {
            Topic topic = topics[index];
            return ListTile(
              title: Text(topic.name),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PostsPage(topicId: topic.id)
                    ),
                );
              },
            );
          },
        );
      },
    );
  }
}
