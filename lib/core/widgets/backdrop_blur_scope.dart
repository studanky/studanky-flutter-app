import 'package:flutter/widgets.dart';

/// Controls whether descendant backdrop filters perform their blur operation.
/// Visual fills, borders, shadows, content, and hit testing are unaffected.
///
/// Outside a scope, backdrop blur remains enabled. The map supplies a scope
/// that disables its expensive filters only while camera pixels are moving.
class BackdropBlurScope extends InheritedWidget {
  const BackdropBlurScope({
    super.key,
    required this.enabled,
    required super.child,
  });

  final bool enabled;

  static bool enabledOf(BuildContext context) =>
      context
          .dependOnInheritedWidgetOfExactType<BackdropBlurScope>()
          ?.enabled ??
      true;

  @override
  bool updateShouldNotify(BackdropBlurScope oldWidget) =>
      enabled != oldWidget.enabled;
}
