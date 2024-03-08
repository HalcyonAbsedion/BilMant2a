import 'package:bilmant2a/pages/profile_edit.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class Profile extends StatefulWidget {
  const Profile({
    Key? key,
  }) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  File? _imageFile; // Define _imageFile

  final ImagePicker _imagePicker = ImagePicker();

  Future<void> _pickImage() async {
    XFile? pickedImage =
        await _imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _imageFile = File(pickedImage.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.share,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage:
                          _imageFile != null ? FileImage(_imageFile!) : null,
                    ),
                    InkWell(
                      onTap: _pickImage, // Call the function to pick an image
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: const Color.fromARGB(255, 255, 0, 0),
                        child: const Icon(
                          Icons.edit,
                          size: 25,
                          color: Color.fromARGB(255, 255, 255, 255),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    "Moustapha Almasri",
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildInfoColumn("16", "Friends"),
                    _buildInfoColumn("16", "Connections"),
                    _buildInfoColumn("16", "Posts"),
                  ],
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  child: const Text("Edit Profile"),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfilePageEdit(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(0),
                    fixedSize: const Size(300, 50),
                    backgroundColor: Colors.red,
                    textStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                GridView.builder(
                  shrinkWrap: true,
                  itemCount: 3, // Number of boxes
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        // Handle box tap
                        print('You Pressed $index !');
                      },
                      child: Container(
                        height: 50, // Adjust box height as needed
                        color: Colors.grey[300],
                        child: Center(
                          child: Text(
                            'Post ${index + 1}',
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoColumn(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 0),
        Text(
          label,
          style: const TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
      ],
    );
  }
}
