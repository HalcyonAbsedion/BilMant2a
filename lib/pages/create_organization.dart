import 'package:bilmant2a/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:bilmant2a/services/auth_service.dart';
import 'package:provider/provider.dart';

import '../components/navbar.dart';
import '../providers/user_provider.dart'; // Import your AuthService

class CreateOrganizationPage extends StatefulWidget {
  const CreateOrganizationPage({Key? key}) : super(key: key);

  @override
  _CreateOrganizationPageState createState() => _CreateOrganizationPageState();
}

class _CreateOrganizationPageState extends State<CreateOrganizationPage> {
  final _organizationNameController = TextEditingController();
  final _locationController = TextEditingController();
  final _creationDateController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isLoading = false;

  void _createOrganization() async {
    if (_isLoading) return;
    setState(() {
      _isLoading = true;
    });

    try {
      // Get values from controllers
      String organizationName = _organizationNameController.text.trim();
      String location = _locationController.text.trim();
      String creationDate = _creationDateController.text.trim();
      String email = _emailController.text.trim();
      String password = _passwordController.text.trim();
      String confirmPassword = _confirmPasswordController.text.trim();

      // Validate fields
      if (organizationName.isEmpty ||
          location.isEmpty ||
          creationDate.isEmpty ||
          email.isEmpty ||
          password.isEmpty ||
          confirmPassword.isEmpty) {
        _displayMessage("Please fill in all fields");
        return;
      }

      if (password != confirmPassword) {
        _displayMessage("Passwords do not match");
        return;
      }

      // Call AuthService to create user and organization
      String result = await AuthMethods().signOrganization(
        email: email,
        birthDate: creationDate,
        organizationName: organizationName,
        password: password,
        location: location,
      );

      if (result == "success") {
        _displayMessage("Organization created successfully!");
        // Clear text fields on success
        _organizationNameController.clear();
        _locationController.clear();
        _creationDateController.clear();
        _emailController.clear();
        _passwordController.clear();
        _confirmPasswordController.clear();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NavBar(),
          ),
        );
      } else {
        _displayMessage("Failed to create organization: $result");
      }
    } catch (e) {
      _displayMessage("An error occurred: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _displayMessage(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Organization'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const Text(
                "Create Organization",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _organizationNameController,
                decoration: InputDecoration(
                  labelText: 'Organization Name',
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _locationController,
                decoration: InputDecoration(
                  labelText: 'Location / Area',
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _creationDateController,
                decoration: InputDecoration(
                  labelText: 'Creation Date',
                  suffixIcon: IconButton(
                    onPressed: () async {
                      final pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now(),
                      );
                      if (pickedDate != null) {
                        setState(() {
                          _creationDateController.text =
                              DateFormat('yyyy-MM-dd').format(pickedDate);
                        });
                      }
                    },
                    icon: Icon(Icons.calendar_today),
                  ),
                ),
                readOnly: true,
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                ),
                obscureText: true,
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _confirmPasswordController,
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                ),
                obscureText: true,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isLoading ? null : _createOrganization,
                child: _isLoading
                    ? const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      )
                    : const Text('Create Organization'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _organizationNameController.dispose();
    _locationController.dispose();
    _creationDateController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}
