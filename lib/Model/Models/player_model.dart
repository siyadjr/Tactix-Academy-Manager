class PlayerModel {
  final String id;
  final String name;
  final String email;
  final String fit;
  final String goals;
  final String assists;
  final String number;
  final String position;
  final String rank;
  final String teamId;
  final String userProfile;

  PlayerModel({
    required this.id,
    required this.name,
    required this.email,
    required this.fit,
    required this.goals,
    required this.assists,
    required this.number,
    required this.position,
    required this.rank,
    required this.teamId,
    required this.userProfile,
  });

  // Factory constructor to convert Firestore document to PlayerModel
  factory PlayerModel.fromMap(Map<String, dynamic> data) {
    return PlayerModel(
      id: data['id']??'',
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      fit: data['fit'] ?? '',
      goals: data['goals'] ?? '0',
      assists: data['assists'] ?? '0',
      number: data['number'] ?? 'not assigned',
      position: data['position'] ?? 'Unknown',
      rank: data['rank'] ?? '0',
      teamId: data['teamId'] ?? '',
      userProfile: data['userProfile'] ?? '',
    );
  }

  // Method to convert PlayerModel to a Map (useful for updating Firestore)
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'fit': fit,
      'goals': goals,
      'assists': assists,
      'number': number,
      'position': position,
      'rank': rank,
      'teamId': teamId,
      'userProfile': userProfile,
    };
  }
}
