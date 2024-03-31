import 'package:apiplayground/views/login_screen.dart';
import 'package:apiplayground/views/search_results_screen.dart';
import 'package:apiplayground/widgets/home_screen_grid_widget.dart';
import 'package:apiplayground/widgets/search_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:apiplayground/models/documents.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Document> _tutorials = [];
  
  @override
  void initState() {
    super.initState();
    _loadTutorials();
  }

  void _loadTutorials() async {
    FirebaseFirestore.instance
    .collection('documentation')
    .limit(2)
    .orderBy('create_date', descending: true)
    .snapshots()
    .listen((snapshot) {
    final newTutorials = snapshot.docs.map((doc) => Document.fromMap(doc.data(), doc.id)).toList();
    setState(() {
        _tutorials = newTutorials;
      });
    },
    onError: (error) => print("Error fetching tutorials: $error"));
  }

  void _signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => LoginScreen()),
        (route) => false,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error signing out: $e')),
      );
    }
  }

    void _onSearch() {
    // Get the current search query
    String searchQuery = _searchController.text;
    // Navigate to the SearchResultsScreen with the search query
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => SearchResultsScreen(searchQuery: searchQuery),
    ));
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _signOut,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              SearchWidget(
                onSearch: (query) {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => SearchResultsScreen(searchQuery: query),
                  ));
                },
              ),
              SizedBox(height: 16),
              Align(
                alignment: Alignment.centerLeft,
                child: Text('Recent Updates',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
              ),
              HomeScreenGridWidget(
                recentDocuments: _tutorials,
                onCodeEditorTap: () {
                  // Navigate to the Code Editor screen
                },
                onChallengesTap: () {
                  // Navigate to the Challenges screen
                },
                onForumTap: () {
                  // Navigate to the Forum screen
                },
                onTutorialsTap: () {
                  // Navigate to the Tutorials screen
                },
              ),
            ]
          )
        )
      )
    );
  }
}

