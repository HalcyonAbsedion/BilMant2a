// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String email;
  final String uid;
  final String photoUrl;
  final String firstName;
  final String lastName;
  final String birthDate;
  final String bio;
  final String phoneNumber;
  final String ownerId;
  final String gender;
  final bool isOrganization;
  final List followers;
  final List following;
  final List locations;
  final List organizations;
  final List postIds;
  User({
    required this.email,
    required this.uid,
    required this.photoUrl,
    required this.firstName,
    required this.lastName,
    required this.birthDate,
    required this.bio,
    required this.phoneNumber,
    required this.ownerId,
    required this.gender,
    required this.isOrganization,
    required this.followers,
    required this.following,
    required this.locations,
    required this.organizations,
    required this.postIds,
  });

  static User fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return User(
      firstName: snapshot["firstName"],
      lastName: snapshot["lastName"],
      birthDate: snapshot["birthDate"],
      gender: snapshot["gender"],
      phoneNumber: snapshot["phoneNumber"],
      uid: snapshot["uid"],
      email: snapshot["email"],
      photoUrl: snapshot["photoUrl"],
      bio: snapshot["bio"],
      followers: snapshot["followers"],
      following: snapshot["following"],
      locations: snapshot["locations"],
      ownerId: snapshot["ownerId"],
      organizations: snapshot["organizations"],
      isOrganization: snapshot["isOrganization"],
      postIds: snapshot["postIds"],
    );
  }

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "email": email,
        "photoUrl": photoUrl,
        "firstName": firstName,
        "lastName": lastName,
        "birthDate": birthDate,
        "bio": bio,
        "phoneNumber": phoneNumber,
        "ownerId": ownerId,
        "gender": gender,
        "isOrganization": isOrganization,
        "followers": followers,
        "following": following,
        "locations": locations,
        "organizations": organizations,
        "postIds": postIds,
      };
}
