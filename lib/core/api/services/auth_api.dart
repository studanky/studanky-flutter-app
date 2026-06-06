import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:studanky_flutter_app/core/api/config/api_config.dart';
import 'package:studanky_flutter_app/core/api/dtos/user_dto.dart';
import 'package:studanky_flutter_app/core/api/models/auth_models.dart';

part 'auth_api.g.dart';

/// Strapi users-permissions authentication endpoints.
@RestApi()
abstract class AuthApi {
  factory AuthApi(Dio dio, {String? baseUrl}) = _AuthApi;

  @POST(ApiConfig.authEndpoint)
  Future<AuthResponse> login(@Body() LoginRequest request);

  @POST(ApiConfig.registerEndpoint)
  Future<AuthResponse> register(@Body() RegisterRequest request);

  @POST(ApiConfig.sendEmailConfirmationEndpoint)
  Future<void> sendEmailConfirmation(
    @Body() SendEmailConfirmationRequest request,
  );

  @POST(ApiConfig.generatePasswordEndpoint)
  Future<void> generatePassword(@Body() GeneratePasswordRequest request);

  @POST(ApiConfig.changePasswordEndpoint)
  Future<AuthResponse> changePassword(@Body() ChangePasswordRequest request);

  @GET(ApiConfig.meEndpoint)
  Future<UserDto> getCurrentUser();
}
