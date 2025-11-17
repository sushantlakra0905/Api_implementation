import 'package:flutter/cupertino.dart';
import 'package:neww/model/user_dob.dart';
import 'package:neww/model/user_location.dart';
import 'package:neww/model/user_name.dart';
import 'package:neww/model/user_picture.dart';  // Ensure this import is present

class User {
  final String gender;
  final String email;
  final String phone;
  final String cell;
  final String nat;
  final UserName name;
  final UserDob dob;
  final UserLocation location;
  final UserPicture picture;  // Added this field

  User({
    required this.gender,
    required this.email,
    required this.phone,
    required this.cell,
    required this.nat,
    required this.name,
    required this.dob,
    required this.location,
    required this.picture,  // Added this to the constructor
  });

  factory User.fromMap(Map<String, dynamic> e) {
    final name = UserName.fromMap(e['name']);
    final dob = UserDob.fromMap(e['dob']);
    final location = UserLocation.fromMap(e['location']);
    final picture = UserPicture.fromMap(e['picture']);  // This was already here

    return User(
      cell: e['cell'],
      email: e['email'],
      gender: e['gender'],
      nat: e['nat'],
      phone: e['phone'],
      name: name,
      dob: dob,
      location: location,
      picture: picture,  // Added this to store the parsed picture
    );
  }

  String get fullName {
    return '${name.title} ${name.first} ${name.last}';
  }
}