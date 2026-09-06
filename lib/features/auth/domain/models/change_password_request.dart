class ChangePasswordRequest {
  ChangePasswordRequest({
    required this.currentPassword,
    required this.password,
    required this.passwordConfirmation,
  });

  factory ChangePasswordRequest.fromJson(Map<String, dynamic> json) =>
      ChangePasswordRequest(
        currentPassword: json['currentPassword'] as String,
        password: json['password'] as String,
        passwordConfirmation: json['passwordConfirmation'] as String,
      );

  final String currentPassword;
  final String password;
  final String passwordConfirmation;

  Map<String, dynamic> toJson() => {
    'currentPassword': currentPassword,
    'password': password,
    'passwordConfirmation': passwordConfirmation,
  };
}
