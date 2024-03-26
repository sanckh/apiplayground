import 'package:apiplayground/views/login_screen.dart';
import 'package:apiplayground/views/search_results_screen.dart';
import 'package:apiplayground/widgets/search_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  
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
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  Flexible(
                    fit: FlexFit.loose,
                    child: SearchWidget(
                      onSearch: (query) {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => SearchResultsScreen(searchQuery: query),
                        ));
                      },
                    ),
                  )
                ],
              ),
              ElevatedButton(
                onPressed: _signOut,
                child: Text('Sign Out')
              )
            ]
          )
        )
      )
    );
  }
}
