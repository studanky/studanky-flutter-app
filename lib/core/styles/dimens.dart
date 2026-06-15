/// Formalized corner-radius scale shared across every surface so the app reads
/// as one system instead of a handful of ad-hoc values. Floating glass controls
/// and content cards share [kRadiusCard]; smaller controls and chips step down
/// from there.
library;

const double kRadiusPill = 100;

/// Cards, dialogs, sheets and the floating glass controls.
const double kRadiusCard = 20;

/// Inputs, list tiles and large controls.
const double kRadiusControl = 16;

/// Standard buttons.
const double kRadiusButton = 14;

/// Small tags / chips.
const double kRadiusChip = 10;
