import 'package:equatable/equatable.dart';
import 'package:shared/common/user_entity.dart';

abstract class UserListState extends Equatable {
  @override
  List<Object?> get props => [];
}

class UserListInitial extends UserListState {}

class UserListLoading extends UserListState {}

class UserListLoaded extends UserListState {
  final List<UserEntity> users;

  UserListLoaded(this.users);

  @override
  List<Object?> get props => [users];
}

class UserListError extends UserListState {
  final String message;

  UserListError(this.message);

  @override
  List<Object?> get props => [message];
}
