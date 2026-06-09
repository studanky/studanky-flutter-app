import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:studanky_flutter_app/features/spring_detail/data/spring_detail_repository.dart';
import 'package:studanky_flutter_app/features/spring_detail/entities/spring_detail.dart';

part 'spring_detail_provider.g.dart';

/// Loads the full spring detail for the header. Auto-disposed with the sheet.
///
/// The repository returns an `ApiResult`; unwrapping with `orThrow` lets the
/// surrounding `AsyncValue` capture the typed failure for the UI.
@riverpod
Future<SpringDetail> springDetail(
  Ref ref,
  String documentId, {
  String? locale,
}) async {
  final result = await ref
      .watch(springDetailRepositoryProvider)
      .fetchDetail(documentId, locale: locale);
  return result.orThrow;
}
