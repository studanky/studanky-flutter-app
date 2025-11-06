// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:studanky_flutter_app/core/api/clients/api_client.dart';
// import 'package:studanky_flutter_app/core/api/config/api_config.dart';
// import 'package:studanky_flutter_app/core/api/services/base_api_service.dart';

// class CowshedService extends BaseApiService {
//   CowshedService(super.apiClient);

//   Future<List<CowshedBO>> getBulk(List<String> documentIds) async {
//     final documentIdsString = documentIds.join(',');
//     return getList<CowshedBO>(
//       ApiConfig.cowshedsBulkEndpoint(documentIdsString),
//       fromJson: CowshedBO.fromJson,
//     );
//   }
// }

// final cowshedServiceProvider = Provider<CowshedService>((ref) {
//   final apiClient = ref.watch(apiClientProvider);
//   return CowshedService(apiClient);
// });
