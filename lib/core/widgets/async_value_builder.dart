import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:studanky_flutter_app/core/widgets/app_progress_indicator.dart';
import 'package:studanky_flutter_app/core/widgets/error_widget.dart';

class AsyncValueBuilder<T> extends StatelessWidget {
  const AsyncValueBuilder({
    super.key,
    required this.asyncValue,
    required this.data,
    this.error,
    this.loading,
    this.onRefresh,
  });

  final AsyncValue<T> asyncValue;
  final Widget Function(T data) data;
  final Widget Function(Object error, StackTrace stack)? error;
  final Widget Function()? loading;
  final VoidCallback? onRefresh;

  static Widget _defaultLoading() =>
      const Center(child: AppProgressIndicator());

  Widget _defaultError(Object err, StackTrace stack) =>
      AppErrorWidget(error: err, stackTrace: stack, onRefresh: onRefresh);

  @override
  Widget build(BuildContext context) {
    return asyncValue.when(
      data: data,
      error: error ?? _defaultError,
      loading: loading ?? _defaultLoading,
    );
  }
}
