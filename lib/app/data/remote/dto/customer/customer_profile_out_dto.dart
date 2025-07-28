import 'package:jobs_flutter_app/app/data/remote/dto/job/job_out_dto.dart'; // Assuming JobOutDto is needed for savedJobs

/// Data Transfer Object for a customer's full profile details.
class CustomerProfileOutDto {
  final String? id;
  final String? userId; // Assuming a link to a user ID
  final String? name;
  final String? email;
  final String? phone;
  final String? location;
  final String? bio;
  final String? avatar; // URL or path to avatar image
  final String? jobTitle; // Added the missing jobTitle field
  final String? description; // <-- ADDED THIS MISSING FIELD
  final List<String>? skills; // List of skills
  final List<WorkExperience>? workExperience; // List of work experiences
  final List<Education>? education; // List of education entries
  final List<String>? language; // <-- ADDED THIS MISSING FIELD
  final List<JobOutDto>? savedJobs; // List of saved jobs, assuming JobOutDto is correct

  CustomerProfileOutDto({
    this.id,
    this.userId,
    this.name,
    this.email,
    this.phone,
    this.location,
    this.bio,
    this.avatar,
    this.jobTitle,
    this.description, // <-- ADDED TO CONSTRUCTOR
    this.skills,
    this.workExperience,
    this.education,
    this.language, // <-- ADDED TO CONSTRUCTOR
    this.savedJobs,
  });

  factory CustomerProfileOutDto.fromJson(Map<String, dynamic> json) {
    return CustomerProfileOutDto(
      id: json['id'],
      userId: json['userId'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      location: json['location'],
      bio: json['bio'],
      avatar: json['avatar'],
      jobTitle: json['jobTitle'],
      description: json['description'], // <-- PARSE FROM JSON
      skills: (json['skills'] as List?)?.map((e) => e.toString()).toList(),
      workExperience: (json['workExperience'] as List?)
          ?.map((e) => WorkExperience.fromJson(e as Map<String, dynamic>))
          .toList(),
      education: (json['education'] as List?)
          ?.map((e) => Education.fromJson(e as Map<String, dynamic>))
          .toList(),
      language: (json['language'] as List?)?.map((e) => e.toString()).toList(), // <-- PARSE FROM JSON
      savedJobs: (json['savedJobs'] as List?)
          ?.map((e) => JobOutDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'name': name,
        'email': email,
        'phone': phone,
        'location': location,
        'bio': bio,
        'avatar': avatar,
        'jobTitle': jobTitle,
        'description': description, // <-- ADDED TO toJson
        'skills': skills,
        'workExperience': workExperience?.map((e) => e.toJson()).toList(),
        'education': education?.map((e) => e.toJson()).toList(),
        'language': language, // <-- ADDED TO toJson
        'savedJobs': savedJobs?.map((e) => e.toJson()).toList(),
      };
}

/// Represents a single work experience entry for a customer.
class WorkExperience {
  final String? id;
  final String? title;
  final String? companyWorkedFor;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? description; // Optional: detailed description of responsibilities

  WorkExperience({
    this.id,
    this.title,
    this.companyWorkedFor,
    this.startDate,
    this.endDate,
    this.description,
  });

  factory WorkExperience.fromJson(Map<String, dynamic> json) {
    return WorkExperience(
      id: json['id'],
      title: json['title'],
      companyWorkedFor: json['companyWorkedFor'],
      startDate: json['startDate'] != null ? DateTime.parse(json['startDate']) : null,
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'companyWorkedFor': companyWorkedFor,
        'startDate': startDate?.toIso8601String(),
        'endDate': endDate?.toIso8601String(),
        'description': description,
      };
}

/// Represents a single education entry for a customer.
class Education {
  final String? id;
  final String? degree;
  final String? institution;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? fieldOfStudy; // Optional: e.g., "Computer Science"

  Education({
    this.id,
    this.degree,
    this.institution,
    this.startDate,
    this.endDate,
    this.fieldOfStudy,
  });

  factory Education.fromJson(Map<String, dynamic> json) {
    return Education(
      id: json['id'],
      degree: json['degree'],
      institution: json['institution'],
      startDate: json['startDate'] != null ? DateTime.parse(json['startDate']) : null,
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
      fieldOfStudy: json['fieldOfStudy'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'degree': degree,
        'institution': institution,
        'startDate': startDate?.toIso8601String(),
        'endDate': endDate?.toIso8601String(),
        'fieldOfStudy': fieldOfStudy,
      };
}
