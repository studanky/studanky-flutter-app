// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:studanky_flutter_app/core/api/clients/api_client.dart';
// import 'package:studanky_flutter_app/core/api/config/api_config.dart';
// import 'package:studanky_flutter_app/core/api/services/base_api_service.dart';

// class UserProfileService extends BaseApiService {
//   UserProfileService(super.apiClient);

//   Future<UserProfileBO> getUserProfile(int userId) async {
//     final userProfile = await getById<UserProfileBO>(
//       ApiConfig.userProfileByUserEndpoint,
//       userId,
//       fromJson: UserProfileBO.fromJson,
//     );

//     return userProfile;
//   }
// }

// final userProfileServiceProvider = Provider<UserProfileService>((ref) {
//   final apiClient = ref.watch(apiClientProvider);
//   return UserProfileService(apiClient);
// });
