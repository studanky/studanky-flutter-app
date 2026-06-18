import 'package:flutter/material.dart';
import 'package:studanky_flutter_app/core/styles/styles.dart';
import 'package:studanky_flutter_app/core/widgets/glass_surface.dart';
import 'package:studanky_flutter_app/core/widgets/scroll_edge_effect.dart';
import 'package:studanky_flutter_app/features/map_search/entities/map_search_result.dart';
import 'package:studanky_flutter_app/features/map_search/entities/map_search_result_type.dart';
import 'package:studanky_flutter_app/l10n/extension.dart';

/// Dropdown of search suggestions, styled as the same frosted-glass surface as
/// the search field so the two read as one component. Each row carries an icon
/// and a short descriptor for its Mapy.com result type.
class MapSearchResultList extends StatelessWidget {
  const MapSearchResultList({
    super.key,
    required this.results,
    required this.onTap,
  });

  final List<MapSearchResult> results;
  final ValueChanged<MapSearchResult> onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Styles.appColors;
    final height = (results.length * 60.0).clamp(0, 300).toDouble();

    return GlassSurface(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Material(
        type: MaterialType.transparency,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: height,
            minWidth: double.infinity,
          ),
          child: ScrollEdgeEffect(
            child: ListView.separated(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              itemCount: results.length,
              separatorBuilder: (_, _) => Divider(
                height: 1,
                indent: 52,
                endIndent: 16,
                color: colors.neutral500.withValues(alpha: 0.18),
              ),
              itemBuilder: (context, index) =>
                  _ResultRow(result: results[index], onTap: onTap),
            ),
          ),
        ),
      ),
    );
  }
}

class _ResultRow extends StatelessWidget {
  const _ResultRow({required this.result, required this.onTap});

  final MapSearchResult result;
  final ValueChanged<MapSearchResult> onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Styles.appColors;
    final text = Styles.textStyles;
    // Prefer the API's parent location (e.g. region) to tell apart places that
    // share a name; fall back to a generic type descriptor when it's absent.
    final secondary = result.subtitle ?? _descriptorFor(context, result.type);

    return InkWell(
      onTap: () => onTap(result),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
        child: Row(
          children: [
            Icon(_iconFor(result.type), size: 20, color: colors.primaryMain),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    result.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: text.title2.copyWith(color: colors.neutral900),
                  ),
                  Text(
                    secondary,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: text.body2.copyWith(
                      fontSize: 12,
                      color: colors.neutral500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Icon per Mapy.com suggest result type (chosen for at-a-glance recognition).
IconData _iconFor(MapSearchResultType type) => switch (type) {
  MapSearchResultType.spring => Icons.water_drop_rounded,
  MapSearchResultType.regionalCountry => Icons.public_rounded,
  MapSearchResultType.regionalRegion => Icons.map_outlined,
  MapSearchResultType.regionalMunicipality => Icons.location_city_rounded,
  MapSearchResultType.regionalMunicipalityPart => Icons.holiday_village_rounded,
  MapSearchResultType.regionalStreet => Icons.signpost_outlined,
  MapSearchResultType.regionalAddress => Icons.home_rounded,
  MapSearchResultType.poi => Icons.place_rounded,
  MapSearchResultType.coordinate => Icons.my_location_rounded,
  MapSearchResultType.regional ||
  MapSearchResultType.other => Icons.place_outlined,
};

/// Short localized descriptor shown under each result's name.
String _descriptorFor(BuildContext context, MapSearchResultType type) {
  final l10n = context.l10n;

  return switch (type) {
    MapSearchResultType.spring => l10n.map_search_type_spring,
    MapSearchResultType.regionalCountry => l10n.map_search_type_country,
    MapSearchResultType.regionalRegion => l10n.map_search_type_region,
    MapSearchResultType.regionalMunicipality =>
      l10n.map_search_type_municipality,
    MapSearchResultType.regionalMunicipalityPart =>
      l10n.map_search_type_municipality_part,
    MapSearchResultType.regionalStreet => l10n.map_search_type_street,
    MapSearchResultType.regionalAddress => l10n.map_search_type_address,
    MapSearchResultType.poi => l10n.map_search_type_place,
    MapSearchResultType.coordinate => l10n.map_search_type_coordinate,
    MapSearchResultType.regional ||
    MapSearchResultType.other => l10n.map_search_type_place,
  };
}
