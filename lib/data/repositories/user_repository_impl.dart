import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/user_repository.dart';
import '../models/user_model.dart';
import '../remote/remote_user_provider.dart';

class UserRepositoryImpl implements UserRepository {
  const UserRepositoryImpl({required RemoteUserProvider remoteUserProvider})
      : _remoteUserProvider = remoteUserProvider;

  final RemoteUserProvider _remoteUserProvider;

  @override
  Future<UserEntity> getUserInfo() async {
    UserModel userModel = await _remoteUserProvider.getUserInfo();
    return _mapUserModelToEntity(userModel);
  }

  UserEntity _mapUserModelToEntity(UserModel userModel) =>
      UserEntity(
        userId: userModel.userId,
        userUsername: userModel.userUsername,
        userName: userModel.userName,
        userType: userModel.userType,
        userLanguage: userModel.userLanguage,
        userTimezone: userModel.userTimezone,
        userRole: _mapUserRoleModelToEntity(
          userModel.userRole?.toJson(),
        ),
        userProfiles: _mapUserProfileListModelToEntityList(
          userModel.userProfiles?.map((e) => e.toJson()).toList(),
        ),
        userRoles: _mapUserRoleListModelToEntityList(
          userModel.userRoles?.map((e) => e.toJson()).toList(),
        ),
        userEmployee: userModel.userEmployee.toString(),
        userCompany: userModel.userCompany.toString(),
        userUnit: userModel.userUnit.toString(),
        userDepartment: userModel.userDepartment.toString(),
        userSubdepartment: userModel.userSubdepartment.toString(),
        userOrganization: _mapUserOrganizationModelToEntity(
          userModel.userOrganization?.toJson(),
        ),
        organizationDepth: userModel.organizationDepth,
        userCanloginweb: userModel.userCanloginweb,
        userEndpoint: userModel.userEndpoint.toString(),
        userEmail: userModel.userEmail,
        userOrganizationU0: _mapUserOrganizationModelToEntity(
          userModel.userOrganizationU0?.toJson(),
        ),
        userOrganizationU1: _mapUserOrganizationModelToEntity(
          userModel.userOrganizationU1?.toJson(),
        ),
        userOrganizationU2: _mapUserOrganizationModelToEntity(
          userModel.userOrganizationU2?.toJson(),
        ),
        userOrganizationU3: _mapUserOrganizationModelToEntity(
          userModel.userOrganizationU3?.toJson(),
        ),
        userOrganizationU4: _mapUserOrganizationModelToEntity(
          userModel.userOrganizationU4?.toJson(),
        ),
        userOrganizationU5: _mapUserOrganizationModelToEntity(
          userModel.userOrganizationU5?.toJson(),
        ),
      );

  UserRoleEntity? _mapUserRoleModelToEntity(Map<String, dynamic>? roleModel) {
    if (roleModel == null) {
      return null;
    }
    return UserRoleEntity(
      roleId: roleModel['roleId'] as String? ?? '',
      roleCode: roleModel['roleCode'] as String? ?? '',
      roleName: roleModel['roleName'] as String? ?? '',
      roleInternalcode: roleModel['roleInternalcode'] as String? ?? '',
    );
  }

  List<UserProfileEntity>? _mapUserProfileListModelToEntityList(
    List<dynamic>? profileList,
  ) =>
      profileList?.map((profileModel) {
        var profileMap = profileModel as Map<String, dynamic>;
        return UserProfileEntity(
          profileId: profileMap['profileId'] as String? ?? '',
          profileCode: profileMap['profileCode'] as String? ?? '',
          profileName: profileMap['profileName'] as String? ?? '',
          profileDescription: profileMap['profileDescription'] as String? ?? '',
          profileVisible: profileMap['profileVisible'] as String? ?? '',
          profileParentId: profileMap['profileParentId'] as String? ?? '',
          profileUpdatedBy: profileMap['profileUpdatedBy'] as String? ?? '',
          profileUpdatedDate: profileMap['profileUpdatedDate'] as String? ?? '',
          profileCreatedBy: profileMap['profileCreatedBy'] as String? ?? '',
          profileCreatedDate: profileMap['profileCreatedDate'] as String? ?? '',
          profileRowActive: profileMap['profileRowActive'] as String? ?? '',
          roleProfile2profileId:
              profileMap['roleProfile2profileId'] as String? ?? '',
          roleProfile2profileRoleId:
              profileMap['roleProfile2profileRoleId'] as String? ?? '',
          roleProfile2profileProfileId:
              profileMap['roleProfile2profileProfileId'] as String? ?? '',
        );
      }).toList();

  List<UserRoleEntity>? _mapUserRoleListModelToEntityList(
    List<dynamic>? roleList,
  ) =>
      roleList?.map((roleModel) {
        var roleMap = roleModel as Map<String, dynamic>;
        return UserRoleEntity(
          roleId: roleMap['roleId'] as String? ?? '',
          roleCode: roleMap['roleCode'] as String? ?? '',
          roleName: roleMap['roleName'] as String? ?? '',
          roleInternalcode: roleMap['roleInternalcode'] as String? ?? '',
        );
      }).toList();

  UserOrganizationEntity? _mapUserOrganizationModelToEntity(
    Map<String, dynamic>? organizationModel,
  ) {
    if (organizationModel == null) {
      return null;
    }
    return UserOrganizationEntity(
      organizationId: organizationModel['organizationId'] as String? ?? '',
      organizationCode: organizationModel['organizationCode'] as String? ?? '',
      organizationName: organizationModel['organizationName'] as String? ?? '',
      organizationInternalcode:
          organizationModel['organizationInternalcode'] as String? ?? '',
      organizationInternalcodelevel:
          organizationModel['organizationInternalcodelevel'] as String? ?? '',
    );
  }
}
