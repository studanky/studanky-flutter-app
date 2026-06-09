import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:studanky_flutter_app/features/spring_detail/entities/report.dart';

part 'report_page.freezed.dart';

/// One page of report history plus its pagination cursor (api-reference.md
/// §3.3).
@freezed
abstract class ReportPage with _$ReportPage {
  const factory ReportPage({
    required List<Report> items,
    required int page,
    required int pageCount,
    required int total,
  }) = _ReportPage;

  const ReportPage._();

  /// Whether at least one more page is available after this one.
  bool get hasMore => page < pageCount;
}
