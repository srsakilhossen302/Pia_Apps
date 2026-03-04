class UserProfileResponseModel {
  int? statusCode;
  bool? success;
  String? message;
  UserProfileModel? data;

  UserProfileResponseModel({
    this.statusCode,
    this.success,
    this.message,
    this.data,
  });

  factory UserProfileResponseModel.fromJson(Map<String, dynamic> json) =>
      UserProfileResponseModel(
        statusCode: json["statusCode"],
        success: json["success"],
        message: json["message"],
        data: json["data"] == null
            ? null
            : UserProfileModel.fromJson(json["data"]),
      );
}

class UserProfileModel {
  LocationModel? location;
  SettingsModel? settings;
  bool? isOnboardingComplete;
  String? id;
  String? name;
  String? email;
  List<dynamic>? services;
  String? status;
  bool? verified;
  bool? subscribe;
  String? role;
  String? timezone;
  DateTime? createdAt;
  DateTime? updatedAt;
  List<String>? interest;
  String? profile;
  List<dynamic>? favorites;
  List<dynamic>? savedRecipes;
  String? phone;

  UserProfileModel({
    this.location,
    this.settings,
    this.isOnboardingComplete,
    this.id,
    this.name,
    this.email,
    this.services,
    this.status,
    this.verified,
    this.subscribe,
    this.role,
    this.timezone,
    this.createdAt,
    this.updatedAt,
    this.interest,
    this.profile,
    this.favorites,
    this.savedRecipes,
    this.phone,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) =>
      UserProfileModel(
        location: json["location"] == null
            ? null
            : LocationModel.fromJson(json["location"]),
        settings: json["settings"] == null
            ? null
            : SettingsModel.fromJson(json["settings"]),
        isOnboardingComplete: json["isOnboardingComplete"],
        id: json["_id"] ?? json["id"],
        name: json["name"],
        email: json["email"],
        services: json["services"] == null
            ? []
            : List<dynamic>.from(json["services"].map((x) => x)),
        status: json["status"],
        verified: json["verified"],
        subscribe: json["subscribe"],
        role: json["role"],
        timezone: json["timezone"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        interest: json["interest"] == null
            ? []
            : List<String>.from(json["interest"].map((x) => x?.toString())),
        profile: json["profile"],
        favorites: json["favorites"] == null
            ? []
            : List<dynamic>.from(json["favorites"].map((x) => x)),
        savedRecipes: json["savedRecipes"] == null
            ? []
            : List<dynamic>.from(json["savedRecipes"].map((x) => x)),
        phone: json["phone"],
      );
}

class LocationModel {
  String? type;
  List<double>? coordinates;

  LocationModel({this.type, this.coordinates});

  factory LocationModel.fromJson(Map<String, dynamic> json) => LocationModel(
    type: json["type"],
    coordinates: json["coordinates"] == null
        ? []
        : List<double>.from(
            json["coordinates"].map((x) => (x as num?)?.toDouble()),
          ),
  );
}

class SettingsModel {
  bool? pushNotification;
  bool? emailNotification;
  bool? locationService;
  String? profileStatus;

  SettingsModel({
    this.pushNotification,
    this.emailNotification,
    this.locationService,
    this.profileStatus,
  });

  factory SettingsModel.fromJson(Map<String, dynamic> json) => SettingsModel(
    pushNotification: json["pushNotification"],
    emailNotification: json["emailNotification"],
    locationService: json["locationService"],
    profileStatus: json["profileStatus"],
  );
}
