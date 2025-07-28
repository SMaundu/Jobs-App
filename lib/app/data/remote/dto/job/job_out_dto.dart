import 'package:jobs_flutter_app/app/data/remote/dto/company/company_out_dto.dart'; // Ensure this path is correct

/// Data Transfer Object for a single job.
class JobOutDto {
  final String? id;
  final String? title;
  final String? position;
  final String? description; // Added missing field
  final String? workplace; // Added missing field
  final String? employmentType; // Added missing field
  final String? location; // Added missing field
  final DateTime? createdAt; // Added missing field, using DateTime for dates
  final CompanyOutDto? company; // Added missing nested object for company details

  JobOutDto({
    this.id,
    this.title,
    this.position,
    this.description,
    this.workplace,
    this.employmentType,
    this.location,
    this.createdAt,
    this.company,
  });

  factory JobOutDto.fromJson(Map<String, dynamic> json) {
    return JobOutDto(
      id: json['id'],
      title: json['title'],
      position: json['position'],
      description: json['description'],
      workplace: json['workplace'],
      employmentType: json['employmentType'],
      location: json['location'],
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      company: json['company'] != null
          ? CompanyOutDto.fromJson(json['company'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'position': position,
        'description': description,
        'workplace': workplace,
        'employmentType': employmentType,
        'location': location,
        'createdAt': createdAt?.toIso8601String(), // Convert DateTime to String for JSON
        'company': company?.toJson(), // Convert nested CompanyOutDto to JSON
      };

  // Helper getters for properties that were causing errors in UI widgets
  // These are derived from the 'company' object or directly from the DTO.
  String? get companyName => company?.name;
  String? get companyImage => company?.image;
  String? get companyId => company?.id;
}

/// Data Transfer Object for Company details, typically nested within JobOutDto.
/// Ensure this file is saved as `lib/app/data/remote/dto/company/company_out_dto.dart`
/// or adjust the import path in `JobOutDto` accordingly.
class CompanyOutDto {
  final String? id;
  final String? name;
  final String? image; // Path or URL to the company's image/logo
  final String? description; // Added for "About Company"
  final String? website; // Added for "Website"
  final String? headOffice; // Added for "Head office"
  final String? type; // Added for "Type" (e.g., Multinational company)
  final int? foundedYear; // Added for "Since" (e.g., 1998)

  CompanyOutDto({
    this.id,
    this.name,
    this.image,
    this.description,
    this.website,
    this.headOffice,
    this.type,
    this.foundedYear,
  });

  factory CompanyOutDto.fromJson(Map<String, dynamic> json) {
    return CompanyOutDto(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      description: json['description'],
      website: json['website'],
      headOffice: json['headOffice'],
      type: json['type'],
      foundedYear: json['foundedYear'], // Assuming it's an int
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'image': image,
        'description': description,
        'website': website,
        'headOffice': headOffice,
        'type': type,
        'foundedYear': foundedYear,
      };
}
