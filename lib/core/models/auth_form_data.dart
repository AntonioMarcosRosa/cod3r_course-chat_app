import 'dart:io';

enum AuthMode {
  signUp,
  signIn,
}

class AuthFormData {
  String name = '';
  String email = '';
  String password = '';
  File? image;
  AuthMode _mode = AuthMode.signIn;

  bool get isSingIn {
    return _mode == AuthMode.signIn;
  }

  bool get isSingUp {
    return _mode == AuthMode.signUp;
  }

  void toggleAuthMode() {
    _mode = isSingIn ? AuthMode.signUp : AuthMode.signIn;
  }
}
