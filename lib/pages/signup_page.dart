import 'package:bilmant2a/pages/login_page.dart';
import 'package:bilmant2a/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String _selectedGender = 'Male';
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmpasswordController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();

  final _locationController = TextEditingController();
  final _genderController = TextEditingController();
  final _birthDateController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmpasswordController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();

    _locationController.dispose();
    _genderController.dispose();
    super.dispose();
  }

  OverlayEntry? _overlayEntry;
  bool _isLoading = false;

  void signUp() async {
    if (_isLoading) return;
    _isLoading = true;

    try {
      _showProgressIndicator();

      if (_passwordController.text != _confirmpasswordController.text) {
        _hideProgressIndicator();
        _isLoading = false;
        displayMessage("Passwords don't match!");
        return;
      }

      String res = await AuthMethods().signUpUser(
        email: _emailController.text.trim(),
        birthDate: _birthDateController.text,
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        gender: _selectedGender,
        password: _passwordController.text.trim(),
        location: _locationController.text.trim(),
      );

      _hideProgressIndicator();
      _isLoading = false;

      if (res == "success") {
      } else {
        displayMessage(res);
      }
    } catch (e) {
      _hideProgressIndicator();
      _isLoading = false;
      displayMessage("An error occurred: $e");
    }
  }

  void _showProgressIndicator() {
    if (_overlayEntry == null) {
      _overlayEntry = OverlayEntry(
        builder: (context) => Center(
          child: Container(
            child: const CircularProgressIndicator(),
          ),
        ),
      );
      Overlay.of(context)?.insert(_overlayEntry!);
    }
  }

  void _hideProgressIndicator() {
    if (_overlayEntry != null) {
      _overlayEntry?.remove();
      _overlayEntry = null;
    }
  }

  void displayMessage(String message) {
    if (!_isLoading) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(message),
        ),
      );
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        // elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.primary,
        leading: IconButton(
          onPressed: () =>
              Navigator.push(context, MaterialPageRoute(builder: (context) {
            return const LoginPage();
          })),
          icon: const Icon(
            Icons.arrow_back_ios,
            size: 20,
            color: Colors.black,
          ),
        ),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        height: MediaQuery.of(context).size.height - 50,
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              const Column(
                children: <Widget>[
                  Text(
                    "Sign up",
                    style: TextStyle(
                        fontSize: 60,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Create an account, It's free ",
                    style: TextStyle(
                        fontFamily: 'Product Sans',
                        fontSize: 14,
                        color: Color.fromARGB(255, 0, 0, 0)),
                  )
                ],
              ),
              Column(
                children: <Widget>[
                  inputFile(
                      label: "First Name", controller: _firstNameController),
                  inputFile(
                      label: "Last Name", controller: _lastNameController),
                  inputFile(label: "Email", controller: _emailController),
                  inputFile(
                      label: "Location / Area",
                      controller: _locationController),
                  DropdownButton<String>(
                    value: _selectedGender,
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedGender = newValue!;
                      });
                    },
                    items: <String>['Male', 'Female', 'Do Not Specify']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: TextStyle(color: Colors.black),
                        ),
                      );
                    }).toList(),
                  ),
                  // inputFile(label: "Gender", controller: _genderController),
                  TextField(
                    controller: _birthDateController,
                    decoration: const InputDecoration(
                      icon: Icon(
                        Icons.calendar_today_rounded,
                        color: Colors.black,
                      ),
                      labelText: "D.O.B",
                      border: InputBorder.none,
                    ),
                    onTap: () async {
                      DateTime? pickedate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1905),
                        lastDate: DateTime.now(),
                      );

                      if (pickedate != null) {
                        setState(() {
                          _birthDateController.text =
                              DateFormat("dd-MM-yyyy").format(pickedate);
                        });
                      }
                    },
                    readOnly: true,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  inputFile(
                      label: "Password",
                      controller: _passwordController,
                      obscureText: true),
                  inputFile(
                      label: "Confirm Password",
                      controller: _confirmpasswordController,
                      obscureText: true),
                ],
              ),
              Container(
                padding: const EdgeInsets.only(top: 0, left: 0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  border: const Border(
                    bottom: BorderSide(color: Colors.black),
                    top: BorderSide(color: Colors.black),
                    left: BorderSide(color: Colors.black),
                    right: BorderSide(color: Colors.black),
                  ),
                ),
                child: MaterialButton(
                  minWidth: double.infinity,
                  height: 60,
                  onPressed: signUp,
                  color: Color.fromARGB(255, 242, 0, 0),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: const Text(
                    "Sign up!",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) {
                  return const LoginPage();
                })),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already have an account?"),
                    Text(
                      " Login",
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

Widget inputFile({
  required String label,
  bool obscureText = false,
  required TextEditingController controller,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Text(
        label,
        style: const TextStyle(
            fontSize: 15, fontWeight: FontWeight.w400, color: Colors.black87),
      ),
      const SizedBox(
        height: 5,
      ),
      TextField(
        obscureText: obscureText,
        controller: controller,
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color.fromARGB(255, 0, 0, 0)),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue),
          ),
        ),
      ),
      const SizedBox(
        height: 10,
      )
    ],
  );
}
