import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';

// ... (existing imports)

class FeedPage extends StatefulWidget {
  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  User? currentUser;
  List<Post> posts = [];

  @override
  void initState() {
    super.initState();
    initializeFirebase(); // Initialize Firebase in initState
  }

  Future<void> initializeFirebase() async {
    await Firebase.initializeApp();
    setState(() {
      currentUser = FirebaseAuth.instance.currentUser;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TripBuddy Feed'),
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () async {
              // Show the dialog to add a new post
              if (currentUser != null) {
                String? email = currentUser!.email;
                if (email != null) {
                  Post? newPost = await showDialog(
                    context: context,
                    builder: (context) => AddPostDialog(username: email),
                  );

                  // Add the new post to the list if a post is returned
                  if (newPost != null) {
                    setState(() {
                      posts.add(newPost);
                    });
                  }
                }
              }
            },
            child: Text('Add New Post'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(posts[index].username),
                      SizedBox(height: 5),
                      PolaroidFrame(
                        child: Image.memory(
                          posts[index].imageBytes!,
                          height: 100,
                          width: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class PolaroidFrame extends StatelessWidget {
  final Widget child;

  PolaroidFrame({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.tealAccent,
            Colors.deepPurpleAccent,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: AspectRatio(
        aspectRatio: 0.8, // Set the aspect ratio to your preference
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10.0),
          child: child,
        ),
      ),
    );
  }
}

class AddPostDialog extends StatefulWidget {
  final String username; // Add this line
  AddPostDialog({required this.username});
  @override
  _AddPostDialogState createState() => _AddPostDialogState();
}

class _AddPostDialogState extends State<AddPostDialog> {
  final ImagePicker _picker = ImagePicker();
  TextEditingController postNameController = TextEditingController();

  Uint8List? _imageBytes;

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      setState(() {
        _imageBytes = bytes;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add New Post'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ... (existing code)
          _imageBytes != null
              ? PolaroidFrame(
                  child: Image.memory(
                    _imageBytes!,
                    height: 100,
                    width: 100,
                    fit: BoxFit.cover,
                  ),
                )
              : SizedBox(),
          _imageBytes != null
              ? PolaroidFrame(
                  child: Image.memory(
                    _imageBytes!,
                    height: 100,
                    width: 100,
                    fit: BoxFit.cover,
                  ),
                )
              : SizedBox(),
          ElevatedButton(
            onPressed: _pickImage,
            child: Text('Pick an Image'),
          ),
        ],
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            // Create a new post object
            Post newPost = Post(
                postName: postNameController.text,
                imageBytes: _imageBytes,
                username: this.widget.username);

            // Close the dialog and pass the new post back to FeedPage
            Navigator.pop(context, newPost);
          },
          child: Text('Add Post'),
        ),
      ],
    );
  }
}

class Post {
  String postName;
  Uint8List? imageBytes;
  String username;

  Post({required this.postName, this.imageBytes, required this.username});
}
