import 'dart:io';

import 'package:chat/components/user_image_picker.dart';
import 'package:chat/core/models/auth_form_data.dart';
import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  final void Function(AuthFormData) onSubmit;
  const AuthForm({
    required this.onSubmit,
    super.key,
  });

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  final _authFormData = AuthFormData();

  void _handleImagePick(File image) {
    _authFormData.image = image;
  }

  void _submit() {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    if (_authFormData.image == null && _authFormData.isSingUp) {
      return _showError('We need a image for complete your registration');
    }
    widget.onSubmit(_authFormData);
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          textAlign: TextAlign.center,
        ),
        backgroundColor: Theme.of(context).errorColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(24),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              if (_authFormData.isSingUp)
                UserImagePicker(onImagePick: _handleImagePick),
              if (_authFormData.isSingUp)
                TextFormField(
                  key: const ValueKey('name'),
                  initialValue: _authFormData.name,
                  onChanged: (name) => _authFormData.name = name,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    contentPadding: EdgeInsets.all(8),
                  ),
                  validator: (_name) {
                    final name = _name ?? '';
                    if (name.isEmpty) {
                      return 'Please insert a Name';
                    } else if (name.trim().length <= 3) {
                      return 'Please your name need contains 3 or more characters';
                    }
                    return null;
                  },
                ),
              TextFormField(
                key: const ValueKey('email'),
                initialValue: _authFormData.email,
                onChanged: (email) => _authFormData.email = email,
                decoration: const InputDecoration(
                  labelText: 'E-mail',
                  contentPadding: EdgeInsets.all(8),
                ),
                validator: (_email) {
                  final email = _email ?? '';
                  if (email.isEmpty) {
                    return 'Please insert a E-mail';
                  } else if (!email.contains('@')) {
                    return 'Please insert a valid E-mail';
                  }
                  return null;
                },
              ),
              TextFormField(
                key: const ValueKey('password'),
                initialValue: _authFormData.password,
                onChanged: (password) => _authFormData.password = password,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  contentPadding: EdgeInsets.all(8),
                ),
                validator: (_password) {
                  final password = _password ?? '';
                  if (password.isEmpty) {
                    return 'Please insert a password';
                  } else if (password.length < 6) {
                    return 'The password need contains 6 or more characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _submit,
                child: Text(_authFormData.isSingIn ? 'Sign In' : 'Sign Up'),
              ),
              TextButton(
                onPressed: () => setState(() => _authFormData.toggleAuthMode()),
                child: Text(
                  _authFormData.isSingIn ? 'Register' : 'Sign In',
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
