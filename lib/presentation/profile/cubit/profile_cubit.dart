import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../domain/entities/user_entity.dart';
import '../../../domain/usecases/user_fetch_usecase.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {

  ProfileCubit({required UserFetchUseCase userFetchDataUsecase})
      : _userFetchDataUsecase = userFetchDataUsecase,
        super(ProfileInitial());
  final UserFetchUseCase _userFetchDataUsecase;

  Future<void> fetchUserData() async {
    emit(ProfileLoading());
    try {
      UserEntity user = await _userFetchDataUsecase.call();
      emit(ProfileLoaded(user: user));
    } catch (e) {
      emit(ProfileError(message: e.toString()));
    }
  }
}
