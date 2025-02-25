class UserModel {
  UserModel({
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

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        userId: json['user_id'].toString(),
        userUsername: json['user_username'] as String,
        userName: json['user_name'] as String,
        userType: json['user_type'] as String,
        userLanguage: json['user_language'].toString(),
        userTimezone: json['user_timezone'] as String?,
        userRole: json['user_role'] == null
            ? null
            : UserRole.fromJson(json['user_role'] as Map<String, dynamic>),
        userProfiles: (json['user_profiles'] as List<dynamic>?)
            ?.map((e) => UserProfile.fromJson(e as Map<String, dynamic>))
            .toList(),
        userRoles: (json['user_roles'] as List<dynamic>?)
            ?.map((e) => UserRole.fromJson(e as Map<String, dynamic>))
            .toList(),
        userEmployee: json['user_employee'],
        userCompany: json['user_company'],
        userUnit: json['user_unit'],
        userDepartment: json['user_department'],
        userSubdepartment: json['user_subdepartment'],
        userOrganization: json['user_organization'] == null
            ? null
            : UserOrganization.fromJson(
                json['user_organization'] as Map<String, dynamic>,
              ),
        organizationDepth: json['organization_depth'] as int?,
        userCanloginweb: json['user_canloginweb'].toString(),
        userEndpoint: json['user_endpoint'],
        userEmail: json['user_email'] as String,
        userOrganizationU0: json['user_organization_u0'] == null
            ? null
            : UserOrganization.fromJson(
                json['user_organization_u0'] as Map<String, dynamic>,
              ),
        userOrganizationU1: json['user_organization_u1'] == null
            ? null
            : UserOrganization.fromJson(
                json['user_organization_u1'] as Map<String, dynamic>,
              ),
        userOrganizationU2: json['user_organization_u2'] == null
            ? null
            : UserOrganization.fromJson(
                json['user_organization_u2'] as Map<String, dynamic>,
              ),
        userOrganizationU3: json['user_organization_u3'] == null
            ? null
            : UserOrganization.fromJson(
                json['user_organization_u3'] as Map<String, dynamic>,
              ),
        userOrganizationU4: json['user_organization_u4'] == null
            ? null
            : UserOrganization.fromJson(
                json['user_organization_u4'] as Map<String, dynamic>,
              ),
        userOrganizationU5: json['user_organization_u5'] == null
            ? null
            : UserOrganization.fromJson(
                json['user_organization_u5'] as Map<String, dynamic>,
              ),
      );
  final String userId;
  final String userUsername;
  final String userName;
  final String userType;
  final String userLanguage;
  final String? userTimezone;
  final UserRole? userRole;
  final List<UserProfile>? userProfiles;
  final List<UserRole>? userRoles;
  final dynamic userEmployee;
  final dynamic userCompany;
  final dynamic userUnit;
  final dynamic userDepartment;
  final dynamic userSubdepartment;
  final UserOrganization? userOrganization;
  final int? organizationDepth;
  final String userCanloginweb;
  final dynamic userEndpoint;
  final String userEmail;
  final UserOrganization? userOrganizationU0;
  final UserOrganization? userOrganizationU1;
  final UserOrganization? userOrganizationU2;
  final UserOrganization? userOrganizationU3;
  final UserOrganization? userOrganizationU4;
  final UserOrganization? userOrganizationU5;

  Map<String, dynamic> toJson() => {
        'user_id': userId,
        'user_username': userUsername,
        'user_name': userName,
        'user_type': userType,
        'user_language': userLanguage,
        'user_timezone': userTimezone,
        'user_role': userRole?.toJson(),
        'user_profiles': userProfiles?.map((e) => e.toJson()).toList(),
        'user_roles': userRoles?.map((e) => e.toJson()).toList(),
        'user_employee': userEmployee,
        'user_company': userCompany,
        'user_unit': userUnit,
        'user_department': userDepartment,
        'user_subdepartment': userSubdepartment,
        'user_organization': userOrganization?.toJson(),
        'organization_depth': organizationDepth,
        'user_canloginweb': userCanloginweb,
        'user_endpoint': userEndpoint,
        'user_email': userEmail,
        'user_organization_u0': userOrganizationU0?.toJson(),
        'user_organization_u1': userOrganizationU1?.toJson(),
        'user_organization_u2': userOrganizationU2?.toJson(),
        'user_organization_u3': userOrganizationU3?.toJson(),
        'user_organization_u4': userOrganizationU4?.toJson(),
        'user_organization_u5': userOrganizationU5?.toJson(),
      };
}

class UserRole {
  UserRole({
    required this.roleId,
    required this.roleCode,
    required this.roleName,
    required this.roleInternalcode,
  });

  factory UserRole.fromJson(Map<String, dynamic> json) => UserRole(
        roleId: json['role_id'].toString(),
        roleCode: json['role_code'] as String,
        roleName: json['role_name'] as String,
        roleInternalcode: json['role_internalcode'] as String,
      );
  final String roleId;
  final String roleCode;
  final String roleName;
  final String roleInternalcode;

  Map<String, dynamic> toJson() => {
        'role_id': roleId,
        'role_code': roleCode,
        'role_name': roleName,
        'role_internalcode': roleInternalcode,
      };
}

class UserProfile {
  UserProfile({
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

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
        profileId: json['profile_id'].toString(),
        profileCode: json['profile_code'] as String,
        profileName: json['profile_name'] as String,
        profileDescription: json['profile_description'] as String,
        profileVisible: json['profile_visible'].toString(),
        profileParentId: json['_profile_parent_id'].toString(),
        profileUpdatedBy: json['_profile_updated_by'].toString(),
        profileUpdatedDate: json['_profile_updated_date'] as String,
        profileCreatedBy: json['_profile_created_by'],
        profileCreatedDate: json['_profile_created_date'],
        profileRowActive: json['_profile_row_active'].toString(),
        roleProfile2profileId: json['role_profile2profile_id'].toString(),
        roleProfile2profileRoleId:
            json['role_profile2profile_role_id'].toString(),
        roleProfile2profileProfileId:
            json['role_profile2profile_profile_id'].toString(),
      );
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

  Map<String, dynamic> toJson() => {
        'profile_id': profileId,
        'profile_code': profileCode,
        'profile_name': profileName,
        'profile_description': profileDescription,
        'profile_visible': profileVisible,
        '_profile_parent_id': profileParentId,
        '_profile_updated_by': profileUpdatedBy,
        '_profile_updated_date': profileUpdatedDate,
        '_profile_created_by': profileCreatedBy,
        '_profile_created_date': profileCreatedDate,
        '_profile_row_active': profileRowActive,
        'role_profile2profile_id': roleProfile2profileId,
        'role_profile2profile_role_id': roleProfile2profileRoleId,
        'role_profile2profile_profile_id': roleProfile2profileProfileId,
      };
}

class UserOrganization {
  UserOrganization({
    required this.organizationId,
    required this.organizationCode,
    required this.organizationName,
    required this.organizationInternalcode,
    required this.organizationInternalcodelevel,
  });

  factory UserOrganization.fromJson(Map<String, dynamic> json) =>
      UserOrganization(
        organizationId: json['organization_id'].toString(),
        organizationCode: json['organization_code'] as String,
        organizationName: json['organization_name'] as String,
        organizationInternalcode: json['organization_internalcode'] as String,
        organizationInternalcodelevel:
            json['organization_internalcodelevel'].toString(),
      );
  final String organizationId;
  final String organizationCode;
  final String organizationName;
  final String organizationInternalcode;
  final String organizationInternalcodelevel;

  Map<String, dynamic> toJson() => {
        'organization_id': organizationId,
        'organization_code': organizationCode,
        'organization_name': organizationName,
        'organization_internalcode': organizationInternalcode,
        'organization_internalcodelevel': organizationInternalcodelevel,
      };
}
