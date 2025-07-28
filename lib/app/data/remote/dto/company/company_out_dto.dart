import 'package:jobs_flutter_app/app/data/remote/base/idto.dart';

class CompanyOutDto implements IDto {
  final String? id;
  final String? name;
  final String? email;
  final String? phone;
  final String? description;
  final String? workType;
  final String? city;
  final String? address;
  final String? image;
  final String? website; // Added missing field
  final String? headOffice; // Added missing field
  final String? type; // Added missing field
  final int? foundedYear; // Added missing field

  CompanyOutDto({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.description,
    this.workType,
    this.city,
    this.address,
    this.image,
    this.website, // Added to constructor
    this.headOffice, // Added to constructor
    this.type, // Added to constructor
    this.foundedYear, // Added to constructor
  });

  factory CompanyOutDto.fromJson(Map<String, dynamic> json) {
    return CompanyOutDto(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      description: json['description'],
      workType: json['work_type'],
      city: json['city'],
      address: json['address'],
      image: json['image'],
      website: json['website'], // Parse from JSON
      headOffice: json['headOffice'], // Parse from JSON
      type: json['type'], // Parse from JSON
      foundedYear: json['foundedYear'], // Parse from JSON
    );
  }

  CompanyOutDto copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? description,
    String? workType,
    String? city,
    String? address,
    String? image,
    String? website,
    String? headOffice,
    String? type,
    int? foundedYear,
  }) =>
      CompanyOutDto(
        id: id ?? this.id,
        name: name ?? this.name,
        email: email ?? this.email,
        phone: phone ?? this.phone,
        description: description ?? this.description,
        workType: workType ?? this.workType,
        city: city ?? this.city,
        address: address ?? this.address,
        image: image ?? this.image,
        website: website ?? this.website,
        headOffice: headOffice ?? this.headOffice,
        type: type ?? this.type,
        foundedYear: foundedYear ?? this.foundedYear,
      );

  @override
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['email'] = email;
    map['phone'] = phone;
    map['description'] = description;
    map['work_type'] = workType;
    map['city'] = city;
    map['address'] = address;
    map['image'] = image;
    map['website'] = website; // Add to toJson
    map['headOffice'] = headOffice; // Add to toJson
    map['type'] = type; // Add to toJson
    map['foundedYear'] = foundedYear; // Add to toJson
    return map;
  }
}
