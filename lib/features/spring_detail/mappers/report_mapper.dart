import 'package:studanky_flutter_app/core/api/models/strapi_response.dart';
import 'package:studanky_flutter_app/features/spring_detail/dtos/report_dto.dart';
import 'package:studanky_flutter_app/features/spring_detail/entities/report.dart';
import 'package:studanky_flutter_app/features/spring_detail/entities/report_page.dart';
import 'package:studanky_flutter_app/features/spring_detail/entities/water_clarity.dart';

class ReportMapper {
  const ReportMapper._();

  static Report fromDto(ReportDto dto) {
    final note = dto.note?.trim();

    return Report(
      documentId: dto.documentId,
      isFlowing: dto.isFlowing,
      reportedAt: dto.reportedAt,
      flowScale: dto.flowScale,
      flowRateLps: dto.flowRateLps,
      hasOdor: dto.hasOdor,
      waterClarity: WaterClarity.fromWire(dto.waterClarity),
      note: (note == null || note.isEmpty) ? null : note,
    );
  }

  /// Builds a [ReportPage] from the paginated list envelope. Falls back to a
  /// single-page cursor when the server omits `meta.pagination`.
  static ReportPage pageFromResponse(
    StrapiListResponse<ReportDto> response, {
    required int requestedPage,
  }) {
    final items = response.data
        .map(ReportMapper.fromDto)
        .toList(growable: false);
    final pagination = response.meta?.pagination;

    return ReportPage(
      items: items,
      page: pagination?.page ?? requestedPage,
      pageCount: pagination?.pageCount ?? requestedPage,
      total: pagination?.total ?? items.length,
    );
  }
}
