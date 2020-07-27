import 'dart:async';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';
import 'package:zoomer_management/validators/login_validators.dart';

enum LoginState { IDLE, LOADING, SUCCESS, FAIL }

//Bloc to control the login feature

class LoginBloc extends BlocBase with LoginValidators {
  final _emailController = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();
  final _stateController = BehaviorSubject<LoginState>();

//Stream that returns the email if its valid and an error if its not
  Stream<String> get outEmail =>
      _emailController.stream.transform(validateEmail);

//Stream that returns the password if its valid and an error if its not
  Stream<String> get outPassword =>
      _passwordController.stream.transform(validatePassword);

//Stream that returns the current login screen state
  Stream<LoginState> get outState => _stateController.stream;

//Stream that returns if the login button is enabled
  Stream<bool> get outSubmitValid =>
      Observable.combineLatest2(outEmail, outPassword, (a, b) => true);

  Function(String) get changeEmail => _emailController.sink.add;
  Function(String) get changePassword => _passwordController.sink.add;

  StreamSubscription _streamSubscription;

  LoginBloc() {
//function to do an auto login when the user open tha app and is alredy logged
    _streamSubscription =
        FirebaseAuth.instance.onAuthStateChanged.listen((user) async {
      if (user != null) {
        if (await verifyPrivileges(user)) {
          _stateController.add(LoginState.SUCCESS);
        } else {
          FirebaseAuth.instance.signOut();
          _stateController.add(LoginState.FAIL);
        }
      } else {
        _stateController.add(LoginState.IDLE);
      }
    });
  }

//function to do the user login
  void submit() {
    final email = _emailController.value;
    final password = _passwordController.value;

    _stateController.add(LoginState.LOADING);

    FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password)
        .catchError((e) {
      _stateController.add(LoginState.FAIL);
    });
  }

//function to check if the email used have the admin privilege
  Future<bool> verifyPrivileges(FirebaseUser user) async {
    return await Firestore.instance
        .collection("admins")
        .document(user.uid)
        .get()
        .then((doc) {
      if (doc.data != null) {
        return true;
      } else {
        return false;
      }
    }).catchError((e) {
      return false;
    });
  }

  @override
  void dispose() {
    _emailController.close();
    _passwordController.close();
    _stateController.close();

    _streamSubscription.cancel();
  }
}
