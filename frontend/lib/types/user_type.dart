class User{
  final String username;
  final String email;
  final String id;
  late final String profileImage;
  late String coverImage;

  User({
    required this.username,
    required this.email,
    required this.id,
    this.profileImage = "",
    this.coverImage = ""
  });
}