class TeamModel {
  String managerId;
  String name;
  String location;
  String teamPhoto;

  TeamModel({
    required this.managerId,
    required this.name,
    required this.location,
    required this.teamPhoto
  });

  // Method to convert TeamModel to a map (for Firestore or other databases)
  Map<String, dynamic> toMap() {
    return {
      'managerId': managerId,
      'name': name,
      'location': location,
      'teamPhoto':teamPhoto
    };
  }

  // Method to create a TeamModel from a map (to retrieve data from Firestore or other databases)
  factory TeamModel.fromMap(Map<String, dynamic> map) {
    return TeamModel(
      managerId: map['managerId'] ?? '',
      name: map['name'] ?? '',
      location: map['location'] ?? '',
      teamPhoto: map['teamPhoto']??''
    );
  }
}
