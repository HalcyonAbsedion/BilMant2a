import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bilmant2a/models/user.dart' as model;

class AuthMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // get user details
  Future<model.User> getUserDetails() async {
    User currentUser = _auth.currentUser!;

    DocumentSnapshot documentSnapshot =
        await _firestore.collection('Users').doc(currentUser.uid).get();

    return model.User.fromSnap(documentSnapshot);
  }

  // Signing Up User

  Future<String> signUpUser({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String birthDate,
    required String location,
    required String gender,
  }) async {
    String res = "Some error Occurred";
    try {
      if (email.isNotEmpty ||
          password.isNotEmpty ||
          firstName.isNotEmpty ||
          lastName.isNotEmpty ||
          birthDate.isNotEmpty ||
          location.isNotEmpty) {
        // registering user in auth with email and password
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        // String photoUrl =
        //     await StorageMethods().uploadImageToStorage('profilePics', file, false);

        model.User user = model.User(
          firstName: firstName,
          lastName: lastName,
          uid: cred.user!.uid,
          photoUrl: "",
          email: email,
          bio: "",
          phoneNumber: "", // Add an empty string or any default value if needed
          birthDate:
              birthDate, // Add an empty string or any default value for birthDate
          gender: "Male", // Add a default value for gender if needed
          followers: [], // Add empty list for followers
          following: [], // Add empty list for following
          locations: [location], // Add empty list for locations
          isOrganization: false,
          organizations: [], // Add empty list for organizations
          ownerId: cred.user!.uid,
        );
        // adding user in our database
        await _firestore
            .collection("Users")
            .doc(cred.user!.uid)
            .set(user.toJson());

        res = "success";
      } else {
        res = "Please enter all the fields";
      }
    } catch (err) {
      return err.toString();
    }
    return res;
  }

  // logging in user
  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String res = "Some error Occurred";
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        // logging in user with email and password
        await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        res = "success";
      } else {
        res = "Please enter all the fields";
      }
    } catch (err) {
      return err.toString();
    }
    return res;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
