enum UserType { admin, moderator, user }

class FirmUser {
  final String id;
  final String name;

  FirmUser({required this.id, required this.name});

  factory FirmUser.fromJson(Map<String, dynamic> json) {
    return FirmUser(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
