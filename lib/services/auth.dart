import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

abstract class AuthBase{
  User? get currentUser ;
  Stream<User?> authStateChanges();
  Future<User?>loginWithEmailAndPassword(String email,String password);
  Future<User?>signWithEmailAndPassword(String email,String password);
 Future <void> logOut();
 
 }
class Auth implements AuthBase{

  final _firebaseAuth = FirebaseAuth.instance;
  @override
  Future<User?> loginWithEmailAndPassword( String email,String password) async{
    final userAuth = await _firebaseAuth.signInWithEmailAndPassword(email: email.trim(), password: password.trim());
    return userAuth.user;
  }

  @override
  Future<User?> signWithEmailAndPassword(String email,String password) async{
    
  final userAuth = await _firebaseAuth.createUserWithEmailAndPassword(email: email.trim(), password: password.trim());
  return userAuth.user;
  }
  
  @override
  Stream<User?> authStateChanges() => _firebaseAuth.authStateChanges();
  
  @override
  
  User? get currentUser =>_firebaseAuth.currentUser;
  
  @override
  Future<void> logOut() async => await _firebaseAuth.signOut();

}