import 'package:json_annotation/json_annotation.dart';

part 'register_request_model.g.dart';

@JsonSerializable()
class RegisterRequestModel {
  final String username;
  final String email;
  final String password;
  @JsonKey(name: "password_again")
  final String passwordAgain;

  RegisterRequestModel({
    required this.username,
    required this.email,
    required this.password,
    required this.passwordAgain,
  });

  factory RegisterRequestModel.fromJson(Map<String, dynamic> json) => _$RegisterRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterRequestModelToJson(this);
}
