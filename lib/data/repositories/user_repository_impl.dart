import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/user_repository.dart';
import '../remote/remote_user_provider.dart';

class UserRepositoryImpl implements UserRepository {
  final RemoteUserProvider _remoteUserProvider;

  UserRepositoryImpl({required RemoteUserProvider remoteUserProvider})
      : _remoteUserProvider = remoteUserProvider;

  @override
  Future<UserEntity> getUserInfo() async {
    final userModel = await _remoteUserProvider.getUserInfo();
    return UserEntity(
      userId: userModel.userId,
      userUsername: userModel.userUsername,
      userName: userModel.userName,
      userType: userModel.userType,
      userLanguage: userModel.userLanguage,
      userTimezone: userModel.userTimezone,
      userRole: UserRoleEntity(
        roleId: userModel.userRole?.roleId ?? '',
        roleCode: userModel.userRole?.roleCode ?? '',
        roleName: userModel.userRole?.roleName ?? '',
        roleInternalcode: userModel.userRole?.roleInternalcode ?? '',
      ),
      userProfiles: userModel.userProfiles
              ?.map((profile) => UserProfileEntity(
                    profileId: profile.profileId,
                    profileCode: profile.profileCode,
                    profileName: profile.profileName,
                    profileDescription: profile.profileDescription,
                    profileVisible: profile.profileVisible,
                    profileParentId: profile.profileParentId,
                    profileUpdatedBy: profile.profileUpdatedBy,
                    profileUpdatedDate: profile.profileUpdatedDate,
                    profileCreatedBy: profile.profileCreatedBy,
                    profileCreatedDate: profile.profileCreatedDate,
                    profileRowActive: profile.profileRowActive,
                    roleProfile2profileId: profile.roleProfile2profileId,
                    roleProfile2profileRoleId: profile.roleProfile2profileRoleId,
                    roleProfile2profileProfileId:
                        profile.roleProfile2profileProfileId,
                  ))
              .toList() ??
          [],
      userRoles: userModel.userRoles
              ?.map((role) => UserRoleEntity(
                    roleId: role.roleId,
                    roleCode: role.roleCode,
                    roleName: role.roleName,
                    roleInternalcode: role.roleInternalcode,
                  ))
              .toList() ??
          [],
      userEmployee: userModel.userEmployee,
      userCompany: userModel.userCompany,
      userUnit: userModel.userUnit,
      userDepartment: userModel.userDepartment,
      userSubdepartment: userModel.userSubdepartment,
      userOrganization: UserOrganizationEntity(
        organizationId: userModel.userOrganization?.organizationId ?? '',
        organizationCode: userModel.userOrganization?.organizationCode ?? '',
        organizationName: userModel.userOrganization?.organizationName ?? '',
        organizationInternalcode:
            userModel.userOrganization?.organizationInternalcode ?? '',
        organizationInternalcodelevel:
            userModel.userOrganization?.organizationInternalcodelevel ?? '',
      ),
      organizationDepth: userModel.organizationDepth,
      userCanloginweb: userModel.userCanloginweb,
      userEndpoint: userModel.userEndpoint,
      userEmail: userModel.userEmail,
      userOrganizationU0: UserOrganizationEntity(
        organizationId: userModel.userOrganizationU0?.organizationId ?? '',
        organizationCode: userModel.userOrganizationU0?.organizationCode ?? '',
        organizationName: userModel.userOrganizationU0?.organizationName ?? '',
        organizationInternalcode:
            userModel.userOrganizationU0?.organizationInternalcode ?? '',
        organizationInternalcodelevel:
            userModel.userOrganizationU0?.organizationInternalcodelevel ?? '',
      ),
      userOrganizationU1: UserOrganizationEntity(
        organizationId: userModel.userOrganizationU1?.organizationId ?? '',
        organizationCode: userModel.userOrganizationU1?.organizationCode ?? '',
        organizationName: userModel.userOrganizationU1?.organizationName ?? '',
        organizationInternalcode:
            userModel.userOrganizationU1?.organizationInternalcode ?? '',
        organizationInternalcodelevel:
            userModel.userOrganizationU1?.organizationInternalcodelevel ?? '',
      ),
      userOrganizationU2: UserOrganizationEntity(
        organizationId: userModel.userOrganizationU2?.organizationId ?? '',
        organizationCode: userModel.userOrganizationU2?.organizationCode ?? '',
        organizationName: userModel.userOrganizationU2?.organizationName ?? '',
        organizationInternalcode:
            userModel.userOrganizationU2?.organizationInternalcode ?? '',
        organizationInternalcodelevel:
            userModel.userOrganizationU2?.organizationInternalcodelevel ?? '',
      ),
      userOrganizationU3: UserOrganizationEntity(
        organizationId: userModel.userOrganizationU3?.organizationId ?? '',
        organizationCode: userModel.userOrganizationU3?.organizationCode ?? '',
        organizationName: userModel.userOrganizationU3?.organizationName ?? '',
        organizationInternalcode:
            userModel.userOrganizationU3?.organizationInternalcode ?? '',
        organizationInternalcodelevel:
            userModel.userOrganizationU3?.organizationInternalcodelevel ?? '',
      ),
      userOrganizationU4: UserOrganizationEntity(
        organizationId: userModel.userOrganizationU4?.organizationId ?? '',
        organizationCode: userModel.userOrganizationU4?.organizationCode ?? '',
        organizationName: userModel.userOrganizationU4?.organizationName ?? '',
        organizationInternalcode:
            userModel.userOrganizationU4?.organizationInternalcode ?? '',
        organizationInternalcodelevel:
            userModel.userOrganizationU4?.organizationInternalcodelevel ?? '',
      ),
      userOrganizationU5: UserOrganizationEntity(
        organizationId: userModel.userOrganizationU5?.organizationId ?? '',
        organizationCode: userModel.userOrganizationU5?.organizationCode ?? '',
        organizationName: userModel.userOrganizationU5?.organizationName ?? '',
        organizationInternalcode:
            userModel.userOrganizationU5?.organizationInternalcode ?? '',
        organizationInternalcodelevel:
            userModel.userOrganizationU5?.organizationInternalcodelevel ?? '',
      ),
    );
  }
}