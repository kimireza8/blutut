class UserEntity {
  UserEntity({
    required this.userId,
    required this.userUsername,
    required this.userName,
    required this.userType,
    required this.userLanguage,
    required this.userCanloginweb,
    required this.userEmail,
    this.userTimezone,
    this.userRole,
    this.userProfiles,
    this.userRoles,
    this.userEmployee,
    this.userCompany,
    this.userUnit,
    this.userDepartment,
    this.userSubdepartment,
    this.userOrganization,
    this.organizationDepth,
    this.userEndpoint,
    this.userOrganizationU0,
    this.userOrganizationU1,
    this.userOrganizationU2,
    this.userOrganizationU3,
    this.userOrganizationU4,
    this.userOrganizationU5,
  });
  final String userId;
  final String userUsername;
  final String userName;
  final String userType;
  final String userLanguage;
  final String? userTimezone;
  final UserRoleEntity? userRole;
  final List<UserProfileEntity>? userProfiles;
  final List<UserRoleEntity>? userRoles;
  final dynamic userEmployee;
  final dynamic userCompany;
  final dynamic userUnit;
  final dynamic userDepartment;
  final dynamic userSubdepartment;
  final UserOrganizationEntity? userOrganization;
  final int? organizationDepth;
  final String userCanloginweb;
  final dynamic userEndpoint;
  final String userEmail;
  final UserOrganizationEntity? userOrganizationU0;
  final UserOrganizationEntity? userOrganizationU1;
  final UserOrganizationEntity? userOrganizationU2;
  final UserOrganizationEntity? userOrganizationU3;
  final UserOrganizationEntity? userOrganizationU4;
  final UserOrganizationEntity? userOrganizationU5;
}

class UserRoleEntity {
  UserRoleEntity({
    required this.roleId,
    required this.roleCode,
    required this.roleName,
    required this.roleInternalcode,
  });
  final String roleId;
  final String roleCode;
  final String roleName;
  final String roleInternalcode;
}

class UserProfileEntity {
  UserProfileEntity({
    required this.profileId,
    required this.profileCode,
    required this.profileName,
    required this.profileDescription,
    required this.profileVisible,
    required this.profileParentId,
    required this.profileUpdatedBy,
    required this.profileUpdatedDate,
    required this.profileRowActive,
    required this.roleProfile2profileId,
    required this.roleProfile2profileRoleId,
    required this.roleProfile2profileProfileId,
    this.profileCreatedBy,
    this.profileCreatedDate,
  });
  final String profileId;
  final String profileCode;
  final String profileName;
  final String profileDescription;
  final String profileVisible;
  final String profileParentId;
  final String profileUpdatedBy;
  final String profileUpdatedDate;
  final dynamic profileCreatedBy;
  final dynamic profileCreatedDate;
  final String profileRowActive;
  final String roleProfile2profileId;
  final String roleProfile2profileRoleId;
  final String roleProfile2profileProfileId;
}

class UserOrganizationEntity {
  UserOrganizationEntity({
    required this.organizationId,
    required this.organizationCode,
    required this.organizationName,
    required this.organizationInternalcode,
    required this.organizationInternalcodelevel,
  });
  final String organizationId;
  final String organizationCode;
  final String organizationName;
  final String organizationInternalcode;
  final String organizationInternalcodelevel;
}
