import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bilmant2a/providers/user_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bilmant2a/pages/create_organization.dart';
import '../components/user_tile.dart';

class ManageOrganizationsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    String currentUserUid = userProvider.getUser.uid;

    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Organizations'),
      ),
      body: _buildUserList(currentUserUid, context),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to the page for creating new organizations
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreateOrganizationPage(),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildUserList(String currentUserUid, BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('Users')
          .where('ownerId', isEqualTo: currentUserUid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          List<QueryDocumentSnapshot> documents = snapshot.data!.docs;

          if (documents.isEmpty) {
            return Center(
              child: Text(
                'No organizations available.',
                style: TextStyle(fontSize: 18),
              ),
            );
          }

          return ListView.builder(
            itemCount: documents.length,
            itemBuilder: (context, index) {
              QueryDocumentSnapshot document = documents[index];
              Map<String, dynamic>? organizationData =
                  document.data() as Map<String, dynamic>?;

              if (organizationData == null) {
                return ListTile(
                  title: Text('Invalid organization data'),
                );
              }

              String organizationName =
                  organizationData['firstName'] ?? 'Unknown';
              String organizationId = document.id;

              return ListTile(
                title: Text(organizationName),
                onTap: () {
                  _showPasswordDialog(context, organizationId);
                },
              );
            },
          );
        }
      },
    );
  }

  Future<void> _showPasswordDialog(
      BuildContext context, String organizationId) async {
    String password = ''; // State variable to hold the entered password

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter Password'),
          content: TextField(
            onChanged: (value) {
              password = value;
            },
            obscureText: true,
            decoration: InputDecoration(
              hintText: 'Enter your password',
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Handle password validation and login logic here
                // You can compare the entered password with the stored password
                // and perform the login action accordingly
                // For demonstration, print the entered password
                print('Entered password: $password');

                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Submit'),
            ),
          ],
        );
      },
    );
  }
}
