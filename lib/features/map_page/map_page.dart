import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:studanky_flutter_app/core/providers/connectivity_status_provider.dart';
import 'package:studanky_flutter_app/core/widgets/async_value_builder.dart';
import 'package:studanky_flutter_app/core/widgets/error_widget.dart';
import 'package:studanky_flutter_app/features/map_page/map_page_content.dart';
import 'package:studanky_flutter_app/features/map_page/widgets/offline_placeholder.dart';
import 'package:studanky_flutter_app/l10n/extension.dart';

class MapPage extends ConsumerWidget {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connectivity = ref.watch(connectivityStatusProvider);

    void invalidateConnectivity() {
      ref.invalidate(connectivityStatusProvider);
    }

    return Scaffold(
      body: AsyncValueBuilder<bool>(
        asyncValue: connectivity,
        error: (error, stackTrace) => AppErrorWidget(
          error: error,
          stackTrace: stackTrace,
          title: context.l10n.error_connectivity_status_title,
          subtitle: context.l10n.error_connectivity_status_subtitle,
          onRefresh: invalidateConnectivity,
        ),
        data: (online) => online
            ? const MapPageContent()
            : OfflinePlaceholder(onRetry: invalidateConnectivity),
      ),
    );
  }
}
