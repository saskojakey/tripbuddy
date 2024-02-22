import 'package:flutter/material.dart';
import 'feed_page.dart'; // Import the FeedPage

class HomePage extends StatelessWidget {
  final String username;
  final String email;

  HomePage({required this.username, required this.email});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TripBuddy Home'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Welcome, $username!'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate to the FeedPage when the button is pressed
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FeedPage(),
                  ),
                );
              },
              child: Text('Go to Feed'),
            ),
          ],
        ),
      ),
    );
  }
}
