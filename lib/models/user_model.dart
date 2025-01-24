import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class User {
  final String? gender;
  final Name? name;
  final Location? location;
  final String? email;
  final Login? login;
  final Dob? dob;
  final Dob? registered;
  final String? phone;
  final String? cell;
  final Id? id;
  final Picture? picture;
  final String? nat;

  User({
    this.gender,
    this.name,
    this.location,
    this.email,
    this.login,
    this.dob,
    this.registered,
    this.phone,
    this.cell,
    this.id,
    this.picture,
    this.nat,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}

@JsonSerializable()
class Name {
  final String? title;
  final String? first;
  final String? last;

  Name({this.title, this.first, this.last});

  factory Name.fromJson(Map<String, dynamic> json) => _$NameFromJson(json);

  Map<String, dynamic> toJson() => _$NameToJson(this);
}

@JsonSerializable()
class Location {
  final Street? street;
  final String? city;
  final String? state;
  final String? country;
  final dynamic postcode;
  final Coordinates? coordinates;
  final Timezone? timezone;

  Location({
    this.street,
    this.city,
    this.state,
    this.country,
    this.postcode,
    this.coordinates,
    this.timezone,
  });

  factory Location.fromJson(Map<String, dynamic> json) =>
      _$LocationFromJson(json);

  Map<String, dynamic> toJson() => _$LocationToJson(this);
}

@JsonSerializable()
class Street {
  final int? number;
  final String? name;

  Street({this.number, this.name});

  factory Street.fromJson(Map<String, dynamic> json) => _$StreetFromJson(json);

  Map<String, dynamic> toJson() => _$StreetToJson(this);
}

@JsonSerializable()
class Coordinates {
  final String? latitude;
  final String? longitude;

  Coordinates({this.latitude, this.longitude});

  factory Coordinates.fromJson(Map<String, dynamic> json) =>
      _$CoordinatesFromJson(json);

  Map<String, dynamic> toJson() => _$CoordinatesToJson(this);
}

@JsonSerializable()
class Timezone {
  final String? offset;
  final String? description;

  Timezone({this.offset, this.description});

  factory Timezone.fromJson(Map<String, dynamic> json) =>
      _$TimezoneFromJson(json);

  Map<String, dynamic> toJson() => _$TimezoneToJson(this);
}

@JsonSerializable()
class Login {
  final String? uuid;
  final String? username;
  final String? password;
  final String? salt;
  final String? md5;
  final String? sha1;
  final String? sha256;

  Login({
    this.uuid,
    this.username,
    this.password,
    this.salt,
    this.md5,
    this.sha1,
    this.sha256,
  });

  factory Login.fromJson(Map<String, dynamic> json) => _$LoginFromJson(json);

  Map<String, dynamic> toJson() => _$LoginToJson(this);
}

@JsonSerializable()
class Dob {
  final String? date;
  final int? age;

  Dob({this.date, this.age});

  factory Dob.fromJson(Map<String, dynamic> json) => _$DobFromJson(json);

  Map<String, dynamic> toJson() => _$DobToJson(this);
}

@JsonSerializable()
class Id {
  final String? name;
  final String? value;

  Id({this.name, this.value});

  factory Id.fromJson(Map<String, dynamic> json) => _$IdFromJson(json);

  Map<String, dynamic> toJson() => _$IdToJson(this);
}

@JsonSerializable()
class Picture {
  final String? large;
  final String? medium;
  final String? thumbnail;

  Picture({this.large, this.medium, this.thumbnail});

  factory Picture.fromJson(Map<String, dynamic> json) =>
      _$PictureFromJson(json);

  Map<String, dynamic> toJson() => _$PictureToJson(this);
}
