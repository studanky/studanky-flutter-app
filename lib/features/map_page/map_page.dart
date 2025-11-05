import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:studanky_flutter_app/core/providers/connectivity_status_provider.dart';
import 'package:studanky_flutter_app/features/map_page/map_content.dart';
import 'package:studanky_flutter_app/features/map_page/widgets/offline_placeholder.dart';

class MapPage extends ConsumerWidget {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connectivity = ref.watch(connectivityStatusProvider);

    return connectivity.when(
      data: (online) {
        if (online) {
          return const MapContent();
        }
        return OfflinePlaceholder(
          message:
              'No internet connection. Map data requires an online connection.',
          onRetry: () => ref.invalidate(connectivityStatusProvider),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => OfflinePlaceholder(
        message: 'Unable to determine internet connection.',
        onRetry: () => ref.invalidate(connectivityStatusProvider),
      ),
    );
  }
}
