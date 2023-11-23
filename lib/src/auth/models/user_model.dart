class UserModel {
  final String uid;
  final String name;
  final String lastName;
  final String email;
  final String password;

  const UserModel({
    required this.uid,
    required this.name,
    required this.lastName,
    required this.email,
    required this.password,
  });
  toJson() {
    return {
      'name': name,
      'lastName': lastName,
      'email': email,
      'password': password,
    };
  }
}
