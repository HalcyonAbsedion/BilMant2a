import 'package:bilmant2a/services/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;
  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
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

  void signUp() async {
    showDialog(
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    if (_passwordController.text != _confirmpasswordController.text) {
      Navigator.pop(context);
      displayMessage("Passwords don't match!");
      return;
    }
    String res = await AuthMethods().signUpUser(
        email: _emailController.text.trim(),
        birthDate: _birthDateController.text,
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        gender: _genderController.text.trim().toLowerCase() == 'male',
        password: _passwordController.text.trim());
    if (res == "success" && context.mounted) {
      Navigator.pop(context);
    } else {
      Navigator.pop(context);
      displayMessage(res);
    }
  }

  void displayMessage(String message) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(message),
            ));
  }

  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        // elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: widget.onTap
          // Ensure that you have the correct context for Navigator.pop
          // Navigator.pop(context);
          ,
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
                    ),
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
                  inputFile(label: "Gender", controller: _genderController),
                  TextField(
                    controller: _birthDateController,
                    decoration: const InputDecoration(
                      icon: Icon(Icons.calendar_today_rounded),
                      labelText: "Birthdate",
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
                    "Sign up",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: widget.onTap,
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
            borderSide: BorderSide(color: Color.fromARGB(255, 255, 0, 0)),
          ),
        ),
      ),
      const SizedBox(
        height: 10,
      )
    ],
  );
}
