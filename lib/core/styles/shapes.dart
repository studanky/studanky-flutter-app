/// Squircle (Apple's *rounded superellipse*) shape helpers, so every zaoblený
/// corner in the app reads as one continuous-curvature family instead of the
/// sharper elliptical arc of a plain [RoundedRectangleBorder].
///
/// Backed by Flutter's **native** [RoundedSuperellipseBorder] /
/// [ClipRSuperellipse] (Flutter 3.35+), rendered directly by Impeller — no
/// third-party squircle package, nothing to break on future SDK bumps. The
/// corner *radius* is unchanged from the app's `dimens` scale; only the corner
/// *curve* becomes a superellipse.
///
/// Usage:
/// * `shape:` slots (Material, Card, buttons, `ShapeDecoration`,
///   `InkWell.customBorder`) → [squircleBorder].
/// * clipping a child → wrap it in a `ClipRSuperellipse` with the matching
///   `borderRadius` (drop-in for `ClipRRect`).
library;

import 'package:flutter/widgets.dart';

/// A squircle [OutlinedBorder] with a uniform corner [radius] and an optional
/// hairline [side]. Feed it anywhere a `ShapeBorder` / `OutlinedBorder` is
/// accepted.
RoundedSuperellipseBorder squircleBorder(
  double radius, {
  BorderSide side = BorderSide.none,
}) => RoundedSuperellipseBorder(
  side: side,
  borderRadius: BorderRadius.circular(radius),
);

/// A squircle border from an explicit [borderRadius] (e.g. a top-only radius on
/// a bottom sheet), with an optional hairline [side].
RoundedSuperellipseBorder squircleBorderFrom(
  BorderRadiusGeometry borderRadius, {
  BorderSide side = BorderSide.none,
}) => RoundedSuperellipseBorder(side: side, borderRadius: borderRadius);
