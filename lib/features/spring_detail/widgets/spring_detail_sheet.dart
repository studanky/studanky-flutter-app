import 'package:flutter/material.dart';
import 'package:studanky_flutter_app/core/haptics/haptics.dart';
import 'package:studanky_flutter_app/core/styles/dimens.dart';
import 'package:studanky_flutter_app/core/styles/styles.dart';
import 'package:studanky_flutter_app/features/spring_detail/presentation/views/spring_detail_view.dart';
import 'package:studanky_flutter_app/features/springs/entities/spring_marker_entity.dart';

/// Draggable presentation shell for a spring detail.
class SpringDetailSheet extends StatefulWidget {
  const SpringDetailSheet({
    required this.documentId,
    required this.onDismissed,
    this.marker,
    super.key,
  });

  final String documentId;
  final SpringMarkerEntity? marker;
  final VoidCallback onDismissed;

  /// Opening height shared with the map camera focus calculation.
  static const double initialSize = 0.55;

  @override
  State<SpringDetailSheet> createState() => _SpringDetailSheetState();
}

class _SpringDetailSheetState extends State<SpringDetailSheet> {
  static const double _minSize = 0.1;
  static const double _dismissThreshold = 0.45;

  bool _dismissing = false;
  bool _atFull = false;

  bool _onNotification(DraggableScrollableNotification notification) {
    if (!_dismissing && notification.extent < _dismissThreshold) {
      _dismissing = true;
      widget.onDismissed();
    }

    final atFull = notification.extent >= 0.999;
    if (atFull != _atFull) {
      _atFull = atFull;
      if (atFull) Haptics.selection();
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<DraggableScrollableNotification>(
      onNotification: _onNotification,
      child: DraggableScrollableSheet(
        initialChildSize: SpringDetailSheet.initialSize,
        minChildSize: _minSize,
        maxChildSize: 1,
        snap: true,
        snapSizes: const [SpringDetailSheet.initialSize],
        expand: false,
        builder: (context, scrollController) => ClipRSuperellipse(
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(kRadiusCard),
          ),
          child: Material(
            color: context.appColors.background,
            child: SpringDetailView(
              documentId: widget.documentId,
              marker: widget.marker,
              scrollController: scrollController,
            ),
          ),
        ),
      ),
    );
  }
}
