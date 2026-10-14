class UserProfile {
  String name;
  String email;
  String focusArea; // e.g. "Mind", "Body", "Productivity", "Spirit"
  bool isRegistered;

  UserProfile({
    required this.name,
    required this.email,
    required this.focusArea,
    required this.isRegistered,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
        'focusArea': focusArea,
        'isRegistered': isRegistered,
      };

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
        name: json['name'] ?? '',
        email: json['email'] ?? '',
        focusArea: json['focusArea'] ?? 'Productivity',
        isRegistered: json['isRegistered'] ?? false,
      );

  static UserProfile guest = UserProfile(
    name: '',
    email: '',
    focusArea: 'Mind',
    isRegistered: false,
  );
}
