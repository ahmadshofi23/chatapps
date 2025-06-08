import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/auth_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          if (state is AuthLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is AuthAuthenticated) {
            Modular.to.pushReplacementNamed(
              '/user-list',
              arguments: {'currentUser': state.user},
            );
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Welcome, ${state.user.displayName ?? "User"}'),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      ReadContext(
                        context,
                      ).read<AuthBloc>().add(AuthSignOutRequested());
                    },
                    child: const Text('Logout'),
                  ),
                ],
              ),
            );
          } else {
            return Center(
              child: ElevatedButton(
                onPressed: () {
                  ReadContext(
                    context,
                  ).read<AuthBloc>().add(AuthSignInRequested());
                },
                child: const Text('Login with Google'),
              ),
            );
          }
        },
      ),
    );
  }
}
