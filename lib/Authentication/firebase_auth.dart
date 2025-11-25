
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreData {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserCredential> signUpWithEmailPassword(String name, int number, String email, String password) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await _firestore.collection("users").doc(userCredential.user!.uid).set({
        'uid': userCredential.user!.uid,
        'name': name,
        'number': number,
        'email': email,
      });
      return userCredential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        throw Exception(
            'The email address is already in use by another account.');
      } else if (e.code == 'weak-password') {
        throw Exception('The password provided is too weak.');
      } else if (e.code == 'invalid-email') {
        throw Exception('The email address is badly formatted.');
      } else {
        throw Exception(e.message ?? 'An undefined error occurred.');
      }
    }
  }

  Future<UserCredential> signInWithEmailPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw Exception('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        throw Exception('Wrong password provided for that user.');
      } else if (e.code == 'invalid-email') {
        throw Exception('The email address is badly formatted.');
      } else {
        throw Exception(e.message ?? 'An undefined error occurred.');
      }
    }
  }


  void addRideToUser(String userId) {
    FirebaseFirestore.instance
        .collection('users') // Main collection
        .doc(userId) // User document ID
        .collection('rides') // Subcollection inside user
        .add({
      'busNumber': 'Bus 10',
      'route': 'Route A',
      'date': DateTime.now(),
      'status': 'Completed'
    }).then((value) {
      print("Ride added successfully!");
    }).catchError((error) {
      print("Failed to add ride: $error");
    });
  }

}