import 'package:apiplayground/models/user_model.dart';
import 'package:apiplayground/services/user_service.dart';
import 'package:apiplayground/views/documentation_screen.dart';
import 'package:apiplayground/views/forum_screen.dart';
import 'package:apiplayground/views/home_screen.dart';
import 'package:apiplayground/views/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:shared_preferences/shared_preferences.dart';

class MainNavigationScreen extends StatefulWidget {
  @override
  _MainNavigationScreenState createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;
  final UserService _userService = UserService();
  User? _user;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadIndex();
    _fetchUserData();
  }

  void _loadIndex() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _currentIndex = prefs.getInt('currentIndex') ?? 0;
    });
  }

  void _saveIndex(int index) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('currentIndex', index);
  }

  _fetchUserData() async {
    final firebaseUser = auth.FirebaseAuth.instance.currentUser;
    if (firebaseUser != null) {
      User? user = await _userService.getUserProfile(firebaseUser.uid);
      if (mounted) {
        setState(() {
          _user = user;
          _isLoading = false;
        });
      }
    } else {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final List<Widget> _screens = [
      HomeScreen(),
      ProfileScreen(user: _user!),
      DocumentationScreen(),
      ForumScreen(),
      // SettingsScreen(), // Uncomment and replace with actual SettingsScreen
    ];

    void _onSelectItem(int index) {
      Navigator.of(context).pop(); // Close the drawer
      setState(() {
        _currentIndex = index;
      });
      _saveIndex(index);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('API Playground'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Drawer Header',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () => _onSelectItem(0),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Profile'),
              onTap: () => _onSelectItem(1),
            ),
            ListTile(
              leading: Icon(Icons.library_books),
              title: Text('Documentation'),
              onTap: () => _onSelectItem(2),
            ),
            ListTile(
              leading: Icon(Icons.folder),
              title: Text('Forum'),
              onTap: () => _onSelectItem(3),
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () => _onSelectItem(4),
            ),
          ],
        ),
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
    );
  }
}
