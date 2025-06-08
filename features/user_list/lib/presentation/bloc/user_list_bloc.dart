import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared/common/user_entity.dart';
import 'package:user_list/domain/usecase/get_online_users_usecase.dart';
import 'package:user_list/presentation/bloc/user_list_event.dart';
import 'package:user_list/presentation/bloc/user_list_state.dart';

import 'package:bloc/bloc.dart';

class UserListBloc extends Bloc<UserListEvent, UserListState> {
  final GetOnlineUsersUsecase getOnlineUsers;

  UserListBloc({required this.getOnlineUsers}) : super(UserListInitial()) {
    on<LoadOnlineUsers>((event, emit) async {
      emit(UserListLoading());
      await emit.forEach<List<UserEntity>>(
        getOnlineUsers(),
        onData: (users) => UserListLoaded(users),
        onError: (_, __) => UserListError('Failed to load users'),
      );
    });
  }
}
