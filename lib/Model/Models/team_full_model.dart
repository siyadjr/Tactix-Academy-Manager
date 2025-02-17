class TeamFullModel {
  String id;
  String teamName;
  String teamPhoto;
  String teamLocation;

  int teamPlayersCount;
  TeamFullModel(
      {required this.id,
        required this.teamName,
      required this.teamLocation,
      required this.teamPhoto,
      required this.teamPlayersCount});
}
