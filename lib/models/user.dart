/// User model for authentication and profile management
class User {
  final String id;
  final String email;
  final String fullName;
  final String hashedPassword;
  final DateTime createdAt;
  final DateTime? lastLogin;

  User({
    required this.id,
    required this.email,
    required this.fullName,
    required this.hashedPassword,
    required this.createdAt,
    this.lastLogin,
  });

  /// Convert User to JSON for storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'fullName': fullName,
      'hashedPassword': hashedPassword,
      'createdAt': createdAt.toIso8601String(),
      'lastLogin': lastLogin?.toIso8601String(),
    };
  }

  /// Create User from JSON
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] as String,
      email: map['email'] as String,
      fullName: map['fullName'] as String,
      hashedPassword: map['hashedPassword'] as String,
      createdAt: DateTime.parse(map['createdAt'] as String),
      lastLogin: map['lastLogin'] != null
          ? DateTime.parse(map['lastLogin'] as String)
          : null,
    );
  }

  /// Create a copy with modified fields
  User copyWith({
    String? id,
    String? email,
    String? fullName,
    String? hashedPassword,
    DateTime? createdAt,
    DateTime? lastLogin,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      hashedPassword: hashedPassword ?? this.hashedPassword,
      createdAt: createdAt ?? this.createdAt,
      lastLogin: lastLogin ?? this.lastLogin,
    );
  }

  @override
  String toString() =>
      'User(id: $id, email: $email, fullName: $fullName, createdAt: $createdAt)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is User &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          email == other.email;

  @override
  int get hashCode => id.hashCode ^ email.hashCode;
}

