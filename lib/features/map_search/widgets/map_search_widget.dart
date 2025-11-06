import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:studanky_flutter_app/features/map_search/entities/map_search_result.dart';
import 'package:studanky_flutter_app/features/map_search/providers/map_search_provider.dart';
import 'package:studanky_flutter_app/features/map_search/widgets/map_search_overlay.dart';

class MapSearchWidget extends ConsumerStatefulWidget {
  const MapSearchWidget({
    super.key,
    required this.hintText,
    this.onResultSelected,
  });

  final String hintText;
  final ValueChanged<MapSearchResult>? onResultSelected;

  @override
  ConsumerState<MapSearchWidget> createState() => _MapSearchWidgetState();
}

class _MapSearchWidgetState extends ConsumerState<MapSearchWidget> {
  late final TextEditingController _controller;

  MapSearchNotifier get _notifier => ref.read(mapSearchProvider.notifier);

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleResult(BuildContext context, MapSearchResult result) {
    _notifier.select(result);
    widget.onResultSelected?.call(result);
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(mapSearchProvider);

    if (_controller.text != state.query) {
      _controller.value = TextEditingValue(
        text: state.query,
        selection: TextSelection.collapsed(offset: state.query.length),
      );
    }

    return MapSearchOverlay(
      controller: _controller,
      state: state,
      hintText: widget.hintText,
      onQueryChanged: _notifier.setQuery,
      onClear: () {
        _notifier.clear();
        FocusScope.of(context).unfocus();
      },
      onResultTap: (result) => _handleResult(context, result),
    );
  }
}
