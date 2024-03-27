import 'package:apiplayground/views/login_screen.dart';
import 'package:apiplayground/views/search_results_screen.dart';
import 'package:apiplayground/widgets/search_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:apiplayground/models/tutorials.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Tutorial> _tutorials = [];
  
  @override
  void initState() {
    super.initState();
    _loadTutorials();
  }

  void _loadTutorials() async {
    FirebaseFirestore.instance
    .collection('documentation')
    .orderBy('create_date', descending: true)
    .snapshots()
    .listen((snapshot) {
    final newTutorials = snapshot.docs.map((doc) => Tutorial.fromMap(doc.data(), doc.id)).toList();
    setState(() {
        _tutorials = newTutorials;
    });
},
onError: (error) => print("Error fetching tutorials: $error"));


  }

  @override
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
                      GridView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10
                        ),
                        itemCount: _tutorials.length,
                        itemBuilder: (context, index) {
                          final tutorial = _tutorials[index];
                          return InkWell(
                            onTap: () {
                              //Navigate to tutorial detail screen
                            },
                            child: Card(
                              child: Padding(
                                padding: EdgeInsets.all(8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      tutorial.title,
                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      tutorial.description,
                                      style: TextStyle(fontSize: 14),
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                    )
                                  ]
                                ))
                            ),
                          );
                        },
                      ),
            ]
          )
        )
      )
    );
  }
}
