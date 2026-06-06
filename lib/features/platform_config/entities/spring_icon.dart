/// The three-state map icon plus an explicit unknown state (spec §4.1).
///
/// [stale] is **computed on the client** from the freshness threshold and the
/// last report timestamp; the server never returns it. It overrides
/// [flowing]/[notFlowing] once a status is older than the threshold.
enum SpringIcon { flowing, notFlowing, stale, unknown }
