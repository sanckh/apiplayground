import 'dart:io';
import 'package:apiplayground/models/user_model.dart';
import 'package:apiplayground/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ProfileScreen extends StatefulWidget{
  final User user;

  ProfileScreen({required this.user});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>{
  late User _user;
  final UserService _userService = UserService();

  final _picker = ImagePicker();
  File? _image; 

  Future getImage() async {
    XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if(image != null){
        _image = File(image.path);
        uploadImageToFirebase(context);
      }
      else{
        print('No image selected');
      }
    });
  }

  Future uploadImageToFirebase(BuildContext context) async {
    String fileName = _user.id;
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference reference = storage.ref().child('images/$fileName');
    UploadTask uploadTask = reference.putFile(_image!);
    await uploadTask.then((res) async {
      await res.ref.getDownloadURL().then((value) async {
        setState(() {
          _user.avatar = value;
        });
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _user = widget.user;
  }

  Widget _buildProfileHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(50), top: Radius.circular(50)
        )
      ),
      child: Center(
        child: Column(
          children: [
            Stack(children: [
              _image != null ? 
              CircleAvatar(
                backgroundImage: FileImage(_image!),
                radius: 60,
              )
              : CircleAvatar(
                radius: 60,
                backgroundImage: AssetImage("asset3.png"),
              ),
            Positioned(
              bottom: -10,
              left: 80,
              child: IconButton(
                onPressed: getImage,
                icon: Icon(Icons.add_a_photo),
              ),
            )
            ]),
            SizedBox(height: 15),
            Text(
              _user.username,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.blue.shade300,
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(50)),
              ),
              child: _buildProfileHeader( context ),
            ),
          ]
        )
      )
    );
  }
}