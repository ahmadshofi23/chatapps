// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_modular/flutter_modular.dart';
// import 'package:user_list/presentation/bloc/user_list_bloc.dart';
// import 'package:user_list/presentation/bloc/user_list_event.dart';
// import 'package:user_list/presentation/bloc/user_list_state.dart';

// class UserListPage extends StatelessWidget {
//   const UserListPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final bloc = Modular.get<UserListBloc>()..add(LoadUserList());

//     return Scaffold(
//       appBar: AppBar(title: const Text("User Online")),
//       body: BlocBuilder<UserListBloc, UserListState>(
//         bloc: bloc,
//         builder: (context, state) {
//           if (state is UserListLoading) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (state is UserListLoaded) {
//             return ListView.builder(
//               itemCount: state.users.length,
//               itemBuilder: (context, index) {
//                 final user = state.users[index];
//                 return ListTile(
//                   leading: CircleAvatar(
//                     backgroundImage: NetworkImage(user.photoUrl),
//                   ),
//                   title: Text(user.name),
//                   subtitle: Text(user.email),
//                   trailing:
//                       user.isOnline
//                           ? const Icon(
//                             Icons.circle,
//                             color: Colors.green,
//                             size: 12,
//                           )
//                           : const Icon(
//                             Icons.circle,
//                             color: Colors.grey,
//                             size: 12,
//                           ),
//                   onTap: () {
//                     // TODO: Navigate to chat
//                     print('user id: ${user.uid}');

//                     Modular.to.pushNamed(
//                       '/chat',
//                       arguments: {
//                         'chatId': user.uid,
//                         'currentUserId': user.uid,
//                       },
//                       // Modular.args.data['currentUserId'],
//                     );
//                   },
//                 );
//               },
//             );
//           } else if (state is UserListError) {
//             return Center(child: Text(state.message));
//           }
//           return const SizedBox.shrink();
//         },
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_list/presentation/bloc/user_list_state.dart';
import '../bloc/user_list_bloc.dart';

// class UserListPage extends StatelessWidget {
//   const UserListPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('User Online')),
//       body: BlocBuilder<UserListBloc, UserListState>(
//         builder: (context, state) {
//           if (state is UserListLoading) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (state is UserListLoaded) {
//             final users = state.users;
//             return ListView.builder(
//               itemCount: users.length,
//               itemBuilder: (_, index) {
//                 final user = users[index];
//                 return ListTile(
//                   leading: const Icon(Icons.person),
//                   title: Text(user.displayName ?? 'No Name'),
//                   subtitle: Text(user.email ?? ''),
//                   trailing:
//                       user.isOnline == true
//                           ? Icon(Icons.circle, color: Colors.green, size: 12)
//                           : Icon(Icons.circle, color: Colors.grey, size: 12),
//                 );
//               },
//             );
//           } else if (state is UserListError) {
//             return Center(child: Text(state.message));
//           } else {
//             return const Center(child: Text('No data'));
//           }
//         },
//       ),
//     );
//   }
// }

// features/user_list/presentation/pages/user_list_page.dart

import 'package:flutter_modular/flutter_modular.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserListPage extends StatelessWidget {
  final User currentUser;

  const UserListPage({Key? key, required this.currentUser}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Online Users")),
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
