import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:studanky_flutter_app/features/map_search/entities/map_search_result.dart';
import 'package:studanky_flutter_app/features/map_search/presentation/widgets/map_search_overlay.dart';
import 'package:studanky_flutter_app/features/map_search/presentation/widgets/map_search_status.dart';
import 'package:studanky_flutter_app/features/map_search/providers/map_search_provider.dart';

class MapSearchWidget extends ConsumerStatefulWidget {
  const MapSearchWidget({
    super.key,
    required this.hintText,
    this.originProvider,
    this.onResultSelected,
    this.status,
  });

  final String hintText;
  final LatLng? Function()? originProvider;
  final ValueChanged<MapSearchResult>? onResultSelected;

  /// Optional advisory status (offline / empty map) attached under the field.
  final MapSearchStatus? status;

  @override
  ConsumerState<MapSearchWidget> createState() => _MapSearchWidgetState();
}

class _MapSearchWidgetState extends ConsumerState<MapSearchWidget> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;
  Locale? _searchLocale;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    // Rebuild on focus changes so the clear/dismiss button can appear as soon
    // as the field is focused (even before anything is typed).
    _focusNode = FocusNode()..addListener(_onFocusChanged);
  }

  void _onFocusChanged() => setState(() {});

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final searchLocale = Localizations.localeOf(context);
    if (_searchLocale == searchLocale) return;
    _searchLocale = searchLocale;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || _searchLocale != searchLocale) return;
      ref
          .read(mapSearchProvider.notifier)
          .updateLocale(searchLocale, origin: widget.originProvider?.call());
    });
  }

  @override
  void dispose() {
    _focusNode
      ..removeListener(_onFocusChanged)
      ..dispose();
    _controller.dispose();
    super.dispose();
  }

  void _handleResult(
    BuildContext context,
    MapSearchNotifier notifier,
    MapSearchResult result,
  ) {
    notifier.select(result);
    widget.onResultSelected?.call(result);
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    // didChangeDependencies always resolves this before the first build.
    final searchLocale = _searchLocale!;
    final state = ref.watch(mapSearchProvider);
    final notifier = ref.read(mapSearchProvider.notifier);

    if (_controller.text != state.query) {
      _controller.value = TextEditingValue(
        text: state.query,
        selection: TextSelection.collapsed(offset: state.query.length),
      );
    }

    return MapSearchOverlay(
      controller: _controller,
      focusNode: _focusNode,
      state: state,
      hintText: widget.hintText,
      status: widget.status,
      onQueryChanged: (query) => notifier.setQuery(
        query,
        locale: searchLocale,
        origin: widget.originProvider?.call(),
      ),
      // Clears the typed query but keeps the field focused so the user can keep
      // typing; the overlay's trailing button handles dismissing an empty field.
      onClear: notifier.clear,
      onResultTap: (result) => _handleResult(context, notifier, result),
    );
  }
}
