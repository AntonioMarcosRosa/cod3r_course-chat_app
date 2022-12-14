import 'package:chat/components/auth_form.dart';
import 'package:chat/core/models/auth_form_data.dart';
import 'package:chat/core/services/auth/auth_mock_service.dart';
import 'package:chat/core/services/auth/auth_service.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool isLoading = false;
  Future<void> _handleSubmit(AuthFormData authFormData) async {
    try {
      if (!mounted) return;
      setState((() => isLoading = true));

      if (authFormData.isSingIn) {
        await AuthService().signIn(authFormData.email, authFormData.password);
      } else {
        await AuthService().signUp(
          authFormData.name,
          authFormData.email,
          authFormData.password,
          authFormData.image,
        );
      }
    } catch (error) {
      //Error
    } finally {
      if (!mounted) return;
      setState((() => isLoading = false));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Stack(
        children: [
          Center(
            child: SingleChildScrollView(
              child: AuthForm(
                onSubmit: _handleSubmit,
              ),
            ),
          ),
          if (isLoading)
            Container(
              decoration:
                  const BoxDecoration(color: Color.fromRGBO(0, 0, 0, 0.5)),
              child: const Center(child: CircularProgressIndicator()),
            )
        ],
      ),
    );
  }
}
