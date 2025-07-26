/// Data Transfer Object for a customer's profile.
class CustomerOutDto {
  final String? id;
  final String? name;
  final String? email;
  // TODO: Add other fields from your API response (e.g., avatarUrl, etc.)

  CustomerOutDto({
    this.id,
    this.name,
    this.email,
  });

  factory CustomerOutDto.fromJson(Map<String, dynamic> json) {
    return CustomerOutDto(
      id: json['id'],
      name: json['name'],
      email: json['email'],
    );
  }
}