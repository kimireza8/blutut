import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../domain/entities/user_entity.dart';
import '../../../domain/usecases/user_fetchdata_usecase.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {

  ProfileCubit({required UserFetchDataUsecase userFetchDataUsecase})
      : _userFetchDataUsecase = userFetchDataUsecase,
        super(ProfileInitial());
  final UserFetchDataUsecase _userFetchDataUsecase;

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
