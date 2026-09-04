class AppUser {
  final String id;
  final String name;
  final String email;
  final String passwordHash;
  final String? avatarPath;

  const AppUser({
    required this.id,
    required this.name,
    required this.email,
    required this.passwordHash,
    this.avatarPath,
  });

  AppUser copyWith({String? name, String? avatarPath}) {
    return AppUser(
      id: id,
      name: name ?? this.name,
      email: email,
      passwordHash: passwordHash,
      avatarPath: avatarPath ?? this.avatarPath,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'passwordHash': passwordHash,
    'avatarPath': avatarPath,
  };

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      passwordHash: json['passwordHash'] as String,
      avatarPath: json['avatarPath'] as String?,
    );
  }
}
