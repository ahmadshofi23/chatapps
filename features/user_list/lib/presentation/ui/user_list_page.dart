import 'package:auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_list/presentation/bloc/user_list_state.dart';
import '../bloc/user_list_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserListPage extends StatelessWidget {
  final User currentUser;

  const UserListPage({Key? key, required this.currentUser}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Online Users"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              BlocProvider.of<AuthBloc>(context).add(AuthSignOutRequested());
              Modular.to.pushReplacementNamed('/auth');
            },
          ),
        ],
      ),

      body: BlocBuilder<UserListBloc, UserListState>(
        builder: (context, state) {
          if (state is UserListLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is UserListLoaded) {
            final users =
                state.users.where((u) => u.uid != currentUser.uid).toList();

            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return ListTile(
                  leading: const Icon(Icons.person),
                  title: Text(user.displayName ?? 'No Name'),
                  subtitle: Text(
                    (user.isOnline ?? false) ? "Online" : "Offline",
                  ),
                  onTap: () {
                    Modular.to.pushNamed(
                      '/chat/${user.uid}/${Uri.encodeComponent(user.displayName ?? 'No Name')}',
                      arguments: {'currentUser': currentUser},
                    );
                  },
                  onLongPress: () {
                    Modular.to.pushNamed('/profile/${user.uid}');
                  },
                );
              },
            );
          } else {
            return const Center(child: Text("Failed to load users"));
          }
        },
      ),
    );
  }
}
