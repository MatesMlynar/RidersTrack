class User{
  final String username;
  final String email;
  final String id;
  String profileImage;
  String coverImage;

  User({
    required this.username,
    required this.email,
    required this.id,
    this.profileImage = "",
    this.coverImage = ""
  });
}