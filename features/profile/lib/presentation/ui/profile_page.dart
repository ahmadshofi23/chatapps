import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:profile/presentation/bloc/profile_event.dart';
import 'package:profile/presentation/bloc/profile_state.dart';
import '../bloc/profile_bloc.dart';

class ProfilePage extends StatelessWidget {
  final String uid;

  const ProfilePage({Key? key, required this.uid}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    context.read<ProfileBloc>().add(LoadUserProfile(uid));

    return Scaffold(
      appBar: AppBar(title: Text('User Profile')),
      body: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is ProfileLoaded) {
            final user = state.profile;
            return SizedBox(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 20),
                  CircleAvatar(
                    backgroundImage: NetworkImage(
                      user.photoUrl ?? 'https://i.pravatar.cc/150',
                    ),
                    radius: 50,
                  ),
                  SizedBox(height: 20),
                  Text('${user.displayName}', style: TextStyle(fontSize: 24)),
                  Text('${user.email}'),
                  Text(
                    user.isOnline == true ? 'Online' : 'Offline',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            );
          } else if (state is ProfileError) {
            return Center(child: Text('Error: ${state.message}'));
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
