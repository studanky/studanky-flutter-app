import 'package:json_annotation/json_annotation.dart';

part 'send_email_confirmation_request.g.dart';

@JsonSerializable()
class SendEmailConfirmationRequest {
  SendEmailConfirmationRequest({required this.email});

  factory SendEmailConfirmationRequest.fromJson(Map<String, dynamic> json) =>
      _$SendEmailConfirmationRequestFromJson(json);

  final String email;

  Map<String, dynamic> toJson() => _$SendEmailConfirmationRequestToJson(this);
}
