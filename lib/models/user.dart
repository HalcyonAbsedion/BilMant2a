// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class User {
  final String email;
  final String uid;
  final String photoUrl;
  final String username;
  final String bio;
  final List followers;
  final List following;
  final List organizations;
  final bool isOrganization;
  final String ownerId;
  final List locations;
  User({
    required this.email,
    required this.uid,
    required this.photoUrl,
    required this.username,
    required this.bio,
    required this.followers,
    required this.following,
    required this.organizations,
    required this.isOrganization,
    required this.ownerId,
    required this.locations,
  });
  

  User copyWith({
    String? email,
    String? uid,
    String? photoUrl,
    String? username,
    String? bio,
    List? followers,
    List? following,
    List? organizations,
    bool? isOrganization,
    String? ownerId,
    List? locations,
  }) {
    return User(
      email: email ?? this.email,
      uid: uid ?? this.uid,
      photoUrl: photoUrl ?? this.photoUrl,
      username: username ?? this.username,
      bio: bio ?? this.bio,
      followers: followers ?? this.followers,
      following: following ?? this.following,
      organizations: organizations ?? this.organizations,
      isOrganization: isOrganization ?? this.isOrganization,
      ownerId: ownerId ?? this.ownerId,
      locations: locations ?? this.locations,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'email': email,
      'uid': uid,
      'photoUrl': photoUrl,
      'username': username,
      'bio': bio,
      'followers': followers,
      'following': following,
      'organizations': organizations,
      'isOrganization': isOrganization,
      'ownerId': ownerId,
      'locations': locations,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      email: map['email'] as String,
      uid: map['uid'] as String,
      photoUrl: map['photoUrl'] as String,
      username: map['username'] as String,
      bio: map['bio'] as String,
      followers: List.from((map['followers'] as List)),
      following: List.from((map['following'] as List)),
      organizations: List.from((map['organizations'] as List)),
      isOrganization: map['isOrganization'] as bool,
      ownerId: map['ownerId'] as String,
      locations: List.from((map['locations'] as List)),
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'User(email: $email, uid: $uid, photoUrl: $photoUrl, username: $username, bio: $bio, followers: $followers, following: $following, organizations: $organizations, isOrganization: $isOrganization, ownerId: $ownerId, locations: $locations)';
  }

  @override
  bool operator ==(covariant User other) {
    if (identical(this, other)) return true;
  
    return 
      other.email == email &&
      other.uid == uid &&
      other.photoUrl == photoUrl &&
      other.username == username &&
      other.bio == bio &&
      listEquals(other.followers, followers) &&
      listEquals(other.following, following) &&
      listEquals(other.organizations, organizations) &&
      other.isOrganization == isOrganization &&
      other.ownerId == ownerId &&
      listEquals(other.locations, locations);
  }

  @override
  int get hashCode {
    return email.hashCode ^
      uid.hashCode ^
      photoUrl.hashCode ^
      username.hashCode ^
      bio.hashCode ^
      followers.hashCode ^
      following.hashCode ^
      organizations.hashCode ^
      isOrganization.hashCode ^
      ownerId.hashCode ^
      locations.hashCode;
  }
}
