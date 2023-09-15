import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileState extends Equatable {
  final UserProfile? userProfile;

  const ProfileState({this.userProfile});

  ProfileState copyWith({
    UserProfile? userProfile,
  }) {
    return ProfileState(
      userProfile: userProfile ?? this.userProfile,
    );
  }

  @override
  List<Object?> get props => [userProfile];
}

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(const ProfileState());

  void setUserProfile(UserProfile userProfile) {
    emit(state.copyWith(userProfile: userProfile));
  }
}

class UserProfile {
  final String name;
  final String email;
  final String profileUrl;

  UserProfile({
    required this.name,
    required this.email,
    required this.profileUrl,
  });
}
