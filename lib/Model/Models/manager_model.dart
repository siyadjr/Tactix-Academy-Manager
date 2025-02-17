class ManagerModel {
  final String id;
  final String name;
  final String email;
  final String userProfile;
  final String licenseUrl;

  ManagerModel({
    required this.id,
    required this.name,
    required this.email,
    required this.userProfile,
    required this.licenseUrl,
  });

  factory ManagerModel.fromFirestore(Map<String, dynamic> data, String id) {
    return ManagerModel(
      id: id,
      name: data['name'] ?? 'Unknown',
      email: data['email'] ?? 'No Email',
      userProfile: data['userProfile'] ?? '',
      licenseUrl: data['licenseUrl'] ?? '',
    );
  }
}
