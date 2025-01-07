class SessionModel {
  final String id;
  final String name;
  final String description;
  final String sessionType;
  final String date;
  final String imagePath;
  final String location;

  SessionModel(
      {required this.
      id,
        required this.name,
      required this.description,
      required this.sessionType,
      required this.date,
      required this.imagePath,
      required this.location});
}
