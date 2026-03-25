class UserModel {
  String name;
  String email;
  String phone;
  String password;
  String confirmPassword;
  String type;

  UserModel({
    required this.name,
    required this.email,
    required this.phone,
    required this.password,
    required this.confirmPassword,
    required this.type,
  });
}