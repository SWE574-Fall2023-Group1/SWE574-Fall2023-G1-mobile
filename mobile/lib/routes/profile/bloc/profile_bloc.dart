import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memories_app/routes/profile/bloc/profile_event.dart';
import 'package:memories_app/routes/profile/bloc/profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(const ProfileInitial());
}
